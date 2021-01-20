//
//  MMOpenCVHelper.h
//  MMCamScanner
//
//  Created by mukesh mandora on 09/06/15.
//  Copyright (c) 2015 madapps. All rights reserved.
//

#import <opencv2/imgproc/imgproc.hpp>
#import <opencv2/highgui/highgui.hpp>
#import <opencv2/opencv.hpp>
#import <opencv2/core/core_c.h>
#import <opencv2/imgproc/imgproc_c.h>
#import <opencv2/imgproc/types_c.h>
#import <opencv2/imgcodecs/ios.h>

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>



@interface MMOpenCVHelper : NSObject
+ (UIImage *)UIImageFromCVMat:(cv::Mat)cvMat;

+ (cv::Mat)cvMatFromAdjustedUIImage:(UIImage *)image;
+ (cv::Mat)cvMatFromUIImage:(UIImage *)image;
+ (cv::Mat)cvMatGrayFromUIImage:(UIImage *)image;
+ (cv::Mat)cvMatGrayFromAdjustedUIImage:(UIImage *)image;


@end
