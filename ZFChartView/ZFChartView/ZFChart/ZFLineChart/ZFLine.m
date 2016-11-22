//
//  ZFLine.m
//  ZFChartView
//
//  Created by apple on 16/3/19.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ZFLine.h"
#import <UIKit/UIKit.h>
#import "ZFCircle.h"
#import "ZFConst.h"
#import "UIBezierPath+Zirkfied.h"

@interface ZFLine()

/** 动画时间 */
@property (nonatomic, assign) CGFloat animationDuration;

@end

@implementation ZFLine

/**
 *  初始化属性
 */
- (void)commonInit{
    _animationDuration = 1.25f;
    _isShadow = YES;
}

+ (instancetype)lineWithCircleArray:(NSMutableArray *)circleArray isAnimated:(BOOL)isAnimated shadowColor:(UIColor *)shadowColor linePatternType:(kLinePatternType)linePatternType padding:(CGFloat)padding{
    return [[ZFLine alloc] initWithCircleArray:circleArray isAnimated:isAnimated shadowColor:shadowColor linePatternType:linePatternType  padding:padding];
}

- (instancetype)initWithCircleArray:(NSMutableArray *)circleArray isAnimated:(BOOL)isAnimated shadowColor:(UIColor *)shadowColor linePatternType:(kLinePatternType)linePatternType padding:(CGFloat)padding{
    self = [super init];
    if (self) {
        [self commonInit];
        
        self.fillColor = nil;
        self.lineCap = kCALineCapRound;
        self.lineJoin = kCALineJoinRound;
        self.path = [self bezierWithCircleArray:circleArray linePatternType:linePatternType padding:padding].CGPath;
        
        if (_isShadow) {
            self.shadowOpacity = 1.f;
            self.shadowColor = shadowColor.CGColor;
            self.shadowOffset = CGSizeMake(2, 1);
        }
        
        if (isAnimated) {
            CABasicAnimation * animation = [self animation];
            [self addAnimation:animation forKey:nil];
        }
    }
    return self;
}

/**
 *  画线
 *
 *  @param circleArray 存储圆的数组
 *
 *  @return UIBezierPath
 */
- (UIBezierPath *)bezierWithCircleArray:(NSMutableArray *)circleArray  linePatternType:(kLinePatternType)linePatternType padding:(CGFloat)padding{
    UIBezierPath * bezier = [UIBezierPath bezierPath];
    for (NSInteger i = 0; i < circleArray.count; i++) {
        ZFCircle * circle = circleArray[i];
        if (i == 0) {
            [bezier moveToPoint:CGPointMake(circle.center.x, circle.center.y)];
        }else{
            [bezier addLineToPoint:CGPointMake(circle.center.x, circle.center.y)];
        }
    }
    
    return linePatternType == kLinePatternTypeForCurve ? [bezier smoothedPathWithGranularity:padding] : bezier;
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
    fillAnimation.fillMode = kCAFillModeForwards;
    fillAnimation.removedOnCompletion = NO;
    fillAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    fillAnimation.fromValue = @(0.f);
    fillAnimation.toValue = @(1.f);
    return fillAnimation;
}

#pragma mark - 重写setter,getter方法

- (void)setIsShadow:(BOOL)isShadow{
    _isShadow = isShadow;
    if (!_isShadow) {
        self.shadowOpacity = 0.f;
    }
}

@end
