//
//  YXLProcessingView.h
//  B612Demo
//
//  Created by yingxl1992 on 2017/6/22.
//  Copyright © 2017年 yingxl1992. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YXLProcessingViewDelegate <NSObject>

@optional
- (void)YXLProcessionViewDidTakePhoto;
- (void)YXLProcessionViewDidClickFilterButton;

@end

@interface YXLProcessingView : UIView

@property (nonatomic, weak) id<YXLProcessingViewDelegate> delegate;

@end
