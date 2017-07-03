//
//  YXLProcessingView.m
//  B612Demo
//
//  Created by yingxl1992 on 2017/6/22.
//  Copyright © 2017年 yingxl1992. All rights reserved.
//

#import "YXLProcessingView.h"

@interface YXLProcessingView ()

@property (nonatomic, strong) UIButton *takePhotoButton;
@property (nonatomic, strong) UIButton *lvJingButton;


@end

@implementation YXLProcessingView

- (instancetype)init {
    
    self = [super init];
    if (self) {
        
        [self setupTakePhotoButton];
        [self setupLvJingButton];
    }
    return self;
}

- (void)setupTakePhotoButton {
    self.takePhotoButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_takePhotoButton setTitle:@"咔嚓"
                      forState:UIControlStateNormal & UIControlStateSelected];
    [_takePhotoButton addTarget:self action:@selector(takePhoto:)
               forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_takePhotoButton];
    
    [_takePhotoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.bottom.equalTo(self.mas_bottom);
    }];
}

- (void)setupLvJingButton {
    self.lvJingButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_lvJingButton setTitle:@"滤镜"
                   forState:UIControlStateNormal & UIControlStateSelected];
    [_lvJingButton addTarget:self action:@selector(pushToFilterView)
            forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_lvJingButton];
    
    [_lvJingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.takePhotoButton.mas_right).offset(10);
        make.centerY.equalTo(self.takePhotoButton.mas_centerY);
    }];

}

- (void)takePhoto:(UIButton *)button {
    
    if (self.delegate
        && [self.delegate respondsToSelector:@selector(YXLProcessionViewDidTakePhoto)]) {
        
        [self.delegate YXLProcessionViewDidTakePhoto];
    };
}

- (void)pushToFilterView {
 
    if (self.delegate
        && [self.delegate respondsToSelector:@selector(YXLProcessionViewDidClickFilterButton)]) {
        
        [self.delegate YXLProcessionViewDidClickFilterButton];
    }
}

@end
