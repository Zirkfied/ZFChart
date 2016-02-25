//
//  NSObject+Zirkfied.h
//  ZFChartView
//
//  Created by apple on 16/2/24.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Zirkfied)

/**
 *  N秒后执行动作(不阻塞主线程)
 *
 *  @param seconds 几秒
 *  @param actions 几秒后执行的动作
 */
- (void)dispatch_after_withSeconds:(float)seconds actions:(void(^)(void))actions;

@end
