//
//  MainViewController.m
//  Runner
//
//  Created by db J on 2021/1/18.
//

#import "MainViewController.h"
#include "GeneratedPluginRegistrant.h"
#import "TestViewController.h"
#import "Test2ViewController.h"
#import "WebVC.h"

#import "CSJIDScanView.h"
#import "CSJScanIDCardViewController.h"
#import "CSJScanResultViewController.h"

#import "NewCropViewController.h"

/** 信号通道，须与flutter里一致*/
#define flutterMethodChannel  @"flutter_native_ios"
/** 交互方法字段名，须与flutter里一致*/
#define flutterMethodPush  @"flutter_push_to_ios"
#define flutterMethodPresent  @"flutter_present_to_ios"

//拍照签名
#define flutterMethodPushCSJIDScanView  @"flutter_push_to_CSJIDScanView"
//拍照自动巡边
#define flutterMethodPushCropView  @"flutter_push_to_CropView"
//Exsl扫描
#define flutterMethodPushExslView  @"flutter_push_to_ExslView"

@interface MainViewController ()

@property(nonatomic,strong) FlutterMethodChannel* methodChannel;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self methodChannelFunction];
}

- (void)methodChannelFunction {
    __weak typeof(self) weakSelf = self;
    //创建 FlutterMethodChannel
    self.methodChannel = [FlutterMethodChannel
                          methodChannelWithName:flutterMethodChannel binaryMessenger:self];
    //设置监听
    [self.methodChannel setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {
        // TODO
        NSString *method=call.method;
        if ([method isEqualToString:flutterMethodPush]) {
            
            Test2ViewController *vc = [[Test2ViewController alloc] init];
            [weakSelf.navigationController pushViewController:vc animated:YES];
            //此方法只能调用一次
            result(@"push返回到flutter");
            
        }else if ([method isEqualToString:flutterMethodPresent]) {
            
            UIViewController *vc = nil;
                        
            NSString *url = call.arguments[@"url"];
            if (url.length>0) {
                vc = [[WebVC alloc] initWithUrlString:url];
            }else{
                vc = [[TestViewController alloc] init];
            }
            
            UINavigationController* navigationController =
            [[UINavigationController alloc] initWithRootViewController:vc];
            if (url.length>0) {
                navigationController.navigationBar.topItem.title = @"原生网页";
            }else{
                navigationController.navigationBar.topItem.title = @"原生普通页面";
            }
            
            [weakSelf presentViewController:navigationController animated:YES completion:nil];
            
            //此方法只能调用一次
            result(@"present返回到flutter");
        }else if ([method isEqualToString:flutterMethodPushCSJIDScanView]) {
            [weakSelf takePicture];
        }else if ([method isEqualToString:flutterMethodPushCropView]) {
            [weakSelf jumpCropView];
        }else if([method isEqualToString:flutterMethodPushExslView]){
            
            CSJScanIDCardViewController * scVC = [[CSJScanIDCardViewController alloc]init];
            scVC.imageBackBlock = ^(UIImage * _Nonnull image) {
                
                CGFloat compression = 0.9f;
                CGFloat maxCompression = 0.3f;
                int maxFileSize = 4*1024*1024;//最大4z

                NSData *imageData = UIImageJPEGRepresentation(image, compression);

                while ([imageData length] > maxFileSize && compression > maxCompression)
                {
                    compression -= 0.05;
                    imageData = UIImageJPEGRepresentation(image, compression);
                }
                
                NSLog(@"Size of Image:%lu kb",(unsigned long)[imageData length]/1024);
                //UIImage转换为base64
                NSString *base64Str = [imageData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
                result(base64Str);
            };
            [weakSelf.navigationController pushViewController:scVC animated:YES];
        }
        
    }];
    [GeneratedPluginRegistrant registerWithRegistry:self];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)takePicture{
    CSJScanIDCardViewController * scVC = [[CSJScanIDCardViewController alloc]init];
    scVC.isScnView = YES;
    scVC.imageBackBlock = ^(UIImage * _Nonnull image) {
        [self jumpResult:image];
    };
    [self.navigationController pushViewController:scVC animated:YES];
}

- (void)jumpCropView{
    CSJScanIDCardViewController * scVC = [[CSJScanIDCardViewController alloc]init];
    scVC.imageBackBlock = ^(UIImage * _Nonnull image) {
        [self jumpCropResult:image];
    };
    [self.navigationController pushViewController:scVC animated:YES];
}

- (void)jumpCropResult:(UIImage *)image{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NewCropViewController *cropViewCtr = [[NewCropViewController alloc] init];
        //UIImage *image = [UIImage imageNamed:@"testtwo"];
        cropViewCtr.adjustedImage = image;
        [self.navigationController pushViewController:cropViewCtr animated:YES];
    });
}

- (void)jumpResult:(UIImage *)image{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CSJScanResultViewController *vc = [[CSJScanResultViewController alloc] init];
        vc.originImage = image;
        [self.navigationController pushViewController:vc animated:YES];
    });
}

@end
