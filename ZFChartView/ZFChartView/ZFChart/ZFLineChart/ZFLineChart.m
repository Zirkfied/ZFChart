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
#import "NSString+Zirkfied.h"
#import "ZFMethod.h"

@interface ZFLineChart()

/** 通用坐标轴图表 */
@property (nonatomic, strong) ZFGenericAxis * genericAxis;
/** 存储圆的数组 */
@property (nonatomic, strong) NSMutableArray * circleArray;
/** 存储popoverLaber数组 */
@property (nonatomic, strong) NSMutableArray * popoverLaberArray;
/** 颜色数组 */
@property (nonatomic, strong) NSMutableArray * colorArray;
/** 存储每条线value位置的数组 */
@property (nonatomic, strong) NSMutableArray * valuePositionArray;
/** 半径 */
@property (nonatomic, assign) CGFloat radius;
/** 线宽 */
@property (nonatomic, assign) CGFloat lineWidth;

@end

@implementation ZFLineChart

/**
 *  初始化变量
 */
- (void)commonInit{
    [super commonInit];
    
    _valueCenterToCircleCenterPadding = 25.f;
    _isShadow = YES;
    _overMaxValueCircleColor = ZFRed;
    _lineWidth = 2.f;
    _linePatternType = kLinePatternTypeForSharp;
    self.shadowColor = ZFLightGray;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
        [self drawGenericChart];
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
            CGFloat percent = ([self.genericAxis.xLineValueArray[i] floatValue] - self.genericAxis.yLineMinValue) / (self.genericAxis.yLineMaxValue - self.genericAxis.yLineMinValue);
            if (percent > 1) {
                percent = 1.f;
                isOverrun = YES;
            }
            
            CGFloat height = self.genericAxis.yLineMaxValueHeight * percent;
            CGFloat center_xPos = self.genericAxis.axisStartXPos + self.genericAxis.groupPadding + (self.genericAxis.groupWidth + self.genericAxis.groupPadding) * i + self.genericAxis.groupWidth * 0.5;
            CGFloat center_yPos = self.genericAxis.axisStartYPos - height;
            
            ZFCircle * circle = [[ZFCircle alloc] initWithFrame:CGRectMake(0, 0, _radius * 2, _radius * 2)];
            circle.lineIndex = 0;
            circle.circleIndex = i;
            circle.center = CGPointMake(center_xPos, center_yPos);
            circle.isOverrun = isOverrun;
            circle.circleColor = isOverrun ? _overMaxValueCircleColor : _colorArray.firstObject;
            circle.isShadow = _isShadow;
            circle.isAnimated = self.isAnimated;
            circle.shadowColor = self.shadowColor;
            circle.opacity = self.opacity;
            [circle strokePath];
            [self.genericAxis addSubview:circle];
            [self.circleArray addObject:circle];
            
            [circle addTarget:self action:@selector(circleAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        
    }else if ([subObject isKindOfClass:[NSArray class]]){
        if ([[subObject firstObject] isKindOfClass:[NSString class]]) {
            //第几条线
            for (NSInteger lineIndex = 0; lineIndex < self.genericAxis.xLineValueArray.count; lineIndex++) {
                NSMutableArray * subArray = [NSMutableArray array];
                //第几个圆
                for (NSInteger circleIndex = 0; circleIndex < [subObject count]; circleIndex++) {
                    BOOL isOverrun = NO;//记录是否超出上限
                    CGFloat percent = ([self.genericAxis.xLineValueArray[lineIndex][circleIndex] floatValue] - self.genericAxis.yLineMinValue) / (self.genericAxis.yLineMaxValue - self.genericAxis.yLineMinValue);
                    if (percent > 1) {
                        percent = 1.f;
                        isOverrun = YES;
                    }
                    
                    CGFloat height = self.genericAxis.yLineMaxValueHeight * percent;
                    CGFloat center_xPos = self.genericAxis.axisStartXPos + self.genericAxis.groupPadding + (self.genericAxis.groupWidth + self.genericAxis.groupPadding) * circleIndex + self.genericAxis.groupWidth * 0.5;
                    CGFloat center_yPos = self.genericAxis.axisStartYPos - height;
                    
                    ZFCircle * circle = [[ZFCircle alloc] initWithFrame:CGRectMake(0, 0, _radius * 2, _radius * 2)];
                    circle.lineIndex = lineIndex;
                    circle.circleIndex = circleIndex;
                    circle.center = CGPointMake(center_xPos, center_yPos);
                    circle.isOverrun = isOverrun;
                    circle.circleColor = isOverrun ? _overMaxValueCircleColor : _colorArray[lineIndex];
                    circle.isShadow = _isShadow;
                    circle.isAnimated = self.isAnimated;
                    circle.shadowColor = self.shadowColor;
                    circle.opacity = self.opacity;
                    [circle strokePath];
                    [self.genericAxis addSubview:circle];
                    [subArray addObject:circle];
                    
                    [circle addTarget:self action:@selector(circleAction:) forControlEvents:UIControlEventTouchUpInside];
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
            [self addValueLabel:self.circleArray index:i colorIndex:0 valueArray:self.genericAxis.xLineValueArray valuePosition:(kChartValuePosition)[self.valuePositionArray.firstObject integerValue]];
            
        }
        
    }else if ([subObject isKindOfClass:[NSArray class]]){
        for (NSInteger i = 0; i < self.circleArray.count; i++) {
            NSMutableArray * subArray = self.circleArray[i];
            for (NSInteger j = 0; j < subArray.count; j++) {
                [self addValueLabel:subArray index:j colorIndex:i valueArray:self.genericAxis.xLineValueArray[i] valuePosition:(kChartValuePosition)[self.valuePositionArray[i] integerValue]];
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
- (void)addValueLabel:(NSMutableArray *)circleArray index:(NSInteger)index colorIndex:(NSInteger)colorIndex valueArray:(NSMutableArray *)valueArray valuePosition:(kChartValuePosition)valuePosition{
    //当前的圆
    ZFCircle * circle = circleArray[index];
    
    CGRect rect = [valueArray[index] stringWidthRectWithSize:CGSizeMake(45, 30) font:self.valueOnChartFont];
    ZFPopoverLabel * popoverLabel = [[ZFPopoverLabel alloc] initWithFrame:CGRectMake(0, 0, rect.size.width + 10, rect.size.height + 10) direction:kAxisDirectionVertical];
    popoverLabel.text = valueArray[index];
    popoverLabel.font = self.valueOnChartFont;
    popoverLabel.textColor = _colorArray[colorIndex];
    popoverLabel.pattern = self.valueLabelPattern;
    popoverLabel.isShadow = self.isShadowForValueLabel;
    popoverLabel.isAnimated = self.isAnimated;
    popoverLabel.groupIndex = colorIndex;
    popoverLabel.labelIndex = index;
    popoverLabel.shadowColor = self.valueLabelShadowColor;
    popoverLabel.hidden = self.isShowAxisLineValue ? NO : YES;
    [self.genericAxis addSubview:popoverLabel];
    [self.popoverLaberArray addObject:popoverLabel];
    [popoverLabel addTarget:self action:@selector(popoverAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //_valueOnChartPosition为上下分布
    if (valuePosition == kChartValuePositionDefalut) {
        //根据end_YPos判断label显示在圆环上面或下面
        CGFloat end_YPos;
        
        if (index == 0) {//当前圆环是第一个时
            end_YPos = circle.center.y;
            
        }else{//当前圆环不是第一个时
            ZFCircle * preCirque = circleArray[index-1];
            end_YPos = preCirque.center.y - circle.center.y;
        }
        
        //根据end_YPos，设置popoverLabel的上下位置
        if (end_YPos < 0) {
            popoverLabel.arrowsOrientation = kPopoverLaberArrowsOrientationOnTop;
            popoverLabel.center = CGPointMake(circle.center.x, circle.center.y + _valueCenterToCircleCenterPadding);
        }else{
            popoverLabel.arrowsOrientation = kPopoverLaberArrowsOrientationOnBelow;
            popoverLabel.center = CGPointMake(circle.center.x, circle.center.y - _valueCenterToCircleCenterPadding);
        }
        
    //_valueOnChartPosition为圆环上方
    }else if (valuePosition == kChartValuePositionOnTop){
        popoverLabel.arrowsOrientation = kPopoverLaberArrowsOrientationOnBelow;
        popoverLabel.center = CGPointMake(circle.center.x, circle.center.y - _valueCenterToCircleCenterPadding);
        
    //_valueOnChartPosition为圆环下方
    }else if (valuePosition == kChartValuePositionOnBelow){
        popoverLabel.arrowsOrientation = kPopoverLaberArrowsOrientationOnTop;
        popoverLabel.center = CGPointMake(circle.center.x, circle.center.y + _valueCenterToCircleCenterPadding);
    }
    
    [popoverLabel strokePath];
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
    ZFLine * layer = [ZFLine lineWithCircleArray:array isAnimated:self.isAnimated shadowColor:self.shadowColor linePatternType:_linePatternType padding:self.genericAxis.groupPadding];
    layer.strokeColor = [_colorArray[index] CGColor];
    layer.lineWidth = _lineWidth;
    layer.isShadow = _isShadow;
    layer.opacity = self.opacity;
    
    return layer;
}

#pragma mark - circle点击事件

/**
 *  circle点击事件
 *
 *  @param sender bar
 */
- (void)circleAction:(ZFCircle *)sender{
    if ([self.delegate respondsToSelector:@selector(lineChart:didSelectCircleAtLineIndex:circleIndex:circle:popoverLabel:)]) {
        
        ZFPopoverLabel * popoverLabel = nil;
        id subObject = self.genericAxis.xLineValueArray.firstObject;
        if ([subObject isKindOfClass:[NSString class]]) {
            popoverLabel = self.popoverLaberArray[sender.circleIndex];
        }else if ([subObject isKindOfClass:[NSArray class]]){
            popoverLabel = self.popoverLaberArray[sender.lineIndex * [subObject count] + sender.circleIndex];
        }
        
        [self.delegate lineChart:self didSelectCircleAtLineIndex:sender.lineIndex circleIndex:sender.circleIndex circle:sender popoverLabel:popoverLabel];
        
        [self resetCircle:sender popoverLabel:popoverLabel];
    }
}

/**
 *  popoverLaber点击事件
 *
 *  @param sender popoverLabel
 */
- (void)popoverAction:(ZFPopoverLabel *)sender{
    if ([self.delegate respondsToSelector:@selector(lineChart:didSelectPopoverLabelAtLineIndex:circleIndex:popoverLabel:)]) {
        [self.delegate lineChart:self didSelectPopoverLabelAtLineIndex:sender.groupIndex circleIndex:sender.labelIndex popoverLabel:sender];
        
        [self resetPopoverLabel:sender];
    }
}

#pragma mark - 重置Circle原始设置

- (void)resetCircle:(ZFCircle *)sender popoverLabel:(ZFPopoverLabel *)label{
    //判断数组
    NSArray * tempArray = nil;
    id subObject = self.circleArray.firstObject;
    if ([subObject isKindOfClass:[ZFCircle class]]) {
        tempArray = [NSMutableArray arrayWithArray:self.circleArray];
    }else if ([subObject isKindOfClass:[NSArray class]]){
        tempArray = [NSMutableArray arrayWithArray:(NSArray *)self.circleArray[sender.lineIndex]];
    }
    
    for (ZFCircle * circle in tempArray) {
        if (circle != sender) {
            circle.circleColor = circle.isOverrun ? _overMaxValueCircleColor : _colorArray[circle.lineIndex];
            circle.isAnimated = NO;
            circle.opacity = self.opacity;
            [circle strokePath];
            //复原
            circle.isAnimated = self.isAnimated;
        }
    }
    
    if (!self.isShowAxisLineValue) {
        for (ZFPopoverLabel * popoverLabel in self.popoverLaberArray) {
            if (popoverLabel != label) {
                popoverLabel.hidden = YES;
            }
        }
    }
}

#pragma mark - 重置PopoverLabel原始设置

- (void)resetPopoverLabel:(ZFPopoverLabel *)sender{
    for (ZFPopoverLabel * popoverLabel in self.popoverLaberArray) {
        if (popoverLabel != sender) {
            popoverLabel.font = self.valueOnChartFont;
            popoverLabel.textColor = (UIColor *)self.colorArray[popoverLabel.groupIndex];
            popoverLabel.isAnimated = sender.isAnimated;
            [popoverLabel strokePath];
        }
    }
}

#pragma mark - 清除控件

/**
 *  清除之前所有圆
 */
- (void)removeAllCircle{
    [self.circleArray removeAllObjects];
    NSArray * subviews = [NSArray arrayWithArray:self.genericAxis.subviews];
    for (UIView * view in subviews) {
        if ([view isKindOfClass:[ZFCircle class]]) {
            [(ZFCircle *)view removeFromSuperview];
        }
    }
}

/**
 *  清除柱状条上的Label
 */
- (void)removeLabelOnChart{
    [self.popoverLaberArray removeAllObjects];
    NSArray * subviews = [NSArray arrayWithArray:self.genericAxis.subviews];
    for (UIView * view in subviews) {
        if ([view isKindOfClass:[ZFPopoverLabel class]]) {
            [(ZFPopoverLabel *)view removeFromSuperview];
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
        _colorArray = [NSMutableArray arrayWithArray:[[ZFMethod shareInstance] cachedRandomColor:self.genericAxis.xLineValueArray]];
    }
    
    if (self.isResetAxisLineMaxValue) {
        if ([self.dataSource respondsToSelector:@selector(axisLineMaxValueInGenericChart:)]) {
            self.genericAxis.yLineMaxValue = [self.dataSource axisLineMaxValueInGenericChart:self];
        }else{
            NSLog(@"请返回一个最大值");
            return;
        }
    }else{
        self.genericAxis.yLineMaxValue = [[ZFMethod shareInstance] cachedMaxValue:self.genericAxis.xLineValueArray];
        
        if (self.genericAxis.yLineMaxValue == 0.f) {
            if ([self.dataSource respondsToSelector:@selector(axisLineMaxValueInGenericChart:)]) {
                self.genericAxis.yLineMaxValue = [self.dataSource axisLineMaxValueInGenericChart:self];
            }else{
                NSLog(@"当前所有数据的最大值为0, 请返回一个固定最大值, 否则没法绘画图表");
                return;
            }
        }
    }
    
    if (self.isResetAxisLineMinValue) {
        if ([self.dataSource respondsToSelector:@selector(axisLineMinValueInGenericChart:)]) {
            if ([self.dataSource axisLineMinValueInGenericChart:self] > [[ZFMethod shareInstance] cachedMinValue:self.genericAxis.xLineValueArray]) {
                self.genericAxis.yLineMinValue = [[ZFMethod shareInstance] cachedMinValue:self.genericAxis.xLineValueArray];
                
            }else{
                self.genericAxis.yLineMinValue = [self.dataSource axisLineMinValueInGenericChart:self];
            }
            
        }else{
            self.genericAxis.yLineMinValue = [[ZFMethod shareInstance] cachedMinValue:self.genericAxis.xLineValueArray];
        }
    }
    
    if ([self.dataSource respondsToSelector:@selector(axisLineSectionCountInGenericChart:)]) {
        self.genericAxis.yLineSectionCount = [self.dataSource axisLineSectionCountInGenericChart:self];
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
    
    if ([self.delegate respondsToSelector:@selector(valuePositionInLineChart:)]) {
        self.valuePositionArray = [NSMutableArray arrayWithArray:[self.delegate valuePositionInLineChart:self]];
    }else{
        self.valuePositionArray = [NSMutableArray arrayWithArray:[[ZFMethod shareInstance] cachedValuePositionInLineChart:self.genericAxis.xLineValueArray]];
    }
    
    [self removeAllCircle];
    [self removeLabelOnChart];
    [self removeAllSubLayer];
    self.genericAxis.xLineNameLabelToXAxisLinePadding = self.xLineNameLabelToXAxisLinePadding;
    self.genericAxis.isAnimated = self.isAnimated;
    self.genericAxis.isShowAxisArrows = self.isShowAxisArrows;
    self.genericAxis.valueType = self.valueType;
    [self.genericAxis strokePath];
    [self drawCircle];
    [self drawLine];
    [self setValueLabelOnChart];
    
    [self bringCircleToFront];
    [self.genericAxis bringSubviewToFront:self.genericAxis.yAxisLine];
    [self.genericAxis bringSectionToFront];
    [self bringSubviewToFront:self.topicLabel];
}

#pragma mark - 把圆放到最前面

- (void)bringCircleToFront{
    for (UIView * view in self.genericAxis.subviews) {
        if ([view isKindOfClass:[ZFCircle class]]) {
            [self.genericAxis bringSubviewToFront:(ZFCircle *)view];
        }
    }
}

#pragma mark - 重写setter,getter方法

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    self.genericAxis.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
}

- (void)setUnit:(NSString *)unit{
    self.genericAxis.unit = unit;
}

- (void)setUnitColor:(UIColor *)unitColor{
    self.genericAxis.unitColor = unitColor;
}

- (void)setAxisLineNameFont:(UIFont *)axisLineNameFont{
    self.genericAxis.xLineNameFont = axisLineNameFont;
}

- (void)setAxisLineValueFont:(UIFont *)axisLineValueFont{
    self.genericAxis.yLineValueFont = axisLineValueFont;
}

- (void)setAxisLineNameColor:(UIColor *)axisLineNameColor{
    self.genericAxis.xLineNameColor = axisLineNameColor;
}

- (void)setAxisLineValueColor:(UIColor *)axisLineValueColor{
    self.genericAxis.yLineValueColor = axisLineValueColor;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor{
    self.genericAxis.axisLineBackgroundColor = backgroundColor;;
}

- (void)setXAxisColor:(UIColor *)xAxisColor{
    self.genericAxis.xAxisColor = xAxisColor;
}

- (void)setYAxisColor:(UIColor *)yAxisColor{
    self.genericAxis.yAxisColor = yAxisColor;
}

- (void)setSeparateColor:(UIColor *)separateColor{
    self.genericAxis.separateColor = separateColor;
}

- (void)setIsShowXLineSeparate:(BOOL)isShowXLineSeparate{
    self.genericAxis.isShowXLineSeparate = isShowXLineSeparate;
}

- (void)setIsShowYLineSeparate:(BOOL)isShowYLineSeparate{
    self.genericAxis.isShowYLineSeparate = isShowYLineSeparate;
}

#pragma mark - 懒加载

- (NSMutableArray *)circleArray{
    if (!_circleArray) {
        _circleArray = [NSMutableArray array];
    }
    return _circleArray;
}

- (NSMutableArray *)popoverLaberArray{
    if (!_popoverLaberArray) {
        _popoverLaberArray = [NSMutableArray array];
    }
    return _popoverLaberArray;
}

@end
