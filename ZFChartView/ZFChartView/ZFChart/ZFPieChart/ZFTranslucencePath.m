//
//  ZFTranslucencePath.m
//  ZFChartView
//
//  Created by apple on 16/2/23.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ZFTranslucencePath.h"
#import "ZFConst.h"

@implementation ZFTranslucencePath

+ (instancetype)layerWithArcCenter:(CGPoint)center radius:(CGFloat)radius startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle clockwise:(BOOL)clockwise{
    return [[ZFTranslucencePath alloc] initWithArcCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:clockwise];
}

- (instancetype)initWithArcCenter:(CGPoint)center radius:(CGFloat)radius startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle clockwise:(BOOL)clockwise{
    self = [super init];
    if (self) {
        self.fillColor = nil;
        self.opacity = 0.5f;
        self.path = [self translucencePathWithArcCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:clockwise].CGPath;
    }
    return self;
}

- (UIBezierPath *)translucencePathWithArcCenter:(CGPoint)center radius:(CGFloat)radius startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle clockwise:(BOOL)clockwise{
    UIBezierPath * bezierPath = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:clockwise];
    return bezierPath;
}

@end
