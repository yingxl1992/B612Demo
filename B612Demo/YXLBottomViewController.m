//
//  YXLBottomViewController.m
//  B612Demo
//
//  Created by yingxl1992 on 2017/6/26.
//  Copyright © 2017年 yingxl1992. All rights reserved.
//

#import "YXLBottomViewController.h"
#import "YXLProcessingView.h"
#import "YXLPhotoAndSaveView.h"
#import <AVFoundation/AVFoundation.h>
#import "UIView+Utils.h"
#import "YXLLvJingViewController.h"
#import "ViewController.h"

@interface YXLBottomViewController ()
<
YXLProcessingViewDelegate,
YXLPhotoAndSaveViewDelegate,
YXLLvJingViewControllerDelegate
>

@property (nonatomic, strong) YXLProcessingView *processingView;
@property (nonatomic, strong) YXLPhotoAndSaveView *photoAndSaveView;
@property (nonatomic, strong) YXLLvJingViewController *lvJingViewController;

@property (nonatomic, strong) UIButton *backButton;

@end

@implementation YXLBottomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithWhite:0
                                                  alpha:0.1];
}

- (void)clickBackButton {
    if (self.bottomState == YXLBottomState_Default) {
        return;
    }
    else if (self.bottomState == YXLBottomState_Save) {
        return;
    }
    else if (self.bottomState == YXLBottomState_Filter) {
        [self setBottomState:YXLBottomState_Default];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setBottomState:(YXLBottomState)bottomState {
    
    _bottomState = bottomState;
    
    [self setupViewOfState:bottomState];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    if (self.bottomState == YXLBottomState_Filter) {
        
        UITouch *touch = [touches anyObject];
        CGPoint touchPoint = [touch locationInView:self.view];
        if (!CGRectContainsPoint(self.lvJingViewController.view.frame, touchPoint)) {
            
            [self clickBackButton];
        }
    }
}

#pragma mark - Private Method

- (void)setupViewOfState:(YXLBottomState)bottomState {
    
    if (bottomState == YXLBottomState_Default) {
        
        [self showDefaultView];
    }
    else if (bottomState == YXLBottomState_Save) {
        
        [self showSaveView];
    }
    else if (bottomState == YXLBottomState_Filter) {
        
        [self showFilterView];
    }
}

- (void)showDefaultView {
    
    [self.view removeAllSubviews];
    
    [self.view addSubview:self.processingView];
    
    [self.processingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-20);
        make.leading.equalTo(self.view);
        make.trailing.equalTo(self.view);
        make.height.mas_equalTo(60);
    }];
    
    [UIView animateWithDuration:0.2 animations:^{
        [self.view layoutIfNeeded];
    }];
    
    [self startCaptureSession];
}

- (void)showSaveView {
    
    [self.view removeAllSubviews];
    
    [self.view addSubview:self.photoAndSaveView];
    
    [self.photoAndSaveView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-20);
        make.leading.equalTo(self.view);
        make.trailing.equalTo(self.view);
        make.height.mas_equalTo(100);
    }];
    
    [UIView animateWithDuration:0.2 animations:^{
        [self.view layoutIfNeeded];
    }];
    
    [self stopCaptureSession];
}

- (void)showFilterView {
    
    [self.view removeAllSubviews];
    
    [self.view addSubview:self.lvJingViewController.view];
    
    [self.lvJingViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-20);
        make.leading.equalTo(self.view);
        make.trailing.equalTo(self.view);
        make.height.mas_equalTo(80);
    }];
    
    [UIView animateWithDuration:0.2 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    
    if (!error) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@""
                                                                                 message:@"保存成功啦~"
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alertController
                           animated:YES
                         completion:nil];
    }
    
    NSLog(@"image = %@, error = %@, contextInfo = %@", image, error, contextInfo);
}

- (void)startCaptureSession {
    
    if (self.delegate
        && [self.delegate respondsToSelector:@selector(bottomViewControllerNeedToStartCaptureSession)]) {
        
        [self.delegate bottomViewControllerNeedToStartCaptureSession];
    }
}

- (void)stopCaptureSession {
    
    if (self.delegate
        && [self.delegate respondsToSelector:@selector(bottomViewControllerNeedToStopCaptureSession)]) {
        
        [self.delegate bottomViewControllerNeedToStopCaptureSession];
    }
}

#pragma mark - YXLProcessingViewDelegate

- (void)YXLProcessionViewDidTakePhoto {
    
    if (self.delegate
        && [self.delegate respondsToSelector:@selector(bottomViewControllerTakePhoto)]) {
        
        [self.delegate bottomViewControllerTakePhoto];
    }
}

- (void)YXLProcessionViewDidClickFilterButton {
    
    [self setBottomState:YXLBottomState_Filter];
}

#pragma mark - YXLPhotoAndSaveViewDelegate

- (void)YXLPhotoAndSaveViewShouldSavePhoto {

    UIImageWriteToSavedPhotosAlbum(_jpegData, self, @selector(image:didFinishSavingWithError:contextInfo:),  (__bridge void *)self);
}

- (void)YXLPhotoAndSaveViewWillDismiss {
    
    [self setBottomState:YXLBottomState_Default];
}

#pragma mark - YXLLvJingViewControllerDelegate

- (void)lvJingViewControllerChangeFilterType:(NSString *)filterType {
    
    if (self.delegate
        && [self.delegate respondsToSelector:@selector(YXLBottomViewControllerChangeFilterType:)]) {
        
        [self.delegate YXLBottomViewControllerChangeFilterType:filterType];
    }
}

#pragma mark - Getter

- (YXLPhotoAndSaveView *)photoAndSaveView {
    
    if (!_photoAndSaveView) {
        
        _photoAndSaveView = [[YXLPhotoAndSaveView alloc] init];
        _photoAndSaveView.delegate = self;
    }
    
    return _photoAndSaveView;
}

- (YXLProcessingView *)processingView {
    
    if (!_processingView) {
        
        _processingView = [[YXLProcessingView alloc] init];
        _processingView.delegate = self;
    }
    
    return _processingView;
}

- (YXLLvJingViewController *)lvJingViewController {
    
    if (!_lvJingViewController) {
        
        _lvJingViewController = [[YXLLvJingViewController alloc] init];
        _lvJingViewController.delegate = self;
    }
    
    return _lvJingViewController;
}

@end
