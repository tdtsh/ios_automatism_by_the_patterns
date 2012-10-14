//
//  RSSResponseParser.h
//  iOSAbtP
//
//  Created by 花崎 忠利 on 2012/10/14.
//  Copyright (c) 2012年 tadatoshi_hanazaki. All rights reserved.
//

#import <UIKit/UIKit.h>

enum {
    RSSNetworkStateNotConnected = 0, 
    RSSNetworkStateInProgress, 
    RSSNetworkStateFinished, 
    RSSNetworkStateError,
    RSSNetworkStateCanceled, 
};

@class RSSItem;
@class RSSChannel;

@interface RSSResponseParser : NSObject <NSXMLParserDelegate>
{
    int                 _networkState;
    NSString*           _feedUrlString;
    RSSChannel*         _parsedChannel;
    
    NSURLConnection*    _connection;
    NSMutableData*      _downloadedData;
    NSError*            _error;
    
    BOOL                _foundRss;
    BOOL                _isRss;
    BOOL                _isChannel;
    BOOL                _isItem;
    NSMutableString*    _buffer;
    NSMutableArray*     _items;
    RSSItem*            _currentItem; // Assign
    
    id                  _delegate; // Assign
}

// プロパティ
@property (nonatomic, readonly) int networkState;
@property (nonatomic, retain) NSString* feedUrlString;
@property (retain) RSSChannel* parsedChannel;

@property (nonatomic, readonly) NSData* downloadedData;
@property (nonatomic, readonly) NSError* error;
@property (nonatomic, assign) id delegate;

// パース
- (void)parse;

// キャンセル
- (void)cancel;

@end

// デリゲートメソッド
@interface NSObject (RSSResponseParserDelegate)

- (void)parser:(RSSResponseParser*)parser didReceiveResponse:(NSURLResponse*)response;
- (void)parser:(RSSResponseParser*)parser didReceiveData:(NSData*)data;
- (void)parserDidFinishLoading:(RSSResponseParser*)parser;
- (void)parser:(RSSResponseParser*)parser didFailWithError:(NSError*)error;
- (void)parserDidCancel:(RSSResponseParser*)parser;

@end
