//
//  RSSChannelCell.h
//  iOSAbtP
//
//  Created by 花崎 忠利 on 2012/10/14.
//  Copyright (c) 2012年 tadatoshi_hanazaki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface RSSChannelCell : UITableViewCell
{
    // サブビュー
    UILabel*        _titleLabel;
    UILabel*        _feedLabel;
    UIImageView*    _numberBackgroundImageView;
    UILabel*        _numberLabel;
}

// プロパティ
@property (nonatomic, retain) UILabel* titleLabel;
@property (nonatomic, retain) UILabel* feedLabel;
@property (nonatomic) int itemNumber;

@end
