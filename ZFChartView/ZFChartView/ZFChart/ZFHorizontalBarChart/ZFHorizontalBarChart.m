//
//  ZFHorizontalBarChart.m
//  ZFChartView
//
//  Created by apple on 16/5/31.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ZFHorizontalBarChart.h"
#import "ZFHorizontalAxis.h"
#import "NSString+Zirkfied.h"
#import "ZFMethod.h"

@interface ZFHorizontalBarChart()

/** 横向通用坐标轴图表 */
@property (nonatomic, strong) ZFHorizontalAxis * horizontalAxis;
/** 存储柱状条的数组 */
@property (nonatomic, strong) NSMutableArray * barArray;
/** 颜色数组 */
@property (nonatomic, strong) NSMutableArray * colorArray;
/** 存储popoverLaber数组 */
@property (nonatomic, strong) NSMutableArray * popoverLaberArray;
/** 存储value文本颜色的数组 */
@property (nonatomic, strong) NSMutableArray * valueTextColorArray;
/** 存储bar渐变色的数组 */
@property (nonatomic, strong) NSMutableArray * gradientColorArray;
/** bar高度 */
@property (nonatomic, assign) CGFloat barHeight;
/** bar与bar之间的间距 */
@property (nonatomic, assign) CGFloat barPadding;
/** value文本颜色 */
@property (nonatomic, strong) UIColor * valueTextColor;

@end


@implementation ZFHorizontalBarChart

/**
 *  初始化变量
 */
- (void)commonInit{
    [super commonInit];
    
    _overMaxValueBarColor = ZFRed;
    _isShadow = YES;
    _barHeight = ZFAxisLineItemWidth;
    _barPadding = ZFAxisLinePaddingForBarLength;
    _valueTextColor = ZFBlack;
    _valueLabelToBarPadding = 5.f;
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
    self.horizontalAxis = [[ZFHorizontalAxis alloc] initWithFrame:self.bounds];
    [self addSubview:self.horizontalAxis];
}

#pragma mark - 柱状条

/**
 *  画柱状条
 */
