//
//  UIColor+Zirkfied.m
//  ZFChartView
//
//  Created by apple on 16/2/24.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UIColor+Zirkfied.h"

@implementation UIColor (Zirkfied)

- (NSDictionary *)getRGBDictionaryByColor{
    CGFloat r=0,g=0,b=0,a=0;
    if ([self respondsToSelector:@selector(getRed:green:blue:alpha:)]) {
        [self getRed:&r green:&g blue:&b alpha:&a];
    }
    else {
        const CGFloat *components = CGColorGetComponents(self.CGColor);
        r = components[0];
        g = components[1];
        b = components[2];
        a = components[3];
    }
    
    r = r * 255;
    g = g * 255;
    b = b * 255;
    
    return @{@"R":@(r),
             @"G":@(g),
             @"B":@(b),
             @"A":@(a)};
}

- (CGFloat)red{
    NSDictionary * dict = [self getRGBDictionaryByColor];
    return [dict[@"R"] floatValue];
}

- (CGFloat)green{
    NSDictionary * dict = [self getRGBDictionaryByColor];
    return [dict[@"G"] floatValue];
}

- (CGFloat)blue{
    NSDictionary * dict = [self getRGBDictionaryByColor];
    return [dict[@"B"] floatValue];
}

- (CGFloat)alpha{
    NSDictionary * dict = [self getRGBDictionaryByColor];
    return [dict[@"A"] floatValue];
}

@end
