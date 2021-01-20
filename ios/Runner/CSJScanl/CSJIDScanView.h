//
//  CSJIDScanView.h
//  GoldenBullRace
//
//  Created by libing on 2019/8/19.
//  Copyright © 2019 CSJ Golden Bull (Beijing) Investment Consulting Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kScreenWidth                [UIScreen mainScreen].bounds.size.width
#define kScreenHeight               [UIScreen mainScreen].bounds.size.height
#define VH_SH           ((kScreenWidth<kScreenHeight)?kScreenHeight:kScreenWidth)
#define VH_SW           ((kScreenWidth<kScreenHeight)?kScreenWidth:kScreenHeight)
//获取导航栏+状态栏的高度
#define getRectNavAndStatusHight  self.navigationController.navigationBar.frame.size.height+[[UIApplication sharedApplication] statusBarFrame].size.height

//判断刘海屏
#define isIphoneX  [[UIApplication sharedApplication] statusBarFrame].size.height>=44
// 紫色
#define kpurpleColor [UIColor colorWithHex:@"6666cc"]
// 粉色
#define kpinkColor [UIColor colorWithHex:@"ff5777"]


// 判断iPhone4
#define kIPHONE4 [[UIScreen mainScreen] bounds].size.height == 480
// 判断iphone5
#define kIPHONE5 ( fabs( ( double )[[ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
// 判断iphone6
#define kIPHONE6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
// 判断iphone6+
#define kIPHONE6_PLUS ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)

// 系统版本
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)
NS_ASSUME_NONNULL_BEGIN
/** 扫描内容的 W 值 */
#define scanBorderW kScreenWidth-60
#define scanBorderH 200
/** 扫描内容的 x 值 */
#define scanBorderX 30
/** 扫描内容的 Y 值 */
#define scanBorderY 200

typedef enum : NSInteger
{
    CSJScanStyleDefault,
    CSJScanStyleGrid
    
}CSJScanStyle;
@interface CSJIDScanView : UIView
@property (nonatomic,assign) CSJScanStyle scanStyle;
@property (nonatomic,strong) UIColor *borderColor;
@property (nonatomic,strong) UIColor *conerColor;
@property (nonatomic,assign) double alph;



@end

NS_ASSUME_NONNULL_END
