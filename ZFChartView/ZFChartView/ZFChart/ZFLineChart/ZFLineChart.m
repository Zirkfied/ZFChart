//
//  ZFLineChart.m
//  ZFChartView
//
//  Created by apple on 16/3/18.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ZFLineChart.h"
#import "ZFCircle.h"
#import "ZFGenericAxis.h"
#import "ZFConst.h"
#import "ZFLabel.h"
#import "ZFLine.h"
#import "NSString+Zirkfied.h"
#import "ZFMethod.h"

@interface ZFLineChart()

/** 通用坐标轴图表 */
@property (nonatomic, strong) ZFGenericAxis * genericAxis;
/** 主题Label */
@property (nonatomic, strong) UILabel * topicLabel;
/** 存储圆的数组 */
@property (nonatomic, strong) NSMutableArray * circleArray;
/** 颜色数组 */
@property (nonatomic, strong) NSMutableArray * colorArray;
/** 半径 */
@property (nonatomic, assign) CGFloat radius;
/** 线宽 */
@property (nonatomic, assign) CGFloat lineWidth;

@end

@implementation ZFLineChart

- (NSMutableArray *)circleArray{
    if (!_circleArray) {
        _circleArray = [NSMutableArray array];
    }
    return _circleArray;
}

- (void)commonInit{
    _valueOnChartFontSize = 10.f;
    _valueCenterToCircleCenterPadding = 25.f;
    _valuePosition = kLineChartValuePositionDefalut;
    _isShadow = YES;
    _overMaxValueCircleColor = ZFRed;
    _lineWidth = 2.f;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
        [self drawGenericChart];
        
        //标题Label
        self.topicLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 30)];
        self.topicLabel.font = [UIFont boldSystemFontOfSize:18.f];
        self.topicLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.topicLabel];
    }
    
    return self;
}

#pragma mark - 坐标轴

/**
 *  画坐标轴
 */
- (void)drawGenericChart{
    self.genericAxis = [[ZFGenericAxis alloc] initWithFrame:self.bounds];
    [self addSubview:self.genericAxis];
}

#pragma mark - 画圆

/**
 *  画圆
 */
- (void)drawCircle{
    id subObject = self.genericAxis.xLineValueArray.firstObject;
    if ([subObject isKindOfClass:[NSString class]]) {
        for (NSInteger i = 0; i < self.genericAxis.xLineValueArray.count; i++) {
            BOOL isOverrun = NO;//记录是否超出上限
            CGFloat percent = [self.genericAxis.xLineValueArray[i] floatValue] / self.genericAxis.yLineMaxValue;
            if (percent > 1) {
                percent = 1.f;
                isOverrun = YES;
            }
            
            CGFloat height = self.genericAxis.yLineMaxValueHeight * percent;
            CGFloat center_xPos = self.genericAxis.axisStartXPos + self.genericAxis.groupPadding + (self.genericAxis.groupWidth + self.genericAxis.groupPadding) * i + self.genericAxis.groupWidth * 0.5;
            CGFloat center_yPos = self.genericAxis.axisStartYPos - height;
            
            ZFCircle * circle = [[ZFCircle alloc] initWithFrame:CGRectMake(0, 0, _radius * 2, _radius * 2)];
            circle.center = CGPointMake(center_xPos, center_yPos);
            circle.circleColor = isOverrun ? _overMaxValueCircleColor : _colorArray.firstObject;
            circle.isShadow = _isShadow;
            [circle strokePath];
            [self.genericAxis addSubview:circle];
            [self.circleArray addObject:circle];
        }
        
    }else if ([subObject isKindOfClass:[NSArray class]]){
        if ([[subObject firstObject] isKindOfClass:[NSString class]]) {
            //第几条线
            for (NSInteger lineIndex = 0; lineIndex < self.genericAxis.xLineValueArray.count; lineIndex++) {
                NSMutableArray * subArray = [NSMutableArray array];
                //第几个圆
                for (NSInteger circleIndex = 0; circleIndex < [subObject count]; circleIndex++) {
                    BOOL isOverrun = NO;//记录是否超出上限
                    CGFloat percent = [self.genericAxis.xLineValueArray[lineIndex][circleIndex] floatValue] / self.genericAxis.yLineMaxValue;
                    if (percent > 1) {
                        percent = 1.f;
                        isOverrun = YES;
                    }
                    
                    CGFloat height = self.genericAxis.yLineMaxValueHeight * percent;
                    CGFloat center_xPos = self.genericAxis.axisStartXPos + self.genericAxis.groupPadding + (self.genericAxis.groupWidth + self.genericAxis.groupPadding) * circleIndex + self.genericAxis.groupWidth * 0.5;
                    CGFloat center_yPos = self.genericAxis.axisStartYPos - height;
                    
                    ZFCircle * circle = [[ZFCircle alloc] initWithFrame:CGRectMake(0, 0, _radius * 2, _radius * 2)];
                    circle.center = CGPointMake(center_xPos, center_yPos);
                    circle.circleColor = isOverrun ? _overMaxValueCircleColor : _colorArray[lineIndex];
                    circle.isShadow = _isShadow;
                    [circle strokePath];
                    [self.genericAxis addSubview:circle];
                    [subArray addObject:circle];
                }
                [self.circleArray addObject:subArray];
            }
        }
    }
}

