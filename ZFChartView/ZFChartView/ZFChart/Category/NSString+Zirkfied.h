//
//  NSString+Zirkfied.h
//  ZFChartView
//
//  Created by apple on 16/2/24.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>

@interface NSString (Zirkfied)

/**
 *  计算字符串宽度(指当该字符串放在view时的自适应宽度)
 *
 *  @param size 填入预留的大小
 *  @param font 字体大小
 *  @param isBold 字体是否加粗
 *
 *  @return 返回CGRect
 */
- (CGRect)stringWidthRectWithSize:(CGSize)size fontOfSize:(CGFloat)font isBold:(BOOL)isBold;

@end
