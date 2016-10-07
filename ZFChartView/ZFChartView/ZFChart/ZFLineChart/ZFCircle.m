//
//  ZFCircle.m
//  ZFChartView
//
//  Created by apple on 16/3/17.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ZFCircle.h"
#import "ZFConst.h"

@interface ZFCircle()

/** 半径 */
@property (nonatomic, assign) CGFloat radius;
/** 动画时间 */
@property (nonatomic, assign) CGFloat animationDuration;
@property (nonatomic, strong) CAShapeLayer * shapeLayer;

@end

@implementation ZFCircle

/**
 *  初始化默认变量
 */
- (void)commonInit{
    _animationDuration = 0.5f;
    _isShadow = YES;
    _circleColor = ZFRandom;
    _radius = self.frame.size.width * 0.5;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    
    return self;
}

#pragma mark - Circle(圆)

/**
 *  未填充
 *
 *  @return UIBezierPath
 */
- (UIBezierPath *)noFill{
    UIBezierPath * bezier = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(_radius, _radius, 0, 0)];
    return bezier;
}

/**
 *  填充
 *
 *  @return UIBezierPath
 */
- (UIBezierPath *)fill{
    UIBezierPath * bezier = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, _radius * 2, _radius * 2)];
    return bezier;
}

/**
 *  CAShapeLayer
 *
 *  @return CAShapeLayer
 */
- (CAShapeLayer *)shapeLayer{
    CAShapeLayer * layer = [CAShapeLayer layer];
    layer.fillColor = _circleColor.CGColor;
    layer.strokeColor = _circleColor.CGColor;
    layer.path = [self fill].CGPath;
    layer.opacity = _opacity;
    self.shapeLayer = layer;
    
    if (_isShadow) {
        //动画的viewj加了阴影会有卡顿现象，添加这句解决
        layer.shadowPath = [self fill].CGPath;
        layer.shadowOpacity = 1.f;
        layer.shadowColor = _shadowColor.CGColor;
        layer.shadowOffset = CGSizeMake(2, 1);
    }
    
    if (_isAnimated) {
        CABasicAnimation * animation = [self animation];
        [layer addAnimation:animation forKey:nil];
    }
    
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
    fillAnimation.fromValue = (__bridge id)([self noFill].CGPath);
    fillAnimation.toValue = (__bridge id)([self fill].CGPath);
    
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
