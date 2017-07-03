//
//  YXLPhotoAndSaveView.h
//  B612Demo
//
//  Created by yingxl1992 on 2017/6/22.
//  Copyright © 2017年 yingxl1992. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YXLPhotoAndSaveViewDelegate <NSObject>

- (void)YXLPhotoAndSaveViewShouldSavePhoto;
- (void)YXLPhotoAndSaveViewWillDismiss;

@end

@interface YXLPhotoAndSaveView : UIView

@property (nonatomic, weak) id<YXLPhotoAndSaveViewDelegate> delegate;

@end