- (void)drawBar:(NSMutableArray *)valueArray{
    id subObject = valueArray.firstObject;
    if ([subObject isKindOfClass:[NSString class]]) {
        for (NSInteger i = 0; i < valueArray.count; i++) {
            CGFloat xPos = self.horizontalAxis.axisStartXPos + self.horizontalAxis.yAxisLine.yLineWidth;
            CGFloat yPos = self.horizontalAxis.axisStartYPos - (self.horizontalAxis.groupPadding + _barHeight) * (i + 1);
            CGFloat width = self.horizontalAxis.xLineMaxValueWidth;
            CGFloat height = _barHeight;
            
            ZFHorizontalBar * bar = [[ZFHorizontalBar alloc] initWithFrame:CGRectMake(xPos, yPos, width, height)];
            bar.groupIndex = 0;
            bar.barIndex = i;
            //当前数值超过y轴显示上限时，柱状改为红色
            if ([self.horizontalAxis.yLineValueArray[i] floatValue] / self.horizontalAxis.xLineMaxValue <= 1) {
                bar.percent = ([self.horizontalAxis.yLineValueArray[i] floatValue] - self.horizontalAxis.xLineMinValue) / (self.horizontalAxis.xLineMaxValue - self.horizontalAxis.xLineMinValue);
                bar.barColor = _colorArray.firstObject;
            }else{
                bar.percent = 1.f;
                bar.barColor = _overMaxValueBarColor;
            }
            bar.isShadow = _isShadow;
            bar.isAnimated = self.isAnimated;
            bar.opacity = self.opacity;
            bar.shadowColor = self.shadowColor;
            bar.gradientAttribute = _gradientColorArray ? _gradientColorArray.firstObject : nil;
            [bar strokePath];
            [self.barArray addObject:bar];
            [self.horizontalAxis addSubview:bar];
            
            [bar addTarget:self action:@selector(barAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        
    }else if ([subObject isKindOfClass:[NSArray class]]){
        if ([[subObject firstObject] isKindOfClass:[NSString class]]) {
            //bar总数
            NSInteger count = [valueArray count] * [subObject count];
            for (NSInteger i = 0; i < count; i++) {
                //每组bar的下标
                NSInteger barIndex = i % [subObject count];
                //组下标
                NSInteger groupIndex = i / [subObject count];
                
                CGFloat xPos = self.horizontalAxis.axisStartXPos + self.horizontalAxis.yAxisLine.yLineWidth;
                CGFloat yPos = self.horizontalAxis.axisStartYPos - self.horizontalAxis.groupPadding * (barIndex + 1) - _barHeight * (groupIndex + 1) - self.horizontalAxis.groupHeight * barIndex - _barPadding * groupIndex;
                CGFloat width = self.horizontalAxis.xLineMaxValueWidth;
                CGFloat height = _barHeight;
                
                ZFHorizontalBar * bar = [[ZFHorizontalBar alloc] initWithFrame:CGRectMake(xPos, yPos, width, height)];
                bar.groupIndex = groupIndex;
                bar.barIndex = barIndex;
                //当前数值超过y轴显示上限时，柱状改为红色
                if ([valueArray[groupIndex][barIndex] floatValue] / self.horizontalAxis.xLineMaxValue <= 1) {
                    bar.percent = ([valueArray[groupIndex][barIndex] floatValue] - self.horizontalAxis.xLineMinValue) / (self.horizontalAxis.xLineMaxValue - self.horizontalAxis.xLineMinValue);
                    bar.barColor = _colorArray[groupIndex];
                }else{
                    bar.percent = 1.f;
                    bar.barColor = _overMaxValueBarColor;
                }
                bar.isShadow = _isShadow;
                bar.isAnimated = self.isAnimated;
                bar.opacity = self.opacity;
                bar.shadowColor = self.shadowColor;
                bar.gradientAttribute = _gradientColorArray ? _gradientColorArray[groupIndex] : nil;
                [bar strokePath];
                [self.barArray addObject:bar];
                [self.horizontalAxis addSubview:bar];
                
                [bar addTarget:self action:@selector(barAction:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
    }
}

/**
 *  设置x轴valueLabel
 */
- (void)setValueLabelOnChart:(NSMutableArray *)valueArray{
    id subObject = valueArray.firstObject;
    if ([subObject isKindOfClass:[NSString class]]) {
        for (NSInteger i = 0; i < self.barArray.count; i++) {
            ZFHorizontalBar * bar = self.barArray[i];
            CGRect rect = [self.horizontalAxis.yLineValueArray[i] stringWidthRectWithSize:CGSizeMake(50 - _valueLabelToBarPadding * 2, _barHeight) font:self.valueOnChartFont];
            //label的中心点
            CGPoint label_center = CGPointMake(bar.endXPos + self.horizontalAxis.yAxisLine.yLineStartXPos + (rect.size.width + 10) * 0.5 + _valueLabelToBarPadding, bar.center.y);
            
            ZFPopoverLabel * popoverLabel = [[ZFPopoverLabel alloc] initWithFrame:CGRectMake(0, 0, rect.size.width + 10, rect.size.height + 10) direction:kAxisDirectionHorizontal];
            popoverLabel.groupIndex = 0;
            popoverLabel.labelIndex = i;
            popoverLabel.text = self.horizontalAxis.yLineValueArray[i];
            popoverLabel.font = self.valueOnChartFont;
            popoverLabel.arrowsOrientation = kPopoverLaberArrowsOrientationOnBelow;
            popoverLabel.center = label_center;
            popoverLabel.pattern = self.valueLabelPattern;
            popoverLabel.textColor = (UIColor *)self.valueTextColorArray.firstObject;
            popoverLabel.isShadow = self.isShadowForValueLabel;
            popoverLabel.isAnimated = self.isAnimated;
            popoverLabel.shadowColor = self.valueLabelShadowColor;
            popoverLabel.hidden = self.isShowAxisLineValue ? NO : YES;
            [popoverLabel strokePath];
            [self.popoverLaberArray addObject:popoverLabel];
            [self.horizontalAxis addSubview:popoverLabel];
            [popoverLabel addTarget:self action:@selector(popoverAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        
    }else if ([subObject isKindOfClass:[NSArray class]]){
        if ([[subObject firstObject] isKindOfClass:[NSString class]]) {
            for (NSInteger i = 0; i < self.barArray.count; i++) {
                ZFHorizontalBar * bar = self.barArray[i];
                NSInteger barIndex = i % [subObject count];
                NSInteger groupIndex = i / [subObject count];
                
                CGRect rect = [valueArray[groupIndex][barIndex] stringWidthRectWithSize:CGSizeMake(50 - _valueLabelToBarPadding * 2, _barHeight) font:self.valueOnChartFont];
                //label的中心点
                CGPoint label_center = CGPointMake(bar.endXPos + self.horizontalAxis.yAxisLine.yLineStartXPos + (rect.size.width + 10) * 0.5 + _valueLabelToBarPadding, bar.center.y);
                
                ZFPopoverLabel * popoverLabel = [[ZFPopoverLabel alloc] initWithFrame:CGRectMake(0, 0, rect.size.width + 10, rect.size.height + 10) direction:kAxisDirectionHorizontal];
                popoverLabel.text = valueArray[groupIndex][barIndex];
                popoverLabel.font = self.valueOnChartFont;
                popoverLabel.arrowsOrientation = kPopoverLaberArrowsOrientationOnBelow;
                popoverLabel.center = label_center;
                popoverLabel.pattern = self.valueLabelPattern;
                popoverLabel.textColor = (UIColor *)self.valueTextColorArray[groupIndex];
                popoverLabel.isShadow = self.isShadowForValueLabel;
                popoverLabel.isAnimated = self.isAnimated;
                popoverLabel.groupIndex = groupIndex;
                popoverLabel.labelIndex = barIndex;
                popoverLabel.shadowColor = self.valueLabelShadowColor;
                popoverLabel.hidden = self.isShowAxisLineValue ? NO : YES;
                [popoverLabel strokePath];
                [self.popoverLaberArray addObject:popoverLabel];
                [self.horizontalAxis addSubview:popoverLabel];
                [popoverLabel addTarget:self action:@selector(popoverAction:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
    }
}

#pragma mark - 点击事件

/**
 *  bar点击事件
 *
 *  @param sender bar
 */
- (void)barAction:(ZFHorizontalBar *)sender{
    if ([self.delegate respondsToSelector:@selector(horizontalBarChart:didSelectBarAtGroupIndex:barIndex:horizontalBar:popoverLabel:)]) {
        
        ZFPopoverLabel * popoverLabel = nil;
        id subObject = self.horizontalAxis.yLineValueArray.firstObject;
        if ([subObject isKindOfClass:[NSString class]]) {
            popoverLabel = self.popoverLaberArray[sender.barIndex];
        }else if ([subObject isKindOfClass:[NSArray class]]){
            popoverLabel = self.popoverLaberArray[[self.barArray indexOfObject:sender]];
        }
        
        [self.delegate horizontalBarChart:self didSelectBarAtGroupIndex:sender.groupIndex barIndex:sender.barIndex horizontalBar:sender popoverLabel:popoverLabel];
        
        [self resetBar:sender popoverLabel:popoverLabel];
    }
}

/**
 *  popoverLaber点击事件
 *
 *  @param sender popoverLabel
 */
- (void)popoverAction:(ZFPopoverLabel *)sender{
    if ([self.delegate respondsToSelector:@selector(horizontalBarChart:didSelectPopoverLabelAtGroupIndex:labelIndex:popoverLabel:)]) {
        [self.delegate horizontalBarChart:self didSelectPopoverLabelAtGroupIndex:sender.groupIndex labelIndex:sender.labelIndex popoverLabel:sender];
        
        [self resetPopoverLabel:sender];
    }
}

#pragma mark - 重置Bar原始设置

- (void)resetBar:(ZFHorizontalBar *)sender popoverLabel:(ZFPopoverLabel *)label{
    for (ZFHorizontalBar * bar in self.barArray) {
        if (bar != sender) {
            bar.barColor = _colorArray[bar.groupIndex];
            bar.isShadow = _isShadow;
            bar.isAnimated = self.isAnimated;
            bar.shadowColor = self.shadowColor;
            bar.opacity = self.opacity;
            [bar strokePath];
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
            popoverLabel.textColor = (UIColor *)self.valueTextColorArray[popoverLabel.groupIndex];
            popoverLabel.shadowColor = self.valueLabelShadowColor;
            popoverLabel.isShadow = self.isShadowForValueLabel;
            popoverLabel.isAnimated = sender.isAnimated;
            [popoverLabel strokePath];
        }
    }
}

#pragma mark - 清除控件

/**
 *  清除之前所有柱状条
 */
- (void)removeAllBar{
    [self.barArray removeAllObjects];
    NSArray * subviews = [NSArray arrayWithArray:self.horizontalAxis.subviews];
    for (UIView * view in subviews) {
        if ([view isKindOfClass:[ZFHorizontalBar class]]) {
            [(ZFHorizontalBar *)view removeFromSuperview];
        }
    }
}

/**
 *  清除柱状条上的Label
 */
- (void)removeLabelOnChart{
    [self.popoverLaberArray removeAllObjects];
    NSArray * subviews = [NSArray arrayWithArray:self.horizontalAxis.subviews];
    for (UIView * view in subviews) {
        if ([view isKindOfClass:[ZFPopoverLabel class]]) {
            [(ZFPopoverLabel *)view removeFromSuperview];
        }
    }
}

#pragma mark - public method

/**
 *  重绘
 */
- (void)strokePath{
    [self.colorArray removeAllObjects];
    [self.valueTextColorArray removeAllObjects];
    
    if ([self.dataSource respondsToSelector:@selector(valueArrayInGenericChart:)]) {
        self.horizontalAxis.yLineValueArray = [NSMutableArray arrayWithArray:[self.dataSource valueArrayInGenericChart:self]];
    }
    
    if ([self.dataSource respondsToSelector:@selector(nameArrayInGenericChart:)]) {
        self.horizontalAxis.yLineNameArray = [NSMutableArray arrayWithArray:[self.dataSource nameArrayInGenericChart:self]];
    }
    
    if ([self.delegate respondsToSelector:@selector(colorArrayInGenericChart:)]) {
        _colorArray = [NSMutableArray arrayWithArray:[self.dataSource colorArrayInGenericChart:self]];
    }else{
        _colorArray = [NSMutableArray arrayWithArray:[[ZFMethod shareInstance] cachedRandomColor:self.horizontalAxis.yLineValueArray]];
    }
    
    if (self.isResetAxisLineMaxValue) {
        if ([self.dataSource respondsToSelector:@selector(axisLineMaxValueInGenericChart:)]) {
            self.horizontalAxis.xLineMaxValue = [self.dataSource axisLineMaxValueInGenericChart:self];
        }else{
            NSLog(@"请返回一个最大值");
            return;
        }
    }else{
        self.horizontalAxis.xLineMaxValue = [[ZFMethod shareInstance] cachedMaxValue:self.horizontalAxis.yLineValueArray];
        
        if (self.horizontalAxis.xLineMaxValue == 0.f) {
            if ([self.dataSource respondsToSelector:@selector(axisLineMaxValueInGenericChart:)]) {
                self.horizontalAxis.xLineMaxValue = [self.dataSource axisLineMaxValueInGenericChart:self];
            }else{
                NSLog(@"当前所有数据的最大值为0, 请返回一个固定最大值, 否则没法绘画图表");
                return;
            }
        }
    }
    
    if (self.isResetAxisLineMinValue) {
        if ([self.dataSource respondsToSelector:@selector(axisLineMinValueInGenericChart:)]) {
            if ([self.dataSource axisLineMinValueInGenericChart:self] > [[ZFMethod shareInstance] cachedMinValue:self.horizontalAxis.yLineValueArray]) {
                self.horizontalAxis.xLineMinValue = [[ZFMethod shareInstance] cachedMinValue:self.horizontalAxis.yLineValueArray];
                
            }else{
                self.horizontalAxis.xLineMinValue = [self.dataSource axisLineMinValueInGenericChart:self];
            }
            
        }else{
            self.horizontalAxis.xLineMinValue = [[ZFMethod shareInstance] cachedMinValue:self.horizontalAxis.yLineValueArray];
        }
    }
    
    if ([self.dataSource respondsToSelector:@selector(axisLineSectionCountInGenericChart:)]) {
        self.horizontalAxis.xLineSectionCount = [self.dataSource axisLineSectionCountInGenericChart:self];
    }
    
    if ([self.delegate respondsToSelector:@selector(barHeightInHorizontalBarChart:)]) {
        _barHeight = [self.delegate barHeightInHorizontalBarChart:self];
    }
    
    if ([self.delegate respondsToSelector:@selector(paddingForGroupsInHorizontalBarChart:)]) {
        self.horizontalAxis.groupPadding = [self.delegate paddingForGroupsInHorizontalBarChart:self];
    }
    
    if ([self.delegate respondsToSelector:@selector(paddingForBarInHorizontalBarChart:)]) {
        _barPadding = [self.delegate paddingForBarInHorizontalBarChart:self];
    }
    
    if ([self.delegate respondsToSelector:@selector(valueTextColorArrayInHorizontalBarChart:)]) {
        id color = [self.delegate valueTextColorArrayInHorizontalBarChart:self];
        id subObject = self.horizontalAxis.yLineValueArray.firstObject;
        if ([subObject isKindOfClass:[NSString class]]) {
            if ([color isKindOfClass:[UIColor class]]) {
                [self.valueTextColorArray addObject:color];
            }else if ([color isKindOfClass:[NSArray class]]){
                self.valueTextColorArray = [NSMutableArray arrayWithArray:color];
            }
            
        }else if ([subObject isKindOfClass:[NSArray class]]){
            if ([color isKindOfClass:[UIColor class]]) {
                for (NSInteger i = 0; i < self.horizontalAxis.yLineValueArray.count; i++) {
                    [self.valueTextColorArray addObject:color];
                }
                
            }else if ([color isKindOfClass:[NSArray class]]){
                self.valueTextColorArray = [NSMutableArray arrayWithArray:color];
            }
        }
        
    }else{
        id subObject = self.horizontalAxis.yLineValueArray.firstObject;
        if ([subObject isKindOfClass:[NSString class]]) {
            [self.valueTextColorArray addObject:_valueTextColor];
        }else if ([subObject isKindOfClass:[NSArray class]]){
            for (NSInteger i = 0; i < self.horizontalAxis.yLineValueArray.count; i++) {
                [self.valueTextColorArray addObject:_valueTextColor];
            }
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(gradientColorArrayInHorizontalBarChart:)]) {
        _gradientColorArray = [NSMutableArray arrayWithArray:[self.delegate gradientColorArrayInHorizontalBarChart:self]];
    }
    
    self.horizontalAxis.groupHeight = [self cachedGroupHeight:self.horizontalAxis.yLineValueArray];
    
    [self removeAllBar];
    [self removeLabelOnChart];
    self.horizontalAxis.isAnimated = self.isAnimated;
    self.horizontalAxis.isShowAxisArrows = self.isShowAxisArrows;
    self.horizontalAxis.valueType = self.valueType;
    [self.horizontalAxis strokePath];
    [self drawBar:self.horizontalAxis.yLineValueArray];
    [self setValueLabelOnChart:self.horizontalAxis.yLineValueArray];
    [self.horizontalAxis bringSubviewToFront:self.horizontalAxis.xAxisLine];
    [self.horizontalAxis bringSubviewToFront:self.horizontalAxis.maskView];
    [self.horizontalAxis bringSectionToFront];
    [self bringSubviewToFront:self.topicLabel];
}

/**
 *  求每组高度
 */
- (CGFloat)cachedGroupHeight:(NSMutableArray *)array{
    id subObject = array.firstObject;
    if ([subObject isKindOfClass:[NSArray class]]) {
        return array.count * _barHeight + (array.count - 1) * _barPadding;
    }
    
    return _barHeight;
}

#pragma mark - 重写setter,getter方法

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    self.horizontalAxis.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
}

- (void)setUnit:(NSString *)unit{
    self.horizontalAxis.unit = unit;
}

- (void)setUnitColor:(UIColor *)unitColor{
    self.horizontalAxis.unitColor = unitColor;
}

- (void)setAxisLineNameFont:(UIFont *)axisLineNameFont{
    self.horizontalAxis.yLineNameFont = axisLineNameFont;
}

- (void)setAxisLineValueFont:(UIFont *)axisLineValueFont{
    self.horizontalAxis.xLineValueFont = axisLineValueFont;
}

- (void)setAxisLineNameColor:(UIColor *)axisLineNameColor{
    self.horizontalAxis.yLineNameColor = axisLineNameColor;
}

- (void)setAxisLineValueColor:(UIColor *)axisLineValueColor{
    self.horizontalAxis.xLineValueColor = axisLineValueColor;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor{
    self.horizontalAxis.axisLineBackgroundColor = backgroundColor;
}

- (void)setXAxisColor:(UIColor *)xAxisColor{
    self.horizontalAxis.xAxisColor = xAxisColor;
}

- (void)setYAxisColor:(UIColor *)yAxisColor{
    self.horizontalAxis.yAxisColor = yAxisColor;
}

- (void)setSeparateColor:(UIColor *)separateColor{
    self.horizontalAxis.separateColor = separateColor;
}

- (void)setIsShowXLineSeparate:(BOOL)isShowXLineSeparate{
    self.horizontalAxis.isShowXLineSeparate = isShowXLineSeparate;
}

- (void)setIsShowYLineSeparate:(BOOL)isShowYLineSeparate{
    self.horizontalAxis.isShowYLineSeparate = isShowYLineSeparate;
}

#pragma mark - 懒加载

- (NSMutableArray *)barArray{
    if (!_barArray) {
        _barArray = [NSMutableArray array];
    }
    return _barArray;
}

- (NSMutableArray *)popoverLaberArray{
    if (!_popoverLaberArray) {
        _popoverLaberArray = [NSMutableArray array];
    }
    return _popoverLaberArray;
}

- (NSMutableArray *)valueTextColorArray{
    if (!_valueTextColorArray) {
        _valueTextColorArray = [NSMutableArray array];
    }
    return _valueTextColorArray;
}

@end
