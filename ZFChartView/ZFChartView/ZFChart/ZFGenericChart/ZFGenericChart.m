//
//  ZFGenericChart.m
//  ZFChartView
//
//  Created by apple on 16/3/18.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ZFGenericChart.h"
#import "ZFColor.h"


@implementation ZFGenericChart

/**
 *  初始化变量
 */
- (void)commonInit{
    _isAnimated = YES;
    _isShadowForValueLabel = YES;
    _opacity = 1.f;
    _valueOnChartFont = [UIFont systemFontOfSize:10.f];
    _xLineNameLabelToXAxisLinePadding = 0.f;
    _valueLabelPattern = kPopoverLabelPatternPopover;
    _valueType = kValueTypeInteger;
    _isShowAxisLineValue = YES;
    _isShowAxisArrows = YES;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    
    return self;
}

- (void)setUp{
    //标题Label
    self.topicLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, TOPIC_HEIGHT)];
    self.topicLabel.font = [UIFont boldSystemFontOfSize:18.f];
    self.topicLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.topicLabel];
}

#pragma mark - 重写setter,getter方法

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    self.topicLabel.frame = CGRectMake(CGRectGetMinX(self.topicLabel.frame), CGRectGetMinY(self.topicLabel.frame), self.frame.size.width, CGRectGetHeight(self.topicLabel.frame));
}

@end
