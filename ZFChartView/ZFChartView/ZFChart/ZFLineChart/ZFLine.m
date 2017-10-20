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
#import "UIBezierPath+Zirkfied.h"
#import "ZFCurveAttribute.h"

@interface ZFLine()

/** 动画时间 */
@property (nonatomic, assign) CGFloat animationDuration;
@property (nonatomic, strong) NSMutableArray * valuePointArray;
/** 存储kLinePatternTypeForCurve样式下各段线段模型数组(存储的是ZFCurveAttribute模型) */
@property (nonatomic, strong) NSMutableArray * curveArray;
/** 存储细分曲线的子数组 */
@property (nonatomic, strong) NSMutableArray * subArray;

@end

@implementation ZFLine

/**
 *  初始化属性
 */
- (void)commonInit{
    _animationDuration = 1.25f;
    _isShadow = YES;
}

+ (instancetype)lineWithValuePointArray:(NSMutableArray *)valuePointArray isAnimated:(BOOL)isAnimated shadowColor:(UIColor *)shadowColor linePatternType:(kLinePatternType)linePatternType padding:(CGFloat)padding{
    return [[ZFLine alloc] initWithValuePointArray:valuePointArray isAnimated:isAnimated shadowColor:shadowColor linePatternType:linePatternType padding:padding];
}

