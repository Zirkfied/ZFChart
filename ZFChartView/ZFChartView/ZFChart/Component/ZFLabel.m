//
//  ZFLabel.m
//  ZFChartView
//
//  Created by apple on 16/2/5.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ZFLabel.h"

@interface ZFLabel()

/** 动画时间 */
@property (nonatomic, assign) CGFloat animationDuration;

@end

@implementation ZFLabel

/**
 *  初始化默认变量
 */
- (void)commonInit{
    self.numberOfLines = 0;
    self.textAlignment = NSTextAlignmentCenter;
    self.font = [UIFont systemFontOfSize:10.f];
    _animationDuration = 1.f;
    _isFadeInAnimation = NO;
}

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
 *  渐现动画
 */
- (void)fadeInAnimation{
    self.alpha = 0.f;
    [UIView animateWithDuration:_animationDuration animations:^{
        self.alpha = 1.f;
    }];
}

#pragma mark - 重写setter, getter方法

-  (void)setIsFadeInAnimation:(BOOL)isFadeInAnimation{
    _isFadeInAnimation = isFadeInAnimation;
    _isFadeInAnimation ? [self fadeInAnimation] : nil;
}

@end
