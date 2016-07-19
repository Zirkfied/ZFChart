//
//  ZFPie.m
//  ZFChartView
//
//  Created by apple on 16/3/21.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ZFPie.h"
#import "ZFConst.h"

@interface ZFPie()

@end

@implementation ZFPie

+ (instancetype)pieWithCenter:(CGPoint)center radius:(CGFloat)radius startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle color:(UIColor *)color duration:(CFTimeInterval)duration piePatternType:(kPiePatternType)piePatternType isAnimated:(BOOL)isAnimated{
    return [[ZFPie alloc] initWithCenter:(CGPoint)center radius:(CGFloat)radius startAngle:startAngle endAngle:endAngle color:color duration:duration piePatternType:piePatternType isAnimated:isAnimated];
}

- (instancetype)initWithCenter:(CGPoint)center radius:(CGFloat)radius startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle color:(UIColor *)color duration:(CFTimeInterval)duration piePatternType:(kPiePatternType)piePatternType isAnimated:(BOOL)isAnimated{
    self = [super init];
    if (self) {
        self.fillColor = nil;
        self.strokeColor = color.CGColor;
        self.path = [self bezierWithCenter:center radius:radius startAngle:startAngle endAngle:endAngle color:color].CGPath;
        
        if (isAnimated) {
            CABasicAnimation * animation = [self animationWithDuration:duration];
            [self addAnimation:animation forKey:nil];
        }
    }
    return self;
}

- (UIBezierPath *)bezierWithCenter:(CGPoint)center radius:(CGFloat)radius startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle color:(UIColor *)color{
    UIBezierPath * bezier = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
    return bezier;
}

- (CABasicAnimation *)animationWithDuration:(CFTimeInterval)duration{
    CABasicAnimation * fillAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    fillAnimation.duration = duration;
    fillAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    fillAnimation.fillMode = kCAFillModeForwards;
    fillAnimation.removedOnCompletion = NO;
    fillAnimation.fromValue = @(0.f);
    fillAnimation.toValue = @(1.f);
    
    return fillAnimation;
}

#pragma mark - 重写setter,getter方法

- (void)setIsShadow:(BOOL)isShadow{
    _isShadow = isShadow;
    if (_isShadow) {
        self.shadowOpacity = 1.f;
        self.shadowColor = ZFDarkGray.CGColor;
        self.shadowOffset = CGSizeMake(2, 2);
    }
}

@end
