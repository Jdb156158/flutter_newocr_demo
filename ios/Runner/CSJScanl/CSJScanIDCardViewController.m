//
//  CSJScanIDCardViewController.m
//  GoldenBullRace
//
//  Created by libing on 2019/8/19.
//  Copyright © 2019 CSJ Golden Bull (Beijing) Investment Consulting Co., Ltd. All rights reserved.
//

#import "CSJScanIDCardViewController.h"
#import "UIColor+UIColorFromRGB.h"
#import "CSJIDScanView.h"
#import <Photos/Photos.h>
#import <Masonry/Masonry.h>
@interface CSJScanIDCardViewController ()<AVCaptureMetadataOutputObjectsDelegate,UIAlertViewDelegate,CAAnimationDelegate,AVCapturePhotoCaptureDelegate>

@property(nonatomic,strong) CSJIDScanView *scanView;
@property (nonatomic,strong) UILabel *tipLabel;//提示label
@property (nonatomic,strong) UIImage *selectedImage;//裁剪好的image
@property (nonatomic,strong) UIImageView *takedImageView;
@property (nonatomic,strong) UIButton *takePictureBtn;//拍
@property (nonatomic,strong) UIButton *retakeBtn;//重拍
@property (nonatomic,strong) UIButton *nextBtn;//下一步

@property(nonatomic) AVCaptureDevice *device;
@property(nonatomic) AVCaptureDeviceInput *input;
//捕获输入
@property(nonatomic) AVCaptureMetadataOutput *output;
@property(nonatomic) AVCapturePhotoOutput *imageOutPut;
@property(nonatomic) AVCaptureSession *session;
//实时图层
@property(nonatomic) AVCaptureVideoPreviewLayer *previewLayer;


@end

@implementation CSJScanIDCardViewController

-(void)dealloc
{
    NSLog(@"CSJScanIDCardViewController-dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    
    //[self interfaceOrientation:UIInterfaceOrientationLandscapeRight];
    
    //自定义相机
    [self customCamera];
    [self customUI];
   
    
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.session stopRunning];
    self.navigationController.navigationBarHidden = NO;
}
-(void)customUI
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:@"back_black"] forState:UIControlStateNormal];
    [btn sizeToFit];
    btn.frame = CGRectMake(10, 35, 50, 50);
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.view addSubview:btn];
    
    if (self.isScnView) {
        
        self.scanView = [[CSJIDScanView alloc]init];
        self.scanView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:self.scanView];
        [self.scanView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).insets(UIEdgeInsetsZero);
        }];
            
        self.takedImageView = [[UIImageView alloc]initWithFrame:CGRectMake(scanBorderX, scanBorderY, scanBorderW, scanBorderH)];
        [self.takedImageView setContentMode:UIViewContentModeScaleAspectFill];
        self.takedImageView.hidden = YES;
        [self.view insertSubview:self.takedImageView belowSubview:self.scanView];
        
        _tipLabel = [[UILabel alloc]init];
        _tipLabel.font = [UIFont systemFontOfSize:15];
        _tipLabel.textColor = [UIColor colorWithRed:236 Green:236 Blue:236];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_tipLabel];
        _tipLabel.frame = CGRectMake(kScreenWidth/2-200/2, scanBorderY+scanBorderH+20, 200, 20);
        self.tipLabel.text = @"请将签名对准参考标识内";
        
        //重拍
        _retakeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _retakeBtn.frame = CGRectMake(30, scanBorderY+scanBorderH+20, 130, 32);
        [_retakeBtn addTarget:self action:@selector(retakeBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _retakeBtn.hidden = YES;
        [_retakeBtn setImage:[UIImage imageNamed:@"chongpai"] forState:UIControlStateNormal];
        [_retakeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.view addSubview:_retakeBtn];

        //下一步
        _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _nextBtn.frame = CGRectMake(kScreenWidth-32-130, scanBorderY+scanBorderH+20, 130, 32);
        [_nextBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _nextBtn.hidden = YES;
        [_nextBtn setImage:[UIImage imageNamed:@"sc_xia"] forState:UIControlStateNormal];
        [_nextBtn addTarget:self action:@selector(nextBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_nextBtn];
    }
    
    //摄像按钮
    _takePictureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_takePictureBtn setImage:[UIImage imageNamed:@"photograph"] forState:UIControlStateNormal];
    [_takePictureBtn setImage:[UIImage imageNamed:@"photograph_Select"] forState:UIControlStateHighlighted];
    if (self.isScnView) {
        _takePictureBtn.frame = CGRectMake(kScreenWidth/2-60/2, scanBorderY+scanBorderH+80, 60, 60);
    }else{
        _takePictureBtn.frame = CGRectMake(kScreenWidth/2-60/2, scanBorderY+scanBorderH+150, 60, 60);
    }
    
    [_takePictureBtn addTarget:self action:@selector(shutterCamera) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_takePictureBtn];
    
}
-(void)customCamera
{
    self.session = [[AVCaptureSession alloc]init];
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    self.input = [[AVCaptureDeviceInput alloc]initWithDevice:self.device error:nil];
    self.imageOutPut = [[AVCapturePhotoOutput alloc]init];
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:self.session];
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:self.previewLayer];
    self.previewLayer.frame = CGRectMake(0, 0,kScreenWidth , kScreenHeight);
    
    if ([self.session canSetSessionPreset:AVCaptureSessionPresetPhoto]) {
        self.session.sessionPreset = AVCaptureSessionPresetPhoto;
    }
    if ([self.session canAddInput:self.input]) {
        [self.session addInput:self.input];
    }
    if ([self.session canAddOutput:self.imageOutPut]) {
        [self.session addOutput:self.imageOutPut];
    }
    
    [self.previewLayer.connection setVideoOrientation:AVCaptureVideoOrientationPortrait];
    //开始启动
    [self.session startRunning];

}


