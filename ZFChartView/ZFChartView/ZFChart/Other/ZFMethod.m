//
//  ZFMethod.m
//  ZFChartView
//
//  Created by apple on 16/3/17.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ZFMethod.h"
#import "ZFConst.h"

static ZFMethod * instance = nil;

@interface ZFMethod()
/** 记录当前遍历中显示的最大值 */
@property (nonatomic, assign) CGFloat tempMaxValue;
/** 记录当前遍历中显示的最小值 */
@property (nonatomic, assign) CGFloat tempMinValue;
/** 记录是否第一次调用方法，用于初始化tempMinValue */
@property (nonatomic, assign) BOOL isFirstTransfer;

@end

@implementation ZFMethod

+ (instancetype)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[super allocWithZone:NULL] init];
    });
    instance.tempMaxValue = 0;
    instance.isFirstTransfer = YES;
    return instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    return [ZFMethod shareInstance];
}

+ (instancetype)copyWithZone:(struct _NSZone *)zone{
    return [ZFMethod shareInstance];
}

/**
 *  计算颜色数量
 */
- (NSInteger)countColorCount:(NSArray *)array{
    id subOject = array.firstObject;
    if ([subOject isKindOfClass:[NSArray class]]){
        return array.count;
    }
    return 1;
}

/**
 *  存储随机颜色
 */
- (NSMutableArray *)cachedRandomColor:(NSArray *)array{
    NSInteger count = [self countColorCount:array];
    NSMutableArray * newArray = [NSMutableArray array];
    for (NSInteger i = 0; i < count; i++) {
        [newArray addObject:ZFRandom];
    }
    return newArray;
}

/**
 *  存储固定颜色
 */
- (NSMutableArray *)cachedColor:(UIColor *)color array:(NSArray *)array{
    NSMutableArray * newArray = [NSMutableArray array];
    for (NSInteger i = 0; i < array.count; i++) {
        [newArray addObject:color];
    }
    return newArray;
}

/**
 *  存储默认kChartValuePosition枚举类型(全部为kChartValuePositionDefalut)
 */
- (NSMutableArray *)cachedValuePositionInLineChart:(NSArray *)array{
    NSInteger count = [self countColorCount:array];
    NSMutableArray * newArray = [NSMutableArray array];
    for (NSInteger i = 0; i < count; i++) {
        [newArray addObject:@(kChartValuePositionDefalut)];
    }
    return newArray;
}

/**
 *  存储雷达图半径延伸长度，默认为25.f
 */
- (NSMutableArray *)cachedRadiusExtendLengthInRadarChart:(NSArray *)array{
    NSMutableArray * newArray = [NSMutableArray array];
    for (NSInteger i = 0; i < array.count; i++) {
        [newArray addObject:@(ZFRadarChartRadiusExtendLength)];
    }
    return newArray;
}

/**
 *  获取数据源最大值，并赋值给y轴显示的最大值
 */
- (CGFloat)cachedMaxValue:(NSMutableArray *)array{
    if (array.count > 0) {
        for (id subObject in array) {
            if ([subObject isKindOfClass:[NSString class]]) {
                CGFloat value = [subObject floatValue];
                if (value > _tempMaxValue) {
                    _tempMaxValue = value;
                }
                
            }else if([subObject isKindOfClass:[NSArray class]]){
                [self cachedMaxValue:subObject];
            }
        }
        return _tempMaxValue;
    }
    return 0;
}

/**
 *  获取数据源最小值，并赋值给y轴显示的最小值
 */
- (CGFloat)cachedMinValue:(NSMutableArray *)array{
    if (_isFirstTransfer) {
        _tempMinValue = [self cachedMaxValue:array];
        _isFirstTransfer = NO;
    }
    
    if (array.count > 0) {
        for (id subObject in array) {
            if ([subObject isKindOfClass:[NSString class]]) {
                CGFloat value = [subObject floatValue];
                if (value < _tempMinValue) {
                    _tempMinValue = value;
                }
                
            }else if([subObject isKindOfClass:[NSArray class]]){
                [self cachedMinValue:subObject];
            }
        }
        
        return _tempMinValue;
    }
    return 0.f;
}

@end
