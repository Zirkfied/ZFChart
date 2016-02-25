//
//  ZFLabel.m
//  ZFChartView
//
//  Created by apple on 16/2/5.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ZFLabel.h"

@implementation ZFLabel

- (instancetype)init{
    self = [super init];
    if (self) {
        [self commonInit];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    
    return self;
}

/**
 *  初始化默认变量
 */
- (void)commonInit{
    self.textAlignment = NSTextAlignmentCenter;
    self.font = [UIFont systemFontOfSize:10.f];
}

@end
