//
//  YXLBottomViewController.h
//  B612Demo
//
//  Created by yingxl1992 on 2017/6/26.
//  Copyright © 2017年 yingxl1992. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, YXLBottomState) {
    YXLBottomState_Default,
    YXLBottomState_Filter,
    YXLBottomState_Save
};

@protocol YXLBottomViewControllerDelegate <NSObject>

@required
- (void)bottomViewControllerTakePhoto;
- (void)bottomViewControllerNeedToStartCaptureSession;
- (void)bottomViewControllerNeedToStopCaptureSession;
- (void)YXLBottomViewControllerChangeFilterType:(NSString *)filterType;

@end

@interface YXLBottomViewController : UIViewController

@property (nonatomic, weak) id<YXLBottomViewControllerDelegate> delegate;

@property (nonatomic, assign) YXLBottomState bottomState;
@property (nonatomic, strong) UIImage *jpegData;

@end
