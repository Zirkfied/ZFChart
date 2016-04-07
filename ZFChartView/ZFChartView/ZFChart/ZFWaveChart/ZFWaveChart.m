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
/** 主题Label */
@property (nonatomic, strong) UILabel * topicLabel;
/** 波浪path颜色 */
@property (nonatomic, strong) UIColor * pathColor;
/** 存储点的位置的数组 */
@property (nonatomic, strong) NSMutableArray * valuePointArray;

@end

@implementation ZFWaveChart

- (void)commonInit{
    _pathColor = ZFSkyBlue;
    _valuePosition = kChartValuePositionDefalut;
    _valueOnChartFontSize = 10.f;
    _valueLabelPattern = kPopoverLabelPatternPopover;
    _valueTextColor = ZFBlack;
    _overMaxValueTextColor = ZFRed;
    _unit = @"";
    _isShadowForValueLabel = YES;
    _wavePatternType = kWavePatternTypeForCurve;
    _isShowXLineValue = YES;
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

#pragma mark - 画波浪path
- (void)drawWavePath{
    self.wave = [[ZFWave alloc] initWithFrame:CGRectMake(self.genericAxis.axisStartXPos, self.genericAxis.yLineMaxValueYPos, self.genericAxis.xLineWidth, self.genericAxis.yLineMaxValueHeight)];
    self.wave.valuePointArray = _valuePointArray;
    self.wave.pathColor = _pathColor;
    self.wave.padding = self.genericAxis.groupPadding;
    self.wave.wavePatternType = _wavePatternType;
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
        
        CGRect rect = [self.genericAxis.xLineValueArray[i] stringWidthRectWithSize:CGSizeMake(45, 30) fontOfSize:_valueOnChartFontSize isBold:NO];
        ZFPopoverLabel * popoverLabel = [[ZFPopoverLabel alloc] initWithFrame:CGRectMake(0, 0, rect.size.width + 10, rect.size.height + 10)];
        popoverLabel.text = self.genericAxis.xLineValueArray[i];
        popoverLabel.font = [UIFont systemFontOfSize:_valueOnChartFontSize];
        popoverLabel.pattern = _valueLabelPattern;
        popoverLabel.textColor = _valueTextColor;
        popoverLabel.isShadow = _isShadowForValueLabel;
        popoverLabel.labelIndex = i;
        CGFloat percent = [self.genericAxis.xLineValueArray[i] floatValue] / self.genericAxis.yLineMaxValue;
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
                popoverLabel.center = CGPointMake([currentDict[@"xPos"] floatValue], [currentDict[@"yPos"] floatValue] + (rect.size.height + 10)*0.5);
            }else{
                popoverLabel.arrowsOrientation = kPopoverLaberArrowsOrientationOnBelow;
                popoverLabel.center = CGPointMake([currentDict[@"xPos"] floatValue], [currentDict[@"yPos"] floatValue] - (rect.size.height + 10)*0.5);
            }
            
        //_valueOnChartPosition为图表上方
        }else if (_valuePosition == kChartValuePositionOnTop){
            popoverLabel.arrowsOrientation = kPopoverLaberArrowsOrientationOnBelow;
            popoverLabel.center = CGPointMake([currentDict[@"xPos"] floatValue], [currentDict[@"yPos"] floatValue] - (rect.size.height + 10)*0.5);
        
        //_valueOnChartPosition为图表下方
        }else if (_valuePosition == kChartValuePositionOnBelow){
            popoverLabel.arrowsOrientation = kPopoverLaberArrowsOrientationOnTop;
            popoverLabel.center = CGPointMake([currentDict[@"xPos"] floatValue], [currentDict[@"yPos"] floatValue] + (rect.size.height + 10)*0.5);
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
    
    if ([self.dataSource respondsToSelector:@selector(yLineMaxValueInGenericChart:)]) {
        self.genericAxis.yLineMaxValue = [self.dataSource yLineMaxValueInGenericChart:self];
    }else{
        self.genericAxis.yLineMaxValue = [[ZFMethod shareInstance] cachedYLineMaxValue:self.genericAxis.xLineValueArray];
    }
    
    if ([self.dataSource respondsToSelector:@selector(yLineSectionCountInGenericChart:)]) {
        self.genericAxis.yLineSectionCount = [self.dataSource yLineSectionCountInGenericChart:self];
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
    [self.genericAxis strokePath];
    _valuePointArray = [NSMutableArray arrayWithArray:[self cachedValuePointArray:self.genericAxis.xLineValueArray]];
    [self drawWavePath];
    _isShowXLineValue ? [self setValueLabelOnChart] : nil;
    [self.genericAxis bringSubviewToFront:self.genericAxis.yAxisLine];
    [self.genericAxis bringSectionToFront];
}

/**
 *  计算点的位置
 */
- (NSMutableArray *)cachedValuePointArray:(NSMutableArray *)valueArray{
    NSMutableArray * valuePointArray = [NSMutableArray array];
    for (NSInteger i = 0; i < valueArray.count; i++) {
        CGFloat percent = [valueArray[i] floatValue] / self.genericAxis.yLineMaxValue;
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

- (void)setIsShowSeparate:(BOOL)isShowSeparate{
    _isShowSeparate = isShowSeparate;
    self.genericAxis.isShowSeparate = _isShowSeparate;
    self.genericAxis.sectionColor = ZFLightGray;
}

@end
