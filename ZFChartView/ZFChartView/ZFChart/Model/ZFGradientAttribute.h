//
//  ZFGradientAttribute.h
//  ZFChartView
//
//  Created by apple on 2016/12/1.
//  Copyright © 2016年 apple. All rights reserved.
//

/**
 *  此类用于记录CAGradientLayer模型，以下属性赋值方式与CAGradientLayer类一致，具体参考Demo或CAGradientLayer的用法
 */

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface ZFGradientAttribute : NSObject

/** 颜色 */
@property(nonatomic, strong) NSArray * colors;
/** 区域 */
@property(nonatomic, strong) NSArray<NSNumber *> *locations;
/** 开始位置 */
@property(nonatomic, assign) CGPoint startPoint;
/** 结束位置 */
@property(nonatomic, assign) CGPoint endPoint;

@end
