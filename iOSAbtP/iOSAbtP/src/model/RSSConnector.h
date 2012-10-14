//
//  RSSConnector.h
//  iOSAbtP
//
//  Created by 花崎 忠利 on 2012/10/14.
//  Copyright (c) 2012年 tadatoshi_hanazaki. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString*    RSSConnectorDidBeginRetriveTitle;
extern NSString*    RSSConnectorDidFinishRetriveTitle;
extern NSString*    RSSConnectorDidBeginRefreshAllChannels;
extern NSString*    RSSConnectorInProgressRefreshAllChannels;
extern NSString*    RSSConnectorDidFinishRefreshAllChannels;

@interface RSSConnector : NSObject
{
    NSMutableArray* _retrieveTitleParsers;
    NSMutableArray* _refreshAllChannelParsers;
}

// プロパティ
@property (nonatomic, readonly, getter=isNetworkAccessing) BOOL networkAccessing;

// 初期化
+ (RSSConnector*)sharedConnector;

// フィードのタイトル取得
- (void)retrieveTitleWithUrlString:(NSString*)urlString;
- (void)cancelRetrieveTitleWithUrlString:(NSString*)urlString;

// 登録したすべてのチャンネルの更新
- (BOOL)isRefreshingAllChannels;
- (void)refreshAllChannels;
- (float)progressOfRefreshAllChannels;
- (void)cancelRefreshAllChannels;

@end
