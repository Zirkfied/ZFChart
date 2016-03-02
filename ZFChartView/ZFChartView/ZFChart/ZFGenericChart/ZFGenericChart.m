//
//  ZFGenericChart.m
//  ZFChartView
//
//  Created by apple on 16/2/5.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ZFGenericChart.h"
#import "ZFAxisLine.h"
#import "ZFLabel.h"
#import "ZFConst.h"
#import "NSString+Zirkfied.h"

@interface ZFGenericChart()

/** 坐标轴 */
@property (nonatomic, strong) ZFAxisLine * axisLine;
/** x轴label高度 */
@property (nonatomic, assign) CGFloat xLineLabelHeight;

@end

@implementation ZFGenericChart

/**
 *  初始化默认变量
 */
- (void)commonInit{
    _yLineSectionCount = 5;
    _xLineLabelHeight = 30.f;
    _xLineTitleFontSize = 10.f;
    _xLineValueFontSize = 10.f;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
        [self drawAxisLine];
    }
    
    return self;
}

#pragma mark - 坐标轴

/**
 *  画坐标轴
 */
- (void)drawAxisLine{
    self.axisLine = [[ZFAxisLine alloc] initWithFrame:self.bounds];
    [self addSubview:self.axisLine];
}

/**
 *  设置x轴标题Label
 */
- (void)setXLineTitleLabel{
    for (NSInteger i = 0; i < self.xLineTitleArray.count; i++) {
        CGFloat xPos = self.axisLine.xLineStartXPos + XLineItemGapLength + (XLineItemWidth + XLineItemGapLength) * i;
        CGFloat yPos = self.axisLine.xLineStartYPos + 5;
        CGFloat width = XLineItemWidth;
        CGFloat height = _xLineLabelHeight;
        
        //label的中心点
        CGPoint label_center = CGPointMake(xPos + width * 0.5, yPos + height * 0.5);
        CGRect rect = [self.xLineTitleArray[i] stringWidthRectWithSize:CGSizeMake(width + XLineItemGapLength * 0.5, height) fontOfSize:_xLineTitleFontSize isBold:NO];
        ZFLabel * label = [[ZFLabel alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
        label.text = self.xLineTitleArray[i];
        label.font = [UIFont systemFontOfSize:_xLineTitleFontSize];
        label.numberOfLines = 0;
        label.center = label_center;
        [self addSubview:label];
        
        //根据item个数,设置x轴长度
        if (i == self.xLineTitleArray.count - 1) {
            self.axisLine.xLineWidth = CGRectGetMaxX(label.frame) + XLineItemGapLength - self.axisLine.xLineStartXPos;
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.axisLine.xLineEndXPos, self.frame.size.height);
        }
    }
}

/**
 *  设置x轴valueLabel
 */
- (void)setXLineValueLabel{
    for (NSInteger i = 0; i < self.xLineValueArray.count; i++) {
        CGFloat xPos = self.axisLine.xLineStartXPos + XLineItemGapLength + (XLineItemWidth + XLineItemGapLength) * i;
        CGFloat yPos = self.axisLine.xLineStartYPos + 5 + _xLineLabelHeight;
        CGFloat width = XLineItemWidth;
        CGFloat height = _xLineLabelHeight;
        
        //label的中心点
        CGPoint label_center = CGPointMake(xPos + width * 0.5, yPos + height * 0.5);
        CGRect rect = [self.xLineValueArray[i] stringWidthRectWithSize:CGSizeMake(width + XLineItemGapLength * 0.5, height) fontOfSize:_xLineValueFontSize isBold:NO];
        ZFLabel * label = [[ZFLabel alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
        label.text = self.xLineValueArray[i];
        label.font = [UIFont systemFontOfSize:_xLineValueFontSize];
        label.numberOfLines = 0;
        label.center = label_center;
        [self addSubview:label];
    }
}

/**
 *  设置y轴valueLabel
 */
- (void)setYLineValueLabel{
    for (NSInteger i = 0; i <= _yLineSectionCount; i++) {
        CGFloat width = self.axisLine.yLineStartXPos;
        CGFloat height = self.axisLine.yLineSectionHeightAverage;
        CGFloat yStartPos = self.axisLine.yLineStartYPos - height / 2 - height * i;
        
        ZFLabel * label = [[ZFLabel alloc] initWithFrame:CGRectMake(0, yStartPos, width, height)];
        //平均值
        float valueAverage = _yLineMaxValue / _yLineSectionCount;
        label.text = [NSString stringWithFormat:@"%.0f",valueAverage * i];
        [self addSubview:label];
    }
}

/**
 *  清除之前所有Label
 */
- (void)removeAllLabel{
    for (UIView * view in self.subviews) {
        if ([view isKindOfClass:[ZFLabel class]]) {
            [(ZFLabel *)view removeFromSuperview];
        }
    }
}

#pragma mark - public method

/**
 *  重绘
 */
- (void)strokePath{
    self.axisLine.yLineSectionCount = _yLineSectionCount;
    
    [self removeAllLabel];
    [self setXLineTitleLabel];
    [self setXLineValueLabel];
    [self setYLineValueLabel];
    [self.axisLine strokePath];
}

#pragma mark - 重写setter,getter方法

/**
 *  获取坐标轴起点x值
 */
- (CGFloat)axisStartXPos{
    return self.axisLine.yLineStartXPos;
}

/**
 *  获取坐标轴起点Y值
 */
- (CGFloat)axisStartYPos{
    return self.axisLine.yLineStartYPos;
}

/**
 *  获取y轴最大上限值y值
 */
- (CGFloat)yLineMaxValueYPos{
    return self.axisLine.yLineEndYPos + ZFAxisLineGapFromYLineMaxValueToArrow;
}

/**
 *  获取y轴最大上限值与0值的高度
 */
- (CGFloat)yLineMaxValueHeight{
    return self.axisLine.yLineStartYPos - (self.axisLine.yLineEndYPos + ZFAxisLineGapFromYLineMaxValueToArrow);
}

/** y轴结束Y位置(从数学坐标轴(0.0)(左下角)开始) */
- (CGFloat)yLineEndYPos{
    return self.axisLine.yLineEndYPos;
}

@end
