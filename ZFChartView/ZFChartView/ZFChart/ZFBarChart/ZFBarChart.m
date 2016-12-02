//
//  ZFBarChart.m
//  ZFChartView
//
//  Created by apple on 16/3/15.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ZFBarChart.h"
#import "ZFGenericAxis.h"
#import "NSString+Zirkfied.h"
#import "ZFMethod.h"

@interface ZFBarChart()

/** 通用坐标轴图表 */
@property (nonatomic, strong) ZFGenericAxis * genericAxis;
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
/** bar宽度 */
@property (nonatomic, assign) CGFloat barWidth;
/** bar与bar之间的间距 */
@property (nonatomic, assign) CGFloat barPadding;
/** value文本颜色 */
@property (nonatomic, strong) UIColor * valueTextColor;

@end

@implementation ZFBarChart

/**
 *  初始化变量
 */
- (void)commonInit{
    [super commonInit];

    _overMaxValueBarColor = ZFRed;
    _isShadow = YES;
    _barWidth = ZFAxisLineItemWidth;
    _barPadding = ZFAxisLinePaddingForBarLength;
    _valueTextColor = ZFBlack;
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

#pragma mark - 柱状条

/**
 *  画柱状条
 */
- (void)drawBar:(NSMutableArray *)valueArray{
    id subObject = valueArray.firstObject;
    if ([subObject isKindOfClass:[NSString class]]) {
        for (NSInteger i = 0; i < valueArray.count; i++) {
            CGFloat xPos = self.genericAxis.axisStartXPos + self.genericAxis.groupPadding + (_barWidth + self.genericAxis.groupPadding) * i;
            CGFloat yPos = self.genericAxis.yLineMaxValueYPos;
            CGFloat width = _barWidth;
            CGFloat height = self.genericAxis.yLineMaxValueHeight;
            
            ZFBar * bar = [[ZFBar alloc] initWithFrame:CGRectMake(xPos, yPos, width, height)];
            bar.groupIndex = 0;
            bar.barIndex = i;
            //当前数值超过y轴显示上限时，柱状改为红色
            if ([self.genericAxis.xLineValueArray[i] floatValue] / self.genericAxis.yLineMaxValue <= 1) {
                bar.percent = ([self.genericAxis.xLineValueArray[i] floatValue] - self.genericAxis.yLineMinValue) / (self.genericAxis.yLineMaxValue - self.genericAxis.yLineMinValue);
                bar.barColor = _colorArray.firstObject;
                
                bar.isOverrun = NO;
            }else{
                bar.percent = 1.f;
                bar.barColor = _overMaxValueBarColor;
                bar.isOverrun = YES;
            }
            bar.isShadow = _isShadow;
            bar.isAnimated = self.isAnimated;
            bar.opacity = self.opacity;
            bar.shadowColor = self.shadowColor;
            bar.gradientAttribute = _gradientColorArray ? _gradientColorArray.firstObject : nil;
            [bar strokePath];
            [self.barArray addObject:bar];
            [self.genericAxis addSubview:bar];
            
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
                
                CGFloat xPos = self.genericAxis.axisStartXPos + self.genericAxis.groupPadding * (barIndex + 1) + self.genericAxis.groupWidth * barIndex + (_barWidth + _barPadding) * groupIndex;
                CGFloat yPos = self.genericAxis.yLineMaxValueYPos;
                CGFloat width = _barWidth;
                CGFloat height = self.genericAxis.yLineMaxValueHeight;
                
                ZFBar * bar = [[ZFBar alloc] initWithFrame:CGRectMake(xPos, yPos, width, height)];
                bar.groupIndex = groupIndex;
                bar.barIndex = barIndex;
                //当前数值超过y轴显示上限时，柱状改为红色
                if ([valueArray[groupIndex][barIndex] floatValue] / self.genericAxis.yLineMaxValue <= 1) {
                    bar.percent = ([valueArray[groupIndex][barIndex] floatValue] - self.genericAxis.yLineMinValue) / (self.genericAxis.yLineMaxValue - self.genericAxis.yLineMinValue);
                    bar.barColor = _colorArray[groupIndex];
                    bar.isOverrun = NO;
                }else{
                    bar.percent = 1.f;
                    bar.barColor = _overMaxValueBarColor;
                    bar.isOverrun = YES;
                }
                bar.isShadow = _isShadow;
                bar.isAnimated = self.isAnimated;
                bar.opacity = self.opacity;
                bar.shadowColor = self.shadowColor;
                bar.gradientAttribute = _gradientColorArray ? _gradientColorArray[groupIndex] : nil;
                [bar strokePath];
                [self.barArray addObject:bar];
                [self.genericAxis addSubview:bar];
                
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
            ZFBar * bar = self.barArray[i];
            //label的中心点
            CGPoint label_center = CGPointMake(bar.center.x, bar.endYPos + self.genericAxis.yAxisLine.yLineEndYPos);
            CGRect rect = [self.genericAxis.xLineValueArray[i] stringWidthRectWithSize:CGSizeMake(_barWidth + _barPadding * 0.5, 30) font:self.valueOnChartFont];
            
            ZFPopoverLabel * popoverLabel = [[ZFPopoverLabel alloc] initWithFrame:CGRectMake(0, 0, rect.size.width + 10, rect.size.height + 10) direction:kAxisDirectionVertical];
            popoverLabel.groupIndex = 0;
            popoverLabel.labelIndex = i;
            popoverLabel.text = self.genericAxis.xLineValueArray[i];
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
            [self.genericAxis addSubview:popoverLabel];
            [popoverLabel addTarget:self action:@selector(popoverAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        
    }else if ([subObject isKindOfClass:[NSArray class]]){
        if ([[subObject firstObject] isKindOfClass:[NSString class]]) {
            for (NSInteger i = 0; i < self.barArray.count; i++) {
                ZFBar * bar = self.barArray[i];
                NSInteger barIndex = i % [subObject count];
                NSInteger groupIndex = i / [subObject count];
                //label的中心点
                CGPoint label_center = CGPointMake(bar.center.x, bar.endYPos + self.genericAxis.yAxisLine.yLineEndYPos);
                CGRect rect = [valueArray[groupIndex][barIndex] stringWidthRectWithSize:CGSizeMake(_barWidth + _barPadding * 0.5, 30) font:self.valueOnChartFont];
                
                ZFPopoverLabel * popoverLabel = [[ZFPopoverLabel alloc] initWithFrame:CGRectMake(0, 0, rect.size.width + 10, rect.size.height + 10) direction:kAxisDirectionVertical];
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
                [self.genericAxis addSubview:popoverLabel];
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
- (void)barAction:(ZFBar *)sender{
    if ([self.delegate respondsToSelector:@selector(barChart:didSelectBarAtGroupIndex:barIndex:bar:popoverLabel:)]) {
        
        ZFPopoverLabel * popoverLabel = nil;
        id subObject = self.genericAxis.xLineValueArray.firstObject;
        if ([subObject isKindOfClass:[NSString class]]) {
            popoverLabel = self.popoverLaberArray[sender.barIndex];
        }else if ([subObject isKindOfClass:[NSArray class]]){
            popoverLabel = self.popoverLaberArray[[self.barArray indexOfObject:sender]];
        }
        
        [self.delegate barChart:self didSelectBarAtGroupIndex:sender.groupIndex barIndex:sender.barIndex bar:sender popoverLabel:popoverLabel];
        
        [self resetBar:sender popoverLabel:popoverLabel];
    }
}

/**
 *  popoverLaber点击事件
 *
 *  @param sender popoverLabel
 */
- (void)popoverAction:(ZFPopoverLabel *)sender{
    if ([self.delegate respondsToSelector:@selector(barChart:didSelectPopoverLabelAtGroupIndex:labelIndex:popoverLabel:)]) {
        [self.delegate barChart:self didSelectPopoverLabelAtGroupIndex:sender.groupIndex labelIndex:sender.labelIndex popoverLabel:sender];
        
        [self resetPopoverLabel:sender];
    }
}

#pragma mark - 重置Bar原始设置

- (void)resetBar:(ZFBar *)sender popoverLabel:(ZFPopoverLabel *)label{
    for (ZFBar * bar in self.barArray) {
        if (bar != sender) {
            bar.barColor = bar.isOverrun ? _overMaxValueBarColor : _colorArray[bar.groupIndex];
            bar.isAnimated = NO;
            bar.opacity = self.opacity;
            [bar strokePath];
            //复原
            bar.isAnimated = self.isAnimated;
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
    NSArray * subviews = [NSArray arrayWithArray:self.genericAxis.subviews];
    for (UIView * view in subviews) {
        if ([view isKindOfClass:[ZFBar class]]) {
            [(ZFBar *)view removeFromSuperview];
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

#pragma mark - public method

/**
 *  重绘
 */
- (void)strokePath{
    [self.colorArray removeAllObjects];
    [self.valueTextColorArray removeAllObjects];
    
    if ([self.dataSource respondsToSelector:@selector(valueArrayInGenericChart:)]) {
        self.genericAxis.xLineValueArray = [NSMutableArray arrayWithArray:[self.dataSource valueArrayInGenericChart:self]];
    }
    
    if ([self.dataSource respondsToSelector:@selector(nameArrayInGenericChart:)]) {
        self.genericAxis.xLineNameArray = [NSMutableArray arrayWithArray:[self.dataSource nameArrayInGenericChart:self]];
    }
    
    if ([self.delegate respondsToSelector:@selector(colorArrayInGenericChart:)]) {
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
    
    if ([self.delegate respondsToSelector:@selector(barWidthInBarChart:)]) {
        _barWidth = [self.delegate barWidthInBarChart:self];
    }
    
    if ([self.delegate respondsToSelector:@selector(paddingForGroupsInBarChart:)]) {
        self.genericAxis.groupPadding = [self.delegate paddingForGroupsInBarChart:self];
    }
    
    if ([self.delegate respondsToSelector:@selector(paddingForBarInBarChart:)]) {
        _barPadding = [self.delegate paddingForBarInBarChart:self];
    }
    
    if ([self.delegate respondsToSelector:@selector(valueTextColorArrayInBarChart:)]) {
        id color = [self.delegate valueTextColorArrayInBarChart:self];
        id subObject = self.genericAxis.xLineValueArray.firstObject;
        if ([subObject isKindOfClass:[NSString class]]) {
            if ([color isKindOfClass:[UIColor class]]) {
                [self.valueTextColorArray addObject:color];
            }else if ([color isKindOfClass:[NSArray class]]){
                self.valueTextColorArray = [NSMutableArray arrayWithArray:color];
            }
            
        }else if ([subObject isKindOfClass:[NSArray class]]){
            if ([color isKindOfClass:[UIColor class]]) {
                for (NSInteger i = 0; i < self.genericAxis.xLineValueArray.count; i++) {
                    [self.valueTextColorArray addObject:color];
                }
                
            }else if ([color isKindOfClass:[NSArray class]]){
                self.valueTextColorArray = [NSMutableArray arrayWithArray:color];
            }
        }
        
    }else{
        id subObject = self.genericAxis.xLineValueArray.firstObject;
        if ([subObject isKindOfClass:[NSString class]]) {
            [self.valueTextColorArray addObject:_valueTextColor];
        }else if ([subObject isKindOfClass:[NSArray class]]){
            for (NSInteger i = 0; i < self.genericAxis.xLineValueArray.count; i++) {
                [self.valueTextColorArray addObject:_valueTextColor];
            }
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(gradientColorArrayInBarChart:)]) {
        _gradientColorArray = [NSMutableArray arrayWithArray:[self.delegate gradientColorArrayInBarChart:self]];
    }
    
    self.genericAxis.groupWidth = [self cachedGroupWidth:self.genericAxis.xLineValueArray];
    
    [self removeAllBar];
    [self removeLabelOnChart];
    self.genericAxis.xLineNameLabelToXAxisLinePadding = self.xLineNameLabelToXAxisLinePadding;
    self.genericAxis.isAnimated = self.isAnimated;
    self.genericAxis.isShowAxisArrows = self.isShowAxisArrows;
    self.genericAxis.valueType = self.valueType;
    [self.genericAxis strokePath];
    [self drawBar:self.genericAxis.xLineValueArray];
    [self setValueLabelOnChart:self.genericAxis.xLineValueArray];
    
    [self.genericAxis bringSubviewToFront:self.genericAxis.yAxisLine];
    [self.genericAxis bringSectionToFront];
    [self bringSubviewToFront:self.topicLabel];
}

/**
 *  求每组宽度
 */
- (CGFloat)cachedGroupWidth:(NSMutableArray *)array{
    id subObject = array.firstObject;
    if ([subObject isKindOfClass:[NSArray class]]) {
        return array.count * _barWidth + (array.count - 1) * _barPadding;
    }
    
    return _barWidth;
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
    self.genericAxis.axisLineBackgroundColor = backgroundColor;
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
