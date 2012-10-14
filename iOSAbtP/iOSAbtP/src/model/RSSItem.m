//
//  RSSItem.m
//  iOSAbtP
//
//  Created by 花崎 忠利 on 2012/10/14.
//  Copyright (c) 2012年 tadatoshi_hanazaki. All rights reserved.
//

#import "RSSItem.h"

@implementation RSSItem

// プロパティ
@synthesize identifier = _identifier;
@synthesize read = _read;
@synthesize title = _title;
@synthesize link = _link;
@synthesize itemDescription = _itemDescription;
@synthesize pubDate = _pubDate;

//--------------------------------------------------------------//
#pragma mark -- 初期化 --
//--------------------------------------------------------------//

- (id)init
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    // 識別子を作成する
    CFUUIDRef   uuid;
    uuid = CFUUIDCreate(NULL);
    _identifier = (NSString*)CFUUIDCreateString(NULL, uuid);
    CFRelease(uuid);
    
    return self;
}

- (id)initWithCoder:(NSCoder*)decoder
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    // インスタンス変数をデコードする
    _identifier = [[decoder decodeObjectForKey:@"identifier"] retain];
    _read = [decoder decodeBoolForKey:@"read"];
    _title = [[decoder decodeObjectForKey:@"title"] retain];
    _link = [[decoder decodeObjectForKey:@"link"] retain];
    _itemDescription = [[decoder decodeObjectForKey:@"itemDescription"] retain];
    _pubDate = [[decoder decodeObjectForKey:@"pubDate"] retain];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder*)encoder
{
    // インスタンス変数をエンコードする
    [encoder encodeObject:_identifier forKey:@"identifier"];
    [encoder encodeBool:_read forKey:@"read"];
    [encoder encodeObject:_title forKey:@"title"];
    [encoder encodeObject:_link forKey:@"link"];
    [encoder encodeObject:_itemDescription forKey:@"itemDescription"];
    [encoder encodeObject:_pubDate forKey:@"pubDate"];
}

- (void)dealloc
{
    // インスタンス変数を解放する
    [_identifier release], _identifier = nil;
    [_title release], _title = nil;
    [_link release], _link = nil;
    [_itemDescription release], _itemDescription = nil;
    [_pubDate release], _pubDate = nil;
    
    // 親クラスのdeallocを呼び出す
    [super dealloc];
}

@end
