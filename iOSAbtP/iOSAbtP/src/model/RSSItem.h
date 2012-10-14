//
//  RSSItem.h
//  iOSAbtP
//
//  Created by 花崎 忠利 on 2012/10/14.
//  Copyright (c) 2012年 tadatoshi_hanazaki. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RSSItem : NSObject <NSCoding>
{
    NSString*   _identifier;        // 識別子
    BOOL        _read;              // 既読フラグ
    
    NSString*   _title;             // タイトル
    NSString*   _link;              // リンク
    NSString*   _itemDescription;   // 記事の記述
    NSString*   _pubDate;           // 発行された日付
}

// プロパティ
@property (nonatomic, readonly) NSString* identifier;
@property (nonatomic, getter=isRead) BOOL read;
@property (nonatomic, retain) NSString* title;
@property (nonatomic, retain) NSString* link;
@property (nonatomic, retain) NSString* itemDescription;
@property (nonatomic, retain) NSString* pubDate;

@end
