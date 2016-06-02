//
//  UIView+Zirkfied.m
//  ZFChartView
//
//  Created by apple on 16/2/24.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UIView+Zirkfied.h"

@implementation UIView (Zirkfied)

/**
 *  自定义边框
 *
 *  @param cornerRadius 角落半径
 *  @param borderWidth  边框宽度
 *  @param color        边框颜色
 */
-(void)setBorderCornerRadius:(CGFloat)cornerRadius andBorderWidth:(CGFloat)borderWidth andBorderColor:(UIColor *)color{
    self.layer.cornerRadius = cornerRadius;
    self.layer.borderWidth = borderWidth;
    self.layer.borderColor = color.CGColor;
}

/**
 *  设置阴影
 */
- (void)setShadow:(UIColor *)color{
    self.layer.shadowPath =[UIBezierPath bezierPathWithRect:self.layer.bounds].CGPath;
    self.layer.shadowColor = color.CGColor;//阴影的颜色
    self.layer.shadowOpacity = 0.5f;   // 阴影透明度
    self.layer.shadowOffset = CGSizeMake(2,2); // 阴影的范围
    self.layer.shadowRadius = 2;  // 阴影扩散的范围控制
}

@end
