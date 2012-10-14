//
//  RSSFeedController.m
//  iOSAbtP
//
//  Created by 花崎 忠利 on 2012/10/14.
//  Copyright (c) 2012年 tadatoshi_hanazaki. All rights reserved.
//

#import "RSSChannel.h"
#import "RSSChannelManager.h"
#import "RSSResponseParser.h"
#import "RSSConnector.h"
#import "RSSFeedController.h"

@interface RSSFeedController (private)

// Appearance
- (void)_updateNavigationItemAnimated:(BOOL)animated;
- (void)_updateToolbarAnimated:(BOOL)animated;
- (void)_updateTextFields;

@end

@implementation RSSFeedController

// プロパティ
@synthesize channel = _channel;
@synthesize delegate = _delegate;

//--------------------------------------------------------------//
#pragma mark -- 初期化 --
//--------------------------------------------------------------//

- (id)init
{
    // nibファイル名を指定して、初期化メソッドを呼び出す
    self = [super initWithNibName:@"Feed" bundle:nil];
    if (!self) {
        return nil;
    }
    
    // コントローラの設定
    self.title = NSLocalizedString(@"Feed", nil);
    
    return self;
}

- (void)_releaseOutlets
{
    // アウトレットを解放する
    [_titleTextField release], _titleTextField = nil;
    [_urlTextField release], _urlTextField = nil;
    [_cancelItem release], _cancelItem = nil;
    [_saveItem release], _saveItem = nil;
}

- (void)dealloc
{
    // 登録の解除
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    // アウトレットを解放する
    [self _releaseOutlets];
    
    // インスタンス変数を解放する
    [_channel release], _channel = nil;
    _delegate = nil;
    
    // 親クラスのdeallocを呼び出す
    [super dealloc];
}

//--------------------------------------------------------------//
#pragma mark -- ビュー --
//--------------------------------------------------------------//

- (void)viewWillAppear:(BOOL)animated
{
    // 親クラスのメソッドを呼び出す
    [super viewWillAppear:animated];
    
    // URLテキストフィールドをfirst responderにする
    [_urlTextField becomeFirstResponder];
    
    // 通知の登録
    NSNotificationCenter*   center;
    center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(connectorDidFinishRetriveTitle:) 
            name:RSSConnectorDidFinishRetriveTitle object:nil];
    
    // 画面を更新する
    [self _updateNavigationItemAnimated:animated];
    [self _updateToolbarAnimated:animated];
    [self _updateTextFields];
}

