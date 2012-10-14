//
//  RSSItemListController.m
//  iOSAbtP
//
//  Created by 花崎 忠利 on 2012/10/14.
//  Copyright (c) 2012年 tadatoshi_hanazaki. All rights reserved.
//

#import "RSSItem.h"
#import "RSSChannel.h"
#import "RSSChannelManager.h"
#import "RSSItemListController.h"
#import "RSSContentController.h"

@interface RSSItemListController (private)

// 画面の更新
- (void)_updateNavigationItemAnimated:(BOOL)animated;
- (void)_updateToolbarItemsAnimated:(BOOL)animated;
- (void)_updateCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath;

@end

@implementation RSSItemListController

// プロパティ
@synthesize channel = _channel;
@synthesize delegate = _delegate;

//--------------------------------------------------------------//
#pragma mark -- Initialize --
//--------------------------------------------------------------//

- (void)_init
{
    // コントローラの設定
    self.title = NSLocalizedString(@"Item List", nil);
}

- (id)init
{
    // nibファイル名を指定して、初期化メソッドを呼び出す
    self = [super initWithNibName:@"ItemList" bundle:nil];
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
    [_markItem release], _markItem = nil;
}

- (void)dealloc
{
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
    
    // 画面を更新する
    [self _updateNavigationItemAnimated:animated];
    [self _updateToolbarItemsAnimated:animated];
    
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

- (void)viewDidUnload
{
    // アウトレットを解放する
    [self _releaseOutlets];
}

//--------------------------------------------------------------//
#pragma mark -- 画面の更新 --
//--------------------------------------------------------------//

- (void)_updateNavigationItemAnimated:(BOOL)animated
{
    // ナビゲーションアイテムの設定を行う
    // ここでは特にやることなし
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
    // 指定された行のアイテムの取得
    NSArray*    items;
    RSSItem*    item = nil;
    items = _channel.items;
    if (indexPath.row < [items count]) {
        item = [items objectAtIndex:indexPath.row];
    }
    
    // タイトルの設定
    cell.textLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    cell.textLabel.text = item.title;
    
    // フィードURLの設定
    cell.detailTextLabel.text = item.pubDate;
    
    // 未読マークの設定
    UIImage*    image;
    image = item.read ? [UIImage imageNamed:@"read.png"] : [UIImage imageNamed:@"unread.png"];
    cell.imageView.image = image;
    
    // アクセサリの設定
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

//--------------------------------------------------------------//
#pragma mark -- アクション --
//--------------------------------------------------------------//

- (IBAction)markAction
{
    // アイテムを既読にする
    for (RSSItem* item in _channel.items) {
        item.read = YES;
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
    return [_channel.items count];
}

- (UITableViewCell*)tableView:(UITableView*)tableView 
        cellForRowAtIndexPath:(NSIndexPath *)indexPath
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

//--------------------------------------------------------------//
#pragma mark -- UITableViewDelegate --
//--------------------------------------------------------------//

- (void)tableView:(UITableView*)tableView 
        didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    // アイテムを取得する
    NSArray*    items;
    RSSItem*    item = nil;
    items = _channel.items;
    if (indexPath.row < [items count]) {
        item = [items objectAtIndex:indexPath.row];
    }
    
    if (!item) {
        return;
    }
    
    // コントローラを作成する
    RSSContentController*   controller;
    controller = [[RSSContentController alloc] init];
    controller.item = item;
    controller.delegate = self;
    
    // 自動解放する
    [controller autorelease];
    
    // ナビゲーションコントローラに追加する
    [self.navigationController pushViewController:controller animated:YES];
}

@end
