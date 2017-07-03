//
//  YXLPhotoAndSaveView.m
//  B612Demo
//
//  Created by yingxl1992 on 2017/6/22.
//  Copyright © 2017年 yingxl1992. All rights reserved.
//

#import "YXLPhotoAndSaveView.h"

@interface YXLPhotoAndSaveView ()

@property (nonatomic, strong) UIView *buttonView;

@end

@implementation YXLPhotoAndSaveView

- (instancetype)init {
    
    self = [super init];
    if (self) {
        
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    
    [self setupButtonView];
}

- (void)setupButtonView {
    
    self.buttonView = [[UIView alloc] init];
    [self addSubview:_buttonView];
    
    [_buttonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self);
        make.trailing.equalTo(self);
        make.bottom.equalTo(self).offset(-20);
        make.height.mas_equalTo(40);
    }];
    
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [saveButton setTitle:@"保存"
                forState:UIControlStateNormal & UIControlStateSelected];
    [saveButton addTarget:self action:@selector(savePhoto)
         forControlEvents:UIControlEventTouchUpInside];
    [self.buttonView addSubview:saveButton];
    
    [saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.buttonView.mas_centerX);
        make.centerY.equalTo(self.buttonView.mas_centerY);
    }];
 
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [backButton setTitle:@"返回"
                forState:UIControlStateNormal & UIControlStateSelected];
    [backButton addTarget:self action:@selector(backToPrePage)
         forControlEvents:UIControlEventTouchUpInside];
    [self.buttonView addSubview:backButton];
    
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.buttonView.mas_centerY);
        make.right.equalTo(saveButton.mas_left).offset(-20);
    }];
    
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [shareButton setTitle:@"分享"
                forState:UIControlStateNormal & UIControlStateSelected];
    [shareButton addTarget:self action:@selector(sharePhoto)
         forControlEvents:UIControlEventTouchUpInside];
    [self.buttonView addSubview:shareButton];
    
    [shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.buttonView.mas_centerY);
        make.left.equalTo(saveButton.mas_right).offset(20);
    }];
}

- (void)savePhoto {

    if (self.delegate
        && [self.delegate respondsToSelector:@selector(YXLPhotoAndSaveViewShouldSavePhoto)]) {
        
        [self.delegate YXLPhotoAndSaveViewShouldSavePhoto];
    }
}

- (void)backToPrePage {
    
    if (self.delegate
        && [self.delegate respondsToSelector:@selector(YXLPhotoAndSaveViewWillDismiss)]) {
        
        [self.delegate YXLPhotoAndSaveViewWillDismiss];
    }
}

- (void)sharePhoto {
    
}

@end
