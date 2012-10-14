//
//  RSSFeedListController.m
//  iOSAbtP
//
//  Created by 花崎 忠利 on 2012/10/14.
//  Copyright (c) 2012年 tadatoshi_hanazaki. All rights reserved.
//

#import "RSSChannel.h"
#import "RSSChannelManager.h"
#import "RSSFeedListController.h"
#import "RSSFeedController.h"

@interface RSSFeedListController (private)

// 画面の更新
- (void)_updateNavigationItemAnimated:(BOOL)animated;
- (void)_updateToolbarAnimated:(BOOL)animated;
- (void)_updateCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath;

@end

@implementation RSSFeedListController

// プロパティ
@synthesize delegate = _delegate;

//--------------------------------------------------------------//
#pragma mark -- 初期化 --
//--------------------------------------------------------------//

- (void)_init
{
    // コントローラの設定
    self.title = NSLocalizedString(@"Feed List", nil);
}

- (id)init
{
    // nibファイル名を指定して、初期化メソッドを呼び出す
    self = [super initWithNibName:@"FeedList" bundle:nil];
    if (!self) {
        return nil;
    }
    
    // 共通の初期化メソッド
    [self _init];
    
    return self;
}

- (void)_releaseOutlets
{
    // アウトレットを解放する
    [_tableView release], _tableView = nil;
    [_addItem release], _addItem = nil;
    [_doneItem release], _doneItem = nil;
}

