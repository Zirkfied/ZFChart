//
//  ZFCircle.h
//  ZFChartView
//
//  Created by apple on 16/3/17.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZFCircle : UIView

/** 圆的颜色 */
@property (nonatomic, strong) UIColor * circleColor;
/** 是否带阴影效果(默认为YES) */
@property (nonatomic, assign) BOOL isShadow;

#pragma mark - public method

/**
 *  重绘
 */
- (void)strokePath;

@end
