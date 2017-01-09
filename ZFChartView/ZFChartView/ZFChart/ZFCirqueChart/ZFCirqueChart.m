//
//  ZFCirqueChart.m
//  ZFChartView
//
//  Created by apple on 2016/10/19.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ZFCirqueChart.h"
#import "ZFColor.h"
#import "ZFMethod.h"
#import "ZFConst.h"

@interface ZFCirqueChart()

/** 存储数据的数组 */
@property (nonatomic, strong) NSMutableArray * valueArray;
/** 存储颜色的数组 */
@property (nonatomic, strong) NSMutableArray * colorArray;
/** 记录数值的最大值 */
@property (nonatomic, assign) CGFloat maxValue;
/** 记录中心点与最内层圆的半径 */
@property (nonatomic, assign) CGFloat radius;
/** 记录圆环与圆环之间的间隔距离 */
@property (nonatomic, assign) CGFloat cirquePadding;
/** 记录圆环线宽 */
@property (nonatomic, assign) CGFloat lineWidth;

@end

@implementation ZFCirqueChart

/**
 *  初始化变量
 */
- (void)commonInit{
    _cirquePadding = 20.f;
    _lineWidth = 8.f;
    _shadowOpacity = 1.f;
    _isAnimated = YES;
    _cirquePatternType = kCirquePatternTypeForDefault;
    _cirqueStartOrientation = kCirqueStartOrientationOnTop;
    self.backgroundColor = ZFWhite;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)setUp{
    //计算Label宽度和高度
    CGFloat labelWidth = sqrt((_radius - _lineWidth / 2) * (_radius - _lineWidth / 2) + (_radius - _lineWidth / 2) * (_radius - _lineWidth / 2));
    self.textLabel.frame = CGRectMake(0, 0, labelWidth, labelWidth);
    self.textLabel.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    [self addSubview:self.textLabel];
}

#pragma mark - 设置圆环

/**
 *  设置圆环
 */
- (void)setCirque{
    for (NSInteger i = 0; i < _valueArray.count; i++) {
        ZFCirque * cirque = [[ZFCirque alloc] initWithFrame:self.frame];
        //计算百分比
        if ([_valueArray[i] floatValue] / _maxValue <= 1.f) {
            cirque.percent = [_valueArray[i] floatValue] / _maxValue;
        }else{
            cirque.percent = 1.f;
        }
        cirque.radius = _radius + (_cirquePadding * i);
        cirque.isAnimated = _isAnimated;
        cirque.cirquePatternType = _cirquePatternType;
        cirque.cirqueStartOrientation = _cirqueStartOrientation;
        cirque.lineWidth = _lineWidth;
        cirque.shadowOpacity = _shadowOpacity;
        cirque.pathColor = _colorArray[i];
        [cirque strokePath];
        [self addSubview:cirque];
    }
}

#pragma mark - 清除控件

/**
 *  清除之前所有子控件
 */
- (void)removeAllSubviews{
    for (UIView * subview in self.subviews) {
        [subview removeFromSuperview];
    }
}

#pragma mark - public method

/**
 *  重绘
 */
- (void)strokePath{
    [self.valueArray removeAllObjects];
    [self.colorArray removeAllObjects];
    [self removeAllSubviews];
    
    if ([self.dataSource respondsToSelector:@selector(valueArrayInCirqueChart:)]) {
        _valueArray = [NSMutableArray arrayWithArray:[self.dataSource valueArrayInCirqueChart:self]];
    }
    
    if ([self.dataSource respondsToSelector:@selector(colorArrayInCirqueChart:)]) {
        if ([[self.dataSource colorArrayInCirqueChart:self] isKindOfClass:[UIColor class]]) {
            _colorArray = [NSMutableArray arrayWithArray:[[ZFMethod shareInstance] cachedColor:[self.dataSource colorArrayInCirqueChart:self] array:_valueArray]];
            
        }else if ([[self.dataSource colorArrayInCirqueChart:self] isKindOfClass:[NSArray class]]){
            
            if ([[self.dataSource colorArrayInCirqueChart:self] count] != _valueArray.count) {
                NSLog(@"颜色个数越界，无法绘画，请检查返回的颜色个数是否与valueArray相同");
            }else{
                _colorArray = [NSMutableArray arrayWithArray:[self.dataSource colorArrayInCirqueChart:self]];
            }
            
        }
    }
    
    if (_isResetMaxValue) {
        if ([self.dataSource respondsToSelector:@selector(maxValueInCirqueChart:)]) {
            _maxValue = [self.dataSource maxValueInCirqueChart:self];
        }else{
            NSLog(@"请返回一个最大值");
            return;
        }
    }else{
        _maxValue = [[ZFMethod shareInstance] cachedMaxValue:_valueArray];
        
        if (_maxValue == 0.f) {
            if ([self.dataSource respondsToSelector:@selector(maxValueInCirqueChart:)]) {
                _maxValue = [self.dataSource maxValueInCirqueChart:self];
            }else{
                NSLog(@"当前所有数据的最大值为0, 请返回一个固定最大值, 否则没法绘画图表");
                return;
            }
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(radiusForCirqueChart:)]) {
        _radius = [self.delegate radiusForCirqueChart:self];
    }
    
    if ([self.delegate respondsToSelector:@selector(paddingForCirqueInCirqueChart:)]) {
        _cirquePadding = [self.delegate paddingForCirqueInCirqueChart:self];
    }
    
    if ([self.delegate respondsToSelector:@selector(lineWidthInCirqueChart:)]) {
        _lineWidth = [self.delegate lineWidthInCirqueChart:self];
    }
    
    [self setCirque];
    [self setUp];
}

#pragma mark - 懒加载

- (ZFLabel *)textLabel{
    if (!_textLabel) {
        _textLabel = [[ZFLabel alloc] init];
        _textLabel.font = [UIFont systemFontOfSize:13.f];
    }
    return _textLabel;
}

@end
