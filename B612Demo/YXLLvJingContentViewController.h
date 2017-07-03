//
//  YXLLvJingContentViewController.h
//  B612Demo
//
//  Created by yingxl1992 on 2017/6/28.
//  Copyright © 2017年 yingxl1992. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YXLLvJingContentViewControllerdelegate <NSObject>

@required
- (void)lvJingContentViewControllerChangeFilterType:(NSString *)filterType;

@end

@interface YXLLvJingContentViewController : UIViewController

@property (nonatomic, weak) id<YXLLvJingContentViewControllerdelegate> delegate;

@end
