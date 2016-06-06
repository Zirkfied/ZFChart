//
//  ZFWave.m
//  ZFChartView
//
//  Created by apple on 16/3/26.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ZFWave.h"
#import "ZFColor.h"
#import "UIBezierPath+Zirkfied.h"

@interface ZFWave()

/** 动画时间 */
@property (nonatomic, assign) CGFloat animationDuration;

@end

@implementation ZFWave

/**
 *  初始化属性
 */
- (void)commonInit{
    _animationDuration = 1.f;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    
    return self;
}

- (UIBezierPath *)noFill{
    UIBezierPath * bezier = [UIBezierPath bezierPath];
    [bezier moveToPoint:CGPointMake(0, self.frame.size.height)];
    for (NSInteger i = 0; i < _valuePointArray.count; i++) {
        NSDictionary * point = _valuePointArray[i];
        [bezier addLineToPoint:CGPointMake([point[@"xPos"] floatValue], self.frame.size.height)];
    }

    [bezier addLineToPoint:CGPointMake(self.frame.size.width, self.frame.size.height)];
    [bezier addLineToPoint:CGPointMake(self.frame.size.width, self.frame.size.height)];
    [bezier closePath];
    
    return bezier = _wavePatternType == kWavePatternTypeForCurve ? [bezier smoothedPathWithGranularity:_padding] : bezier;;
}

- (UIBezierPath *)fill{
    UIBezierPath * bezier = [UIBezierPath bezierPath];
    [bezier moveToPoint:CGPointMake(0, self.frame.size.height)];
    for (NSInteger i = 0; i < _valuePointArray.count; i++) {
        NSDictionary * point = _valuePointArray[i];
        [bezier addLineToPoint:CGPointMake([point[@"xPos"] floatValue], [point[@"yPos"] floatValue])];
    }
    
    NSDictionary * lastPoint = _valuePointArray.lastObject;
    [bezier addLineToPoint:CGPointMake(self.frame.size.width, [lastPoint[@"yPos"] floatValue])];
    [bezier addLineToPoint:CGPointMake(self.frame.size.width, self.frame.size.height)];
    [bezier closePath];
    
    return bezier = _wavePatternType == kWavePatternTypeForCurve ? [bezier smoothedPathWithGranularity:_padding] : bezier;
}

- (CAShapeLayer *)shapeLayer{
    CAShapeLayer * shapeLayer = [CAShapeLayer layer];
    shapeLayer.anchorPoint = CGPointMake(1, 0.5);
    shapeLayer.fillColor = _pathColor.CGColor;
    shapeLayer.path = [self fill].CGPath;
    shapeLayer.lineJoin = kCALineJoinRound;
    shapeLayer.lineCap = kCALineCapRound;
    shapeLayer.opacity = _opacity;
    
    if (_isAnimated) {
        CABasicAnimation * animation = [self animation];
        [shapeLayer addAnimation:animation forKey:nil];
    }
    
    return shapeLayer;
}

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

- (void)strokePath{
    for (CALayer * layer in self.layer.sublayers) {
        [layer removeAllAnimations];
        [layer removeFromSuperlayer];
    }
    
    [self.layer addSublayer:[self shapeLayer]];
}

@end
