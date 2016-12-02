//
//  ZFWaveChart.m
//  ZFChartView
//
//  Created by apple on 16/3/26.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ZFWaveChart.h"
#import "ZFGenericAxis.h"
#import "ZFMethod.h"
#import "NSString+Zirkfied.h"

@interface ZFWaveChart ()

/** 通用坐标轴图表 */
@property (nonatomic, strong) ZFGenericAxis * genericAxis;
/** 波浪path */
@property (nonatomic, strong) ZFWave * wave;
/** 存储path渐变色 */
@property (nonatomic, strong) ZFGradientAttribute * gradientAttribute;
/** 存储点的位置的数组 */
@property (nonatomic, strong) NSMutableArray * valuePointArray;
/** 存储popoverLaber数组 */
@property (nonatomic, strong) NSMutableArray * popoverLaberArray;

@end

@implementation ZFWaveChart

- (void)commonInit{
    [super commonInit];
    
    _pathColor = ZFSkyBlue;
    _pathLineColor = ZFClear;
    _valuePosition = kChartValuePositionDefalut;
    _valueTextColor = ZFBlack;
    _overMaxValueTextColor = ZFRed;
    _wavePatternType = kWavePatternTypeForCurve;
    _valueLabelToWaveLinePadding = 0.f;
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

#pragma mark - 画波浪path
- (void)drawWavePath{
    self.wave = [[ZFWave alloc] initWithFrame:CGRectMake(self.genericAxis.axisStartXPos, self.genericAxis.yLineMaxValueYPos, self.genericAxis.xLineWidth, self.genericAxis.yLineMaxValueHeight)];
    self.wave.valuePointArray = _valuePointArray;
    self.wave.pathColor = _pathColor;
    self.wave.pathLineColor = _pathLineColor;
    self.wave.padding = self.genericAxis.groupPadding;
    self.wave.wavePatternType = _wavePatternType;
    self.wave.isAnimated = self.isAnimated;
    self.wave.opacity = self.opacity;
    self.wave.gradientAttribute = _gradientAttribute;
    [self.genericAxis addSubview:self.wave];
    [self.wave strokePath];
}

#pragma mark - 设置x轴valueLabel

/**
 *  设置x轴valueLabel
 */
- (void)setValueLabelOnChart{
    for (NSInteger i = 0; i < _valuePointArray.count; i++) {
        //当前点的位置
        NSDictionary * currentDict = _valuePointArray[i];
        
        CGRect rect = [self.genericAxis.xLineValueArray[i] stringWidthRectWithSize:CGSizeMake(45, 30) font:self.valueOnChartFont];
        ZFPopoverLabel * popoverLabel = [[ZFPopoverLabel alloc] initWithFrame:CGRectMake(0, 0, rect.size.width + 10, rect.size.height + 10) direction:kAxisDirectionVertical];
        popoverLabel.text = self.genericAxis.xLineValueArray[i];
        popoverLabel.font = self.valueOnChartFont;
        popoverLabel.pattern = self.valueLabelPattern;
        popoverLabel.textColor = _valueTextColor;
        popoverLabel.isShadow = self.isShadowForValueLabel;
        popoverLabel.isAnimated = self.isAnimated;
        popoverLabel.labelIndex = i;
        popoverLabel.shadowColor = self.valueLabelShadowColor;
        popoverLabel.isOverrun = NO;
        popoverLabel.hidden = self.isShowAxisLineValue ? NO : YES;
        CGFloat percent = ([self.genericAxis.xLineValueArray[i] floatValue] - self.genericAxis.yLineMinValue) / (self.genericAxis.yLineMaxValue - self.genericAxis.yLineMinValue);
        if (percent > 1) {
            popoverLabel.textColor = _overMaxValueTextColor;
            popoverLabel.isOverrun = YES;
        }
        
        [self.genericAxis addSubview:popoverLabel];
        [self.popoverLaberArray addObject:popoverLabel];
        [popoverLabel addTarget:self action:@selector(popoverAction:) forControlEvents:UIControlEventTouchUpInside];
        
        //_valueOnChartPosition为上下分布
        if (_valuePosition == kChartValuePositionDefalut) {
            //根据end_YPos判断label显示在上面或下面
            CGFloat end_YPos;
            
            if (i == 0) {//当前点是第一个时
                end_YPos = [currentDict[ZFWaveChartYPos] floatValue];
                
            }else{//当前点不是第一个时
                NSDictionary * preDict = _valuePointArray[i - 1];
                end_YPos = [preDict[ZFWaveChartYPos] floatValue] - [currentDict[ZFWaveChartYPos] floatValue];
            }
            
            if (end_YPos < 0) {
                popoverLabel.arrowsOrientation = kPopoverLaberArrowsOrientationOnTop;
                popoverLabel.center = CGPointMake([currentDict[ZFWaveChartXPos] floatValue] + CGRectGetMinX(self.wave.frame), [currentDict[ZFWaveChartYPos] floatValue] + (rect.size.height + 10) * 0.5 + _valueLabelToWaveLinePadding + CGRectGetMinY(self.wave.frame));
            }else{
                popoverLabel.arrowsOrientation = kPopoverLaberArrowsOrientationOnBelow;
                popoverLabel.center = CGPointMake([currentDict[ZFWaveChartXPos] floatValue] + CGRectGetMinX(self.wave.frame), [currentDict[ZFWaveChartYPos] floatValue] - (rect.size.height + 10) * 0.5 - _valueLabelToWaveLinePadding + CGRectGetMinY(self.wave.frame));
            }
            
            //_valueOnChartPosition为图表上方
        }else if (_valuePosition == kChartValuePositionOnTop){
            popoverLabel.arrowsOrientation = kPopoverLaberArrowsOrientationOnBelow;
            popoverLabel.center = CGPointMake([currentDict[ZFWaveChartXPos] floatValue] + CGRectGetMinX(self.wave.frame), [currentDict[ZFWaveChartYPos] floatValue] - (rect.size.height + 10) * 0.5 - _valueLabelToWaveLinePadding + CGRectGetMinY(self.wave.frame));
            
            //_valueOnChartPosition为图表下方
        }else if (_valuePosition == kChartValuePositionOnBelow){
            popoverLabel.arrowsOrientation = kPopoverLaberArrowsOrientationOnTop;
            popoverLabel.center = CGPointMake([currentDict[ZFWaveChartXPos] floatValue] + CGRectGetMinX(self.wave.frame), [currentDict[ZFWaveChartYPos] floatValue] + (rect.size.height + 10) * 0.5 + _valueLabelToWaveLinePadding + CGRectGetMinY(self.wave.frame));
        }
        
        [popoverLabel strokePath];
    }
}

#pragma mark - popover点击事件

- (void)popoverAction:(ZFPopoverLabel *)sender{
    if ([self.delegate respondsToSelector:@selector(waveChart:popoverLabelAtIndex:popoverLabel:)]) {
        [self.delegate waveChart:self popoverLabelAtIndex:sender.labelIndex popoverLabel:sender];
        
        [self resetPopoverLabel:sender];
    }
}

#pragma mark - 重置PopoverLabel原始设置

- (void)resetPopoverLabel:(ZFPopoverLabel *)sender{
    for (ZFPopoverLabel * popoverLabel in self.popoverLaberArray) {
        if (popoverLabel != sender) {
            popoverLabel.font = self.valueOnChartFont;
            popoverLabel.textColor = popoverLabel.isOverrun ? _overMaxValueTextColor : _valueTextColor;
            popoverLabel.shadowColor = self.valueLabelShadowColor;
            popoverLabel.isShadow = self.isShadowForValueLabel;
            popoverLabel.isAnimated = sender.isAnimated;
            [popoverLabel strokePath];
        }
    }
}

#pragma mark - 清除所有子控件

/**
 *  清除所有子控件
 */
- (void)removeAllSubview{
    [self.popoverLaberArray removeAllObjects];
    NSArray * subviews = [NSArray arrayWithArray:self.genericAxis.subviews];
    for (UIView * view in subviews) {
        if ([view isKindOfClass:[ZFWave class]] || [view isKindOfClass:[ZFPopoverLabel class]]) {
            [view removeFromSuperview];
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
        //如果数组里存的不是字符串，则return
        id subObject = self.genericAxis.xLineValueArray.firstObject;
        if (![subObject isKindOfClass:[NSString class]]) {
            return;
        }
    }
    
    if ([self.dataSource respondsToSelector:@selector(nameArrayInGenericChart:)]) {
        self.genericAxis.xLineNameArray = [NSMutableArray arrayWithArray:[self.dataSource nameArrayInGenericChart:self]];
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
    
    if ([self.delegate respondsToSelector:@selector(groupWidthInWaveChart:)]) {
        self.genericAxis.groupWidth = [self.delegate groupWidthInWaveChart:self];
    }
    
    if ([self.delegate respondsToSelector:@selector(paddingForGroupsInWaveChart:)]) {
        self.genericAxis.groupPadding = [self.delegate paddingForGroupsInWaveChart:self];
    }
    
    if ([self.delegate respondsToSelector:@selector(gradientColorInWaveChart:)]) {
        _gradientAttribute = [self.delegate gradientColorInWaveChart:self];
    }
    
    [self removeAllSubview];
    self.genericAxis.xLineNameLabelToXAxisLinePadding = self.xLineNameLabelToXAxisLinePadding;
    self.genericAxis.isAnimated = self.isAnimated;
    self.genericAxis.isShowAxisArrows = self.isShowAxisArrows;
    self.genericAxis.valueType = self.valueType;
    [self.genericAxis strokePath];
    _valuePointArray = [NSMutableArray arrayWithArray:[self cachedValuePointArray:self.genericAxis.xLineValueArray]];
    [self drawWavePath];
    [self setValueLabelOnChart];
    [self.genericAxis bringSubviewToFront:self.genericAxis.yAxisLine];
    [self.genericAxis bringSectionToFront];
    [self bringSubviewToFront:self.topicLabel];
}

/**
 *  计算点的位置
 */
- (NSMutableArray *)cachedValuePointArray:(NSMutableArray *)valueArray{
    NSMutableArray * valuePointArray = [NSMutableArray array];
    for (NSInteger i = 0; i < valueArray.count; i++) {
        CGFloat percent = ([valueArray[i] floatValue] - self.genericAxis.yLineMinValue) / (self.genericAxis.yLineMaxValue - self.genericAxis.yLineMinValue);
        if (percent > 1) {
            percent = 1;
        }
        
        CGFloat height = percent * self.genericAxis.yLineMaxValueHeight;
        CGFloat xPos = self.genericAxis.groupPadding + self.genericAxis.groupWidth * 0.5 + (self.genericAxis.groupPadding + self.genericAxis.groupWidth) * i;
        CGFloat yPos = self.genericAxis.axisStartYPos - self.genericAxis.yLineMaxValueYPos - height;
        
        //判断高度是否为0
        BOOL isHeightEqualZero = height == 0 ? YES : NO;
        NSDictionary * dict = @{ZFWaveChartXPos:@(xPos), ZFWaveChartYPos:@(yPos), ZFWaveChartIsHeightEqualZero:@(isHeightEqualZero)};
        [valuePointArray addObject:dict];
    }
    
    return valuePointArray;
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

- (NSMutableArray *)popoverLaberArray{
    if (!_popoverLaberArray) {
        _popoverLaberArray = [NSMutableArray array];
    }
    return _popoverLaberArray;
}

@end
