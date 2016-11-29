//
//  ZFWaveAttribute.h
//  ZFChartView
//
//  Created by apple on 2016/11/24.
//  Copyright © 2016年 apple. All rights reserved.
//

/**
 *  ZFWave曲线模型
 */

#import <Foundation/Foundation.h>

@interface ZFWaveAttribute : NSObject

/** 记录该段曲线或直线经过的所有点(数组里存的是NSValue) */
@property (nonatomic, strong) NSMutableArray * pointArray;
/** 记录该段是曲线还是直线(YES为曲线，NO为直线) */
@property (nonatomic, assign) BOOL isCurve;

@end
