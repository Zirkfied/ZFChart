//
//  ZFCircle.h
//  ZFChartView
//
//  Created by apple on 16/3/17.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZFCircle : UIControl

/** 圆的颜色 */
@property (nonatomic, strong) UIColor * circleColor;
/** 是否带阴影效果(默认为YES) */
@property (nonatomic, assign) BOOL isShadow;
/** self所在第几条线 */
@property (nonatomic, assign) NSInteger lineAtIndex;
/** self在该线的下标位置 */
@property (nonatomic, assign) NSInteger circleIndex;

#pragma mark - public method

/**
 *  重绘
 */
- (void)strokePath;

@end
