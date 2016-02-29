//
//  ZFCirque.h
//  ZFChartView
//
//  Created by apple on 16/2/15.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZFCirque : UIView

/** 圆环颜色 */
@property (nonatomic, strong) UIColor * cirqueColor;
/** 是否带阴影效果(默认为YES) */
@property (nonatomic, assign) BOOL isShadow;

#pragma mark - public method

/**
 *  重绘
 */
- (void)strokePath;

@end
