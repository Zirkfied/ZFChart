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
/** 波浪path颜色 */
@property (nonatomic, strong) UIColor * pathColor;
/** 存储点的位置的数组 */
@property (nonatomic, strong) NSMutableArray * valuePointArray;

@end

@implementation ZFWaveChart

- (void)commonInit{
    [super commonInit];
    
    _pathColor = ZFSkyBlue;
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
    self.wave.padding = self.genericAxis.groupPadding;
    self.wave.wavePatternType = _wavePatternType;
    self.wave.isAnimated = self.isAnimated;
    self.wave.opacity = self.opacity;
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
        
        CGRect rect = [self.genericAxis.xLineValueArray[i] stringWidthRectWithSize:CGSizeMake(45, 30) fontOfSize:self.valueOnChartFontSize isBold:NO];
        ZFPopoverLabel * popoverLabel = [[ZFPopoverLabel alloc] initWithFrame:CGRectMake(0, 0, rect.size.width + 10, rect.size.height + 10) direction:kAxisDirectionVertical];
        popoverLabel.text = self.genericAxis.xLineValueArray[i];
        popoverLabel.font = [UIFont systemFontOfSize:self.valueOnChartFontSize];
        popoverLabel.pattern = self.valueLabelPattern;
        popoverLabel.textColor = _valueTextColor;
        popoverLabel.isShadow = self.isShadowForValueLabel;
        popoverLabel.isAnimated = self.isAnimated;
        popoverLabel.labelIndex = i;
        popoverLabel.shadowColor = self.valueLabelShadowColor;
        CGFloat percent = ([self.genericAxis.xLineValueArray[i] floatValue] - self.genericAxis.yLineMinValue) / (self.genericAxis.yLineMaxValue - self.genericAxis.yLineMinValue);
        if (percent > 1) {
            popoverLabel.textColor = _overMaxValueTextColor;
        }
        
        [self.wave addSubview:popoverLabel];
        [popoverLabel addTarget:self action:@selector(popoverAction:) forControlEvents:UIControlEventTouchUpInside];
        
        //_valueOnChartPosition为上下分布
        if (_valuePosition == kChartValuePositionDefalut) {
            //根据end_YPos判断label显示在上面或下面
            CGFloat end_YPos;
            
            if (i == 0) {//当前点是第一个时
                end_YPos = [currentDict[@"yPos"] floatValue];
                
            }else{//当前点不是第一个时
                NSDictionary * preDict = _valuePointArray[i - 1];
                end_YPos = [preDict[@"yPos"] floatValue] - [currentDict[@"yPos"] floatValue];
            }
            
            if (end_YPos < 0) {
                popoverLabel.arrowsOrientation = kPopoverLaberArrowsOrientationOnTop;
                popoverLabel.center = CGPointMake([currentDict[@"xPos"] floatValue], [currentDict[@"yPos"] floatValue] + (rect.size.height + 10) * 0.5 + _valueLabelToWaveLinePadding);
            }else{
                popoverLabel.arrowsOrientation = kPopoverLaberArrowsOrientationOnBelow;
                popoverLabel.center = CGPointMake([currentDict[@"xPos"] floatValue], [currentDict[@"yPos"] floatValue] - (rect.size.height + 10) * 0.5 - _valueLabelToWaveLinePadding);
            }
            
        //_valueOnChartPosition为图表上方
        }else if (_valuePosition == kChartValuePositionOnTop){
            popoverLabel.arrowsOrientation = kPopoverLaberArrowsOrientationOnBelow;
            popoverLabel.center = CGPointMake([currentDict[@"xPos"] floatValue], [currentDict[@"yPos"] floatValue] - (rect.size.height + 10) * 0.5 - _valueLabelToWaveLinePadding);
        
        //_valueOnChartPosition为图表下方
        }else if (_valuePosition == kChartValuePositionOnBelow){
            popoverLabel.arrowsOrientation = kPopoverLaberArrowsOrientationOnTop;
            popoverLabel.center = CGPointMake([currentDict[@"xPos"] floatValue], [currentDict[@"yPos"] floatValue] + (rect.size.height + 10) * 0.5 + _valueLabelToWaveLinePadding);
        }
        
        [popoverLabel strokePath];
    }
}

#pragma mark - popover点击事件

- (void)popoverAction:(ZFPopoverLabel *)sender{
    if ([self.delegate respondsToSelector:@selector(waveChart:popoverLabelAtIndex:)]) {
        [self.delegate waveChart:self popoverLabelAtIndex:sender.labelIndex];
    }
}

#pragma mark - 清除所有子控件

/**
 *  清除所有子控件
 */
- (void)removeAllSubview{
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
    
    if ([self.dataSource respondsToSelector:@selector(axisLineMaxValueInGenericChart:)]) {
        self.genericAxis.yLineMaxValue = [self.dataSource axisLineMaxValueInGenericChart:self];
    }else{
        self.genericAxis.yLineMaxValue = [[ZFMethod shareInstance] cachedYLineMaxValue:self.genericAxis.xLineValueArray];
    }
    
    if (self.isResetAxisLineMinValue) {
        if ([self.dataSource respondsToSelector:@selector(axisLineMinValueInGenericChart:)]) {
            if ([self.dataSource axisLineMinValueInGenericChart:self] > [[ZFMethod shareInstance] cachedYLineMinValue:self.genericAxis.xLineValueArray]) {
                self.genericAxis.yLineMinValue = [[ZFMethod shareInstance] cachedYLineMinValue:self.genericAxis.xLineValueArray];
                
            }else{
                self.genericAxis.yLineMinValue = [self.dataSource axisLineMinValueInGenericChart:self];
            }
            
        }else{
            self.genericAxis.yLineMinValue = [[ZFMethod shareInstance] cachedYLineMinValue:self.genericAxis.xLineValueArray];
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
    
    if ([self.delegate respondsToSelector:@selector(pathColorInWaveChart:)]) {
        _pathColor = [self.delegate pathColorInWaveChart:self];
    }
    
    [self removeAllSubview];
    self.genericAxis.xLineNameLabelToXAxisLinePadding = self.xLineNameLabelToXAxisLinePadding;
    self.genericAxis.isAnimated = self.isAnimated;
    self.genericAxis.axisLineValueType = self.axisLineValueType;
    [self.genericAxis strokePath];
    _valuePointArray = [NSMutableArray arrayWithArray:[self cachedValuePointArray:self.genericAxis.xLineValueArray]];
    [self drawWavePath];
    self.isShowAxisLineValue ? [self setValueLabelOnChart] : nil;
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
        
        NSDictionary * dict = @{@"xPos":@(xPos), @"yPos":@(yPos)};
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

- (void)setAxisLineNameFontSize:(CGFloat)axisLineNameFontSize{
    self.genericAxis.xLineNameFontSize = axisLineNameFontSize;
}

- (void)setAxisLineValueFontSize:(CGFloat)axisLineValueFontSize{
    self.genericAxis.yLineValueFontSize = axisLineValueFontSize;
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

- (void)setAxisColor:(UIColor *)axisColor{
    self.genericAxis.axisColor = axisColor;
}

- (void)setSeparateColor:(UIColor *)separateColor{
    self.genericAxis.separateColor = separateColor;
}

- (void)setIsShowSeparate:(BOOL)isShowSeparate{
    self.genericAxis.isShowSeparate = isShowSeparate;
}

@end
