//
//  ZFRadar.h
//  ZFChartView
//
//  Created by apple on 16/9/6.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZFRadar : UIView

/** item数组 */
@property (nonatomic, strong) NSMutableArray * itemArray;
/** 半径延伸长度，用于计算item label的中心点位置(默认25.f) */
@property (nonatomic, strong) NSMutableArray * radiusExtendLengthArray;
/** 半径 */
@property (nonatomic, assign) CGFloat radius;
/** 雷达图线宽(默认1.f) */
@property (nonatomic, assign) CGFloat radarLineWidth;
/** 雷达图分割线线宽(默认1.f) */
@property (nonatomic, assign) CGFloat separateLineWidth;
/** 分段数 */
@property (nonatomic, assign) NSUInteger sectionCount;
/** 雷达边线颜色 */
@property (nonatomic, strong) UIColor * radarLineColor;
/** 雷达背景颜色 */
@property (nonatomic, strong) UIColor * radarBackgroundColor;
/** 是否显示雷达图分割线(默认为YES) */
@property (nonatomic, assign) BOOL isShowSeparate;


#warning message - readonly(只读)
/** itemLabel中心点数组 */
@property (nonatomic, strong, readonly) NSArray * itemLabelCenterArray;
/** 雷达中点平均角度 */
@property (nonatomic, assign, readonly) CGFloat averageRadarAngle;
/** 半径平均分成n段的长度 */
@property (nonatomic, assign, readonly) CGFloat averageRadius;


#pragma mark - public method

/**
 *  重绘
 */
- (void)strokePath;

@end
