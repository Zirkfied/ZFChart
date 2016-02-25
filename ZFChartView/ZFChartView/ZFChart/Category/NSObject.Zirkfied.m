//
//  NSObject+Zirkfied.m
//  ZFChartView
//
//  Created by apple on 16/2/24.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "NSObject+Zirkfied.h"

@implementation NSObject (Zirkfied)

/**
 *  N秒后执行动作(不阻塞主线程)
 *
 *  @param seconds 几秒
 *  @param actions 几秒后执行的动作
 */
- (void)dispatch_after_withSeconds:(float)seconds actions:(void(^)(void))actions{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(seconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        actions();
    });
}

@end
