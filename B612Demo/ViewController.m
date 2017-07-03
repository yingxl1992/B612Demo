//
//  ViewController.m
//  B612Demo
//
//  Created by yingxl1992 on 2017/6/20.
//  Copyright © 2017年 yingxl1992. All rights reserved.
//

#import "ViewController.h"
#import <Photos/Photos.h>
#import "YXLProcessingView.h"
#import "YXLPhotoAndSaveView.h"
#import "YXLBottomViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()
<
AVCaptureVideoDataOutputSampleBufferDelegate,
YXLBottomViewControllerDelegate
>

@property (nonatomic, strong) UIImageView *showStillImageView;

@property (nonatomic, strong) CALayer *previewLayer;
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureDeviceInput *videoInput;
@property (nonatomic, strong) AVCaptureStillImageOutput *stillImageOutput;

@property (nonatomic, strong) YXLBottomViewController *bottomViewController;

@property (nonatomic, strong) CIFilter *filter;
@property (nonatomic, strong) CIContext *context;
@property (nonatomic, strong) NSString *currentFilterName;
@property (nonatomic, assign) CGImageRef cgImage;

@end

@implementation ViewController

- (void)dealloc {
    NSLog(@"===ViewController dealloc===");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self initAVCaptureSession];
    [self setupShowImageView];
    
    [self setupBottomView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.session startRunning];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.session stopRunning];
}

#pragma mark - Private Method

- (void)initAVCaptureSession {
    
    //1
    self.session = [[AVCaptureSession alloc] init];
    self.session.sessionPreset = AVCaptureSessionPresetMedium;
    
    //2
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    //3
    NSError *error = nil;
    self.videoInput = [AVCaptureDeviceInput deviceInputWithDevice:device
                                                            error:&error];
    if (error) {
        NSLog(@"%@", error);
    }
    
    if ([_session canAddInput:_videoInput]) {
        [_session addInput:_videoInput];
    }
    
    //4
    self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG, AVVideoCodecKey, nil];
    [self.stillImageOutput setOutputSettings:outputSettings];
    
    AVCaptureVideoDataOutput * videoDataOutput = [[AVCaptureVideoDataOutput alloc] init];
    videoDataOutput.videoSettings = @{(__bridge NSString *)kCVPixelBufferPixelFormatTypeKey : @(kCVPixelFormatType_32BGRA)};
    videoDataOutput.alwaysDiscardsLateVideoFrames = YES;
    
    dispatch_queue_t videoOutputQueue = dispatch_queue_create("videoOutputQueue", DISPATCH_QUEUE_SERIAL);
    [videoDataOutput setSampleBufferDelegate:self
                                       queue:videoOutputQueue];
    
    if ([_session canAddOutput:_stillImageOutput]) {
        [_session addOutput:_stillImageOutput];
    }
    
    if ([_session canAddOutput:videoDataOutput]) {
        [_session addOutput:videoDataOutput];
    }

    //5
//    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
//    [_previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
//    self.previewLayer.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
//    self.backView.layer.masksToBounds = YES;
//    [self.backView.layer addSublayer:_previewLayer];
    self.previewLayer = [[CALayer alloc] init];
    self.previewLayer.anchorPoint = CGPointZero;
    self.previewLayer.bounds = self.view.bounds;
    
    [self.view.layer insertSublayer:_previewLayer
                                  atIndex:0];
    
    self.filter = [[CIFilter alloc] init];
}

- (void)setupShowImageView {
 
    self.showStillImageView = [[UIImageView alloc] init];
    [self.view addSubview:self.showStillImageView];
    
    [self.showStillImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.showStillImageView setHidden:YES];
}

- (void)setupBottomView {
    
    self.bottomViewController = [[YXLBottomViewController alloc] init];
    self.bottomViewController.delegate = self;
    self.bottomViewController.bottomState = YXLBottomState_Default;
    [self.view addSubview:self.bottomViewController.view];
    [self.bottomViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).mas_offset(UIEdgeInsetsMake(60, 0, 0, 0));
    }];
    [self addChildViewController:self.bottomViewController];
}

