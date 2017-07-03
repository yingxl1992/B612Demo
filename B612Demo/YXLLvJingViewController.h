//
//  YXLLvJingViewController.h
//  B612Demo
//
//  Created by yingxl1992 on 2017/6/28.
//  Copyright © 2017年 yingxl1992. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YXLLvJingViewControllerDelegate <NSObject>

@required
- (void)lvJingViewControllerChangeFilterType:(NSString *)filterType;

@end

@interface YXLLvJingViewController : UIViewController

@property (nonatomic, weak) id<YXLLvJingViewControllerDelegate> delegate;

@end
