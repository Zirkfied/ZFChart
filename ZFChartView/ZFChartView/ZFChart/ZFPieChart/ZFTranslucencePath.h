//
//  ZFTranslucencePath.h
//  ZFChartView
//
//  Created by apple on 16/2/23.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
#import "ZFPie.h"

@interface ZFTranslucencePath : CAShapeLayer

+ (instancetype)layerWithArcCenter:(CGPoint)center radius:(CGFloat)radius startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle clockwise:(BOOL)clockwise;

@end
