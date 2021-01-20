//
//  UIColor+UIColorFromRGB.m
//  ReferenceNews
//
//  Created by 李翔 on 16/3/14.
//  Copyright © 2016年 Lx. All rights reserved.
//

#import "UIColor+UIColorFromRGB.h"

@implementation UIColor (UIColorFromRGB)

+ (UIColor *)colorRandom
{
    return [UIColor colorWithRed:(float)(1+arc4random()%99)/100
                           green:(float)(1+arc4random()%99)/100
                            blue:(float)(1+arc4random()%99)/100
                           alpha:1];
}

+ (UIColor *)colorWithRed:(CGFloat)red
                    Green:(CGFloat)green
                     Blue:(CGFloat)blue
                    alpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:red/255.f
                           green:green/255.f
                            blue:blue/255.f
                           alpha:alpha];
}

+ (UIColor *)colorWithRed:(CGFloat)red
                    Green:(CGFloat)green
                     Blue:(CGFloat)blue
{
    return [UIColor colorWithRed:red/255.f
                           green:green/255.f
                            blue:blue/255.f
                           alpha:1];
}

+ (UIColor*)colorWithHex:(NSString *)hexValue alpha:(CGFloat)alphaValue
{
    char *stopstring;
    long hex = strtol([hexValue cStringUsingEncoding:NSUTF8StringEncoding], &stopstring, 16);
    return [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0
                           green:((float)((hex & 0xFF00) >> 8))/255.0
                            blue:((float)(hex & 0xFF))/255.0 alpha:alphaValue];
}

+ (UIColor*)colorWithHex:(NSString *)hexValue
{
    char *stopstring;
    long hex = strtol([hexValue cStringUsingEncoding:NSUTF8StringEncoding], &stopstring, 16);
    int r, g, b;
    r = ( 0xff <<16 & hex ) >> 16;
    g = ( 0xff <<8 & hex ) >> 8;
    b = 0xff & hex;
    return [UIColor colorWithRed:(0.0f + r)/255 green:(0.0f + g)/255 blue:(0.0f + b)/255 alpha:1.0];
}

+ (UIColor *)colorWithBackgroundColor
{
    return [UIColor colorWithHex:@"F1F1F1"];
}

+ (UIColor *)colorWithSeparatorLine
{
    return [UIColor colorWithHex:@"ededed"];
}

+ (UIColor *)colorWithRedContent
{
    return [UIColor colorWithHex:@"db1f2c"];
}

+ (UIColor *)colorWithVirtualRedContent
{
    return [UIColor colorWithHex:@"ff4b58"];
}

+ (UIColor *)colorWithGreenContent
{
    return [UIColor colorWithHex:@"088546"];
}

+ (UIColor *)colorWithBlueContent
{
    return [UIColor colorWithHex:@"006699"];
}

@end
