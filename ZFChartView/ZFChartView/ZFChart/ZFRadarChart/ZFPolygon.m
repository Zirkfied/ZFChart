//
//  ZFPolygon.m
//  ZFChartView
//
//  Created by apple on 16/9/21.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ZFPolygon.h"
#import "ZFConst.h"

@interface ZFPolygon()

/** 动画时间 */
@property (nonatomic, assign) CGFloat animationDuration;
/** 多边形中心点 */
@property (nonatomic, assign) CGPoint polygonCenter;
/** 雷达中点当前角度 */
@property (nonatomic, assign) CGFloat currentRadarAngle;
/** 雷达角点终点xPos */
@property (nonatomic, assign) CGFloat endXPos;
/** 雷达角点终点yPos */
@property (nonatomic, assign) CGFloat endYPos;
/** 雷达开始角度 */
@property (nonatomic, assign) CGFloat startAngle;
/** 雷达结束角度 */
@property (nonatomic, assign) CGFloat endAngle;
/** 获取当前item半径 */
@property (nonatomic, assign) CGFloat currentRadius;
/** 存储每个item半径的数组 */
@property (nonatomic, strong) NSMutableArray<NSNumber *> * radiusArray;
/** 存储item point的数组 */
@property (nonatomic, strong) NSMutableArray * pointArray;

@end

@implementation ZFPolygon

/**
 *  初始化变量
 */
