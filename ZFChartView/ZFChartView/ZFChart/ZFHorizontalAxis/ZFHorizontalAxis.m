//
//  ZFHorizontalAxis.m
//  ZFChartView
//
//  Created by apple on 16/5/30.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ZFHorizontalAxis.h"
#import "ZFConst.h"
#import "ZFLabel.h"
#import "NSString+Zirkfied.h"
#import "ZFColor.h"

@interface ZFHorizontalAxis()<UIScrollViewDelegate>

/** 动画时间 */
@property (nonatomic, assign) CGFloat animationDuration;
/** 记录y轴原始的yPos */
@property (nonatomic, assign) CGFloat tempXAxisLineOriginYPos;
/** y轴单位Label */
@property (nonatomic, strong) ZFLabel * unitLabel;
/** 存储分段线的数组 */
@property (nonatomic, strong) NSMutableArray * sectionArray;
/** 顶部遮罩层 */
@property (nonatomic, strong) UIView * maskView;

@end

@implementation ZFHorizontalAxis

/**
 *  初始化默认变量
 */
- (void)commonInit{
    _xLineMinValue = 0;
    _xLineSectionCount = 5;
    _yLineNameFont = [UIFont systemFontOfSize:10.f];
    _xLineValueFont = [UIFont systemFontOfSize:10.f];
    _animationDuration = 1.f;
    _groupHeight = ZFAxisLineItemWidth;
    _groupPadding = ZFAxisLinePaddingForGroupsLength;
    _unitColor = ZFBlack;
    _yLineNameColor = ZFBlack;
    _xLineValueColor = ZFBlack;
    _axisLineBackgroundColor = ZFWhite;
    _separateColor = ZFLightGray;
    
    self.delegate = self;
    self.showsVerticalScrollIndicator = NO;
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
    //y轴
    self.yAxisLine = [[ZFYAxisLine alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height) direction:kAxisDirectionHorizontal];
    self.yAxisLine.backgroundColor = _axisLineBackgroundColor;
    [self addSubview:self.yAxisLine];
    
    //x轴
    self.xAxisLine = [[ZFXAxisLine alloc] initWithFrame:CGRectMake(0, self.bounds.size.height * ZFAxisLineHorizontalEndRatio, self.bounds.size.width, self.bounds.size.height - self.bounds.size.height * ZFAxisLineHorizontalEndRatio) direction:kAxisDirectionHorizontal];
    self.xAxisLine.backgroundColor = _axisLineBackgroundColor;
    [self addSubview:self.xAxisLine];
    
    //顶部遮罩层
    self.maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.yAxisLine.yLineArrowTopYPos)];
    self.maskView.backgroundColor = _axisLineBackgroundColor;
    [self addSubview:self.maskView];
}

#pragma mark - x轴单位Label

/**
 *  x轴单位Label
 */
- (void)addUnitLabel{
    if (_unit) {
        ZFLabel * lastLabel = (ZFLabel *)[self.xAxisLine viewWithTag:ZFAxisLineValueLabelTag + _xLineSectionCount];
        
        CGFloat width = self.xAxisLine.bounds.size.width - CGRectGetMaxX(lastLabel.frame);
        CGFloat height = self.xAxisLine.bounds.size.height;
        CGFloat xPos = CGRectGetMaxX(lastLabel.frame);
        CGFloat yPos = 0;
        
        self.unitLabel = [[ZFLabel alloc] initWithFrame:CGRectMake(xPos, yPos, width, height)];
        self.unitLabel.text = [NSString stringWithFormat:@"(%@)",_unit];
        self.unitLabel.textColor = _unitColor;
        self.unitLabel.font = [UIFont boldSystemFontOfSize:10];
        [self.xAxisLine addSubview:self.unitLabel];
    }
}

#pragma mark - 设置y轴标题Label

/**
 *  设置y轴标题Label
 */
