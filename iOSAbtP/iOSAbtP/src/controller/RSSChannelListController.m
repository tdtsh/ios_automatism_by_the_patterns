//
//  RSSChannelListController.m
//  iOSAbtP
//
//  Created by 花崎 忠利 on 2012/10/14.
//  Copyright (c) 2012年 tadatoshi_hanazaki. All rights reserved.
//

#import "RSSItem.h"
#import "RSSChannel.h"
#import "RSSChannelManager.h"
#import "RSSConnector.h"
#import "RSSChannelListController.h"
#import "RSSFeedListController.h"
#import "RSSItemListController.h"
#import "RSSChannelCell.h"

@interface RSSChannelListController (private)

// 画面の更新
- (void)_updateNavigationItemAnimated:(BOOL)animated;
- (void)_updateToolbarItemsAnimated:(BOOL)animated;
- (void)_updateCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath;

@end

@implementation RSSChannelListController

// プロパティ
@synthesize delegate = _delegate;

//--------------------------------------------------------------//
#pragma mark -- 初期化 --
//--------------------------------------------------------------//

- (void)_init
{
    // コントローラの設定
    self.title = NSLocalizedString(@"Channel List", nil);
}

- (id)initWithCoder:(NSCoder*)decoder
{
    self = [super initWithCoder:decoder];
    if (!self) {
        return nil;
    }
    
    // 共通の初期化メソッド
    [self _init];
    
    return self;
}

- (id)initWithNibName:(NSString*)nibName bundle:(NSBundle*)bundle
{
    self = [super initWithNibName:nibName bundle:nil];
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
    [_feedItem release], _feedItem = nil;
    [_refreshItem release], _refreshItem = nil;
    [_markItem release], _markItem = nil;
}

