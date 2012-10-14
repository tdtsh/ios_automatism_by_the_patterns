//
//  RSSChannelManager.h
//  iOSAbtP
//
//  Created by 花崎 忠利 on 2012/10/14.
//  Copyright (c) 2012年 tadatoshi_hanazaki. All rights reserved.
//

//#import <Foundation/Foundation.h>
//@interface RSSChannelManager : NSObject
//@end
#import <UIKit/UIKit.h>

@class RSSChannel;

@interface RSSChannelManager : NSObject
{
    NSMutableArray* _channels;  // チャンネルの配列
}

// プロパティ
@property (nonatomic, readonly) NSArray* channels;

// 初期化
+ (RSSChannelManager*)sharedManager;

// チャンネルの操作
- (void)addChannel:(RSSChannel*)channel;
- (void)insertChannel:(RSSChannel*)channel atIndex:(unsigned int)index;
- (void)removeChannelAtIndex:(unsigned int)index;
- (void)moveChannelAtIndex:(unsigned int)fromIndex toIndex:(unsigned int)toIndex;

// 永続化
- (void)load;
- (void)save;

@end