- (void)setYLineNameLabel{
    if (self.yLineNameArray.count > 0) {
        for (NSInteger i = 0; i < self.yLineNameArray.count; i++) {
            CGFloat width = self.axisStartXPos;
            CGFloat height = _groupHeight;
            CGFloat center_xPos = width * 0.5;
            CGFloat center_yPos = self.yAxisLine.yLineStartYPos - _groupPadding - (_groupHeight + _groupPadding) * i - height * 0.5;
            
            //label的中心点
            CGPoint label_center = CGPointMake(center_xPos, center_yPos);
            CGRect rect = [self.yLineNameArray[i] stringWidthRectWithSize:CGSizeMake(width, height + _groupPadding * 0.5) font:_yLineNameFont];
            ZFLabel * label = [[ZFLabel alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
            label.text = self.yLineNameArray[i];
            label.textColor = _yLineNameColor;
            label.font = _yLineNameFont;
            label.center = label_center;
            [self.yAxisLine addSubview:label];
        }
    }
    
    self.contentSize = CGSizeMake(self.bounds.size.width, self.yAxisLine.frame.size.height);
    self.contentOffset = CGPointMake(self.contentOffset.x, self.contentSize.height - self.frame.size.height);
}

#pragma mark - 设置x轴valueLabel

/**
 *  设置x轴valueLabel
 */
- (void)setXLineValueLabel{
    for (NSInteger i = 0; i <= _xLineSectionCount; i++) {
        CGFloat width = self.xAxisLine.xLineSectionWidthAverage - 10 < 60 ? self.xAxisLine.xLineSectionWidthAverage - 10 : 60;
        CGFloat height = self.xAxisLine.frame.size.height;
        CGFloat center_xPos = self.xAxisLine.xLineStartXPos + self.xAxisLine.xLineSectionWidthAverage * i;
        CGFloat center_yPos = height * 0.5;
        
        ZFLabel * label = [[ZFLabel alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        //平均值
        float valueAverage = (_xLineMaxValue - _xLineMinValue) / _xLineSectionCount;
        
        if (_valueType == kValueTypeInteger) {
            label.text = [NSString stringWithFormat:@"%.0f", valueAverage * i + _xLineMinValue];
            
        }else if (_valueType == kValueTypeDecimal){
            label.text = [NSString stringWithFormat:@"%@", @(valueAverage * i + _xLineMinValue)];
            
        }
        
        label.textColor = _xLineValueColor;
        label.font = _xLineValueFont;
        label.center = CGPointMake(center_xPos, center_yPos);
        label.tag = ZFAxisLineValueLabelTag + i;
        [self.xAxisLine addSubview:label];
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
    CGFloat xStartPos = self.xAxisLine.xLineStartXPos + (self.xAxisLine.xLineWidth - ZFAxisLineGapFromAxisLineMaxValueToArrow) / _xLineSectionCount * (i + 1);
    [bezier moveToPoint:CGPointMake(self.xAxisLine.xLineStartXPos, xStartPos)];
    [bezier addLineToPoint:CGPointMake(self.xAxisLine.xLineStartXPos, xStartPos)];
    
    return bezier;
}

/**
 *  画x轴灰色分割线
 *
 *  @param i 下标
 *
 *  @return UIBezierPath
 */
- (UIBezierPath *)drawXAxisLineSection:(NSInteger)i sectionLength:(CGFloat)sectionLength{
    UIBezierPath * bezier = [UIBezierPath bezierPath];
    CGFloat xStartPos = self.xAxisLine.xLineStartXPos + (self.xAxisLine.xLineWidth - ZFAxisLineGapFromAxisLineMaxValueToArrow) / _xLineSectionCount * (i + 1);
    [bezier moveToPoint:CGPointMake(xStartPos, self.yAxisLine.yLineStartYPos + self.contentOffset.y)];
    [bezier addLineToPoint:CGPointMake(xStartPos, self.yAxisLine.yLineEndYPos)];
    
    return bezier;
}

/**
 *  x轴灰色分割线CAShapeLayer
 *
 *  @param i 下标
 *
 *  @return CAShapeLayer
 */
- (CAShapeLayer *)xAxisLineSectionShapeLayer:(NSInteger)i sectionLength:(CGFloat)sectionLength sectionColor:(UIColor *)sectionColor{
    CAShapeLayer * layer = [CAShapeLayer layer];
    layer.strokeColor = sectionColor.CGColor;
    layer.path = [self drawXAxisLineSection:i sectionLength:sectionLength].CGPath;
    
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
    CGFloat yStartPos = self.yAxisLine.yLineStartYPos - _groupPadding - (_groupHeight + _groupPadding) * i - _groupHeight * 0.5;
    [bezier moveToPoint:CGPointMake(self.xAxisLine.xLineStartXPos, yStartPos)];
    [bezier addLineToPoint:CGPointMake(self.xAxisLine.xLineStartXPos, yStartPos)];
    
    return bezier;
}

/**
 *  画y轴灰色分割线
 *
 *  @param i 下标
 *
 *  @return UIBezierPath
 */
- (UIBezierPath *)drawYAxisLineSection:(NSInteger)i{
    UIBezierPath * bezier = [UIBezierPath bezierPath];
    CGFloat yStartPos = self.yAxisLine.yLineStartYPos - _groupPadding - (_groupHeight + _groupPadding) * i - _groupHeight * 0.5;
    [bezier moveToPoint:CGPointMake(self.xAxisLine.xLineStartXPos, yStartPos)];
    [bezier addLineToPoint:CGPointMake(self.xAxisLine.xLineEndXPos, yStartPos)];
    
    return bezier;
}

/**
 *  y轴灰色分割线CAShapeLayer
 *
 *  @param i 下标
 *
 *  @return CAShapeLayer
 */
- (CAShapeLayer *)yAxisLineSectionShapeLayer:(NSInteger)i sectionColor:(UIColor *)sectionColor{
    CAShapeLayer * layer = [CAShapeLayer layer];
    layer.strokeColor = sectionColor.CGColor;
    layer.path = [self drawYAxisLineSection:i].CGPath;
    
    return layer;
}

#pragma mark - x轴分段线

/**
 *  x轴分段线
 */
- (UIView *)sectionView:(NSInteger)i{
    CGFloat xStartPos = self.xAxisLine.xLineStartXPos + (self.xAxisLine.xLineWidth - ZFAxisLineGapFromAxisLineMaxValueToArrow) / _xLineSectionCount * (i + 1);
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(xStartPos, self.yAxisLine.yLineStartYPos - ZFAxisLineSectionLength, ZFAxisLineSectionHeight, ZFAxisLineSectionLength)];
    view.backgroundColor = _xAxisColor;
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
    self.xAxisLine.xLineSectionCount = _xLineSectionCount;
    
    if (self.yLineNameArray.count > 0) {
        //根据item个数,设置y轴高度
        self.yAxisLine.yLineHeight = self.yLineNameArray.count * (_groupHeight + _groupPadding) + _groupPadding;
        self.xAxisLine.frame = CGRectMake(self.xAxisLine.frame.origin.x, self.yAxisLine.yLineStartYPos, self.xAxisLine.frame.size.width, self.xAxisLine.frame.size.height);
        _tempXAxisLineOriginYPos = self.xAxisLine.frame.origin.y;
    }
    
    self.xAxisLine.isAnimated = _isAnimated;
    self.yAxisLine.isAnimated = _isAnimated;
    self.yAxisLine.isShowAxisArrows = _isShowAxisArrows;
    self.xAxisLine.isShowAxisArrows = _isShowAxisArrows;
    [self.yAxisLine strokePath];
    [self.xAxisLine strokePath];
    [self setYLineNameLabel];
    [self setXLineValueLabel];
    [self addUnitLabel];
    
    for (NSInteger i = 0; i < _xLineSectionCount; i++) {
        if (_isShowXLineSeparate) {
            [self.layer addSublayer:[self xAxisLineSectionShapeLayer:i sectionLength:self.yLineHeight sectionColor:_separateColor]];
        }else{
            UIView * sectionView = [self sectionView:i];
            [self addSubview:sectionView];
            [self.sectionArray addObject:sectionView];
        }
    }
    
    for (NSInteger i = 0; i < self.yLineNameArray.count; i++) {
        if (_isShowYLineSeparate) {
            [self.layer addSublayer:[self yAxisLineSectionShapeLayer:i sectionColor:_separateColor]];
        }
    }
}

/**
 *  把分段线放的父控件最上面
 */
- (void)bringSectionToFront{
    if (!_isShowXLineSeparate) {
        for (NSInteger i = 0; i < self.sectionArray.count; i++) {
            UIView * sectionView = self.sectionArray[i];
            [self bringSubviewToFront:sectionView];
        }
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat yPos = _tempXAxisLineOriginYPos - (self.contentSize.height - self.frame.size.height - scrollView.contentOffset.y);
    
    //滚动时重设y轴的frame
    self.xAxisLine.frame = CGRectMake(self.xAxisLine.frame.origin.x, yPos, self.xAxisLine.frame.size.width, self.xAxisLine.frame.size.height);
    
    //滚动时重设分段线的frame
    if (!_isShowXLineSeparate) {
        for (NSInteger i = 0; i < self.sectionArray.count; i++) {
            UIView * sectionView = self.sectionArray[i];
            sectionView.frame = CGRectMake(sectionView.frame.origin.x, yPos - ZFAxisLineSectionLength, sectionView.frame.size.width, sectionView.frame.size.height);
        }
    }
    
    //顶部遮罩层
    self.maskView.frame = CGRectMake(self.maskView.frame.origin.x, scrollView.contentOffset.y, self.maskView.frame.size.width, self.maskView.frame.size.height);
}

#pragma mark - 重写setter,getter方法

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    self.xAxisLine.frame = CGRectMake(0, self.bounds.size.height * ZFAxisLineHorizontalEndRatio, self.bounds.size.width, self.bounds.size.height - self.bounds.size.height * ZFAxisLineHorizontalEndRatio);    
    self.yAxisLine.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    self.maskView.frame = CGRectMake(0, 0, self.frame.size.width, self.yAxisLine.yLineArrowTopYPos);
}

/** 
 *  y轴背景颜色 
 */
- (void)setAxisLineBackgroundColor:(UIColor *)axisLineBackgroundColor{
    _axisLineBackgroundColor = axisLineBackgroundColor;
    self.yAxisLine.backgroundColor = _axisLineBackgroundColor;
    self.xAxisLine.backgroundColor = _axisLineBackgroundColor;
    self.maskView.backgroundColor = _axisLineBackgroundColor;
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
    return self.yAxisLine.yLineStartXPos;
}

/**
 *  获取坐标轴起点Y值
 */
- (CGFloat)axisStartYPos{
    return self.yAxisLine.yLineStartYPos;
}

/**
 *  获取x轴最大上限值x值
 */
- (CGFloat)xLineMaxValueXPos{
    return self.xAxisLine.xLineEndYPos - ZFAxisLineGapFromAxisLineMaxValueToArrow;
}

/**
 *  获取x轴最大上限值与0值的宽度
 */
- (CGFloat)xLineMaxValueWidth{
    return self.xAxisLine.xLineEndXPos - ZFAxisLineGapFromAxisLineMaxValueToArrow - self.xAxisLine.xLineStartXPos;
}

/**
 *  获取y轴宽度
 */
- (CGFloat)yLineHeight{
    return self.yAxisLine.yLineHeight;
}

#pragma mark - 懒加载

- (NSMutableArray *)sectionArray{
    if (!_sectionArray) {
        _sectionArray = [NSMutableArray array];
    }
    
    return _sectionArray;
}

@end
