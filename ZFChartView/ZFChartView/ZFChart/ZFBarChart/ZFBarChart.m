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
#import "ZFLabel.h"
#import "NSString+Zirkfied.h"

@interface ZFBarChart()<UIScrollViewDelegate>

/** 通用坐标轴图表 */
@property (nonatomic, strong) ZFGenericChart * genericChart;
/** 标题Label */
@property (nonatomic, strong) UILabel * titleLabel;
/** 存储柱状条的数组 */
@property (nonatomic, strong) NSMutableArray * barArray;

@end

@implementation ZFBarChart

- (NSMutableArray *)barArray{
    if (!_barArray) {
        _barArray = [NSMutableArray array];
    }
    return _barArray;
}

/**
 *  初始化变量
 */
- (void)commonInit{
    _isShowValueOnChart = YES;
    _valueOnChartFontSize = 10.f;
    _isShadow = YES;
    _barColor = ZFDecimalColor(0, 0.68, 1, 1);
    _overMaxValueBarColor = ZFRed;
    self.showsHorizontalScrollIndicator = NO;
    self.delegate = self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
        [self drawGenericChart];
        
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
    [self removeLabelOnChart];
    
    for (NSInteger i = 0; i < self.xLineValueArray.count; i++) {
        CGFloat xPos = self.genericChart.axisStartXPos + XLineItemGapLength + (XLineItemWidth + XLineItemGapLength) * i;
        CGFloat yPos = self.genericChart.yLineMaxValueYPos;
        CGFloat width = XLineItemWidth;
        CGFloat height = self.genericChart.yLineMaxValueHeight;
        
        ZFBar * bar = [[ZFBar alloc] initWithFrame:CGRectMake(xPos, yPos, width, height)];
        //当前数值超过y轴显示上限时，柱状改为红色
        if ([self.xLineValueArray[i] floatValue] / _yLineMaxValue <= 1) {
            bar.percent = [self.xLineValueArray[i] floatValue] / _yLineMaxValue;
            bar.barColor = _barColor;
        }else{
            bar.percent = 1.f;
            bar.barColor = _overMaxValueBarColor;
        }
        bar.isShadow = _isShadow;
        [bar strokePath];
        [self.barArray addObject:bar];
        [self addSubview:bar];
    }
    
    _isShowValueOnChart ? [self showLabelOnChart] : nil;
}

/**
 *  显示bar上的label
 */
- (void)showLabelOnChart{
    for (NSInteger i = 0; i < self.barArray.count; i++) {
        ZFBar * bar = self.barArray[i];
        //label的中心点
        CGPoint label_center = CGPointMake(bar.center.x, bar.endYPos + self.genericChart.yLineEndYPos);
        CGRect rect = [self.xLineValueArray[i] stringWidthRectWithSize:CGSizeMake(XLineItemWidth + XLineItemGapLength * 0.5, 30) fontOfSize:_valueOnChartFontSize isBold:NO];
        ZFLabel * label = [[ZFLabel alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
        label.text = self.xLineValueArray[i];
        label.font = [UIFont systemFontOfSize:_valueOnChartFontSize];
        label.numberOfLines = 0;
        label.center = label_center;
        label.isFadeInAnimation = YES;
        [self addSubview:label];
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

/**
 *  清除圆环上的Label
 */
- (void)removeLabelOnChart{
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
    [self.genericChart strokePath];
    [self drawBar];
    self.contentSize = CGSizeMake(CGRectGetWidth(self.genericChart.frame), self.frame.size.height);
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //self滚动时，标题保持相对不动
    self.titleLabel.frame = CGRectMake(self.contentOffset.x, self.titleLabel.frame.origin.y, self.titleLabel.frame.size.width, self.titleLabel.frame.size.height);
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

- (void)setXLineTitleFontSize:(CGFloat)xLineTitleFontSize{
    _xLineTitleFontSize = xLineTitleFontSize;
    self.genericChart.xLineTitleFontSize = _xLineTitleFontSize;
}

- (void)setXLineValueFontSize:(CGFloat)xLineValueFontSize{
    _xLineValueFontSize = xLineValueFontSize;
    self.genericChart.xLineValueFontSize = _xLineValueFontSize;
}

@end