- (void)dealloc
{
    // 登録の解除
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    // アウトレットを解放する
    [self _releaseOutlets];
    
    // インスタンス変数を解放する
    [_refreshAllChannelsSheet release], _refreshAllChannelsSheet = nil;
    
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
    [self _updateToolbarItemsAnimated:animated];
    
    // テーブルの行の数とチャンネルの数を比較する
    NSArray*    channels;
    channels = [RSSChannelManager sharedManager].channels;
    if ([_tableView numberOfRowsInSection:0] != [channels count]) {
        // データの再読み込みを行う
        [_tableView reloadData];
        
        // 最後の行を表示する
        if ([channels count] > 0) {
            NSIndexPath*    lastIndexPath;
            lastIndexPath = [NSIndexPath indexPathForRow:[channels count] - 1 inSection:0];
            [_tableView scrollToRowAtIndexPath:lastIndexPath 
                    atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
    }
    // データの再読み込みを行わない場合
    else {
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
    
    // 通知の登録
    NSNotificationCenter*   center;
    center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(connectorDidBeginRefreshAllChannels:) 
            name:RSSConnectorDidBeginRefreshAllChannels object:nil];
    [center addObserver:self selector:@selector(connectorInProgressRefreshAllChannels:) 
            name:RSSConnectorInProgressRefreshAllChannels object:nil];
    [center addObserver:self selector:@selector(connectorDidFinishRefreshAllChannels:) 
            name:RSSConnectorDidFinishRefreshAllChannels object:nil];
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

//--------------------------------------------------------------//
#pragma mark -- 画面の更新 --
//--------------------------------------------------------------//

- (void)_updateNavigationItemAnimated:(BOOL)animated
{
    // ナビゲーションアイテムの設定を行う
    [self.navigationItem setLeftBarButtonItem:_feedItem animated:animated];
    [self.navigationItem setRightBarButtonItem:_refreshItem animated:animated];
}

- (void)_updateToolbarItemsAnimated:(BOOL)animated
{
    // ツールバーを表示する
    [self.navigationController setToolbarHidden:NO animated:animated];
    
    // ツールバーアイテムの設定を行う
    NSArray*    toolbarItems;
    toolbarItems = [NSArray arrayWithObjects:_markItem, nil];
    [self setToolbarItems:toolbarItems animated:animated];
}

- (void)_updateCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath
{
    // セルのキャスト
    RSSChannelCell* channelCell;
    channelCell = (RSSChannelCell*)cell;
    
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
    channelCell.titleLabel.text = title;
    channelCell.titleLabel.textColor = titleColor;
    
    // フィードURLの設定
    NSString*   feedUrlString;
    feedUrlString = channel.feedUrlString;
    if ([feedUrlString length] == 0) {
        feedUrlString = @"（URLが設定されていません）";
    }
    channelCell.feedLabel.text = feedUrlString;
    
    // 未読記事数の設定
    int itemNumber = 0;
    for (RSSItem* item in channel.items) {
        if (!item.read) {
            itemNumber++;
        }
    }
    channelCell.itemNumber = itemNumber;
    
    // アクセサリの設定
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

//--------------------------------------------------------------//
#pragma mark -- アクション --
//--------------------------------------------------------------//

- (IBAction)feedAction
{
    // コントローラを作成する
    RSSFeedListController*  controller;
    controller = [[RSSFeedListController alloc] init];
    controller.delegate = self;
    
    // 自動解放する
    [controller autorelease];
    
    // ナビゲーションコントローラを作成する
    UINavigationController* navController;
    navController = [[UINavigationController alloc] initWithRootViewController:controller];
    navController.modalPresentationStyle = UIModalPresentationFormSheet;
    
    // 自動解放する
    [navController autorelease];
    
    // モーダルビューとして表示する
    [self presentModalViewController:navController animated:YES];
}

- (IBAction)refreshAction
{
    // 登録してあるすべてのチャンネルを更新する
    [[RSSConnector sharedConnector] refreshAllChannels];
}

- (IBAction)markAction
{
    // すべてのアイテムを既読にする
    for (RSSChannel* channel in [RSSChannelManager sharedManager].channels) {
        for (RSSItem* item in channel.items) {
            item.read = YES;
        }
    }
    
    // セルの表示更新を行う
    for (UITableViewCell* cell in [_tableView visibleCells]) {
        [self _updateCell:cell atIndexPath:[_tableView indexPathForCell:cell]];
    }
    
    // 保存を行う
    [[RSSChannelManager sharedManager] save];
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
        cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // セルを取得する
    RSSChannelCell* cell;
    cell = (RSSChannelCell*)[_tableView dequeueReusableCellWithIdentifier:@"RSSChannelCell"];
    if (!cell) {
        cell = [[RSSChannelCell alloc] 
                initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"RSSChannelCell"];
        [cell autorelease];
    }
    
    // セルの値を更新する
    [self _updateCell:cell atIndexPath:indexPath];
    
    return cell;
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
    RSSItemListController*  controller;
    controller = [[RSSItemListController alloc] init];
    controller.channel = channel;
    controller.delegate = self;
    
    // 自動解放する
    [controller autorelease];
    
    // ナビゲーションコントローラに追加する
    [self.navigationController pushViewController:controller animated:YES];
}

//--------------------------------------------------------------//
#pragma mark -- RSSFeedListControllerDelegate --
//--------------------------------------------------------------//

- (void)feedListControllerDidFinish:(RSSFeedListController*)controller
{
    // コントローラを隠す
    [controller dismissModalViewControllerAnimated:YES];
}

//--------------------------------------------------------------//
#pragma mark -- RSSConnector notification --
//--------------------------------------------------------------//

- (void)connectorDidBeginRefreshAllChannels:(NSNotification*)notification
{
    // アクションシートを表示する
    _refreshAllChannelsSheet = [[UIActionSheet alloc] 
            initWithTitle:@"Refreshing all channels…" 
            delegate:self 
            cancelButtonTitle:@"Cancel" 
            destructiveButtonTitle:nil 
            otherButtonTitles:nil];
    [_refreshAllChannelsSheet showFromToolbar:self.navigationController.toolbar];
}

- (void)connectorInProgressRefreshAllChannels:(NSNotification*)notification
{
    // 進捗を取得する
    float   progress;
    progress = [[RSSConnector sharedConnector] progressOfRefreshAllChannels];
    
    // アクションシートのタイトルを更新する
    _refreshAllChannelsSheet.title = 
            [NSString stringWithFormat:@"Refreshing all channels… %d", (int)(progress * 100)];
}

- (void)connectorDidFinishRefreshAllChannels:(NSNotification*)notification
{
    // アクションシートを隠す
    [_refreshAllChannelsSheet dismissWithClickedButtonIndex:0 animated:YES];
    [_refreshAllChannelsSheet release], _refreshAllChannelsSheet = nil;
    
    // セルの表示更新を行う
    for (UITableViewCell* cell in [_tableView visibleCells]) {
        [self _updateCell:cell atIndexPath:[_tableView indexPathForCell:cell]];
    }
    
    // 保存を行う
    [[RSSChannelManager sharedManager] save];
}

@end
