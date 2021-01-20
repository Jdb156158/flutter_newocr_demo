//
//  UIColor+UIColorFromRGB.h
//  ReferenceNews
//
//  Created by 李翔 on 16/3/14.
//  Copyright © 2016年 Lx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (UIColorFromRGB)

/**
 *  @author Lx
 *
 *  生成随机颜色
 *
 *  @return 返回随机颜色
 */
+ (UIColor *)colorRandom;

/**
 *  根据RGB色值获取颜色
 *
 *  @param red   红色值
 *  @param green 绿色值
 *  @param blue  蓝色值
 *  @param alpha 透明度
 *
 *  @return 返回带透明度的RGB颜色
 */
+ (UIColor *)colorWithRed:(CGFloat)red Green:(CGFloat)green Blue:(CGFloat)blue alpha:(CGFloat)alpha;

/**
 *  根据RGB色值获取颜色
 *
 *  @param red   红色值
 *  @param green 绿色值
 *  @param blue  蓝色值
 *
 *  @return 返回RGB颜色
 */
+ (UIColor *)colorWithRed:(CGFloat)red Green:(CGFloat)green Blue:(CGFloat)blue;

/**
 *  根据十六进制获取颜色
 *
 *  @param hexValue   十六进制数
 *  @param alphaValue 透明度
 *
 *  @return 返回带透明度的十六进制颜色
 */
+ (UIColor *)colorWithHex:(NSString *)hexValue alpha:(CGFloat)alphaValue;

/**
 *  根据十六进制获取颜色
 *
 *  @param hexValue 十六进制数
 *
 *  @return 返回十六进制颜色
 */
+ (UIColor *)colorWithHex:(NSString *)hexValue;

/**
 背景色Color

 @return @"F1F1F1"
 */
+ (UIColor *)colorWithBackgroundColor;

/**
 分割线Color

 @return @"ededed"
 */
+ (UIColor *)colorWithSeparatorLine;

/**
 红色 db1f2c
 */
+ (UIColor *)colorWithRedContent;

/**
 红色 ff4b58
 */
+ (UIColor *)colorWithVirtualRedContent;

/**
 绿色 088546
 */
+ (UIColor *)colorWithGreenContent;

/**
 蓝色 006699
 */
+ (UIColor *)colorWithBlueContent;

@end
