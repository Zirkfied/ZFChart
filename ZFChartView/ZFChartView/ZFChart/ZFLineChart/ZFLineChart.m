
//
//  ZFLineChart.m
//  ZFChartView
//
//  Created by apple on 16/2/15.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ZFLineChart.h"
#import "ZFGenericChart.h"
#import "ZFLine.h"
#import "ZFCirque.h"
#import "ZFConst.h"

@interface ZFLineChart()

/** 通用坐标轴图表 */
@property (nonatomic, strong) ZFGenericChart * genericChart;
/** 存储圆环的数组 */
@property (nonatomic, strong) NSMutableArray * cirqueArray;
/** 标题Label */
@property (nonatomic, strong) UILabel * titleLabel;

@end

@implementation ZFLineChart

- (NSMutableArray *)cirqueArray{
    if (!_cirqueArray) {
        _cirqueArray = [NSMutableArray array];
    }
    return _cirqueArray;
}

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

#pragma mark - 画圆环和线

/**
 *  画圆环和线
 */
- (void)drawLineAndCirque{
    [self removeAllLineAndCirque];
    [self.cirqueArray removeAllObjects];
    
    //圆环
    for (NSInteger i = 0; i < self.xLineValueArray.count; i++) {
        BOOL isOverrun = NO;//记录是否超出上限
        CGFloat percent = [self.xLineValueArray[i] floatValue] / _yLineMaxValue;
        if (percent > 1) {
            percent = 1.f;
            isOverrun = YES;
        }
        
        CGFloat height = self.genericChart.yLineMaxValueHeight * percent;
        CGFloat y = self.genericChart.axisStartYPos - height;
        CGFloat x = self.genericChart.axisStartXPos + XLineItemGapLength + (XLineItemWidth + XLineItemGapLength) * i + XLineItemWidth / 2;
        
        ZFCirque * cirque = [[ZFCirque alloc] initWithFrame:CGRectMake(x, y, 0, 0)];
        //当前数值超过y轴显示上限时，圆环改为红色
        if (isOverrun == YES) {
            cirque.cirqueColor = [UIColor redColor];
        }
        [cirque strokePath];
        [self.genericChart addSubview:cirque];
        [self.cirqueArray addObject:cirque];
    }
    
    //线
    for (NSInteger i = 0; i < self.cirqueArray.count - 1; i++) {
        ZFCirque * cirque = self.cirqueArray[i];
        ZFCirque * nextCirque = self.cirqueArray[i+1];
        
        CGFloat end_XPos = fabs(cirque.center.x - nextCirque.center.x);
        CGFloat end_YPos = nextCirque.center.y - cirque.center.y;
        
        ZFLine * line = [[ZFLine alloc] initWithStartPoint:CGPointMake(cirque.center.x, cirque.center.y) endPoint:CGPointMake(end_XPos, end_YPos)];
        [line strokePath];
        [self.genericChart addSubview:line];
    }
}

/**
 *  清除之前所有圆环和线
 */
- (void)removeAllLineAndCirque{
    for (UIView * view in self.genericChart.subviews) {
        if ([view isKindOfClass:[ZFLine class]] || [view isKindOfClass:[ZFCirque class]]) {
            [view removeFromSuperview];
        }
    }
}

#pragma mark - public method

/**
 *  重绘
 */
- (void)strokePath{
    [self.genericChart strokePath];
    [self drawLineAndCirque];
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
