//
//  ZFLine.m
//  ZFChartView
//
//  Created by apple on 16/2/15.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ZFLine.h"
#import "ZFConst.h"

@interface ZFLine()

/** 线宽 */
@property (nonatomic, assign) CGFloat lineWidth;
/** 动画时间 */
@property (nonatomic, assign) CGFloat animationDuration;

@end

@implementation ZFLine

/**
 *  初始化默认变量
 */
- (void)commonInit{
    _lineWidth = 1.5f;
    _animationDuration = 0.5f;
    _isShadow = YES;
}

- (instancetype)initWithStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint{
    //根据终点y值调整line的接口位置
    CGFloat x = startPoint.x + 3;
    if (endPoint.y < 0) {
        endPoint.x = endPoint.x - 6;
    }else if (endPoint.y == 0){
        endPoint.x = endPoint.x - 6;
    }else if (endPoint.y > 0){
        endPoint.x = endPoint.x - 6;
    }
    
    _endPoint = endPoint;
    
    return [self initWithFrame:CGRectMake(x, startPoint.y, 0, 0)];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

#pragma mark - line(线)

/**
 *  填充
 *
 *  @return UIBezierPath
 */
- (UIBezierPath *)fill{
    UIBezierPath * bezier = [UIBezierPath bezierPath];
    [bezier moveToPoint:CGPointMake(0, 0)];
    [bezier addLineToPoint:_endPoint];
    [bezier stroke];
    return bezier;
}

/**
 *  CAShapeLayer
 *
 *  @return CAShapeLayer
 */
- (CAShapeLayer *)shapeLayer{
    CAShapeLayer * layer = [CAShapeLayer layer];
    layer.strokeColor = _lineColor.CGColor;
    layer.lineWidth = _lineWidth;
    layer.path = [self fill].CGPath;
    
    if (_isShadow) {
        layer.shadowOpacity = 1.f;
        layer.shadowColor = [UIColor lightGrayColor].CGColor;
        layer.shadowOffset = CGSizeMake(2, 1);
    }
    
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
    CABasicAnimation * fillAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    fillAnimation.duration = _animationDuration;
    fillAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    fillAnimation.fillMode = kCAFillModeForwards;
    fillAnimation.removedOnCompletion = NO;
    fillAnimation.fromValue = @(0.f);
    fillAnimation.toValue = @(1.f);
    
    return fillAnimation;
}

/**
 *  清除之前所有subLayers
 */
- (void)removeAllSubLayers{
    NSArray * subLayers = [NSArray arrayWithArray:self.layer.sublayers];
    for (CALayer * layer in subLayers) {
        [layer removeAllAnimations];
        [layer removeFromSuperlayer];
    }
}

#pragma mark - public method

/**
 *  重绘
 */
- (void)strokePath{
    [self removeAllSubLayers];
    
    [self.layer addSublayer:[self shapeLayer]];
}

@end
