//
//  ZFWave.h
//  ZFChartView
//
//  Created by apple on 16/3/26.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZFWave : UIView

@property (nonatomic, strong) UIColor * pathColor;
@property (nonatomic, strong) NSMutableArray * valuePointArray;

#pragma mark - public method

/**
 *  重绘
 */
- (void)strokePath;

@end