- (void)viewWillDisappear:(BOOL)animated
{
    // 親クラスのメソッドを呼び出す
    [super viewWillDisappear:animated];
    
    // 登録の解除
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidUnload
{
    // アウトレットを解放する
    [self _releaseOutlets];
}

//--------------------------------------------------------------//
#pragma mark -- フィード --
//--------------------------------------------------------------//

- (void)_saveFeed
{
    // 編集中のチャンネルを取得する
    RSSChannel* channel;
    channel = _channel;
    
    // チャンネルがない場合は新たに作成する
    if (!channel) {
        // 新規チャンネルを作成する
        channel = [[RSSChannel alloc] init];
        [channel autorelease];
        
        // チャンネルを追加する
        [[RSSChannelManager sharedManager] addChannel:channel];
    }
    
    // タイトルを設定する
    channel.title = _titleTextField.text;
    
    // URLを設定する
    channel.feedUrlString = _urlTextField.text;
    
    // チャンネルを保存する
    [[RSSChannelManager sharedManager] save];
    
    // デリゲートに通知する
    if ([_delegate respondsToSelector:@selector(feedControllerDidSave:)]) {
        [_delegate feedControllerDidSave:self];
    }
}

//--------------------------------------------------------------//
#pragma mark -- 画面の更新 --
//--------------------------------------------------------------//

- (void)_updateNavigationItemAnimated:(BOOL)animated
{
    // ナビゲーションアイテムの設定を行う
    [self.navigationItem setLeftBarButtonItem:_cancelItem animated:animated];
    [self.navigationItem setRightBarButtonItem:_saveItem animated:animated];
}

- (void)_updateToolbarAnimated:(BOOL)animated
{
    // ツールバーを隠す
    [self.navigationController setToolbarHidden:YES animated:animated];
}

- (void)_updateTextFields
{
    // タイトルテキストフィールドを更新する
    _titleTextField.text = _channel.title;
    
    // URLテキストフィールドを更新する
    _urlTextField.text = _channel.feedUrlString;
}

//--------------------------------------------------------------//
#pragma mark -- アクション --
//--------------------------------------------------------------//

- (IBAction)cancelAction
{
    // ネットワークの状態を確認する
    if ([RSSConnector sharedConnector].networkAccessing) {
        // タイトルの取得中なのでキャンセルしない
        return;
    }
    
    // デリゲートに通知する
    if ([_delegate respondsToSelector:@selector(feedControllerDidCancel:)]) {
        [_delegate feedControllerDidCancel:self];
    }
}

- (IBAction)saveAction
{
    // ネットワークの状態を確認する
    if ([RSSConnector sharedConnector].networkAccessing) {
        // タイトルの取得中なので保存しない
        return;
    }
    
    // タイトルを取得する
    NSString*   title;
    title = _titleTextField.text;
    
    // タイトルが設定されていない場合
    if ([title length] == 0) {
        // タイトルを取得する
        [[RSSConnector sharedConnector] 
                retrieveTitleWithUrlString:_urlTextField.text];
        
        return;
    }
    
    // 編集中のチャンネルを取得する
    RSSChannel* channel;
    channel = _channel;
    
    // チャンネルがない場合は新たに作成する
    if (!channel) {
        // 新規チャンネルを作成する
        channel = [[RSSChannel alloc] init];
        [channel autorelease];
        
        // チャンネルを追加する
        [[RSSChannelManager sharedManager] addChannel:channel];
    }
    
    // タイトルを設定する
    channel.title = _titleTextField.text;
    
    // URLを設定する
    channel.feedUrlString = _urlTextField.text;
    
    // チャンネルを保存する
    [[RSSChannelManager sharedManager] save];
    
    // デリゲートに通知する
    if ([_delegate respondsToSelector:@selector(feedControllerDidSave:)]) {
        [_delegate feedControllerDidSave:self];
    }
}

//--------------------------------------------------------------//
#pragma mark -- UIAlertViewDelegate --
//--------------------------------------------------------------//

- (void)alertView:(UIAlertView*)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    // キャンセルの場合
    if (buttonIndex == alertView.cancelButtonIndex) {
        // URLテキストフィールドをfirst responderにする
        [_urlTextField becomeFirstResponder];
        
        return;
    }
    
    // フィードを保存する
    [self _saveFeed];
}

//--------------------------------------------------------------//
#pragma mark -- RSSConnector notification --
//--------------------------------------------------------------//

- (void)connectorDidFinishRetriveTitle:(NSNotification*)notification
{
    // パーサを取得する
    RSSResponseParser*  parser;
    parser = [[notification userInfo] objectForKey:@"parser"];
    
    // タイトルを取得する
    NSString*   title;
    title = parser.parsedChannel.title;
    if (!title) {
        // エラーを表示する
        UIAlertView*    alert;
        alert = [[UIAlertView alloc] 
                initWithTitle:@"RSS" 
                message:@"タイトルの取得に失敗しました" 
                delegate:self 
                cancelButtonTitle:@"URLを入力し直す" 
                otherButtonTitles:@"このまま保存する", nil];
        [alert autorelease];
        alert.delegate = self;
        [alert show];
        
        return;
    }
    
    // タイトルを設定する
    _titleTextField.text = title;
    
    // フィードを保存する
    [self _saveFeed];
}

@end
