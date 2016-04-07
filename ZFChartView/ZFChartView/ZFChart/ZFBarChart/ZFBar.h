//
//  ZFBar.h
//  ZFChart
//
//  Created by apple on 16/1/26.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZFBar : UIControl

/** bar颜色 */
@property (nonatomic, strong) UIColor * barColor;
/** 百分比小数 */
@property (nonatomic, assign) CGFloat percent;
/** 是否带阴影效果(默认为YES) */
@property (nonatomic, assign) BOOL isShadow;
/** self所在第几组数据 */
@property (nonatomic, assign) NSInteger groupAtIndex;
/** self在该组数据的下标位置 */
@property (nonatomic, assign) NSInteger barIndex;

#warning message - readonly(只读)

/** bar终点Y值 */
@property (nonatomic, assign, readonly) CGFloat endYPos;

#pragma mark - public method

/**
 *  重绘
 */
- (void)strokePath;

@end
