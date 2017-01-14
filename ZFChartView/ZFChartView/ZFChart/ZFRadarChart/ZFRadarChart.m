//
//  ZFRadarChart.m
//  ZFChartView
//
//  Created by apple on 16/9/6.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ZFRadarChart.h"
#import "ZFRadar.h"
#import "ZFPolygon.h"
#import "ZFLabel.h"
#import "ZFMethod.h"
#import "NSString+Zirkfied.h"

@interface ZFRadarChart()

/** 雷达图控件 */
@property (nonatomic, strong) ZFRadar * radar;
/** 半径 */
@property (nonatomic, assign) CGFloat radius;
/** 旋转手势 */
@property (nonatomic, strong) UIRotationGestureRecognizer * rotationGesture;
/** 存储数据的数组 */
@property (nonatomic, strong) NSMutableArray * valueArray;
/** 存储颜色的数组 */
@property (nonatomic, strong) NSMutableArray * colorArray;
/** 存储itemLabel的数组 */
@property (nonatomic, strong) NSMutableArray * itemLabelArray;
/** 记录数值显示的最大值 */
@property (nonatomic, assign) CGFloat maxValue;
/** 记录数值显示的最小值 */
@property (nonatomic, assign) CGFloat minValue;
/** 记录最终旋转角度 */
@property (nonatomic, assign) CGFloat finalRotationAngle;
/** 分段数值开始的角度 */
@property (nonatomic, assign) CGFloat valueStartAngle;
/** 存储分段数值的旋转角度 */
@property (nonatomic, assign) CGFloat valueRotationAngle;
/** 分段数值终点xPos */
@property (nonatomic, assign) CGFloat endXPos;
/** 分段数值终点yPos */
@property (nonatomic, assign) CGFloat endYPos;

@end

@implementation ZFRadarChart

/**
 *  初始化变量
 */
- (void)commonInit{
    _unit = nil;
    _itemTextColor = ZFBlack;
    _radarLineColor = ZFLightGray;
    _valueTextColor = ZFBlack;
    _radarLineWidth = 1.f;
    _separateLineWidth = 1.f;
    _polygonLineWidth = 1.f;
    _itemFont = [UIFont systemFontOfSize:15.f];
    _valueFont = [UIFont systemFontOfSize:10.f];
    _opacity = 0.3f;
    _isAnimated = YES;
    _finalRotationAngle = 0.f;
    _valueType = kValueTypeInteger;
    _isShowPolygonLine = YES;
    _isShowValue = YES;
    _valueStartAngle = -90.f;
    _valueRotationAngle = _valueStartAngle;
    _isShowSeparate = YES;
    _canRotation = YES;
    self.backgroundColor = ZFWhite;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
        [self setUp];
    }
    return self;
}

- (void)setUp{
    self.radar = [[ZFRadar alloc] initWithFrame:self.bounds];
    [self addSubview:self.radar];
    
    //旋转手势
    self.rotationGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotationAction:)];
    [self addGestureRecognizer:self.rotationGesture];
}

#pragma mark - 设置多边形

/**
 *  设置多边形
 */