- (void)startSession {
    [self.session startRunning];
}

- (void)stopSession {
    [self.session stopRunning];
}

- (AVCaptureVideoOrientation)avOrientationForDeviceOrientation:(UIDeviceOrientation)deviceOrientation {
    
    AVCaptureVideoOrientation result = (AVCaptureVideoOrientation)deviceOrientation;
    if (deviceOrientation == UIDeviceOrientationLandscapeLeft) {
        result = AVCaptureVideoOrientationLandscapeRight;
    }
    else if (deviceOrientation == UIDeviceOrientationLandscapeRight){
        result = AVCaptureVideoOrientationLandscapeLeft;
    }
    return result;
}

#pragma mark - YXLBottomViewControllerDelegate

- (void)bottomViewControllerTakePhoto {
    
//    AVCaptureConnection *stillImageConnection = [self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
//    UIDeviceOrientation currentDeviceOrientation = [[UIDevice currentDevice] orientation];
//    AVCaptureVideoOrientation avcaptureOrientation = [self avOrientationForDeviceOrientation:currentDeviceOrientation];
//    [stillImageConnection setVideoOrientation:avcaptureOrientation];
//    [stillImageConnection setVideoScaleAndCropFactor:1];
//    
//    __weak __typeof(self) weakSelf = self;
//    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:stillImageConnection
//                                                       completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
//                                                           
//                                                           __strong __typeof(weakSelf) strongSelf = weakSelf;
//                                                           if (!strongSelf) {
//                                                               return;
//                                                           }
//                                                           
//                                                           NSData *jpegData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
    
                                                           [self.session stopRunning];
                                                           
                                                           self.bottomViewController.bottomState = YXLBottomState_Save;
                                                           
                                                           self.bottomViewController.jpegData = [UIImage imageWithCGImage:_cgImage];
                                                           
                                                           self.showStillImageView.image = [UIImage imageWithCGImage:_cgImage];
                                                           [self.showStillImageView setHidden:NO];
//                                                       }];
}

- (void)bottomViewControllerNeedToStartCaptureSession {
    [self startSession];
    [self.showStillImageView setHidden:YES];
}

- (void)bottomViewControllerNeedToStopCaptureSession {
    [self stopSession];
}

- (void)YXLBottomViewControllerChangeFilterType:(NSString *)filterType {
    
    self.currentFilterName = filterType;
    self.filter = [CIFilter filterWithName:filterType];
}

#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    
    
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    
    CIImage *outputImage = [CIImage imageWithCVImageBuffer:imageBuffer];
    
    if (_currentFilterName.length > 0) {
        
        [self.filter setValue:outputImage
                       forKey:kCIInputImageKey];
        outputImage = self.filter.outputImage;
    }
    
    CGAffineTransform transform;
    if ([UIDevice currentDevice].orientation == UIDeviceOrientationPortrait) {
        transform = CGAffineTransformMakeRotation(-M_PI / 2.0);
    }
    else if ([UIDevice currentDevice].orientation == UIDeviceOrientationPortraitUpsideDown) {
        transform = CGAffineTransformMakeRotation(M_PI / 2.0);
    }
    else if ([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeRight) {
        transform = CGAffineTransformMakeRotation(M_PI);
    }
    else {
        transform = CGAffineTransformMakeRotation(0);
    }
    outputImage = [outputImage imageByApplyingTransform:transform];
    
    self.cgImage = [self.context createCGImage:outputImage fromRect:outputImage.extent];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.previewLayer.contents = (__bridge id _Nullable)(_cgImage);
    });
}

#pragma mark - Getter

- (CIContext *)context {
    
    if (!_context) {
        EAGLContext *egalContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
        _context = [CIContext contextWithEAGLContext:egalContext
                                             options:@{kCIContextWorkingColorSpace : [NSNull null]}];
    }
    
    return _context;
}

@end
