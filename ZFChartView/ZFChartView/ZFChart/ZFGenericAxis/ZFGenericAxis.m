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
#import "ZFColor.h"

@interface ZFGenericAxis()<UIScrollViewDelegate>

/** 动画时间 */
@property (nonatomic, assign) CGFloat animationDuration;
/** y轴单位Label */
@property (nonatomic, strong) ZFLabel * unitLabel;
/** 存储分段线的数组 */
@property (nonatomic, strong) NSMutableArray * sectionArray;

@end

@implementation ZFGenericAxis

/**
 *  初始化默认变量
 */
- (void)commonInit{
    _yLineMinValue = 0;
    _yLineSectionCount = 5;
    _xLineNameFont = [UIFont systemFontOfSize:10.f];
    _yLineValueFont = [UIFont systemFontOfSize:10.f];
    _animationDuration = 1.f;
    _groupWidth = ZFAxisLineItemWidth;
    _groupPadding = ZFAxisLinePaddingForGroupsLength;
    _unitColor = ZFBlack;
    _xLineNameColor = ZFBlack;
    _yLineValueColor = ZFBlack;
    _axisLineBackgroundColor = ZFWhite;
    _separateColor = ZFLightGray;
    
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
    self.xAxisLine = [[ZFXAxisLine alloc] initWithFrame:self.bounds direction:kAxisDirectionVertical];
    self.xAxisLine.backgroundColor = _axisLineBackgroundColor;
    [self addSubview:self.xAxisLine];
    
    //y轴
    self.yAxisLine = [[ZFYAxisLine alloc] initWithFrame:CGRectMake(0, 0, ZFAxisLineStartXPos, self.bounds.size.height) direction:kAxisDirectionVertical];
    self.yAxisLine.backgroundColor = _axisLineBackgroundColor;
    [self addSubview:self.yAxisLine];
}

#pragma mark - y轴单位Label

/**
 *  y轴单位Label
 */
