//
//  NSNumber+Zirkfied.m
//  ZFChartView
//
//  Created by apple on 2017/2/6.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "NSNumber+Zirkfied.h"

@implementation NSNumber (Zirkfied)

+ (NSString *)roundOffValue:(NSNumber *)value numberOfdecimal:(CGFloat)numberOfdecimal{
    NSNumberFormatter * format = [[NSNumberFormatter alloc] init];
    format.numberStyle = NSNumberFormatterDecimalStyle;
    
    NSString * formatString = @"0.";
    for (NSInteger i = 0; i < numberOfdecimal; i++) {
        formatString = [formatString stringByAppendingString:@"0"];
    }
    
    format.positiveFormat = formatString;
    return [format stringFromNumber:value];
}

@end
