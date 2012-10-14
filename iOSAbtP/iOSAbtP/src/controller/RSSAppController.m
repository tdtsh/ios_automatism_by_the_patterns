//
//  RSSAppController.m
//  iOSAbtP
//
//  Created by 花崎 忠利 on 12/09/04.
//  Copyright (c) 2012年 tadatoshi_hanazaki. All rights reserved.
//

#import "RSSChannelManager.h"
#import "RSSConnector.h"
#import "RSSAppController.h"
#import "RSSChannelListController.h"

@implementation RSSAppController

/////////////////////////////////////////////////////////////////////
// この様にすることで、他のどのコントローラからでもアプリコントローラ
// の参照を取得できる
/////////////////////////////////////////////////////////////////////
// RSSAppControllerの参照を入れておく共用static変数
static RSSAppController*    _sharaedInstance = nil;

+ (RSSAppController*)sharedController
{
    // 共用static変数を返す
    return _sharaedInstance;
}

- (id)init
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    // 共用static変数に、参照を設定する
    _sharaedInstance = self;
    
    return self;
}
/////////////////////////////////////////////////////////////////////





- (void)applicationDidFinishLaunching:(UIApplication*)application
{
    // データを読み込む
    [[RSSChannelManager sharedManager] load];
    
    // チャンネルリストコントローラを作成する
//    _channelListController = [[RSSChannelListController alloc] init];
    
    // ルートとなるナビゲーションコントローラを作成する
//    _navChannelListController = [[UINavigationController alloc] initWithRootViewController:_channelListController];
    
    // ウィンドウにルートビューコントローラを追加する
    CGRect rect;
    rect = [UIScreen mainScreen] .applicationFrame;
    _navChannelListController.view.frame = rect;
    [_window addSubview:_navChannelListController];
    
    // ウィンドウを表示する
    [_window makeKeyAndVisible];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // データを保存する
    [[RSSChannelManager sharedManager] save];
}





@end
