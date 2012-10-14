//
//  RSSFeedController.h
//  iOSAbtP
//
//  Created by 花崎 忠利 on 2012/10/14.
//  Copyright (c) 2012年 tadatoshi_hanazaki. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RSSChannel;

@interface RSSFeedController : UIViewController
{
    RSSChannel* _channel;
    
    id          _delegate; // Assign
    
    IBOutlet UITextField*       _titleTextField;
    IBOutlet UITextField*       _urlTextField;
    
    IBOutlet UIBarButtonItem*   _cancelItem;
    IBOutlet UIBarButtonItem*   _saveItem;
}

// プロパティ
@property (nonatomic, retain) RSSChannel* channel;
@property (nonatomic, assign) id delegate;

// アクション
- (IBAction)cancelAction;
- (IBAction)saveAction;

@end

// デリゲートメソッド
@interface NSObject (RSSFeedControllerDelegate)

- (void)feedControllerDidCancel:(RSSFeedController*)controller;
- (void)feedControllerDidSave:(RSSFeedController*)controller;

@end
