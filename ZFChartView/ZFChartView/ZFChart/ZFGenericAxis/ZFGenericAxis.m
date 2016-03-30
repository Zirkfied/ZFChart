//
//  ZFGenericAxis.m
//  ZFChartView
//
//  Created by apple on 16/3/18.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ZFGenericAxis.h"
#import "ZFConst.h"
#import "ZFLabel.h"
#import "NSString+Zirkfied.h"

@interface ZFGenericAxis()<UIScrollViewDelegate>

/** x轴label高度 */
@property (nonatomic, assign) CGFloat xLineLabelHeight;
/** y轴单位Label */
@property (nonatomic, strong) ZFLabel * unitLabel;

@end

@implementation ZFGenericAxis

/**
 *  初始化默认变量
 */
- (void)commonInit{
    _yLineSectionCount = 5;
    _xLineLabelHeight = 30.f;
    _xLineNameFontSize = 10.f;
    _yLineValueFontSize = 10.f;
    _groupWidth = XLineItemWidth;
    _groupPadding = XLinePaddingForGroupsLength;
    _axisLineBackgroundColor = ZFWhite;
    _isShowSeparate = NO;
    
    self.delegate = self;
    self.showsHorizontalScrollIndicator = NO;
    self.bounces = NO;
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
    //x轴
    self.xAxisLine = [[ZFXAxisLine alloc] initWithFrame:self.bounds];
    self.xAxisLine.backgroundColor = _axisLineBackgroundColor;
    [self addSubview:self.xAxisLine];
    
    //y轴
    self.yAxisLine = [[ZFYAxisLine alloc] initWithFrame:CGRectMake(0, 0, ZFAxisLineStartXPos + YLineSectionLength, self.bounds.size.height)];
    self.yAxisLine.backgroundColor = _axisLineBackgroundColor;
    self.yAxisLine.alpha = 1;
    [self addSubview:self.yAxisLine];
}

#pragma mark - y轴单位Label

/**
 *  y轴单位Label
 */
- (void)addUnitLabel{
    ZFLabel * lastLabel = (ZFLabel *)[self.yAxisLine viewWithTag:YLineValueLabelTag + _yLineSectionCount];
    
    CGFloat width = self.yAxisLine.yLineStartXPos;
    CGFloat height = self.yAxisLine.yLineSectionHeightAverage;
    CGFloat xPos = 0;
    CGFloat yPos = CGRectGetMinY(lastLabel.frame) - height;
    
    self.unitLabel = [[ZFLabel alloc] initWithFrame:CGRectMake(xPos, yPos, width, height)];
    self.unitLabel.text = [NSString stringWithFormat:@"(%@)",_unit];
    self.unitLabel.font = [UIFont boldSystemFontOfSize:10];
    [self.yAxisLine addSubview:self.unitLabel];
}

#pragma mark - 设置x轴标题Label

/**
 *  设置x轴标题Label
 */