- (instancetype)initWithValuePointArray:(NSMutableArray *)valuePointArray isAnimated:(BOOL)isAnimated shadowColor:(UIColor *)shadowColor linePatternType:(kLinePatternType)linePatternType padding:(CGFloat)padding{
    self = [super init];
    if (self) {
        [self commonInit];
        
        self.valuePointArray = [NSMutableArray arrayWithArray:valuePointArray];
        [self subsectionCruve];
        self.fillColor = nil;
        self.lineCap = kCALineCapRound;
        self.lineJoin = kCALineJoinRound;
        self.path = [self bezierWithValuePointArray:self.valuePointArray linePatternType:linePatternType padding:padding].CGPath;
        
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
- (UIBezierPath *)bezierWithValuePointArray:(NSMutableArray *)valuePointArray linePatternType:(kLinePatternType)linePatternType padding:(CGFloat)padding{
    if (linePatternType == kLinePatternTypeCurve) {
        UIBezierPath * bezier = [UIBezierPath bezierPath];
        for (NSInteger i = 0; i < self.curveArray.count; i++) {
            UIBezierPath * subBezier = [UIBezierPath bezierPath];
            ZFCurveAttribute * attribute = self.curveArray[i];
            for (NSInteger j = 0; j < attribute.pointArray.count; j++) {
                NSDictionary * currentPoint = attribute.pointArray[j];
                if (j == 0) {
                    [subBezier moveToPoint:CGPointMake([currentPoint[ZFLineChartXPos] floatValue], [currentPoint[ZFLineChartYPos] floatValue])];
                    
                }else{
                    [subBezier addLineToPoint:CGPointMake([currentPoint[ZFLineChartXPos] floatValue], [currentPoint[ZFLineChartYPos] floatValue])];
                }
            }
            //判断绘画直线还是曲线
            subBezier = attribute.isCurve ? [subBezier smoothedPathWithGranularity:padding] : subBezier;
            [bezier appendPath:subBezier];
        }
        
        return bezier;
        
    }else if (linePatternType == kLinePatternTypeSharp){
        [_valuePointArray removeObjectAtIndex:0];
        [_valuePointArray removeObjectAtIndex:0];
        [_valuePointArray removeLastObject];
        
        UIBezierPath * bezier = [UIBezierPath bezierPath];
        for (NSInteger i = 0; i < _valuePointArray.count; i++) {
            NSDictionary * point = _valuePointArray[i];
            
            if (i == 0) {
                [bezier moveToPoint:CGPointMake([point[ZFLineChartXPos] floatValue], [point[ZFLineChartYPos] floatValue])];
            }else{
                [bezier addLineToPoint:CGPointMake([point[ZFLineChartXPos] floatValue], [point[ZFLineChartYPos] floatValue])];
            }
        }

        return bezier;
    }
    
    return nil;
}

/**
 *  渐变色
 */
- (CALayer *)lineGradientColor{
    CALayer * layer = [CALayer layer];
    layer.name = ZFLineChartGradientLayer;
    CAGradientLayer * gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    gradientLayer.colors = _gradientAttribute.colors;
    gradientLayer.locations = _gradientAttribute.locations;
    gradientLayer.startPoint = _gradientAttribute.startPoint;
    gradientLayer.endPoint = _gradientAttribute.endPoint;
    [layer addSublayer:gradientLayer];
    layer.mask = self;
    
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
    fillAnimation.fillMode = kCAFillModeForwards;
    fillAnimation.removedOnCompletion = NO;
    fillAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    fillAnimation.fromValue = @(0.f);
    fillAnimation.toValue = @(1.f);
    return fillAnimation;
}

#pragma mark - kLinePatternTypeForCurve样式下模型处理

/**
 *  细分曲线
 */
- (void)subsectionCruve{
    [self.subArray removeAllObjects];
    
    for (NSInteger i = 2; i < self.valuePointArray.count; i++) {
        NSDictionary * previousPoint2 = self.valuePointArray[i - 2];
        NSDictionary * previousPoint1 = self.valuePointArray[i - 1];
        NSDictionary * currentPoint = self.valuePointArray[i];
        
        if (i == 2) {
            [self.subArray addObject:currentPoint];
        }
        
        //最后一个点不加入到画线的范围
        if (i > 2 && i < self.valuePointArray.count - 1) {
            //a.a.a
            if ([previousPoint2[ZFLineChartIsHeightEqualZero] boolValue] == [currentPoint[ZFLineChartIsHeightEqualZero] boolValue] && [previousPoint1[ZFLineChartIsHeightEqualZero] boolValue] == [currentPoint[ZFLineChartIsHeightEqualZero] boolValue]) {
                [self.subArray addObject:currentPoint];
                
                //a.a.b
            }else if (![previousPoint2[ZFLineChartIsHeightEqualZero] boolValue] == [currentPoint[ZFLineChartIsHeightEqualZero] boolValue] && ![previousPoint1[ZFLineChartIsHeightEqualZero] boolValue] == [currentPoint[ZFLineChartIsHeightEqualZero] boolValue]){
                //当高度为0
                if ([currentPoint[ZFLineChartIsHeightEqualZero] boolValue]) {
                    [self.subArray addObject:currentPoint];
                    //当高度不为0
                }else{
                    ZFCurveAttribute * attribute = [[ZFCurveAttribute alloc] init];
                    attribute.pointArray = [NSMutableArray arrayWithArray:self.subArray];
                    attribute.isCurve = NO;
                    [self.curveArray addObject:attribute];
                    
                    [self.subArray removeAllObjects];
                    [self.subArray addObject:previousPoint1];
                    [self.subArray addObject:currentPoint];
                }
                
                //a.b.a
            }else if ([previousPoint2[ZFLineChartIsHeightEqualZero] boolValue] == [currentPoint[ZFLineChartIsHeightEqualZero] boolValue] && ![previousPoint1[ZFLineChartIsHeightEqualZero] boolValue] == [currentPoint[ZFLineChartIsHeightEqualZero] boolValue]){
                [self.subArray addObject:currentPoint];
                
                //a.b.b
            }else if (![previousPoint2[ZFLineChartIsHeightEqualZero] boolValue] == [currentPoint[ZFLineChartIsHeightEqualZero] boolValue] && [previousPoint1[ZFLineChartIsHeightEqualZero] boolValue] == [currentPoint[ZFLineChartIsHeightEqualZero] boolValue]){
                //当高度为0
                if ([currentPoint[ZFLineChartIsHeightEqualZero] boolValue]) {
                    ZFCurveAttribute * attribute = [[ZFCurveAttribute alloc] init];
                    attribute.pointArray = [NSMutableArray arrayWithArray:self.subArray];
                    attribute.isCurve = YES;
                    [self.curveArray addObject:attribute];
                    
                    [self.subArray removeAllObjects];
                    [self.subArray addObject:previousPoint1];
                    [self.subArray addObject:currentPoint];
                    //当高度不为0
                }else{
                    [self.subArray addObject:currentPoint];
                }
            }
        }
        
        //最后一个点
        if (i == self.valuePointArray.count - 1) {
            ZFCurveAttribute * attribute = [[ZFCurveAttribute alloc] init];
            attribute.pointArray = [NSMutableArray arrayWithArray:self.subArray];
            //a.a.a
            if ([previousPoint1[ZFLineChartIsHeightEqualZero] boolValue] == [currentPoint[ZFLineChartIsHeightEqualZero] boolValue] && [previousPoint2[ZFLineChartIsHeightEqualZero] boolValue] == [currentPoint[ZFLineChartIsHeightEqualZero] boolValue]) {
                //当高度为0
                if ([currentPoint[ZFLineChartIsHeightEqualZero] boolValue]) {
                    attribute.isCurve = NO;
                }else{
                    attribute.isCurve = YES;
                }
            }else{
                attribute.isCurve = YES;
            }
            
            [self.curveArray addObject:attribute];
            
            [self.subArray removeAllObjects];
        }
    }
}

#pragma mark - 重写setter,getter方法

- (void)setIsShadow:(BOOL)isShadow{
    _isShadow = isShadow;
    if (!_isShadow) {
        self.shadowOpacity = 0.f;
    }
}

#pragma mark - 懒加载

- (NSMutableArray *)curveArray{
    if (!_curveArray) {
        _curveArray = [NSMutableArray array];
    }
    return _curveArray;
}

- (NSMutableArray *)subArray{
    if (!_subArray) {
        _subArray = [NSMutableArray array];
    }
    return _subArray;
}

@end
