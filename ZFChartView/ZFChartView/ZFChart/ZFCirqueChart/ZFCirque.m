//
//  ZFCirque.m
//  ZFChartView
//
//  Created by apple on 2016/10/20.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ZFCirque.h"
#import "ZFConst.h"
#import "UIColor+Zirkfied.h"

@interface ZFCirque()

/** 动画时间 */
@property (nonatomic, assign) CGFloat animationDuration;
/** 圆环中心点 */
@property (nonatomic, assign) CGPoint cirqueCenter;
/** 圆环开始的角度 */
@property (nonatomic, assign) CGFloat startAngle;
/** 圆环结束的角度 */
@property (nonatomic, assign) CGFloat endAngle;
/** 阴影偏移量 */
@property (nonatomic, assign) CGSize shadowOffset;

@end

@implementation ZFCirque

/**
 *  初始化变量
 */
- (void)commonInit{
    _animationDuration = 0.75f;
    _startAngle = ZFRadian(-90);
    _cirqueCenter = CGPointMake(CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame) / 2);
    _shadowOffset = CGSizeMake(1, 1);
    self.backgroundColor = ZFClear;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

#pragma mark - 画圆环

/**
 *  画圆环
 *
 *  @return UIBezierPath
 */
- (UIBezierPath *)drawCirque{
    _endAngle = ZFRadian(ZFPerigon * _percent) + _startAngle;
    
    UIBezierPath * bezier = [UIBezierPath bezierPathWithArcCenter:_cirqueCenter radius:_radius startAngle:_startAngle endAngle:_endAngle clockwise:YES];
    return bezier;
}

/**
 *  圆环ShapeLayer
 *
 *  @return CAShapeLayer
 */
- (CAShapeLayer *)cirqueShapeLayer{
    CAShapeLayer * shapeLayer = [CAShapeLayer layer];
    shapeLayer.lineCap = _percent != 1.f ? kCALineCapRound : kCALineCapButt;
    shapeLayer.lineWidth = _lineWidth;
    shapeLayer.fillColor = ZFClear.CGColor;
    shapeLayer.strokeColor = _pathColor.CGColor;
    shapeLayer.path = [self drawCirque].CGPath;

    if (_cirquePatternType == kCirquePatternTypeForShadow) {
        shapeLayer.shadowOpacity = _shadowOpacity;
        shapeLayer.shadowColor = ZFDarkGray.CGColor;
        shapeLayer.shadowOffset = _shadowOffset;
    }
    
    if (_isAnimated) {
        CABasicAnimation * animation = [self animation];
        [shapeLayer addAnimation:animation forKey:nil];
    }
    
    return shapeLayer;
}

#pragma mark - 圆环轨迹背景

/**
 *  画圆环轨迹背景
 *
 *  @return UIBezierPath
 */
- (UIBezierPath *)drawCirqueBackgroundView{
    UIBezierPath * bezier = [UIBezierPath bezierPathWithArcCenter:_cirqueCenter radius:_radius startAngle:_startAngle endAngle:ZFRadian(270) clockwise:YES];
    return bezier;
}

/**
 *  圆环轨迹背景ShapeLayer
 *
 *  @return CAShapeLayer
 */
- (CAShapeLayer *)cirqueShapeLayerBackgroundView{
    CAShapeLayer * shapeLayer = [CAShapeLayer layer];
    shapeLayer.lineWidth = _lineWidth;
    shapeLayer.fillColor = ZFClear.CGColor;
    shapeLayer.strokeColor = ZFTaupe2.CGColor;
    shapeLayer.path = [self drawCirqueBackgroundView].CGPath;
    
    if (_cirquePatternType == kCirquePatternTypeForDefaultWithShadow) {
        shapeLayer.shadowOpacity = _shadowOpacity;
        shapeLayer.shadowColor = ZFDarkGray.CGColor;
        shapeLayer.shadowOffset = _shadowOffset;
    }
    
    return shapeLayer;
}

#pragma mark - 动画

/**
 *  填充动画
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

#pragma mark - 清除之前所有subLayers

/**
 *  清除之前所有subLayers
 */
- (void)removeAllSubLayers{
    NSArray * sublayers = [NSArray arrayWithArray:self.layer.sublayers];
    for (CALayer * layer in sublayers) {
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
    
    if (_cirquePatternType == kCirquePatternTypeForDefault || _cirquePatternType == kCirquePatternTypeForDefaultWithShadow) {
        [self.layer addSublayer:[self cirqueShapeLayerBackgroundView]];
    }
    
    //重置圆环起始角度
    _startAngle = ZFRadian((-90 + _cirqueStartOrientation * 45.f));
    [self.layer addSublayer:[self cirqueShapeLayer]];
}

@end
