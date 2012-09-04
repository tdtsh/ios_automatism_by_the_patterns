//
//  RSSAppController.m
//  iOSAbtP
//
//  Created by 花崎 忠利 on 12/09/04.
//  Copyright (c) 2012年 tadatoshi_hanazaki. All rights reserved.
//

#import "RSSAppController.h"

@interface RSSAppController()
{
}

+ (RSSAppController*)sharedController;

@end

@implementation RSSAppController

// RSSAppControllerの参照を入れておく共用static変数
static RSSAppController*    _sharedInstance = nil;


+ (RSSAppController*)sharedController
{
    // 共用static変数を返す
    return _sharedInstance;
}

- (id)init
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    // 共用static変数に、参照を設定する
    _sharedInstance = self;
    
    return self;
}


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
