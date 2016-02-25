//
//  ZFBarChart.m
//  ZFChartView
//
//  Created by apple on 16/2/2.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ZFBarChart.h"
#import "ZFGenericChart.h"
#import "ZFBar.h"
#import "ZFConst.h"

@interface ZFBarChart()

/** 通用坐标轴图表 */
@property (nonatomic, strong) ZFGenericChart * genericChart;
/** 标题Label */
@property (nonatomic, strong) UILabel * titleLabel;

@end

@implementation ZFBarChart

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self drawGenericChart];
        self.showsHorizontalScrollIndicator = NO;
        
        //标题Label
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 30)];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:18.f];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.textColor = [UIColor redColor];
        [self addSubview:self.titleLabel];
    }
    
    return self;
}

#pragma mark - 坐标轴

/**
 *  画坐标轴
 */
- (void)drawGenericChart{
    self.genericChart = [[ZFGenericChart alloc] initWithFrame:self.bounds];
    [self addSubview:self.genericChart];
}

#pragma mark - 柱状条

/**
 *  画柱状条
 */
- (void)drawBar{
    [self removeAllBar];
    
    for (NSInteger i = 0; i < self.xLineValueArray.count; i++) {
        CGFloat xPos = self.genericChart.axisStartXPos + XLineItemGapLength + (XLineItemWidth + XLineItemGapLength) * i;
        CGFloat yPos = self.genericChart.yLineMaxValueYPos;
        CGFloat width = XLineItemWidth;
        CGFloat height = self.genericChart.yLineMaxValueHeight;
        
        ZFBar * bar = [[ZFBar alloc] initWithFrame:CGRectMake(xPos, yPos, width, height)];
        if ([self.xLineValueArray[i] floatValue] / _yLineMaxValue <= 1) {
            bar.percent = [self.xLineValueArray[i] floatValue] / _yLineMaxValue;
        }else{
            bar.percent = 1.f;
            bar.barBackgroundColor = [UIColor redColor];
        }
        [bar strokePath];
        [self addSubview:bar];
    }
}

/**
 *  清除之前所有柱状条
 */
- (void)removeAllBar{
    for (UIView * view in self.subviews) {
        if ([view isKindOfClass:[ZFBar class]]) {
            [(ZFBar *)view removeFromSuperview];
        }
    }
}

#pragma mark - public method

/**
 *  重绘
 */
- (void)strokePath{
    [self.genericChart strokePath];
    [self drawBar];
    self.contentSize = CGSizeMake(CGRectGetWidth(self.genericChart.frame), self.frame.size.height);
}

#pragma mark - 重写setter,getter方法

- (void)setXLineTitleArray:(NSMutableArray *)xLineTitleArray{
    _xLineTitleArray = xLineTitleArray;
    self.genericChart.xLineTitleArray = _xLineTitleArray;
}

- (void)setXLineValueArray:(NSMutableArray *)xLineValueArray{
    _xLineValueArray = xLineValueArray;
    self.genericChart.xLineValueArray = _xLineValueArray;
}

- (void)setYLineMaxValue:(float)yLineMaxValue{
    _yLineMaxValue = yLineMaxValue;
    self.genericChart.yLineMaxValue = _yLineMaxValue;
}

- (void)setYLineSectionCount:(NSInteger)yLineSectionCount{
    _yLineSectionCount = yLineSectionCount;
    self.genericChart.yLineSectionCount = _yLineSectionCount;
}

- (void)setTitle:(NSString *)title{
    _title = title;
    self.titleLabel.text = _title;
}

@end
