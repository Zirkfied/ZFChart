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
#import "ZFWaveAttribute.h"

@interface ZFWave()

/** 动画时间 */
@property (nonatomic, assign) CGFloat animationDuration;
/** 临时新数值坐标的数组 */
@property (nonatomic, strong) NSMutableArray * tempValuePointArray;
/** 存储kWavePatternTypeForCurve样式下各段线段模型数组(存储的是ZFWaveAttribute模型) */
@property (nonatomic, strong) NSMutableArray * curveArray;
/** 存储细分曲线的子数组 */
@property (nonatomic, strong) NSMutableArray * subArray;

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
    if (_wavePatternType == kWavePatternTypeForCurve) {
        UIBezierPath * bezier = [UIBezierPath bezierPath];
        for (NSInteger i = 0; i < self.curveArray.count; i++) {
            UIBezierPath * subBezier = [UIBezierPath bezierPath];
            ZFWaveAttribute * attribute = self.curveArray[i];
            for (NSInteger j = 0; j < attribute.pointArray.count; j++) {
                NSDictionary * currentPoint = attribute.pointArray[j];
                if (j == 0) {
                    [subBezier moveToPoint:CGPointMake([currentPoint[ZFWaveChartXPos] floatValue], self.frame.size.height)];
                }else{
                    [subBezier addLineToPoint:CGPointMake([currentPoint[ZFWaveChartXPos] floatValue], self.frame.size.height)];
                }
            }
            //判断绘画直线还是曲线
            subBezier = attribute.isCurve ? [subBezier smoothedPathWithGranularity:_padding] : subBezier;
            [bezier appendPath:subBezier];
            
            UIBezierPath * closeBezier = [UIBezierPath bezierPath];
            [closeBezier moveToPoint:CGPointMake(self.frame.size.width, self.frame.size.height)];
            [closeBezier addLineToPoint:CGPointMake(0, self.frame.size.height)];
            [bezier appendPath:closeBezier];
        }
        
        return bezier;
        
    }else if (_wavePatternType == kWavePatternTypeForSharp){
        UIBezierPath * bezier = [UIBezierPath bezierPath];
        [bezier moveToPoint:CGPointMake(0, self.frame.size.height)];
        for (NSInteger i = 0; i < _valuePointArray.count; i++) {
            NSDictionary * point = _valuePointArray[i];
            
            [bezier addLineToPoint:CGPointMake([point[ZFWaveChartXPos] floatValue], self.frame.size.height)];
        }

        [bezier addLineToPoint:CGPointMake(self.frame.size.width, self.frame.size.height)];
        [bezier closePath];
        return bezier;
    }
    
    return nil;
}

- (UIBezierPath *)fill{
    if (_wavePatternType == kWavePatternTypeForCurve) {
        UIBezierPath * bezier = [UIBezierPath bezierPath];
        for (NSInteger i = 0; i < self.curveArray.count; i++) {
            UIBezierPath * subBezier = [UIBezierPath bezierPath];
            ZFWaveAttribute * attribute = self.curveArray[i];
            for (NSInteger j = 0; j < attribute.pointArray.count; j++) {
                NSDictionary * currentPoint = attribute.pointArray[j];
                if (j == 0) {
                    [subBezier moveToPoint:CGPointMake([currentPoint[ZFWaveChartXPos] floatValue], [currentPoint[ZFWaveChartYPos] floatValue])];
                }else{
                    [subBezier addLineToPoint:CGPointMake([currentPoint[ZFWaveChartXPos] floatValue], [currentPoint[ZFWaveChartYPos] floatValue])];
                }
            }
            //判断绘画直线还是曲线
            subBezier = attribute.isCurve ? [subBezier smoothedPathWithGranularity:_padding] : subBezier;
            [bezier appendPath:subBezier];
            
            UIBezierPath * closeBezier = [UIBezierPath bezierPath];
            [closeBezier moveToPoint:CGPointMake(self.frame.size.width, self.frame.size.height)];
            [closeBezier addLineToPoint:CGPointMake(0, self.frame.size.height)];
            [bezier appendPath:closeBezier];
        }
        
        return bezier;
        
    }else if (_wavePatternType == kWavePatternTypeForSharp){
        UIBezierPath * bezier = [UIBezierPath bezierPath];
        [bezier moveToPoint:CGPointMake(0, self.frame.size.height)];
        for (NSInteger i = 0; i < _valuePointArray.count; i++) {
            NSDictionary * point = _valuePointArray[i];
            [bezier addLineToPoint:CGPointMake([point[ZFWaveChartXPos] floatValue], [point[ZFWaveChartYPos] floatValue])];
        }
    
        [bezier addLineToPoint:CGPointMake(self.frame.size.width, self.frame.size.height)];
        [bezier closePath];
        return bezier;
    }
    
    return nil;
}

