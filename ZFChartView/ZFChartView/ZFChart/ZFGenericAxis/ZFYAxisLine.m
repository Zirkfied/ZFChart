//
//  ZFYAxisLine.m
//  ZFChartView
//
//  Created by apple on 16/3/14.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ZFYAxisLine.h"
#import "ZFConst.h"

@interface ZFYAxisLine()

/** 定时器 */
@property (nonatomic, strong) NSTimer * timer;

/** 动画时间 */
@property (nonatomic, assign) CGFloat animationDuration;
/** 箭头边长 */
@property (nonatomic, assign) CGFloat arrowsWidth;
/** 箭头边长的一半 */
@property (nonatomic, assign) CGFloat arrowsWidthHalf;
/** 坐标轴线宽的一半 */
@property (nonatomic, assign) CGFloat lineWidthHalf;
/** 分段线长度 */
@property (nonatomic, assign) CGFloat sectionLength;

@end

@implementation ZFYAxisLine

/**
 *  初始化默认变量
 */
- (void)commonInit{
    _yLineWidth = 1.f;
    _yLineHeight = self.frame.size.height * (EndRatio - StartRatio);
    
    _yLineStartXPos = ZFAxisLineStartXPos;
    _yLineStartYPos = self.frame.size.height * EndRatio;
    _yLineEndXPos = ZFAxisLineStartXPos;
    _yLineEndYPos = self.frame.size.height * StartRatio;
    
    _animationDuration = 0.5f;
    _arrowsWidth = 10.f;
    _arrowsWidthHalf = _arrowsWidth / 2.f;
    _lineWidthHalf = _yLineWidth / 2.f;
    _sectionLength = YLineSectionLength;
    _sectionColor = ZFBlack;
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
    UIBezierPath * bezier = [UIBezierPath bezierPathWithRect:CGRectMake(_yLineStartXPos, _yLineStartYPos, _yLineWidth, _yLineWidth)];
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
 *  y轴shapeLayer
 *
 *  @return CAShapeLayer
 */
- (CAShapeLayer *)yAxisLineShapeLayer{
    CAShapeLayer * yAxisLineLayer = [CAShapeLayer layer];
    yAxisLineLayer.fillColor = [UIColor blackColor].CGColor;
    yAxisLineLayer.path = [self drawYAxisLine].CGPath;
    
    CABasicAnimation * animation = [self animationFromValue:[self axisLineNoFill] toValue:[self drawYAxisLine] duration:_animationDuration];
    [yAxisLineLayer addAnimation:animation forKey:nil];
    
    return yAxisLineLayer;
}

#pragma mark - 箭头

/**
 *  箭头起始位置（未填充）
 *
 *  @return UIBezierPath
 */
- (UIBezierPath *)arrowsNoFill{
    UIBezierPath * bezier = [UIBezierPath bezierPath];
    [bezier moveToPoint:CGPointMake(_yLineEndXPos + _arrowsWidthHalf + _lineWidthHalf, _yLineEndYPos)];
    [bezier addLineToPoint:CGPointMake(_yLineEndXPos - _arrowsWidthHalf + _lineWidthHalf, _yLineEndYPos)];
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
    [bezier moveToPoint:CGPointMake(_yLineEndXPos + _lineWidthHalf - _arrowsWidthHalf, _yLineEndYPos)];
    [bezier addLineToPoint:CGPointMake(_yLineEndXPos + _lineWidthHalf, _yLineEndYPos - _arrowsWidthHalf * ZFTan(60))];
    [bezier addLineToPoint:CGPointMake(_yLineEndXPos + _arrowsWidthHalf + _lineWidthHalf, _yLineEndYPos)];

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
    arrowsLayer.path = [self drawArrows].CGPath;
    
    CABasicAnimation * animation = [self animationFromValue:[self arrowsNoFill] toValue:[self drawArrows] duration:_animationDuration];
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
    layer.strokeColor = _sectionColor.CGColor;
    layer.path = [self drawYAxisLineSection:i].CGPath;
    
    CABasicAnimation * animation = [self animationFromValue:[self yAxisLineSectionNoFill:i] toValue:[self drawYAxisLineSection:i] duration:_animationDuration];
    [layer addAnimation:animation forKey:nil];
    
    return layer;
}

/**
 *  填充动画
 *
 *  @return CABasicAnimation
 */
- (CABasicAnimation *)animationFromValue:(UIBezierPath *)fromValue toValue:(UIBezierPath *)toValue duration:(double)duration{
    CABasicAnimation * fillAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    fillAnimation.duration = duration;
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
    [self.layer addSublayer:[self yAxisLineShapeLayer]];
    
    //延迟0.5秒执行
    self.timer = [NSTimer timerWithTimeInterval:_animationDuration target:self selector:@selector(timerAction:) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
}

#pragma mark - 定时器

- (void)timerAction:(NSTimer *)sender{
    [self.layer addSublayer:[self arrowsShapeLayer]];
    
    [sender invalidate];
    sender = nil;
}

#pragma mark - 重写setter,getter方法

/**
 *  计算y轴分段高度的平均值
 */
- (CGFloat)yLineSectionHeightAverage{
    return ((_yLineHeight - ZFAxisLineGapFromYLineMaxValueToArrow) / _yLineSectionCount);
}

@end
