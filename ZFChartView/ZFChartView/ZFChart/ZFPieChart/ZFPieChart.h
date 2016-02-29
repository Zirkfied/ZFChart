//
//  ZFPieChart.h
//  ZFChartView
//
//  Created by apple on 16/2/16.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    /**
     *  保留2位小数形式(默认)
     */
    kPercentTypeDecimal = 0,
    /**
     *  取整数形式(四舍五入)
     */
    kPercentTypeInteger = 1
}kPercentType;

@interface ZFPieChart : UIScrollView

#pragma mark - 初始化时必须要赋值的属性

/** 数值数组 (存储的是NSString类型) */
@property (nonatomic, strong) NSMutableArray * valueArray;
/** 名字数组 (存储的是NSString类型) */
@property (nonatomic, strong) NSMutableArray * nameArray;
/** 颜色数组 (存储的是UIColor类型) */
@property (nonatomic, strong) NSMutableArray * colorArray;


#pragma mark - 可选属性

/** 标题 */
@property (nonatomic, copy) NSString * title;
/** kPercentType类型 */
@property (nonatomic, assign) kPercentType percentType;
/** 显示详细信息(默认为YES) */
@property (nonatomic, assign) BOOL isShowDetail;
/** 显示百分比(默认为YES) */
@property (nonatomic, assign) BOOL isShowPercent;
/** 图表上百分比字体大小 */
@property (nonatomic, assign) CGFloat percentOnChartFontSize;
/** 是否带阴影效果(默认为YES) */
@property (nonatomic, assign) BOOL isShadow;


#pragma mark - public method

/**
 *  重绘
 */
- (void)strokePath;

@end
