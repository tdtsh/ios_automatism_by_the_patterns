//
//  RSSChannel.h
//  iOSAbtP
//
//  Created by 花崎 忠利 on 2012/10/14.
//  Copyright (c) 2012年 tadatoshi_hanazaki. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RSSChannel : NSObject <NSCoding>
{
    NSString*       _identifier;    // 識別子
    NSString*       _feedUrlString; // フィードURL
    
    NSString*       _title;         // タイトル
    NSString*       _link;          // リンク
    
    NSMutableArray* _items;         // アイテムの配列
}

// プロパティ
@property (nonatomic, readonly) NSString* identifier;
@property (nonatomic, retain) NSString* feedUrlString;
@property (nonatomic, retain) NSString* title;
@property (nonatomic, retain) NSString* link;
@property (nonatomic, readonly) NSMutableArray* items;

@end
