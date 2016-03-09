//
//  ZFCirque.m
//  ZFChartView
//
//  Created by apple on 16/2/15.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ZFCirque.h"
#import "ZFConst.h"

@interface ZFCirque()

/** 半径 */
@property (nonatomic, assign) CGFloat radius;
/** 线宽 */
@property (nonatomic, assign) CGFloat lineWidth;
/** 动画时间 */
@property (nonatomic, assign) CGFloat animationDuration;
@property (nonatomic, strong) CAShapeLayer * shapeLayer;

@end

@implementation ZFCirque

/**
 *  初始化默认变量
 */
- (void)commonInit{
    _radius = 3;
    _lineWidth = 2;
    _animationDuration = 0.5f;
    _isShadow = YES;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:CGRectMake(frame.origin.x - 2.5, frame.origin.y - 2, 5, 5)];// 5 = _radius + _lineWidth
    if (self) {
        [self commonInit];
    }
    
    return self;
}

#pragma mark - Cirque(圆环)

/**
 *  填充
 *
 *  @return UIBezierPath
 */
- (UIBezierPath *)fill{
    UIBezierPath * bezier = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2) radius:_radius startAngle:ZFRadian(-90) endAngle:ZFRadian(270) clockwise:YES];
    return bezier;
}

/**
 *  CAShapeLayer
 *
 *  @return CAShapeLayer
 */
- (CAShapeLayer *)shapeLayer{
    CAShapeLayer * layer = [CAShapeLayer layer];
    layer.fillColor = nil;
    layer.lineWidth = _lineWidth;
    layer.path = [self fill].CGPath;
    layer.strokeColor = _cirqueColor.CGColor;
    self.shapeLayer = layer;
    
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

#pragma mark - 重写setter,getter方法

- (void)setCirqueColor:(UIColor *)cirqueColor{
    _cirqueColor = cirqueColor;
    self.shapeLayer.strokeColor = _cirqueColor.CGColor;
}

@end
