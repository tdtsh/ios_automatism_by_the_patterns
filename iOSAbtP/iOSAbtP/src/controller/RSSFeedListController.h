//
//  RSSFeedListController.h
//  iOSAbtP
//
//  Created by 花崎 忠利 on 2012/10/14.
//  Copyright (c) 2012年 tadatoshi_hanazaki. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RSSFeedListController : UIViewController
{
    id  _delegate; // Assign
    
    IBOutlet UITableView*       _tableView;
    
    IBOutlet UIBarButtonItem*   _addItem;
    IBOutlet UIBarButtonItem*   _doneItem;
}

// プロパティ
@property (nonatomic, assign) id delegate;

// アクション
- (IBAction)addAction;
- (IBAction)doneAction;

@end

// デリゲートメソッド
@interface NSObject (RSSFeedListControllerDelegate)

- (void)feedListControllerDidFinish:(RSSFeedListController*)controller;

@end
