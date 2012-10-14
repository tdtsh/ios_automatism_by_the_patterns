//
//  RSSContentController.m
//  iOSAbtP
//
//  Created by 花崎 忠利 on 2012/10/14.
//  Copyright (c) 2012年 tadatoshi_hanazaki. All rights reserved.
//

#import "RSSItem.h"
#import "RSSChannelManager.h"
#import "RSSContentController.h"

@interface RSSContentController (private)

// 画面の更新
- (void)_updateHTMLContent;

@end

@implementation RSSContentController

// プロパティ
@synthesize item = _item;
@synthesize delegate = _delegate;

//--------------------------------------------------------------//
#pragma mark -- 初期化 --
//--------------------------------------------------------------//

- (void)_init
{
    // コントローラの設定
    self.title = NSLocalizedString(@"Content", nil);
}

- (id)init
{
    self = [super initWithNibName:@"Content" bundle:nil];
    if (!self) {
        return nil;
    }
    
    // 共通の初期化メソッド
    [self _init];
    
    return self;
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

- (void)_releaseOutlets
{
    // アウトレットを解放する
    [_webView release], _webView = nil;
}

- (void)dealloc
{
    // アウトレットを解放する
    [self _releaseOutlets];
    
    // インスタンス変数を解放する
    [_item release], _item = nil;
    _delegate = nil;
    
    // 親クラスのdeallocを呼び出す
    [super dealloc];
}

//--------------------------------------------------------------//
#pragma mark -- プロパティ --
//--------------------------------------------------------------//

- (void)setItem:(RSSItem*)item
{
    // アイテムを設定する
    if (_item != item) {
        [_item release], _item = nil;
        _item = [item retain];
    }
    
    // アイテムを既読にする
    _item.read = YES;
    
    // 画面を更新する
    [self _updateHTMLContent];
    
    // 保存を行う
    [[RSSChannelManager sharedManager] save];
}

//--------------------------------------------------------------//
#pragma mark -- ビュー --
//--------------------------------------------------------------//

- (void)viewDidLoad
{
    // 画面を更新する
    [self _updateHTMLContent];
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

- (void)_updateHTMLContent
{
    // webViewを確認する
    if (!_webView) {
        return;
    }
    
    // HTMLを作成する
    NSMutableString*    html;
    html = [NSMutableString string];
    
    // ヘッダを追加する
    [html appendString:@"<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\">"];
    [html appendString:@"<html>"];
    [html appendString:@"<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">"];
    [html appendString:@"<meta http-equiv=\"Content-Style-Type\" content=\"text/css\">"];
    [html appendString:@"<meta http-equiv=\"Content-Script-Type\" content=\"text/javascript\">"];
    [html appendString:@"<meta name=\"viewport\" content=\"minimum-scale=1.0, width=device-width, maximum-scale=1.0, user-scalable=no\" />"];
    [html appendString:@"</head>"];
    
    // bodyを追加する
    [html appendString:@"<body>"];
    
    // アイテムを追加する
    if (_item) {
        // titleを追加する
        NSString*   title;
        title = _item.title;
        if (!title) {
            title = NSLocalizedString(@"Untitled", nil);
        }
        [html appendString:@"<h2>"];
        [html appendString:title];
        [html appendString:@"</h2>"];
        
        // linkを追加する
        NSString*   link;
        link = _item.link;
        if (link) {
            [html appendString:@"<h4>"];
            [html appendString:_item.link];
            [html appendString:@"</h4>"];
        }
        
        // pubDateを追加する
        NSString*   pubDate;
        pubDate = _item.pubDate;
        if (pubDate) {
            [html appendString:@"<h4>"];
            [html appendString:_item.pubDate];
            [html appendString:@"</h4>"];
        }
        
        // itemDescriptionを追加する
        NSString*   itemDescription;
        itemDescription = _item.itemDescription;
        if (!itemDescription) {
            itemDescription = @"(No Description)";
        }
        [html appendString:@"<p>"];
        [html appendString:itemDescription];
        [html appendString:@"</p>"];
    }
    
    // bodyの終わり
    [html appendString:@"</body>"];
    
    // HTMLの終わり
    [html appendString:@"</html>"];
    
    // HTMLを読み込む
    [_webView loadHTMLString:html baseURL:nil];
}

@end
