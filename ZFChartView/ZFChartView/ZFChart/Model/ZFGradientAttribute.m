//
//  ZFGradientAttribute.m
//  ZFChartView
//
//  Created by apple on 2016/12/1.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ZFGradientAttribute.h"

@implementation ZFGradientAttribute

- (instancetype)init{
    self = [super init];
    if (self) {
        _startPoint = CGPointMake(0.5, 0);
        _endPoint = CGPointMake(0.5, 1);
    }
    return self;
}

- (NSArray *)colors{
    if (!_colors) {
        _colors = [NSArray array];
    }
    return _colors;
}

- (NSArray<NSNumber *> *)locations{
    if (!_locations) {
        _locations = [NSArray array];
    }
    return _locations;
}

@end
