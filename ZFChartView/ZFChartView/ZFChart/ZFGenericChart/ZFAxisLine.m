//
//  ZFAxisLine.m
//  ZFChartView
//
//  Created by apple on 16/2/2.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ZFAxisLine.h"
#import "ZFConst.h"

@interface ZFAxisLine()

/** 箭头边长 */
@property (nonatomic, assign) CGFloat arrowsWidth;
/** 箭头边长的一半 */
@property (nonatomic, assign) CGFloat arrowsWidthHalf;
/** 动画时间 */
@property (nonatomic, assign) CGFloat animationDuration;
/** 分段线长度 */
@property (nonatomic, assign) CGFloat sectionLength;

@end

@implementation ZFAxisLine

/**
 *  初始化默认变量
 */
- (void)commonInit{
    _xLineWidth = self.frame.size.width - ZFAxisLineStartXPos - 20.f;
    _xLineHeight = 1.f;
    _yLineWidth = 1.f;
    _yLineHeight = self.frame.size.height * 0.7;
    
    _xLineStartXPos = ZFAxisLineStartXPos;
    _xLineStartYPos = self.frame.size.height * 0.8;
    _xLineEndXPos = self.frame.size.width - 20;
//    _xLineEndYPos = _xLineStartYPos;
    
    _yLineStartXPos = ZFAxisLineStartXPos;
    _yLineStartYPos = _xLineStartYPos;
    _yLineEndXPos = ZFAxisLineStartXPos;
    _yLineEndYPos = self.frame.size.height * 0.1;
    
    _arrowsWidth = 10.f;
    _arrowsWidthHalf = _arrowsWidth / 2.f;
    
    _animationDuration = 0.5f;
    _sectionLength = 5.f;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    
    return self;
}

#pragma mark - 坐标轴

/**
 *  坐标轴起始位置（未填充）
 *
 *  @return UIBezierPath
 */
- (UIBezierPath *)axisLineNoFill{
    UIBezierPath * bezier = [UIBezierPath bezierPathWithRect:CGRectMake(_xLineStartXPos, _xLineStartYPos, _xLineHeight, _xLineHeight)];
    [bezier fill];
    return bezier;
}

/**
 *  画x轴
 *
 *  @return UIBezierPath
 */
- (UIBezierPath *)drawXAxisLine{
    UIBezierPath * bezier = [UIBezierPath bezierPathWithRect:CGRectMake(_xLineStartXPos, _xLineStartYPos, _xLineWidth, _xLineHeight)];
    [bezier stroke];
    
    return bezier;
}

/**
 *  画y轴
 *
 *  @return UIBezierPath
 */
- (UIBezierPath *)drawYAxisLine{
    UIBezierPath * bezier = [UIBezierPath bezierPathWithRect:CGRectMake(_yLineEndXPos, _yLineEndYPos, _yLineWidth, _yLineHeight)];
    [bezier stroke];
    return bezier;
}

/**
 *  x轴shapeLayer
 *
 *  @return CAShapeLayer
 */
- (CAShapeLayer *)xAxisLineShapeLayer{
    CAShapeLayer * xAxisLinelayer = [CAShapeLayer layer];
    xAxisLinelayer.fillColor = [UIColor blackColor].CGColor;
    
    CABasicAnimation * animation = [self animationFromValue:[self axisLineNoFill] toValue:[self drawXAxisLine]];
    [xAxisLinelayer addAnimation:animation forKey:nil];
    
    return xAxisLinelayer;
}

/**
 *  y轴shapeLayer
 *
 *  @return CAShapeLayer
 */
- (CAShapeLayer *)yAxisLineShapeLayer{
    CAShapeLayer * yAxisLinelayer = [CAShapeLayer layer];
    yAxisLinelayer.fillColor = [UIColor blackColor].CGColor;
    
    CABasicAnimation * animation = [self animationFromValue:[self axisLineNoFill] toValue:[self drawYAxisLine]];
    [yAxisLinelayer addAnimation:animation forKey:nil];
    
    return yAxisLinelayer;
}

#pragma mark - 箭头

/**
 *  箭头起始位置（未填充）
 *
 *  @return UIBezierPath
 */
- (UIBezierPath *)arrowsNoFill{
    UIBezierPath * bezier = [UIBezierPath bezierPath];
    [bezier moveToPoint:CGPointMake(_yLineEndXPos + _arrowsWidthHalf + 0.5, _yLineEndYPos)];
    [bezier addLineToPoint:CGPointMake(_yLineEndXPos - _arrowsWidthHalf + 0.5, _yLineEndYPos)];
    [bezier stroke];
    
    return bezier;
}

/**
 *  画箭头
 *
 *  @return UIBezierPath
 */