- (void)dealloc
{
    // アウトレットを解放する
    [self _releaseOutlets];
    
    // インスタンス変数を解放する
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
    
    // 画面を更新する
    [self _updateNavigationItemAnimated:animated];
    [self _updateToolbarAnimated:animated];
    
    // 選択されているセルを解除する
    NSIndexPath*    indexPath;
    indexPath = [_tableView indexPathForSelectedRow];
    if (indexPath) {
        [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    
    // セルの表示更新を行う
    for (UITableViewCell* cell in [_tableView visibleCells]) {
        [self _updateCell:cell atIndexPath:[_tableView indexPathForCell:cell]];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    // 親クラスのメソッドを呼び出す
    [super viewDidAppear:animated];
}

- (void)viewDidUnload
{
    // アウトレットを解放する
    [self _releaseOutlets];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

//--------------------------------------------------------------//
#pragma mark -- プロパティ --
//--------------------------------------------------------------//

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    // 親クラスのメソッドを呼び出す
    [super setEditing:editing animated:animated];
    
    // テーブルビューの編集モードを設定する
    [_tableView setEditing:editing animated:animated];
    
    // 画面を更新する
    [self _updateNavigationItemAnimated:animated];
}

//--------------------------------------------------------------//
#pragma mark -- 画面の更新 --
//--------------------------------------------------------------//

- (void)_updateNavigationItemAnimated:(BOOL)animated
{
    // 編集モードの場合
    if (self.editing) {
        // ナビゲーションアイテムの設定を行う
        [self.navigationItem setLeftBarButtonItem:nil animated:animated];
        [self.navigationItem setRightBarButtonItem:nil animated:animated];
    }
    // 通常モードの場合
    else {
        // ナビゲーションアイテムの設定を行う
        [self.navigationItem setLeftBarButtonItem:_addItem animated:animated];
        [self.navigationItem setRightBarButtonItem:_doneItem animated:animated];
    }
}

- (void)_updateToolbarAnimated:(BOOL)animated
{
    // ツールバーを表示する
    [self.navigationController setToolbarHidden:NO animated:animated];
    
    // ツールバーアイテムの設定を行う
    NSArray*    toolbarItems;
    toolbarItems = [NSArray arrayWithObject:[self editButtonItem]];
    [self setToolbarItems:toolbarItems animated:animated];
}

- (void)_updateCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath
{
    // 指定された行のチャンネルの取得
    NSArray*    channels;
    RSSChannel* channel = nil;
    channels = [RSSChannelManager sharedManager].channels;
    if (indexPath.row < [channels count]) {
        channel = [channels objectAtIndex:indexPath.row];
    }
    
    // タイトルの設定
    NSString*   title;
    UIColor*    titleColor;
    title = channel.title;
    titleColor = [UIColor blackColor];
    if ([title length] == 0) {
        title = @"（名称未設定）";
        titleColor = [UIColor grayColor];
    }
    cell.textLabel.text = title;
    cell.textLabel.textColor = titleColor;
    
    // フィードURLの設定
    NSString*   feedUrlString;
    feedUrlString = channel.feedUrlString;
    if ([feedUrlString length] == 0) {
        feedUrlString = @"（URLが設定されていません）";
    }
    cell.detailTextLabel.text = feedUrlString;
    
    // アクセサリの設定
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

//--------------------------------------------------------------//
#pragma mark -- Action --
//--------------------------------------------------------------//

- (IBAction)addAction
{
    // コントローラを作成する
    RSSFeedController*  controller;
    controller = [[RSSFeedController alloc] init];
    controller.delegate = self;
    
    // 自動解放する
    [controller autorelease];
    
    // ナビゲーションコントローラに追加する
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)doneAction
{
    // デリゲートに通知する
    if ([_delegate respondsToSelector:@selector(feedListControllerDidFinish:)]) {
        [_delegate feedListControllerDidFinish:self];
    }
}

//--------------------------------------------------------------//
#pragma mark -- UITableViewDataSource --
//--------------------------------------------------------------//

- (NSInteger)tableView:(UITableView*)tableView 
        numberOfRowsInSection:(NSInteger)section
{
    // 配列の数を返す
    return [[RSSChannelManager sharedManager].channels count];
}

- (UITableViewCell*)tableView:(UITableView*)tableView 
        cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    // セルを取得する
    UITableViewCell*    cell;
    cell = [_tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] 
                initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UITableViewCell"];
        [cell autorelease];
    }
    
    // セルの値を更新する
    [self _updateCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (BOOL)tableView:(UITableView*)tableView 
        canEditRowAtIndexPath:(NSIndexPath*)indexPath
{
    return YES;
}

- (void)tableView:(UITableView*)tableView 
        commitEditingStyle:(UITableViewCellEditingStyle)editingStyle 
        forRowAtIndexPath:(NSIndexPath*)indexPath
{
    // 削除操作の場合
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // チャンネルを削除する
        [[RSSChannelManager sharedManager] removeChannelAtIndex:indexPath.row];
        
        // チャンネルを保存する
        [[RSSChannelManager sharedManager] save];
        
        // テーブルの行を削除する
        [_tableView beginUpdates];
        [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] 
                withRowAnimation:UITableViewRowAnimationRight];
        [_tableView endUpdates];
    }
}

- (BOOL)tableView:(UITableView*)tableView 
        canMoveRowAtIndexPath:(NSIndexPath*)indexPath
{
    return YES;
}

- (void)tableView:(UITableView*)tableView 
        moveRowAtIndexPath:(NSIndexPath*)fromIndexPath 
        toIndexPath:(NSIndexPath*)toIndexPath
{
    // チャンネルを移動する
    [[RSSChannelManager sharedManager] 
            moveChannelAtIndex:fromIndexPath.row toIndex:toIndexPath.row];
    
    // チャンネルを保存する
    [[RSSChannelManager sharedManager] save];
}

//--------------------------------------------------------------//
#pragma mark -- UITableViewDelegate --
//--------------------------------------------------------------//

- (void)tableView:(UITableView*)tableView 
        didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    // チャンネルを取得する
    NSArray*    channels;
    RSSChannel* channel = nil;
    channels = [RSSChannelManager sharedManager].channels;
    if (indexPath.row < [channels count]) {
        channel = [channels objectAtIndex:indexPath.row];
    }
    
    if (!channel) {
        return;
    }
    
    // コントローラを作成する
    RSSFeedController*  controller;
    controller = [[RSSFeedController alloc] init];
    controller.channel = channel;
    controller.delegate = self;
    
    // 自動解放する
    [controller autorelease];
    
    // ナビゲーションコントローラに追加する
    [self.navigationController pushViewController:controller animated:YES];
}

//--------------------------------------------------------------//
#pragma mark -- RSSFeedControllerDelegate --
//--------------------------------------------------------------//

- (void)feedControllerDidCancel:(RSSFeedController*)controller
{
    // コントローラをポップする
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)feedControllerDidSave:(RSSFeedController*)controller
{
    // コントローラをポップする
    [self.navigationController popViewControllerAnimated:YES];
    
    // テーブルの行の数とチャンネルの数を比較する
    NSArray*    channels;
    channels = [RSSChannelManager sharedManager].channels;
    if ([_tableView numberOfRowsInSection:0] != [channels count]) {
        // データの再読み込みを行う
        [_tableView reloadData];
        
        // 最後の行を表示する
        NSIndexPath*    lastIndexPath;
        lastIndexPath = [NSIndexPath indexPathForRow:[channels count] - 1 inSection:0];
        [_tableView scrollToRowAtIndexPath:lastIndexPath 
                atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
}

@end
