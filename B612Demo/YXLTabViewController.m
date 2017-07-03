//
//  YXLTabViewController.m
//  B612Demo
//
//  Created by yingxl1992 on 2017/6/28.
//  Copyright © 2017年 yingxl1992. All rights reserved.
//

#import "YXLTabViewController.h"

@interface YXLTabViewController ()

@property (nonatomic, strong) NSArray<NSString *> *titles;
@property (nonatomic, strong) NSArray<UIButton *> *titleButtons;
@property (nonatomic, strong) NSArray<UIViewController *> *contentViewControllers;

@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, assign) NSInteger lastSelectedIndex;

@end

@implementation YXLTabViewController

- (instancetype)initWithTitles:(NSArray<NSString *> *)titles contentViewControllers:(NSArray<UIViewController *> *)contentViewControllers {
    
    self = [super init];
    
    if (self) {
        
        self.titles = titles;
        self.contentViewControllers = contentViewControllers;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupTitleView];
    [self setupContentView];
    
    self.lastSelectedIndex = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private method

- (void)setupTitleView {
    
    [self.view addSubview:self.titleView];
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view);
        make.trailing.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.mas_equalTo(20);
    }];
    
    NSMutableArray<UIButton *> *tmpTitleButtons = [NSMutableArray arrayWithCapacity:_titles.count];
    for (NSInteger i = 0; i < _titles.count; i ++) {
        
        NSString *title = [_titles objectAtIndex:i];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        [button setTitle:title
                forState:UIControlStateNormal & UIControlStateSelected];
        [button addTarget:self
                   action:@selector(clickButton:)
         forControlEvents:UIControlEventTouchUpInside];
        button.tag = i;
        
        [self.titleView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo((i == 0) ? self.titleView : tmpTitleButtons[(i - 1)].mas_right);
            make.top.equalTo(self.titleView);
            make.width.equalTo(self.titleView).multipliedBy(1.0/_titles.count);
            make.height.mas_equalTo(20);
        }];
        
        [tmpTitleButtons addObject:button];
    }
}

- (void)setupContentView {
    [self.view addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleView.mas_bottom);
        make.leading.equalTo(self.view);
        make.trailing.equalTo(self.view);
        make.height.mas_equalTo(60);
    }];
    
    for (NSInteger i = 0; i < _contentViewControllers.count; i++) {
        
        UIViewController *contentViewController = [_contentViewControllers objectAtIndex:i];
        [self.contentView addSubview:contentViewController.view];
        [self addChildViewController:contentViewController];
        [contentViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        
        if (i > 0) {
            [contentViewController.view setHidden:YES];
        }
    }
}

- (void)clickButton:(UIButton *)button {
    
    if (button.tag != _lastSelectedIndex) {
        
        [[_contentViewControllers objectAtIndex:_lastSelectedIndex].view setHidden:YES];
        [[_contentViewControllers objectAtIndex:button.tag].view setHidden:NO];
        
        self.lastSelectedIndex = button.tag;
    }
}

#pragma mark - Getter

- (UIView *)titleView {
    
    if (!_titleView) {
        
        _titleView = [[UIView alloc] init];
    }
    
    return _titleView;
}

- (UIView *)contentView {
    
    if (!_contentView) {
        
        _contentView = [[UIView alloc] init];
    }
    
    return _contentView;
}

@end
