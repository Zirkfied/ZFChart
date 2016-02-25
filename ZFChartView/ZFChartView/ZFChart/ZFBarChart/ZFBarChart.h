//
//  ZFBarChart.h
//  ZFChartView
//
//  Created by apple on 16/2/2.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZFBarChart : UIScrollView

/** 标题 */
@property (nonatomic, copy) NSString * title;
/** x轴数值数组 (存储的是NSString类型) */
@property (nonatomic, strong) NSMutableArray * xLineValueArray;
/** x轴名字数组 (存储的是NSString类型) */
@property (nonatomic, strong) NSMutableArray * xLineTitleArray;
/** y轴数值显示的上限 */
@property (nonatomic, assign) float yLineMaxValue;
/** y轴数值显示的段数 */
@property (nonatomic, assign) NSInteger yLineSectionCount;

#pragma mark - public method

/**
 *  重绘
 */
- (void)strokePath;

@end
