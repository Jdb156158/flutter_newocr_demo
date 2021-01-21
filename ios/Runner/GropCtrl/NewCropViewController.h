//
//  NewCropViewController.h
//  CameraCut
//
//  Created by db J on 2021/1/18.
//  Copyright © 2021 libing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+fixOrientation.h"
#import "UIImageView+ContentFrame.h"

NS_ASSUME_NONNULL_BEGIN
@class NewCropViewController;
@protocol MMCropDelegate <NSObject>

-(void)didFinishCropping:(UIImage *)finalCropImage from:(NewCropViewController *)cropObj;

@end

typedef void(^CropFinshBlock)(UIImage *finalCropImage);

@interface NewCropViewController : UIViewController{
    CGFloat _rotateSlider;
    CGRect _initialRect,final_Rect;
}

@property (weak,nonatomic) id<MMCropDelegate> cropdelegate;

@property (strong, nonatomic) UIImage *adjustedImage,*cropgrayImage,*cropImage;

@property(atomic,copy) CropFinshBlock myCropBlock;

@end

NS_ASSUME_NONNULL_END
