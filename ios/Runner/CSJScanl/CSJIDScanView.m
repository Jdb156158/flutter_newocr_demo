//
//  CSJIDScanView.m
//  GoldenBullRace
//
//  Created by libing on 2019/8/19.
//  Copyright © 2019 CSJ Golden Bull (Beijing) Investment Consulting Co., Ltd. All rights reserved.
//

#import "CSJIDScanView.h"
#import "UIColor+UIColorFromRGB.h"


@interface CSJIDScanView ()
//@property (nonatomic,assign) UIView *contentView;
//@property (nonatomic,strong) NSTimer *timer;
//@property (nonatomic,strong) UIImageView *scanningline;
@end
@implementation CSJIDScanView

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
    
}

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    _borderColor = [UIColor whiteColor];
    _conerColor = [UIColor colorWithRed:255 Green:132 Blue:0];
    
    CGFloat borderW = scanBorderW;
    CGFloat borderH = scanBorderH;
    CGFloat borderX = scanBorderX;
    CGFloat borderY = scanBorderY;
    CGFloat borderLineW = 0.2;
    
    
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    CGContextSetRGBFillColor(context, 255, 255, 255, self.alph?self.alph:0.2);
    
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    UIBezierPath *bezeierPath = [UIBezierPath bezierPathWithRect:rect];
    
    UIBezierPath *borderPath = [UIBezierPath bezierPathWithRect:CGRectMake(borderX, borderY, borderW, borderH)];
    
    
    [bezeierPath appendPath:borderPath];
    bezeierPath.usesEvenOddFillRule = YES;
    [bezeierPath fill];
    
    
    borderPath.lineWidth = borderLineW;
    CGContextSetRGBStrokeColor(context, 255, 255, 255, 1);
    [borderPath stroke];
    CGContextRestoreGState(context);
    
    
    CGFloat conerLength = 24;
    CGFloat lineWidth = 5;

    UIBezierPath *leftTopPath = [UIBezierPath bezierPath];
    leftTopPath.lineWidth = lineWidth;
    [self.conerColor set];


    [leftTopPath moveToPoint:CGPointMake(borderX+0.5*lineWidth , borderY + conerLength)];
    [leftTopPath addLineToPoint:CGPointMake(borderX+0.5*lineWidth, borderY+0.5*lineWidth)];
    [leftTopPath addLineToPoint:CGPointMake(borderX +conerLength, borderY+0.5*lineWidth)];


    [leftTopPath stroke];

    UIBezierPath *leftBottomPath = [UIBezierPath bezierPath];
    leftBottomPath.lineWidth = lineWidth;
    [self.conerColor set];


    [leftBottomPath moveToPoint:CGPointMake(borderX+0.5*lineWidth , borderY + borderH- conerLength)];
    [leftBottomPath addLineToPoint:CGPointMake(borderX+0.5*lineWidth, borderY+borderH-0.5*lineWidth)];
    [leftBottomPath addLineToPoint:CGPointMake(borderX +conerLength, borderY+borderH-0.5*lineWidth)];


    [leftBottomPath stroke];


    UIBezierPath *rightTopPath = [UIBezierPath bezierPath];
    rightTopPath.lineWidth = lineWidth;
    [self.conerColor set];


    [rightTopPath moveToPoint:CGPointMake(borderX+borderW-conerLength , borderY + 0.5*lineWidth)];
    [rightTopPath addLineToPoint:CGPointMake(borderX+borderW-0.5*lineWidth, borderY+0.5*lineWidth)];
    [rightTopPath addLineToPoint:CGPointMake(borderX+borderW-0.5*lineWidth, borderY+conerLength)];


    [rightTopPath stroke];

    UIBezierPath *rightBottomPath = [UIBezierPath bezierPath];
    rightBottomPath.lineWidth = lineWidth;
    [self.conerColor set];


    [rightBottomPath moveToPoint:CGPointMake(borderX+borderW-0.5*lineWidth , borderY + borderH - conerLength)];
    [rightBottomPath addLineToPoint:CGPointMake(borderX+borderW-0.5*lineWidth, borderY + borderH - 0.5*lineWidth)];
    [rightBottomPath addLineToPoint:CGPointMake(borderX+borderW-conerLength, borderY + borderH-0.5*lineWidth)];
    

    [rightBottomPath stroke];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
