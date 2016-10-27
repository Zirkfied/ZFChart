//
//  ZFYAxisLine.m
//  ZFChartView
//
//  Created by apple on 16/3/14.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ZFYAxisLine.h"

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
/** 记录原来y轴终点y值 (用于横竖屏适配) */
@property (nonatomic, assign) CGFloat originYLineEndYPos;
/** 记录坐标轴方向 */
@property (nonatomic, assign) kAxisDirection direction;

@end

@implementation ZFYAxisLine

/**
 *  初始化默认变量
 */
- (void)commonInit{
    _yLineStartXPos = ZFAxisLineStartXPos;
    _yLineStartYPos = _direction == kAxisDirectionVertical ? self.frame.size.height * ZFAxisLineVerticalEndRatio : self.frame.size.height * ZFAxisLineHorizontalEndRatio;
    _yLineEndXPos = ZFAxisLineStartXPos;
    _yLineEndYPos = self.frame.size.height * ZFAxisLineStartRatio < TOPIC_HEIGHT + 20 ? TOPIC_HEIGHT + 20 : self.frame.size.height * ZFAxisLineStartRatio;
    
    _yLineWidth = 1.f;
    _yLineHeight = _yLineStartYPos - _yLineEndYPos;
    
    _animationDuration = 0.5f;
    _arrowsWidth = 10.f;
    _arrowsWidthHalf = _arrowsWidth / 2.f;
    _lineWidthHalf = _yLineWidth / 2.f;
    _sectionLength = ZFAxisLineSectionLength;
}

- (void)setUp{
    _axisColor = ZFBlack;
}

- (instancetype)initWithFrame:(CGRect)frame direction:(kAxisDirection)direction{
    self = [super initWithFrame:frame];
    if (self) {
        _direction = direction;
        [self commonInit];
        [self setUp];
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
    return bezier;
}

/**
 *  画y轴
 *
 *  @return UIBezierPath
 */
- (UIBezierPath *)drawYAxisLine{
    UIBezierPath * bezier = [UIBezierPath bezierPathWithRect:CGRectMake(_yLineEndXPos, _yLineEndYPos, _yLineWidth, _yLineHeight)];
    return bezier;
}

/**
 *  y轴shapeLayer
 *
 *  @return CAShapeLayer
 */
- (CAShapeLayer *)yAxisLineShapeLayer{
    CAShapeLayer * yAxisLineLayer = [CAShapeLayer layer];
    yAxisLineLayer.fillColor = _axisColor.CGColor;
    yAxisLineLayer.path = [self drawYAxisLine].CGPath;
    
    if (_isAnimated) {
        CABasicAnimation * animation = [self animationFromValue:[self axisLineNoFill] toValue:[self drawYAxisLine] duration:_animationDuration];
        [yAxisLineLayer addAnimation:animation forKey:nil];
    }
    
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
    
    return bezier;
}

/**
 *  箭头CAShapeLayer
 *
 *  @return CAShapeLayer
 */
- (CAShapeLayer *)arrowsShapeLayer{
    CAShapeLayer * arrowsLayer = [CAShapeLayer layer];
    arrowsLayer.fillColor = _axisColor.CGColor;
    arrowsLayer.path = [self drawArrows].CGPath;
    
    if (_isAnimated) {
        CABasicAnimation * animation = [self animationFromValue:[self arrowsNoFill] toValue:[self drawArrows] duration:_animationDuration];
        [arrowsLayer addAnimation:animation forKey:nil];
    }
    
    return arrowsLayer;
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
    fillAnimation.fromValue = (__bridge id)(fromValue.CGPath);
    fillAnimation.toValue = (__bridge id)(toValue.CGPath);
    
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
    
    //有动画时,延迟0.5秒执行
    if (_isAnimated) {
        self.timer = [NSTimer timerWithTimeInterval:_animationDuration target:self selector:@selector(timerAction:) userInfo:nil repeats:NO];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    }else{//无动画
        _isShowAxisArrows ? [self.layer addSublayer:[self arrowsShapeLayer]] : nil;
    }
}

#pragma mark - 定时器

- (void)timerAction:(NSTimer *)sender{
    _isShowAxisArrows ? [self.layer addSublayer:[self arrowsShapeLayer]] : nil;
    
    [sender invalidate];
    sender = nil;
}

#pragma mark - 重写setter,getter方法

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [self commonInit];
}

- (void)setYLineHeight:(CGFloat)yLineHeight{
    if (yLineHeight > _yLineStartYPos - _yLineEndYPos) {
        _originYLineEndYPos = _yLineEndYPos;
        //底部高度(x轴到底部的高度)
        CGFloat bottomHeight = self.frame.size.height - _yLineStartYPos;
        //计算self的新高度
        CGFloat height = (self.frame.size.height - _yLineStartYPos) + yLineHeight + _yLineEndYPos;
        //重设self的frame
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, height);
        //计算y轴新的StartYPos
        _yLineStartYPos = self.frame.size.height - bottomHeight;
        _yLineEndYPos = _originYLineEndYPos;
        _yLineHeight = yLineHeight;
    }
}

/**
 *  计算y轴分段高度的平均值
 */
- (CGFloat)yLineSectionHeightAverage{
    return ((_yLineHeight - ZFAxisLineGapFromAxisLineMaxValueToArrow) / _yLineSectionCount);
}

/**
 *  y轴箭头顶点yPos
 */
- (CGFloat)yLineArrowTopYPos{
    return _yLineEndYPos - _arrowsWidthHalf * ZFTan(60);
}

@end
