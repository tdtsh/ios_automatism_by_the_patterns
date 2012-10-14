//
//  RSSChannelListController.h
//  iOSAbtP
//
//  Created by 花崎 忠利 on 2012/10/14.
//  Copyright (c) 2012年 tadatoshi_hanazaki. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RSSChannelListController : UIViewController <UIActionSheetDelegate>
{
    UIActionSheet*  _refreshAllChannelsSheet;
    
    id              _delegate; // Assign
    
    IBOutlet UITableView*       _tableView;
    
    IBOutlet UIBarButtonItem*   _feedItem;
    IBOutlet UIBarButtonItem*   _refreshItem;
    IBOutlet UIBarButtonItem*   _markItem;
}

// プロパティ
@property (nonatomic, assign) id delegate;

// アクション
- (IBAction)feedAction;
- (IBAction)refreshAction;
- (IBAction)markAction;

@end