- (void)setXLineNameLabel{
    if (self.xLineNameArray.count > 0) {
        for (NSInteger i = 0; i < self.xLineNameArray.count; i++) {
            CGFloat width = _groupWidth;
            CGFloat height = _xLineLabelHeight;
            CGFloat center_xPos = self.xAxisLine.xLineStartXPos + _groupPadding + (_groupWidth + _groupPadding) * i + width * 0.5;
            CGFloat center_yPos = self.yAxisLine.yLineStartYPos + 20 + height * 0.5;
            
            //label的中心点
            CGPoint label_center = CGPointMake(center_xPos, center_yPos);
            CGRect rect = [self.xLineNameArray[i] stringWidthRectWithSize:CGSizeMake(width + _groupPadding * 0.5, height) fontOfSize:_xLineNameFontSize isBold:NO];
            ZFLabel * label = [[ZFLabel alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
            label.text = self.xLineNameArray[i];
            label.font = [UIFont systemFontOfSize:_xLineNameFontSize];
            label.numberOfLines = 0;
            label.center = label_center;
            [self.xAxisLine addSubview:label];
        }
    }
    
    self.contentSize = CGSizeMake(self.xAxisLine.frame.size.width, self.bounds.size.height);
}

#pragma mark - 设置y轴valueLabel

/**
 *  设置y轴valueLabel
 */
- (void)setYLineValueLabel{
    for (NSInteger i = 0; i <= _yLineSectionCount; i++) {
        CGFloat width = self.yAxisLine.yLineStartXPos;
        CGFloat height = self.yAxisLine.yLineSectionHeightAverage;
        CGFloat yStartPos = self.yAxisLine.yLineStartYPos - height / 2 - height * i;
        
        ZFLabel * label = [[ZFLabel alloc] initWithFrame:CGRectMake(0, yStartPos, width, height)];
        //平均值
        float valueAverage = _yLineMaxValue / _yLineSectionCount;
        label.text = [NSString stringWithFormat:@"%.0f",valueAverage * i];
        label.font = [UIFont systemFontOfSize:_yLineValueFontSize];
        label.tag = YLineValueLabelTag + i;
        [self.yAxisLine addSubview:label];
    }
}

#pragma mark - 灰色分割线

/**
 *  灰色分割线起始位置 (未填充)
 *
 *  @param i 下标
 *
 *  @return UIBezierPath
 */
- (UIBezierPath *)yAxisLineSectionNoFill:(NSInteger)i {
    UIBezierPath * bezier = [UIBezierPath bezierPath];
    CGFloat yStartPos = self.yAxisLine.yLineStartYPos - (self.yAxisLine.yLineHeight - ZFAxisLineGapFromYLineMaxValueToArrow) / _yLineSectionCount * (i + 1);
    [bezier moveToPoint:CGPointMake(self.yAxisLine.yLineStartXPos, yStartPos)];
    [bezier addLineToPoint:CGPointMake(self.yAxisLine.yLineStartXPos, yStartPos)];
    
    return bezier;
}

/**
 *  画灰色分割线
 *
 *  @param i 下标
 *
 *  @return UIBezierPath
 */
- (UIBezierPath *)drawYAxisLineSection:(NSInteger)i {
    UIBezierPath * bezier = [UIBezierPath bezierPath];
    CGFloat yStartPos = self.yAxisLine.yLineStartYPos - (self.yAxisLine.yLineHeight - ZFAxisLineGapFromYLineMaxValueToArrow) / _yLineSectionCount * (i + 1);
    [bezier moveToPoint:CGPointMake(self.yAxisLine.yLineStartXPos, yStartPos)];
    [bezier addLineToPoint:CGPointMake(self.yAxisLine.yLineStartXPos + self.xLineWidth, yStartPos)];
    
    return bezier;
}

/**
 *  灰色分割线CAShapeLayer
 *
 *  @param i 下标
 *
 *  @return CAShapeLayer
 */
- (CAShapeLayer *)yAxisLineSectionShapeLayer:(NSInteger)i {
    CAShapeLayer * layer = [CAShapeLayer layer];
    layer.strokeColor = [UIColor lightGrayColor].CGColor;
    layer.path = [self drawYAxisLineSection:i].CGPath;
    
    return layer;
}

#pragma mark - 清除控件

/**
 *  清除之前所有Label
 */
- (void)removeAllLabel{
    NSArray * subviews1 = [NSArray arrayWithArray:self.xAxisLine.subviews];
    for (UIView * view in subviews1) {
        if ([view isKindOfClass:[ZFLabel class]]) {
            [(ZFLabel *)view removeFromSuperview];
        }
    }
    
    NSArray * subviews2 = [NSArray arrayWithArray:self.yAxisLine.subviews];
    for (UIView * view in subviews2) {
        if ([view isKindOfClass:[ZFLabel class]]) {
            [(ZFLabel *)view removeFromSuperview];
        }
    }
    
    NSArray * sublayers = [NSArray arrayWithArray:self.layer.sublayers];
    for (CALayer * layer in sublayers) {
        if ([layer isKindOfClass:[CAShapeLayer class]]) {
            [layer removeFromSuperlayer];
        }
    }
}

#pragma mark - public method

/**
 *  重绘
 */
- (void)strokePath{
    [self removeAllLabel];
    self.yAxisLine.yLineSectionCount = _yLineSectionCount;
    
    if (self.xLineNameArray.count > 0) {
        //根据item个数,设置x轴长度
        self.xAxisLine.xLineWidth = self.xLineNameArray.count * (_groupWidth + _groupPadding) + _groupPadding;
    }
    
    [self.xAxisLine strokePath];
    [self.yAxisLine strokePath];
    
    if (_isShowSeparate) {
        for (NSInteger i = 0; i < _yLineSectionCount; i++) {
            [self.layer addSublayer:[self yAxisLineSectionShapeLayer:i]];
        }
    }
    
    [self setXLineNameLabel];
    [self setYLineValueLabel];
    [self addUnitLabel];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //滚动时重设y轴的frame
    self.yAxisLine.frame = CGRectMake(scrollView.contentOffset.x, self.yAxisLine.frame.origin.y, self.yAxisLine.frame.size.width, self.yAxisLine.frame.size.height);
}

#pragma mark - 重写setter,getter方法

/** y轴背景颜色 */
- (void)setAxisLineBackgroundColor:(UIColor *)axisLineBackgroundColor{
    _axisLineBackgroundColor = axisLineBackgroundColor;
    self.yAxisLine.backgroundColor = _axisLineBackgroundColor;
    self.xAxisLine.backgroundColor = _axisLineBackgroundColor;
}

/**
 *  获取坐标轴起点x值
 */
- (CGFloat)axisStartXPos{
    return self.xAxisLine.xLineStartXPos;
}

/**
 *  获取坐标轴起点Y值
 */
- (CGFloat)axisStartYPos{
    return self.xAxisLine.xLineStartYPos;
}

/**
 *  获取y轴最大上限值y值
 */
- (CGFloat)yLineMaxValueYPos{
    return self.yAxisLine.yLineEndYPos + ZFAxisLineGapFromYLineMaxValueToArrow;
}

/**
 *  获取y轴最大上限值与0值的高度
 */
- (CGFloat)yLineMaxValueHeight{
    return self.yAxisLine.yLineStartYPos - (self.yAxisLine.yLineEndYPos + ZFAxisLineGapFromYLineMaxValueToArrow);
}

/** 
 *  获取x轴宽度 
 */
- (CGFloat)xLineWidth{
    return self.xAxisLine.xLineWidth;
}

/**
 *  分段线颜色 
 */
- (void)setSectionColor:(UIColor *)sectionColor{
    _sectionColor = sectionColor;
    self.yAxisLine.sectionColor = _sectionColor;
}

@end