- (CAShapeLayer *)shapeLayer{
    CAShapeLayer * shapeLayer = [CAShapeLayer layer];
    shapeLayer.anchorPoint = CGPointMake(1, 0.5);
    shapeLayer.strokeColor = _pathLineColor.CGColor;
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

/**
 *  渐变色
 */
- (CALayer *)pathGradientColor{
    CALayer * layer = [CALayer layer];
    CAGradientLayer * gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    gradientLayer.colors = _gradientAttribute.colors;
    gradientLayer.locations = _gradientAttribute.locations;
    gradientLayer.startPoint = _gradientAttribute.startPoint;
    gradientLayer.endPoint = _gradientAttribute.endPoint;
    [layer addSublayer:gradientLayer];
    
    CAShapeLayer * lineLayer = [CAShapeLayer layer];
    lineLayer.strokeColor = _pathLineColor.CGColor;
    lineLayer.fillColor = nil;
    lineLayer.path = [self fill].CGPath;
    lineLayer.lineJoin = kCALineJoinRound;
    lineLayer.lineCap = kCALineCapRound;
    [layer addSublayer:lineLayer];
    
    if (_isAnimated) {
        CABasicAnimation * animation = [self animation];
        [lineLayer addAnimation:animation forKey:nil];
    }
    
    layer.mask = [self shapeLayer];
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

#pragma mark - 重绘

- (void)strokePath{
    for (CALayer * layer in self.layer.sublayers) {
        [layer removeAllAnimations];
        [layer removeFromSuperlayer];
    }
    
    if (_wavePatternType == kWavePatternTypeForCurve) {
        [self subsectionCruve];
    }
    
    _gradientAttribute ? [self.layer addSublayer:[self pathGradientColor]] : [self.layer addSublayer:[self shapeLayer]];
}

#pragma mark - kWavePatternTypeForCurve样式下模型处理

/**
 *  细分曲线
 */
- (void)subsectionCruve{
    [self.subArray removeAllObjects];
    
    for (NSInteger i = 2; i < self.tempValuePointArray.count; i++) {
        NSDictionary * previousPoint2 = self.tempValuePointArray[i - 2];
        NSDictionary * previousPoint1 = self.tempValuePointArray[i - 1];
        NSDictionary * currentPoint = self.tempValuePointArray[i];
        
        if (i == 2) {
            [self.subArray addObject:previousPoint1];
            [self.subArray addObject:currentPoint];
        }
        
        if (i > 2) {
            //a.a.a
            if ([previousPoint2[ZFWaveChartIsHeightEqualZero] boolValue] == [currentPoint[ZFWaveChartIsHeightEqualZero] boolValue] &&[previousPoint1[ZFWaveChartIsHeightEqualZero] boolValue] == [currentPoint[ZFWaveChartIsHeightEqualZero] boolValue]) {
                [self.subArray addObject:currentPoint];
                
            //a.a.b
            }else if (![previousPoint2[ZFWaveChartIsHeightEqualZero] boolValue] == [currentPoint[ZFWaveChartIsHeightEqualZero] boolValue] && ![previousPoint1[ZFWaveChartIsHeightEqualZero] boolValue] == [currentPoint[ZFWaveChartIsHeightEqualZero] boolValue]){
                //当高度为0
                if ([currentPoint[ZFWaveChartIsHeightEqualZero] boolValue]) {
                    [self.subArray addObject:currentPoint];
                //当高度不为0
                }else{
                    ZFWaveAttribute * attribute = [[ZFWaveAttribute alloc] init];
                    attribute.pointArray = [NSMutableArray arrayWithArray:self.subArray];
                    attribute.isCurve = NO;
                    [self.curveArray addObject:attribute];
                    
                    [self.subArray removeAllObjects];
                    [self.subArray addObject:previousPoint1];
                    [self.subArray addObject:currentPoint];
                }
                
            //a.b.a
            }else if ([previousPoint2[ZFWaveChartIsHeightEqualZero] boolValue] == [currentPoint[ZFWaveChartIsHeightEqualZero] boolValue] && ![previousPoint1[ZFWaveChartIsHeightEqualZero] boolValue] == [currentPoint[ZFWaveChartIsHeightEqualZero] boolValue]){
                [self.subArray addObject:currentPoint];
                
            //a.b.b
            }else if (![previousPoint2[ZFWaveChartIsHeightEqualZero] boolValue] == [currentPoint[ZFWaveChartIsHeightEqualZero] boolValue] && [previousPoint1[ZFWaveChartIsHeightEqualZero] boolValue] == [currentPoint[ZFWaveChartIsHeightEqualZero] boolValue]){
                //当高度为0
                if ([currentPoint[ZFWaveChartIsHeightEqualZero] boolValue]) {
                    ZFWaveAttribute * attribute = [[ZFWaveAttribute alloc] init];
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
        if (i == self.tempValuePointArray.count - 1) {
            ZFWaveAttribute * attribute = [[ZFWaveAttribute alloc] init];
            attribute.pointArray = [NSMutableArray arrayWithArray:self.subArray];
            //a.a.a
            if ([previousPoint1[ZFWaveChartIsHeightEqualZero] boolValue] == [currentPoint[ZFWaveChartIsHeightEqualZero] boolValue] && [previousPoint2[ZFWaveChartIsHeightEqualZero] boolValue] == [currentPoint[ZFWaveChartIsHeightEqualZero] boolValue]) {
                //当高度为0
                if ([currentPoint[ZFWaveChartIsHeightEqualZero] boolValue]) {
                    attribute.isCurve = NO;
                }else{
                    attribute.isCurve = YES;
                }
                
            //a.b.b
            }else if (![previousPoint1[ZFWaveChartIsHeightEqualZero] boolValue] == [currentPoint[ZFWaveChartIsHeightEqualZero] boolValue] && [previousPoint2[ZFWaveChartIsHeightEqualZero] boolValue] == [currentPoint[ZFWaveChartIsHeightEqualZero] boolValue]){
                //当高度为0
                if ([currentPoint[ZFWaveChartIsHeightEqualZero] boolValue]) {
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

- (NSMutableArray *)tempValuePointArray{
    if (!_tempValuePointArray) {
        _tempValuePointArray = [NSMutableArray arrayWithArray:_valuePointArray];
        //(在最前面多插入了2个原点, 在最后面多插入了1个终点, 用于判断切断位置)
        NSDictionary * startPoint = @{ZFWaveChartXPos:@(0), ZFWaveChartYPos:@(self.frame.size.height), ZFWaveChartIsHeightEqualZero:@(YES)};
        NSDictionary * endPoint = @{ZFWaveChartXPos:@(self.frame.size.width), ZFWaveChartYPos:@(self.frame.size.height), ZFWaveChartIsHeightEqualZero:@(YES)};
        [_tempValuePointArray insertObject:startPoint atIndex:0];
        [_tempValuePointArray insertObject:startPoint atIndex:0];
        [_tempValuePointArray addObject:endPoint];
    }
    return _tempValuePointArray;
}

@end
