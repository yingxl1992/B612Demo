//
//  UIView+Utils.m
//  B612Demo
//
//  Created by yingxl1992 on 2017/6/27.
//  Copyright © 2017年 yingxl1992. All rights reserved.
//

#import "UIView+Utils.h"

@implementation UIView (Utils)

- (void)removeAllSubviews {
    
    NSArray<UIView *> *subviews = [self subviews];
    for (UIView *subview in subviews) {
        [subview removeFromSuperview];
    }
}

@end
