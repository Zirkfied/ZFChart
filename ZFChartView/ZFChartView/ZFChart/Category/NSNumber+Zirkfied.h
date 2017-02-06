//
//  NSNumber+Zirkfied.h
//  ZFChartView
//
//  Created by apple on 2017/2/6.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface NSNumber (Zirkfied)

/** 四舍五入 */
+ (NSString *)roundOffValue:(NSNumber *)value numberOfdecimal:(CGFloat)numberOfdecimal;

@end