- (UIBezierPath *)drawArrows{
    UIBezierPath * bezier = [UIBezierPath bezierPath];
    [bezier moveToPoint:CGPointMake(_yLineEndXPos + 0.5, _yLineEndYPos - _arrowsWidthHalf * ZFTan(60))];
    [bezier addLineToPoint:CGPointMake(_yLineEndXPos + _arrowsWidthHalf + 0.5, _yLineEndYPos)];
    [bezier addLineToPoint:CGPointMake(_yLineEndXPos + 0.5 - _arrowsWidthHalf, _yLineEndYPos)];
    [bezier closePath];
    [bezier fill];
    
    return bezier;
}

/**
 *  箭头CAShapeLayer
 *
 *  @return CAShapeLayer
 */
- (CAShapeLayer *)arrowsShapeLayer{
    CAShapeLayer * arrowsLayer = [CAShapeLayer layer];
    arrowsLayer.fillColor = [UIColor blackColor].CGColor;
    
    CABasicAnimation * animation = [self animationFromValue:[self arrowsNoFill] toValue:[self drawArrows]];
    [arrowsLayer addAnimation:animation forKey:nil];
    
    return arrowsLayer;
}

#pragma mark - y轴分段线

/**
 *  y轴分段线起始位置 (未填充)
 *
 *  @param i 下标
 *
 *  @return UIBezierPath
 */
- (UIBezierPath *)yAxisLineSectionNoFill:(NSInteger)i {
    UIBezierPath * bezier = [UIBezierPath bezierPath];
    CGFloat yStartPos = _yLineStartYPos - (_yLineHeight - ZFAxisLineGapFromYLineMaxValueToArrow) / _yLineSectionCount * (i + 1);
    [bezier moveToPoint:CGPointMake(_yLineStartXPos, yStartPos)];
    [bezier addLineToPoint:CGPointMake(_yLineStartXPos, yStartPos)];
    
    return bezier;
}

/**
 *  画y轴分段线
 *
 *  @param i 下标
 *
 *  @return UIBezierPath
 */
- (UIBezierPath *)drawYAxisLineSection:(NSInteger)i {
    UIBezierPath * bezier = [UIBezierPath bezierPath];
    CGFloat yStartPos = _yLineStartYPos - (_yLineHeight - ZFAxisLineGapFromYLineMaxValueToArrow) / _yLineSectionCount * (i + 1);
    [bezier moveToPoint:CGPointMake(_yLineStartXPos, yStartPos)];
    [bezier addLineToPoint:CGPointMake(_yLineStartXPos + _sectionLength, yStartPos)];
    
    return bezier;
}

/**
 *  y轴分段线CAShapeLayer
 *
 *  @param i 下标
 *
 *  @return CAShapeLayer
 */
- (CAShapeLayer *)yAxisLineSectionShapeLayer:(NSInteger)i {
    CAShapeLayer * layer = [CAShapeLayer layer];
    layer.strokeColor = [UIColor blackColor].CGColor;
    
    CABasicAnimation * animation = [self animationFromValue:[self yAxisLineSectionNoFill:i] toValue:[self drawYAxisLineSection:i]];
    [layer addAnimation:animation forKey:nil];
    
    return layer;
}

#pragma mark - 动画

/**
 *  填充动画
 *
 *  @return CABasicAnimation
 */
- (CABasicAnimation *)animationFromValue:(UIBezierPath *)fromValue toValue:(UIBezierPath *)toValue{
    CABasicAnimation * fillAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    fillAnimation.duration = _animationDuration;
    fillAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    fillAnimation.fillMode = kCAFillModeForwards;
    fillAnimation.removedOnCompletion = NO;
    fillAnimation.fromValue = (id)fromValue.CGPath;
    fillAnimation.toValue = (id)toValue.CGPath;
    
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
    
    [self.layer addSublayer:[self xAxisLineShapeLayer]];
    [self.layer addSublayer:[self yAxisLineShapeLayer]];
    
    for (NSInteger i = 0; i < _yLineSectionCount; i++) {
        [self.layer addSublayer:[self yAxisLineSectionShapeLayer:i]];
    }
    
    //延迟0.5秒执行
    NSTimer * timer = [NSTimer timerWithTimeInterval:_animationDuration target:self selector:@selector(timerAction:) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
}

#pragma mark - 定时器

- (void)timerAction:(NSTimer *)sender{
    [self.layer addSublayer:[self arrowsShapeLayer]];
    
    [sender invalidate];
    sender = nil;
}

#pragma mark - 重写setter,getter方法

- (void)setXLineWidth:(CGFloat)xLineWidth{
    if (xLineWidth < self.frame.size.width - ZFAxisLineStartXPos - 20.f) {
        _xLineWidth = self.frame.size.width - ZFAxisLineStartXPos - 20.f;
    }else{
        _xLineWidth = xLineWidth;
        _xLineEndXPos = _xLineStartXPos + _xLineWidth + 20.f;
    }
}

/**
 *  计算y轴分段高度的平均值
 */
- (CGFloat)yLineSectionHeightAverage{
    return ((_yLineHeight - ZFAxisLineGapFromYLineMaxValueToArrow) / _yLineSectionCount);
}

@end
