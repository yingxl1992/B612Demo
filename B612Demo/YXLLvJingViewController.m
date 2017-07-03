//
//  YXLLvJingViewController.m
//  B612Demo
//
//  Created by yingxl1992 on 2017/6/28.
//  Copyright © 2017年 yingxl1992. All rights reserved.
//

#import "YXLLvJingViewController.h"
#import "YXLTabViewController.h"
#import "YXLMeiJiView.h"
#import "YXLMeiYanView.h"
#import "YXLLvJingContentViewController.h"

@interface YXLLvJingViewController ()
<
YXLLvJingContentViewControllerdelegate
>

@property (nonatomic, strong) YXLLvJingContentViewController *lvJingContentViewController;
@property (nonatomic, strong) YXLTabViewController *tabViewController;
@property (nonatomic, strong) UIButton *photoButton;

@end

@implementation YXLLvJingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (void)setupViews {
    self.lvJingContentViewController = [[YXLLvJingContentViewController alloc] init];
    self.lvJingContentViewController.delegate = self;
    
    self.tabViewController = [[YXLTabViewController alloc] initWithTitles:@[@"滤镜", @"美颜", @"美肌"]
                                                   contentViewControllers:@[self.lvJingContentViewController, [[YXLLvJingContentViewController alloc] init], [[YXLLvJingContentViewController alloc] init]]];
    [self.view addSubview:self.tabViewController.view];
    [self.tabViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.leading.equalTo(self.view);
        make.trailing.equalTo(self.view);
        make.height.mas_equalTo(80);
    }];
    
    self.photoButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.photoButton setTitle:@"咔嚓"
                      forState:UIControlStateNormal & UIControlStateSelected];
    [self.photoButton addTarget:self action:@selector(clickPhotoButton:)
               forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.photoButton];
}

- (void)clickPhotoButton:(UIButton *)button {
    
}

#pragma mark - YXLLvJingContentViewControllerdelegate

- (void)lvJingContentViewControllerChangeFilterType:(NSString *)filterType {
    
    if (self.delegate
        && [self.delegate respondsToSelector:@selector(lvJingViewControllerChangeFilterType:)]) {
        
        [self.delegate lvJingViewControllerChangeFilterType:filterType];
    }
}

@end
