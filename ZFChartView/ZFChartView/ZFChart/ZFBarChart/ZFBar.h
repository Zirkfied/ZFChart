//
//  ZFBar.h
//  ZFChart
//
//  Created by apple on 16/1/26.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZFBar : UIView

/** bar颜色 */
@property (nonatomic, strong) UIColor * barColor;
/** 百分比小数 */
@property (nonatomic, assign) CGFloat percent;
/** 是否带阴影效果(默认为YES) */
@property (nonatomic, assign) BOOL isShadow;

#warning message - readonly(只读)

/** bar终点Y值 */
@property (nonatomic, assign, readonly) CGFloat endYPos;

#pragma mark - public method

/**
 *  重绘
 */
- (void)strokePath;

@end