-(void)nextBtnClick
{
    _retakeBtn.hidden = YES;
    _nextBtn.hidden = YES;
    _tipLabel.hidden = NO;
    _takePictureBtn.hidden = NO;
    self.takedImageView.hidden = YES;
    [self.session startRunning];
    self.scanView.alph = 0.2;
    
    self.imageBackBlock(self.selectedImage);
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)retakeBtnClick
{
    _retakeBtn.hidden = YES;
    _nextBtn.hidden = YES;
    _tipLabel.hidden = NO;
    _takePictureBtn.hidden = NO;
    self.takedImageView.hidden = YES;
    [self.session startRunning];
    self.scanView.alph = 0.2;
    [self.scanView setNeedsDisplay];
}

- (void)popViewController
{
    if(self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark 拍照
-(void)shutterCamera
{
    [self.imageOutPut capturePhotoWithSettings:[AVCapturePhotoSettings photoSettingsWithFormat:@{AVVideoCodecKey:AVVideoCodecTypeJPEG}] delegate:self];
    
}
#pragma mark AVCapturePhotoCaptureDelegate

-(void)captureOutput:(AVCapturePhotoOutput *)output didFinishProcessingPhoto:(nonnull AVCapturePhoto *)photo error:(nullable NSError *)error
{
    NSData *data = photo.fileDataRepresentation;
    UIImage *image = [UIImage imageWithData:data];
    
    self.takedImageView.hidden = NO;
    
    
    
    [self.session stopRunning];
    self.scanView.alph = 1;
    [self.scanView setNeedsDisplay];
    
    if (!self.isScnView) {
        if (self.imageBackBlock) {
            self.imageBackBlock(image);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self cropImage:image];
    }
    
    _retakeBtn.hidden = NO;
    _nextBtn.hidden = NO;
    _tipLabel.hidden = YES;
    _takePictureBtn.hidden = YES;
    
}
- (void)cropImage:(UIImage *)image
{
    
    NSLog(@"image=%@",NSStringFromCGSize(image.size));
     
    CGImageRef sourceImageRef = [image CGImage];
    CGFloat widthScale = image.size.width/kScreenWidth;
    CGFloat heightScale = image.size.height/kScreenHeight;
    
    CGRect clipedRect = CGRectMake( self.takedImageView.frame.origin.y*heightScale,self.takedImageView.frame.origin.x*widthScale, self.takedImageView.frame.size.height*heightScale, self.takedImageView.frame.size.width*widthScale);
    
    
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, clipedRect);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef scale:1.0 orientation:image.imageOrientation];
    NSLog(@"newImage=%@",NSStringFromCGSize(newImage.size));
    CGImageRelease(newImageRef);
    

    CGSize newSize = CGSizeMake(newImage.size.width*scanBorderH/newImage.size.height, scanBorderH);

    UIGraphicsBeginImageContext(newSize);
    [newImage drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *compressImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSLog(@"newImage=%@",NSStringFromCGSize(compressImage.size));

    self.takedImageView.image = compressImage;

    self.selectedImage = compressImage;
    
}

@end
