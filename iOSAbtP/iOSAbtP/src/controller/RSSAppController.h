//
//  RSSAppController.h
//  iOSAbtP
//
//  Created by 花崎 忠利 on 12/09/04.
//  Copyright (c) 2012年 tadatoshi_hanazaki. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RSSChannelListController;

//サンプルコードはこうなっているが
//@interface RSSAppController : NSObject
//本ではこうなっている。どっちが正しいのか
@interface RSSAppController : NSObject <UIApplicationDelegate>
{
    IBOutlet RSSChannelListController* _channelListController;
    IBOutlet UINavigationController*   _channelListNavController;
    
    IBOutlet UIWindow*                 _window;
}

// プロパティ
@property (nonatomic, readonly) RSSChannelListController* channelListController;
@property (nonatomic, readonly) UINavigationController* channelListNavController;
@property (nonatomic, readonly) UIWindow* window;

@end