- (void)setPolygon{
    id subObject = _valueArray.firstObject;
    //一组数据
    if ([subObject isKindOfClass:[NSString class]]) {
        CGFloat width = self.radar.radius * 2;
        CGFloat height = width;
        
        ZFPolygon * polygon = [[ZFPolygon alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        polygon.polygonColor = _colorArray.firstObject;
        polygon.center = self.radar.center;
        polygon.averageRadarAngle = self.radar.averageRadarAngle;
        polygon.maxValue = self.maxValue;
        polygon.minValue = self.minValue;
        polygon.maxRadius = self.radar.radius;
        polygon.isAnimated = _isAnimated;
        polygon.valueArray = _valueArray;
        polygon.opacity = _opacity;
        polygon.polygonLineColor = _colorArray.firstObject;
        polygon.polygonLineWidth = _polygonLineWidth;
        polygon.isShowPolygonLine = _isShowPolygonLine;
        [self.radar addSubview:polygon];
        [polygon strokePath];
    
    //多组数据
    }else if ([subObject isKindOfClass:[NSArray class]]){
        for (NSInteger i = 0; i < _valueArray.count; i++) {
            CGFloat width = self.radar.radius * 2;
            CGFloat height = width;
            
            ZFPolygon * polygon = [[ZFPolygon alloc] initWithFrame:CGRectMake(0, 0, width, height)];
            polygon.polygonColor = _colorArray[i];
            polygon.center = self.radar.center;
            polygon.averageRadarAngle = self.radar.averageRadarAngle;
            polygon.maxValue = self.maxValue;
            polygon.minValue = self.minValue;
            polygon.maxRadius = self.radar.radius;
            polygon.isAnimated = _isAnimated;
            polygon.valueArray = _valueArray[i];
            polygon.opacity = _opacity;
            polygon.polygonLineColor = _colorArray[i];
            polygon.polygonLineWidth = _polygonLineWidth;
            polygon.isShowPolygonLine = _isShowPolygonLine;
            [self.radar addSubview:polygon];
            [polygon strokePath];
        }
    }
}

#pragma mark - 设置item label

/**
 *  设置item label
 */
- (void)setItemLabelOnChart{
    for (NSInteger i = 0; i < self.radar.itemLabelCenterArray.count; i++) {
        CGPoint labelCenter = [self.radar.itemLabelCenterArray[i] CGPointValue];
        CGSize size = [self.radar.itemArray[i] stringWidthRectWithSize:CGSizeMake(self.bounds.size.width / 2 - self.radar.radius - 10, self.bounds.size.width / 2 - self.radar.radius - 10) font:_itemFont].size;
        
        ZFLabel * itemLabel = [[ZFLabel alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        itemLabel.center = labelCenter;
        itemLabel.font = _itemFont;
        itemLabel.text = self.radar.itemArray[i];
        itemLabel.textColor = _itemTextColor;
        itemLabel.transform = CGAffineTransformMakeRotation(-_finalRotationAngle);
        [self.radar addSubview:itemLabel];
        [self.itemLabelArray addObject:itemLabel];
        
        //添加点击手势
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemAction:)];
        itemLabel.userInteractionEnabled = YES;
        [itemLabel addGestureRecognizer:tap];
    }
}

#pragma mark - 点击事件

- (void)itemAction:(UITapGestureRecognizer *)sender{
    if ([self.delegate respondsToSelector:@selector(radarChart:didSelectItemLabelAtIndex:)]) {
        
        [self.delegate radarChart:self didSelectItemLabelAtIndex:[self.itemLabelArray indexOfObject:sender.view]];
    }
}

#pragma mark - 设置分段数值Label

/**
 *  设置分段数值Label
 */
- (void)setValueLabelOnChart{
    //平均值
    float valueAverage = (_maxValue - _minValue) / self.radar.sectionCount;
    
    for (NSInteger i = 0; i < self.radar.sectionCount + 1; i++) {
        //设置内容
        NSString * valueString = nil;
        
        if (_valueType == kValueTypeInteger) {
            valueString = [NSString stringWithFormat:@"%.0f", valueAverage * i + _minValue];
        }else if (_valueType == kValueTypeDecimal){
            valueString = [NSString stringWithFormat:@"%@", @(valueAverage * i + _minValue)];
        }
        
        if (_unit) {
            valueString = [NSString stringWithFormat:@"%@%@", valueString, _unit];
        }
        
        CGSize size = [valueString stringWidthRectWithSize:CGSizeMake(self.frame.size.width, 20) font:_valueFont].size;
        
        //计算旋转位置
        _radius = self.radar.averageRadius * i;
        
        if (_valueRotationAngle >= -90.f && _valueRotationAngle <= 0.f) {
            _endXPos = self.radar.center.x + fabs(-(_radius * ZFSin(fabs(_valueRotationAngle - (_valueStartAngle)))));
            _endYPos = self.radar.center.y - fabs(_radius * ZFCos(fabs(_valueRotationAngle - (_valueStartAngle))));
            
        }else if (_valueRotationAngle > 0.f && _valueRotationAngle <= 90.f){
            _endXPos = self.radar.center.x + fabs(-(_radius * ZFSin(fabs(_valueRotationAngle - (_valueStartAngle)))));
            _endYPos = self.radar.center.y + fabs(_radius * ZFCos(fabs(_valueRotationAngle - (_valueStartAngle))));
            
        }else if (_valueRotationAngle > 90.f && _valueRotationAngle <= 180.f){
            _endXPos = self.radar.center.x - fabs(-(_radius * ZFSin(fabs(_valueRotationAngle - (_valueStartAngle)))));
            _endYPos = self.radar.center.y + fabs(_radius * ZFCos(fabs(_valueRotationAngle - (_valueStartAngle))));
            
        }else if (_valueRotationAngle > 180.f && _valueRotationAngle < 270.f){
            _endXPos = self.radar.center.x - fabs(-(_radius * ZFSin(fabs(_valueRotationAngle - (_valueStartAngle)))));
            _endYPos = self.radar.center.y - fabs(_radius * ZFCos(fabs(_valueRotationAngle - (_valueStartAngle))));
        }
        
        ZFLabel * label = [[ZFLabel alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        label.center = CGPointMake(_endXPos, _endYPos);
        label.text = valueString;
        label.font = _valueFont;
        label.textColor = _valueTextColor;
        [self addSubview:label];
    }
}

#pragma mark - 清除控件

/**
 *  清除之前所有子控件
 */
- (void)removeAllSubviews{
    for (UIView * subview in self.radar.subviews) {
        [subview removeFromSuperview];
    }
    
    for (UIView * subview in self.subviews) {
        if (![subview isKindOfClass:[ZFRadar class]]) {
            [subview removeFromSuperview];
        }
    }
}

#pragma mark - public method

/**
 *  重绘
 */
- (void)strokePath{
    [self.valueArray removeAllObjects];
    [self.colorArray removeAllObjects];
    [self.itemLabelArray removeAllObjects];
    [self removeAllSubviews];
    
    if ([self.dataSource respondsToSelector:@selector(itemArrayInRadarChart:)]) {
        self.radar.itemArray = [NSMutableArray arrayWithArray:[self.dataSource itemArrayInRadarChart:self]];
    }
    
    if ([self.dataSource respondsToSelector:@selector(valueArrayInRadarChart:)]) {
        _valueArray = [NSMutableArray arrayWithArray:[self.dataSource valueArrayInRadarChart:self]];
    }
    
    if ([self.dataSource respondsToSelector:@selector(colorArrayInRadarChart:)]) {
        _colorArray = [NSMutableArray arrayWithArray:[self.dataSource colorArrayInRadarChart:self]];
    }else{
        _colorArray = [NSMutableArray arrayWithArray:[[ZFMethod shareInstance] cachedRandomColor:_valueArray]];
    }
    
    if (_isResetMaxValue) {
        if ([self.dataSource respondsToSelector:@selector(maxValueInRadarChart:)]) {
            _maxValue = [self.dataSource maxValueInRadarChart:self];
        }else{
            NSLog(@"请返回一个最大值");
            return;
        }
    }else{
        _maxValue = [[ZFMethod shareInstance] cachedMaxValue:_valueArray];
        
        if (_maxValue == 0.f) {
            if ([self.dataSource respondsToSelector:@selector(maxValueInRadarChart:)]) {
                _maxValue = [self.dataSource maxValueInRadarChart:self];
            }else{
                NSLog(@"当前所有数据的最大值为0, 请返回一个固定最大值, 否则没法绘画图表");
                return;
            }
        }
    }
    
    if (_isResetMinValue) {
        if ([self.dataSource respondsToSelector:@selector(minValueInRadarChart:)]) {
            if ([self.dataSource minValueInRadarChart:self] > [[ZFMethod shareInstance] cachedMinValue:_valueArray]) {
                _minValue = [[ZFMethod shareInstance] cachedMinValue:_valueArray];
                
            }else{
                _minValue = [self.dataSource minValueInRadarChart:self];
            }
            
        }else{
            _minValue = [[ZFMethod shareInstance] cachedMinValue:_valueArray];
        }
    }
    
    if ([self.dataSource respondsToSelector:@selector(minValueInRadarChart:)]) {
        _minValue = [self.dataSource minValueInRadarChart:self];
    }
    
    if ([self.delegate respondsToSelector:@selector(radiusForRadarChart:)]) {
        self.radar.radius = [self.delegate radiusForRadarChart:self];
    }
    
    if ([self.delegate respondsToSelector:@selector(sectionCountInRadarChart:)]) {
        self.radar.sectionCount = [self.delegate sectionCountInRadarChart:self];
    }
    
    if (self.radar.itemArray) {
        for (NSInteger i = 0; i < self.radar.itemArray.count; i++) {
            if ([self.delegate respondsToSelector:@selector(radiusExtendLengthForRadarChart:itemIndex:)]) {
                CGFloat radiusExtendLength = [self.delegate radiusExtendLengthForRadarChart:self itemIndex:i];
                [self.radar.radiusExtendLengthArray replaceObjectAtIndex:i withObject:@(radiusExtendLength)];
            }
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(valueRotationAngleForRadarChart:)]) {
        _valueRotationAngle = [self.delegate valueRotationAngleForRadarChart:self];
    }
    
    self.radar.radarLineColor = _radarLineColor;
    self.radar.radarLineWidth = _radarLineWidth;
    self.radar.separateLineWidth = _separateLineWidth;
    self.radar.isShowSeparate = _isShowSeparate;
    [self.radar strokePath];
    [self setItemLabelOnChart];
    [self setPolygon];
    _isShowValue ? [self setValueLabelOnChart] : nil;
    [self bringItemLabelToFront];
}

#pragma mark - 把item Label放在父控件最上面

- (void)bringItemLabelToFront{
    for (ZFLabel * itemLabel in self.itemLabelArray) {
        [self.radar bringSubviewToFront:itemLabel];
        itemLabel.transform = CGAffineTransformMakeRotation(-(_finalRotationAngle + self.rotationGesture.rotation));
    }
}

#pragma mark - 旋转事件(UIRotationGestureRecognizer)

- (void)rotationAction:(UIRotationGestureRecognizer *)sender{
    self.radar.transform = CGAffineTransformMakeRotation(_finalRotationAngle + sender.rotation);
    
    for (ZFLabel * itemLabel in self.itemLabelArray) {
        itemLabel.transform = CGAffineTransformMakeRotation(-(_finalRotationAngle + sender.rotation));
    }
    
    if (sender.state == UIGestureRecognizerStateEnded) {
        _finalRotationAngle += sender.rotation;
    }
}
    
#pragma mark - 重写setter,getter方法

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    self.radar.transform = CGAffineTransformIdentity;
    self.radar.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    self.radar.transform = CGAffineTransformMakeRotation(_finalRotationAngle + self.rotationGesture.rotation);
}

- (void)setCanRotation:(BOOL)canRotation{
    _canRotation = canRotation;
    self.rotationGesture.enabled = _canRotation ? YES : NO;
}

#pragma mark - 懒加载

- (NSMutableArray *)itemLabelArray{
    if (!_itemLabelArray) {
        _itemLabelArray = [NSMutableArray array];
    }
    return _itemLabelArray;
}

@end
