//
//  ZFBar.m
//  ZFChart
//
//  Created by apple on 16/1/26.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ZFBar.h"
#import "ZFConst.h"

@interface ZFBar()

/** bar宽度 */
@property (nonatomic, assign) CGFloat barWidth;
/** bar高度上限 */
@property (nonatomic, assign) CGFloat barHeightLimit;
/** 动画时间 */
@property (nonatomic, assign) CGFloat animationDuration;

@end

@implementation ZFBar

/**
 *  初始化默认变量
 */
- (void)commonInit{
    _barBackgroundColor = ZFDecimalColor(0, 0.68, 1, 1);
    _barWidth = XLineItemWidth;
    _barHeightLimit = self.frame.size.height;
    _percent = 0;
    _animationDuration = 0.5f;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    
    return self;
}

#pragma mark - bar

/**
 *  未填充
 *
 *  @return UIBezierPath
 */
- (UIBezierPath *)noFill{
    UIBezierPath * bezier = [UIBezierPath bezierPathWithRect:CGRectMake(0, _barHeightLimit, _barWidth, 0)];
    [bezier fill];
    return bezier;
}

/**
 *  填充
 *
 *  @return UIBezierPath
 */
- (UIBezierPath *)fill{
    CGFloat currentHeight = _barHeightLimit * self.percent;
    
    UIBezierPath * bezier = [UIBezierPath bezierPathWithRect:CGRectMake(0, _barHeightLimit - currentHeight, _barWidth, currentHeight)];
    [bezier fill];
    return bezier;
}

/**
 *  CAShapeLayer
 *
 *  @return CAShapeLayer
 */
- (CAShapeLayer *)shapeLayer{
    CAShapeLayer * layer = [CAShapeLayer layer];
    layer.strokeColor = _barBackgroundColor.CGColor;
    layer.fillColor = _barBackgroundColor.CGColor;
    layer.lineCap = kCALineCapRound;
    
    CABasicAnimation * animation = [self animation];
    [layer addAnimation:animation forKey:nil];
    
    return layer;
}

#pragma mark - 动画

/**
 *  填充动画过程
 *
 *  @return CABasicAnimation
 */
- (CABasicAnimation *)animation{
    CABasicAnimation * fillAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    fillAnimation.duration = _animationDuration;
    fillAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    fillAnimation.fillMode = kCAFillModeForwards;
    fillAnimation.removedOnCompletion = NO;
    fillAnimation.fromValue = (id)[self noFill].CGPath;
    fillAnimation.toValue = (id)[self fill].CGPath;
    
    return fillAnimation;
}

#pragma mark - public method

/**
 *  重绘
 */
- (void)strokePath{
    for (CALayer * layer in self.layer.sublayers) {
        [layer removeAllAnimations];
        [layer removeFromSuperlayer];
    }
    
    [self.layer addSublayer:[self shapeLayer]];
}

@end
