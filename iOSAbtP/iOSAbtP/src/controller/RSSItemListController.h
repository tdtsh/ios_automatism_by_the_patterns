//
//  RSSItemListController.h
//  iOSAbtP
//
//  Created by 花崎 忠利 on 2012/10/14.
//  Copyright (c) 2012年 tadatoshi_hanazaki. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RSSChannel;

@interface RSSItemListController : UIViewController
{
    RSSChannel* _channel;
    
    id          _delegate; // Assign
    
    IBOutlet UITableView*       _tableView;
    
    IBOutlet UIBarButtonItem*   _markItem;
}

// プロパティ
@property (nonatomic, retain) RSSChannel* channel;
@property (nonatomic, assign) id delegate;

// アクション
- (IBAction)markAction;

@end