- (void)commonInit{
    _animationDuration = 0.5f;
    _startAngle = -90.f;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

/**
 *  未填充bezierPath
 *
 *  @return UIBezierPath
 */
- (UIBezierPath *)noFill{
    UIBezierPath * bezier = [UIBezierPath bezierPath];
    for (NSInteger i = 0; i < _radiusArray.count; i++) {
        i == 0 ? [bezier moveToPoint:_polygonCenter] : [bezier addLineToPoint:_polygonCenter];
    }

    [bezier closePath];
    return bezier;
}

/**
 *  填充bezierPath
 *
 *  @return UIBezierPath
 */
- (UIBezierPath *)fill{
    _startAngle = -90.f;
    //获取第一个item半径
    _currentRadius = [_radiusArray.firstObject floatValue];
    UIBezierPath * bezier = [UIBezierPath bezierPath];
    [bezier moveToPoint:CGPointMake(_polygonCenter.x, _polygonCenter.y - _currentRadius)];
    //存储多边形开始的棱角point
    [self.pointArray addObject:[NSValue valueWithCGPoint:CGPointMake(_polygonCenter.x, _polygonCenter.y - _currentRadius)]];
    
    for (NSInteger i = 1; i < _radiusArray.count; i++) {
        _currentRadarAngle = _averageRadarAngle * i;
        //计算每个item的角度
        _endAngle = _startAngle + _averageRadarAngle;
        //获取当前item半径
        _currentRadius = [_radiusArray[i] floatValue];
        
        if (_endAngle > -90.f && _endAngle <= 0.f) {
            _endXPos = _polygonCenter.x + fabs(-(_currentRadius * ZFSin(_currentRadarAngle)));
            _endYPos = _polygonCenter.y - fabs(_currentRadius * ZFCos(_currentRadarAngle));
            
        }else if (_endAngle > 0.f && _endAngle <= 90.f){
            _endXPos = _polygonCenter.x + fabs(-(_currentRadius * ZFSin(_currentRadarAngle)));
            _endYPos = _polygonCenter.y + fabs(_currentRadius * ZFCos(_currentRadarAngle));
            
        }else if (_endAngle > 90.f && _endAngle <= 180.f){
            _endXPos = _polygonCenter.x - fabs(-(_currentRadius * ZFSin(_currentRadarAngle)));
            _endYPos = _polygonCenter.y + fabs(_currentRadius * ZFCos(_currentRadarAngle));
            
        }else if (_endAngle > 180.f && _endAngle < 270.f){
            _endXPos = _polygonCenter.x - fabs(-(_currentRadius * ZFSin(_currentRadarAngle)));
            _endYPos = _polygonCenter.y - fabs(_currentRadius * ZFCos(_currentRadarAngle));
        }

        [bezier addLineToPoint:CGPointMake(_endXPos, _endYPos)];
        //记录下一个item开始角度
        _startAngle = _endAngle;
        
        //存储多边形各棱角的point,用于画圆点
        [self.pointArray addObject:[NSValue valueWithCGPoint:CGPointMake(_endXPos, _endYPos)]];
    }
    [bezier closePath];
    return bezier;
}

/**
 *  多边形ShapeLayer
 *
 *  @return CAShapeLayer
 */
- (CAShapeLayer *)polygonFillShapelayer{
    CAShapeLayer * shapeLayer = [CAShapeLayer layer];
    shapeLayer.fillColor = _polygonColor.CGColor;
    shapeLayer.opacity = _opacity;
    shapeLayer.path = [self fill].CGPath;
    
    if (_isAnimated) {
        CABasicAnimation * animation = [self animation];
        [shapeLayer addAnimation:animation forKey:nil];
    }
    
    return shapeLayer;
}

#pragma mark - 多边形边线

/**
 *  多边形边线ShapeLayer
 *
 *  @return CAShapeLayer
 */
- (CAShapeLayer *)polygonStrokeShapelayer{
    CAShapeLayer * shapeLayer = [CAShapeLayer layer];
    shapeLayer.fillColor = nil;
    shapeLayer.strokeColor = _polygonLineColor.CGColor;
    shapeLayer.lineJoin = kCALineJoinRound;
    shapeLayer.lineWidth = _polygonLineWidth;
    shapeLayer.path = [self fill].CGPath;
    
    if (_isAnimated) {
        CABasicAnimation * animation = [self animation];
        [shapeLayer addAnimation:animation forKey:nil];
    }
    
    return shapeLayer;
}

#pragma mark - item顶点

/**
 *  画item顶点(开始显示的位置)
 *
 *  @return UIBezierPath
 */
- (UIBezierPath *)drawStartPeak:(NSInteger)index{
    UIBezierPath * bezier = [UIBezierPath bezierPathWithArcCenter:_polygonCenter radius:_polygonPeakRadius startAngle:ZFRadian(-90) endAngle:ZFRadian(270) clockwise:YES];
    return bezier;
}

/**
 *  画item顶点(最终显示的位置)
 *
 *  @return UIBezierPath
 */
- (UIBezierPath *)drawEndPeak:(NSInteger)index{
    CGPoint endPoint = [self.pointArray[index] CGPointValue];

    UIBezierPath * bezier = [UIBezierPath bezierPathWithArcCenter:endPoint radius:_polygonPeakRadius startAngle:ZFRadian(-90) endAngle:ZFRadian(270) clockwise:YES];
    return bezier;
}

/**
 *  item顶点ShapeLayer
 *
 *  @return CAShapeLayer
 */
- (CAShapeLayer *)topCircleShapeLayer:(NSInteger)index{
    CAShapeLayer * shapeLayer = [CAShapeLayer layer];
    shapeLayer.fillColor = _polygonPeakColor.CGColor;
    shapeLayer.path = [self drawEndPeak:index].CGPath;
    
    if (_isAnimated) {
        CABasicAnimation * animation = [self polygonPeakAnimation:index];
        [shapeLayer addAnimation:animation forKey:nil];
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
    CABasicAnimation * fillAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    fillAnimation.duration = _animationDuration;
    fillAnimation.fillMode = kCAFillModeForwards;
    fillAnimation.removedOnCompletion = NO;
    fillAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    fillAnimation.fromValue = (__bridge id)[self noFill].CGPath;
    fillAnimation.toValue = (__bridge id)[self fill].CGPath;
    
    return fillAnimation;
}

/**
 *  顶点动画
 */
- (CABasicAnimation *)polygonPeakAnimation:(NSInteger)i{
    CABasicAnimation * fillAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    fillAnimation.duration = _animationDuration;
    fillAnimation.fillMode = kCAFillModeForwards;
    fillAnimation.removedOnCompletion = NO;
    fillAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    fillAnimation.fromValue = (__bridge id)[self drawStartPeak:i].CGPath;
    fillAnimation.toValue = (__bridge id)[self drawEndPeak:i].CGPath;
    
    return fillAnimation;
}

#pragma mark - 清除控件

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
    [self.pointArray removeAllObjects];
    [self removeAllSubLayers];
    [self.layer addSublayer:[self polygonFillShapelayer]];
    _isShowPolygonLine ? [self.layer addSublayer:[self polygonStrokeShapelayer]] : nil;
    
    if (_isShowPolygonPeak) {
        for (NSInteger i = 0; i < self.pointArray.count; i++) {
            [self.layer addSublayer:[self topCircleShapeLayer:i]];
        }
    }
}

#pragma mark - 重写setter, getter方法

- (void)setMaxRadius:(CGFloat)maxRadius{
    _maxRadius = maxRadius;
    _polygonCenter = CGPointMake(_maxRadius, _maxRadius);
}

- (void)setValueArray:(NSMutableArray *)valueArray{
    _valueArray = valueArray;
    
    //计算每个item的半径
    for (NSInteger i = 0; i < _valueArray.count; i++) {
        CGFloat percent = ([_valueArray[i] floatValue] - _minValue) / (_maxValue - _minValue);
        CGFloat currentRadius = _maxRadius * percent;
        
        [self.radiusArray addObject:@(currentRadius)];
    }
}

#pragma mark - 懒加载

- (NSMutableArray *)pointArray{
    if (!_pointArray) {
        _pointArray = [NSMutableArray array];
    }
    return _pointArray;
}

- (NSMutableArray<NSNumber *> *)radiusArray{
    if (!_radiusArray) {
        _radiusArray = [NSMutableArray array];
    }
    return _radiusArray;
}

@end
