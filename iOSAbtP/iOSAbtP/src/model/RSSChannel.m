//
//  RSSChannel.m
//  iOSAbtP
//
//  Created by 花崎 忠利 on 2012/10/14.
//  Copyright (c) 2012年 tadatoshi_hanazaki. All rights reserved.
//

#import "RSSChannel.h"

@implementation RSSChannel

// プロパティ
@synthesize identifier = _identifier;
@synthesize feedUrlString = _feedUrlString;
@synthesize title = _title;
@synthesize link = _link;
@synthesize items = _items;

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
    
    _items = [[NSMutableArray array] retain];
    
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
    _feedUrlString = [[decoder decodeObjectForKey:@"feedUrlString"] retain];
    _title = [[decoder decodeObjectForKey:@"title"] retain];
    _link = [[decoder decodeObjectForKey:@"link"] retain];
    _items = [[decoder decodeObjectForKey:@"items"] retain];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder*)encoder
{
    // インスタンス変数をエンコードする
    [encoder encodeObject:_identifier forKey:@"identifier"];
    [encoder encodeObject:_feedUrlString forKey:@"feedUrlString"];
    [encoder encodeObject:_title forKey:@"title"];
    [encoder encodeObject:_link forKey:@"link"];
    [encoder encodeObject:_items forKey:@"items"];
}

- (void)dealloc
{
    // インスタンス変数を解放する
    [_identifier release], _identifier = nil;
    [_feedUrlString release], _feedUrlString = nil;
    [_title release], _title = nil;
    [_link release], _link = nil;
    [_items release], _items = nil;
    
    // 親クラスのdeallocを呼び出す
    [super dealloc];
}

@end
