//
//  YXLTabViewController.h
//  B612Demo
//
//  Created by yingxl1992 on 2017/6/28.
//  Copyright © 2017年 yingxl1992. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YXLTabViewController : UIViewController

- (instancetype)initWithTitles:(NSArray<NSString *> *)titles contentViewControllers:(NSArray<UIViewController *> *)contentViewControllers;

@end