/**
 *  设置x轴valueLabel
 */
- (void)setValueLabelOnChart{
    id subObject = self.circleArray.firstObject;
    if ([subObject isKindOfClass:[ZFCircle class]]) {
        for (NSInteger i = 0; i < self.circleArray.count; i++) {
            [self addValueLabel:self.circleArray index:i colorIndex:0 valueArray:self.genericAxis.xLineValueArray];
        }
        
    }else if ([subObject isKindOfClass:[NSArray class]]){
        for (NSInteger i = 0; i < self.circleArray.count; i++) {
            NSMutableArray * subArray = self.circleArray[i];
            for (NSInteger j = 0; j < subArray.count; j++) {
                [self addValueLabel:subArray index:j colorIndex:i valueArray:self.genericAxis.xLineValueArray[i]];
            }
        }
    }
}

/**
 *  创建valueLabel
 *
 *  @param circleArray 当前线段存储圆的数组
 *  @param index       圆在数组的下标
 *  @param colorIndex  颜色下标
 *  @param valueArray  当前线段的value数组
 */
- (void)addValueLabel:(NSMutableArray *)circleArray index:(NSInteger)index colorIndex:(NSInteger)colorIndex valueArray:(NSMutableArray *)valueArray{
    ZFCircle * cirque = circleArray[index];
    //label的中心点
    CGPoint label_center = CGPointMake(0, 0);
    
    //_valueOnChartPosition为上下分布
    if (_valuePosition == kLineChartValuePositionDefalut) {
        //根据end_YPos判断label显示在圆环上面或下面
        CGFloat end_YPos;
        
        if (index < circleArray.count - 1) {//当前圆环不是最后一个时
            ZFCircle * nextCirque = circleArray[index+1];
            end_YPos = nextCirque.center.y - cirque.center.y;
            
        }else{//当前圆环为最后一个时
            ZFCircle * preCirque = circleArray[index-1];
            end_YPos = preCirque.center.y - cirque.center.y;
            
        }
        
        label_center = end_YPos <= 0 ? CGPointMake(cirque.center.x, cirque.center.y + _valueCenterToCircleCenterPadding) : CGPointMake(cirque.center.x, cirque.center.y - _valueCenterToCircleCenterPadding);
        
        //_valueOnChartPosition为圆环上方
    }else if (_valuePosition == kLineChartValuePositionOnTop){
        label_center = CGPointMake(cirque.center.x, cirque.center.y - _valueCenterToCircleCenterPadding);
        
        //_valueOnChartPosition为圆环下方
    }else if (_valuePosition == kLineChartValuePositionOnBelow){
        label_center = CGPointMake(cirque.center.x, cirque.center.y + _valueCenterToCircleCenterPadding);
        
    }
    
    CGRect rect = [valueArray[index] stringWidthRectWithSize:CGSizeMake(45, 30) fontOfSize:_valueOnChartFontSize isBold:NO];
    ZFLabel * label = [[ZFLabel alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    label.text = valueArray[index];
    label.font = [UIFont systemFontOfSize:_valueOnChartFontSize];
    label.center = label_center;
    label.numberOfLines = 0;
    label.textColor = _colorArray[colorIndex];
    label.isFadeInAnimation = YES;
    [self.genericAxis addSubview:label];
}

#pragma mark - 画线

/**
 *  画线
 */
- (void)drawLine{
    id subObject = self.circleArray.firstObject;
    if ([subObject isKindOfClass:[ZFCircle class]]) {
        [self.genericAxis.layer addSublayer:[self lineShapeLayer:self.circleArray index:0]];
    }else if ([subObject isKindOfClass:[NSArray class]]){
        for (NSInteger i = 0; i < self.circleArray.count; i++) {
            [self.genericAxis.layer addSublayer:[self lineShapeLayer:(NSMutableArray *)self.circleArray[i] index:i]];
        }
    }
}

/**
 *  线shapeLayer
 *
 *  @return CAShapeLayer
 */
- (CAShapeLayer *)lineShapeLayer:(NSMutableArray *)array index:(NSInteger)index{
    ZFLine * layer = [ZFLine lineWithCircleArray:array];
    layer.strokeColor = [_colorArray[index] CGColor];
    layer.lineWidth = _lineWidth;
    layer.isShadow = _isShadow;
    
    return layer;
}

/**
 *  清除之前所有圆
 */
- (void)removeAllCircle{
    [self.circleArray removeAllObjects];
    for (UIView * view in self.genericAxis.subviews) {
        if ([view isKindOfClass:[ZFCircle class]]) {
            [(ZFCircle *)view removeFromSuperview];
        }
    }
}

/**
 *  清除柱状条上的Label
 */
- (void)removeLabelOnChart{
    for (UIView * view in self.genericAxis.subviews) {
        if ([view isKindOfClass:[ZFLabel class]]) {
            [(ZFLabel *)view removeFromSuperview];
        }
    }
}

/**
 *  清除之前所有line
 */
- (void)removeAllSubLayer{
    NSArray * subLayers = [NSArray arrayWithArray:self.genericAxis.layer.sublayers];
    for (CALayer * layer in subLayers) {
        if ([layer isKindOfClass:[ZFLine class]]) {
            [layer removeAllAnimations];
            [layer removeFromSuperlayer];
        }
    }
}

#pragma mark - public method

/**
 *  重绘
 */
- (void)strokePath{
    if ([self.dataSource respondsToSelector:@selector(valueArrayInGenericChart:)]) {
        self.genericAxis.xLineValueArray = [NSMutableArray arrayWithArray:[self.dataSource valueArrayInGenericChart:self]];
    }
    
    if ([self.dataSource respondsToSelector:@selector(nameArrayInGenericChart:)]) {
        self.genericAxis.xLineNameArray = [NSMutableArray arrayWithArray:[self.dataSource nameArrayInGenericChart:self]];
    }
    
    if ([self.dataSource respondsToSelector:@selector(colorArrayInGenericChart:)]) {
        _colorArray = [NSMutableArray arrayWithArray:[self.dataSource colorArrayInGenericChart:self]];
    }else{
        _colorArray = [NSMutableArray arrayWithArray:[[ZFMethod shareInstance] cachedColor:self.genericAxis.xLineValueArray]];
    }
    
    if ([self.dataSource respondsToSelector:@selector(yLineMaxValueInGenericChart:)]) {
        self.genericAxis.yLineMaxValue = [self.dataSource yLineMaxValueInGenericChart:self];
    }else{
        self.genericAxis.yLineMaxValue = [[ZFMethod shareInstance] cachedYLineMaxValue:self.genericAxis.xLineValueArray];
    }
    
    if ([self.dataSource respondsToSelector:@selector(yLineSectionCountInGenericChart:)]) {
        self.genericAxis.yLineSectionCount = [self.dataSource yLineSectionCountInGenericChart:self];
    }
    
    if ([self.delegate respondsToSelector:@selector(groupWidthInLineChart:)]) {
        self.genericAxis.groupWidth = [self.delegate groupWidthInLineChart:self];
    }
    
    if ([self.delegate respondsToSelector:@selector(paddingForGroupsInLineChart:)]) {
        self.genericAxis.groupPadding = [self.delegate paddingForGroupsInLineChart:self];
    }
    
    if ([self.delegate respondsToSelector:@selector(circleRadiusInLineChart:)]) {
        _radius = [self.delegate circleRadiusInLineChart:self];
    }else{
        _radius = ZFLineChartCircleRadius;
    }
    
    if ([self.delegate respondsToSelector:@selector(lineWidthInLineChart:)]) {
        _lineWidth = [self.delegate lineWidthInLineChart:self];
    }
    
    [self removeAllCircle];
    [self removeLabelOnChart];
    [self removeAllSubLayer];
    [self.genericAxis strokePath];
    [self drawCircle];
    [self drawLine];
    [self setValueLabelOnChart];
    [self.genericAxis bringSubviewToFront:self.genericAxis.yAxisLine];
}

#pragma mark - 重写setter,getter方法

- (void)setTopic:(NSString *)topic{
    _topic = topic;
    self.topicLabel.text = _topic;
}

- (void)setUnit:(NSString *)unit{
    _unit = unit;
    self.genericAxis.unit = _unit;
}

- (void)setTopicColor:(UIColor *)topicColor{
    _topicColor = topicColor;
    self.topicLabel.textColor = _topicColor;
}

- (void)setXLineNameFontSize:(CGFloat)xLineNameFontSize{
    _xLineNameFontSize = xLineNameFontSize;
    self.genericAxis.xLineNameFontSize = _xLineNameFontSize;
}

- (void)setYLineValueFontSize:(CGFloat)yLineValueFontSize{
    _yLineValueFontSize = yLineValueFontSize;
    self.genericAxis.yLineValueFontSize = _yLineValueFontSize;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor{
    _backgroundColor = !backgroundColor ? ZFWhite : backgroundColor;
    self.genericAxis.axisLineBackgroundColor = _backgroundColor;
}

@end