- (void)addUnitLabel{
    if (_unit) {
        CGFloat width = self.yAxisLine.yLineStartXPos;
        CGFloat height = self.yAxisLine.yLineSectionHeightAverage;
        CGFloat center_xPos = self.yAxisLine.yLineStartXPos / 2;
        CGFloat center_yPos = self.yAxisLine.yLineEndYPos;
        
        self.unitLabel = [[ZFLabel alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        self.unitLabel.center = CGPointMake(center_xPos, center_yPos);
        self.unitLabel.text = [NSString stringWithFormat:@"(%@)",_unit];
        self.unitLabel.textColor = _unitColor;
        self.unitLabel.font = [UIFont boldSystemFontOfSize:10.f];
        [self.yAxisLine addSubview:self.unitLabel];
    }
}

#pragma mark - 设置x轴标题Label

/**
 *  设置x轴标题Label
 */
- (void)setXLineNameLabel{
    if (self.xLineNameArray.count > 0) {
        for (NSInteger i = 0; i < self.xLineNameArray.count; i++) {
            CGFloat width = _groupWidth;
            CGFloat height = self.frame.size.height - self.xAxisLine.xLineStartYPos - _xLineNameLabelToXAxisLinePadding;
            CGFloat center_xPos = self.xAxisLine.xLineStartXPos + _groupPadding + (_groupWidth + _groupPadding) * i + width * 0.5;
            CGFloat center_yPos = self.yAxisLine.yLineStartYPos + _xLineNameLabelToXAxisLinePadding + height * 0.5;

            //label的中心点
            CGPoint label_center = CGPointMake(center_xPos, center_yPos);
            CGRect rect = [self.xLineNameArray[i] stringWidthRectWithSize:CGSizeMake(width + _groupPadding * 0.5, height) font:_xLineNameFont];
            ZFLabel * label = [[ZFLabel alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
            label.text = self.xLineNameArray[i];
            label.textColor = _xLineNameColor;
            label.font = _xLineNameFont;
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
    //平均值
    float valueAverage = (_yLineMaxValue - _yLineMinValue) / _yLineSectionCount;
    
    for (NSInteger i = 0; i <= _yLineSectionCount; i++) {
        CGFloat width = self.yAxisLine.yLineStartXPos;
        CGFloat height = self.yAxisLine.yLineSectionHeightAverage;
        CGFloat yStartPos = self.yAxisLine.yLineStartYPos - height / 2 - height * i;
        
        ZFLabel * label = [[ZFLabel alloc] initWithFrame:CGRectMake(0, yStartPos, width, height)];
        
        if (_valueType == kValueTypeInteger) {
            label.text = [NSString stringWithFormat:@"%.0f", valueAverage * i + _yLineMinValue];
            
        }else if (_valueType == kValueTypeDecimal){
            label.text = [NSString stringWithFormat:@"%@", @(valueAverage * i + _yLineMinValue)];
            
        }
        
        label.textColor = _yLineValueColor;
        label.font = _yLineValueFont;
        label.tag = ZFAxisLineValueLabelTag + i;
        [self.yAxisLine addSubview:label];
    }
}

#pragma mark - x轴灰色分割线

/**
 *  x轴灰色分割线起始位置 (未填充)
 *
 *  @param i 下标
 *
 *  @return UIBezierPath
 */
- (UIBezierPath *)xAxisLineSectionNoFill:(NSInteger)i{
    UIBezierPath * bezier = [UIBezierPath bezierPath];
    CGFloat xStartPos = self.xAxisLine.xLineStartXPos + _groupPadding + (_groupWidth + _groupPadding) * i + _groupWidth * 0.5;
    [bezier moveToPoint:CGPointMake(xStartPos, self.yAxisLine.yLineStartYPos)];
    [bezier addLineToPoint:CGPointMake(xStartPos, self.yAxisLine.yLineStartYPos)];
    
    return bezier;
}

/**
 *  画x轴灰色分割线
 *
 *  @param i 下标
 *
 *  @return UIBezierPath
 */
- (UIBezierPath *)drawXAxisLineSection:(NSInteger)i{
    UIBezierPath * bezier = [UIBezierPath bezierPath];
    CGFloat xStartPos = self.xAxisLine.xLineStartXPos + _groupPadding + (_groupWidth + _groupPadding) * i + _groupWidth * 0.5;
    [bezier moveToPoint:CGPointMake(xStartPos, self.yAxisLine.yLineStartYPos)];
    [bezier addLineToPoint:CGPointMake(xStartPos, self.yLineMaxValueYPos)];
    
    return bezier;
}

/**
 *  x轴灰色分割线CAShapeLayer
 *
 *  @param i 下标
 *
 *  @return CAShapeLayer
 */
- (CAShapeLayer *)xAxisLineSectionShapeLayer:(NSInteger)i sectionColor:(UIColor *)sectionColor{
    CAShapeLayer * layer = [CAShapeLayer layer];
    layer.strokeColor = sectionColor.CGColor;
    layer.path = [self drawXAxisLineSection:i].CGPath;

    return layer;
}

#pragma mark - y轴灰色分割线

/**
 *  y轴灰色分割线起始位置 (未填充)
 *
 *  @param i 下标
 *
 *  @return UIBezierPath
 */
- (UIBezierPath *)yAxisLineSectionNoFill:(NSInteger)i{
    UIBezierPath * bezier = [UIBezierPath bezierPath];
    CGFloat yStartPos = self.yAxisLine.yLineStartYPos - (self.yAxisLine.yLineHeight - ZFAxisLineGapFromAxisLineMaxValueToArrow) / _yLineSectionCount * (i + 1);
    [bezier moveToPoint:CGPointMake(self.yAxisLine.yLineStartXPos, yStartPos)];
    [bezier addLineToPoint:CGPointMake(self.yAxisLine.yLineStartXPos, yStartPos)];
    
    return bezier;
}

/**
 *  画y轴灰色分割线
 *
 *  @param i 下标
 *
 *  @return UIBezierPath
 */
- (UIBezierPath *)drawYAxisLineSection:(NSInteger)i sectionLength:(CGFloat)sectionLength{
    UIBezierPath * bezier = [UIBezierPath bezierPath];
    CGFloat yStartPos = self.yAxisLine.yLineStartYPos - (self.yAxisLine.yLineHeight - ZFAxisLineGapFromAxisLineMaxValueToArrow) / _yLineSectionCount * (i + 1);
    [bezier moveToPoint:CGPointMake(self.yAxisLine.yLineStartXPos, yStartPos)];
    [bezier addLineToPoint:CGPointMake(self.yAxisLine.yLineStartXPos + sectionLength, yStartPos)];
    
    return bezier;
}

/**
 *  y轴灰色分割线CAShapeLayer
 *
 *  @param i 下标
 *
 *  @return CAShapeLayer
 */
- (CAShapeLayer *)yAxisLineSectionShapeLayer:(NSInteger)i sectionLength:(CGFloat)sectionLength sectionColor:(UIColor *)sectionColor{
    CAShapeLayer * layer = [CAShapeLayer layer];
    layer.strokeColor = sectionColor.CGColor;
    layer.path = [self drawYAxisLineSection:i sectionLength:sectionLength].CGPath;
    
    return layer;
}

#pragma mark - y轴分段线

/**
 *  y轴分段线
 */
- (UIView *)sectionView:(NSInteger)i{
    CGFloat yStartPos = self.yAxisLine.yLineStartYPos - (self.yAxisLine.yLineHeight - ZFAxisLineGapFromAxisLineMaxValueToArrow) / _yLineSectionCount * (i + 1);
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(self.yAxisLine.yLineStartXPos + self.contentOffset.x, yStartPos, ZFAxisLineSectionLength, ZFAxisLineSectionHeight)];
    view.backgroundColor = _yAxisColor;
    view.alpha = 0.f;
    
    if (_isAnimated) {
        [UIView animateWithDuration:_animationDuration animations:^{
            view.alpha = 1.f;
        }];
    }else{
        view.alpha = 1.f;
    }
    
    return view;
}

#pragma mark - 清除控件

/**
 *  清除之前所有控件
 */
- (void)removeAllSubviews{
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
    
    for (UIView * view in self.sectionArray) {
        [view removeFromSuperview];
    }
    [self.sectionArray removeAllObjects];
}

#pragma mark - public method

/**
 *  重绘
 */
- (void)strokePath{
    [self removeAllSubviews];
    [self.sectionArray removeAllObjects];
    self.yAxisLine.yLineSectionCount = _yLineSectionCount;
    
    if (self.xLineNameArray.count > 0) {
        //根据item个数,设置x轴长度
        self.xAxisLine.xLineWidth = self.xLineNameArray.count * (_groupWidth + _groupPadding) + _groupPadding;
    }
    
    self.xAxisLine.isAnimated = _isAnimated;
    self.yAxisLine.isAnimated = _isAnimated;
    self.xAxisLine.isShowAxisArrows = _isShowAxisArrows;
    self.yAxisLine.isShowAxisArrows = _isShowAxisArrows;
    [self.xAxisLine strokePath];
    [self.yAxisLine strokePath];
    [self setXLineNameLabel];
    [self setYLineValueLabel];
    [self addUnitLabel];
    
    for (NSInteger i = 0; i < _yLineSectionCount; i++) {
        if (_isShowYLineSeparate) {
            [self.layer addSublayer:[self yAxisLineSectionShapeLayer:i sectionLength:self.xLineWidth sectionColor:_separateColor]];
        }else{
            UIView * sectionView = [self sectionView:i];
            [self addSubview:sectionView];
            [self.sectionArray addObject:sectionView];
        }
    }
    
    for (NSInteger i = 0; i < self.xLineNameArray.count; i++) {
        if (_isShowXLineSeparate) {
            [self.layer addSublayer:[self xAxisLineSectionShapeLayer:i sectionColor:_separateColor]];
        }
    }
}

/**
 *  把分段线放在父控件最上面
 */
- (void)bringSectionToFront{
    if (!_isShowYLineSeparate) {
        for (NSInteger i = 0; i < self.sectionArray.count; i++) {
            UIView * sectionView = self.sectionArray[i];
            [self bringSubviewToFront:sectionView];
        }
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //滚动时重设y轴的frame
    self.yAxisLine.frame = CGRectMake(scrollView.contentOffset.x, self.yAxisLine.frame.origin.y, self.yAxisLine.frame.size.width, self.yAxisLine.frame.size.height);
    
    if (!_isShowYLineSeparate) {
        for (NSInteger i = 0; i < self.sectionArray.count; i++) {
            UIView * sectionView = self.sectionArray[i];
            sectionView.frame = CGRectMake(self.yAxisLine.yLineStartXPos + self.contentOffset.x, sectionView.frame.origin.y, sectionView.frame.size.width, sectionView.frame.size.height);
        }
    }
}

#pragma mark - 重写setter,getter方法

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    self.xAxisLine.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);    
    self.yAxisLine.frame = CGRectMake(self.contentOffset.x, 0, ZFAxisLineStartXPos, frame.size.height);
}

/** 
 *  y轴背景颜色 
 */
- (void)setAxisLineBackgroundColor:(UIColor *)axisLineBackgroundColor{
    _axisLineBackgroundColor = axisLineBackgroundColor;
    self.yAxisLine.backgroundColor = _axisLineBackgroundColor;
    self.xAxisLine.backgroundColor = _axisLineBackgroundColor;
}

/**
 *  设置x轴颜色
 */
- (void)setXAxisColor:(UIColor *)xAxisColor{
    _xAxisColor = xAxisColor;
    self.xAxisLine.axisColor = _xAxisColor;
}

/**
 *  设置y轴颜色
 */
- (void)setYAxisColor:(UIColor *)yAxisColor{
    _yAxisColor = yAxisColor;
    self.yAxisLine.axisColor = _yAxisColor;
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
    return self.yAxisLine.yLineEndYPos + ZFAxisLineGapFromAxisLineMaxValueToArrow;
}

/**
 *  获取y轴最大上限值与0值的高度
 */
- (CGFloat)yLineMaxValueHeight{
    return self.yAxisLine.yLineStartYPos - (self.yAxisLine.yLineEndYPos + ZFAxisLineGapFromAxisLineMaxValueToArrow);
}

/** 
 *  获取x轴宽度 
 */
- (CGFloat)xLineWidth{
    return self.xAxisLine.xLineWidth;
}

#pragma mark - 懒加载

- (NSMutableArray *)sectionArray{
    if (!_sectionArray) {
        _sectionArray = [NSMutableArray array];
    }
    
    return _sectionArray;
}

@end
