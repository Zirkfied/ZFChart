//
//  ZFPopoverLabel.m
//  ZFChartView
//
//  Created by apple on 16/3/29.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ZFPopoverLabel.h"
#import "UIView+Zirkfied.h"

#define TriAngleHalfLength 2

@interface ZFPopoverLabel()

@property (nonatomic, strong) UILabel * label;
/** 动画时间 */
@property (nonatomic, assign) CGFloat animationDuration;
/** 坐标轴方向 */
@property (nonatomic, assign) kAxisDirection direction;

@end

@implementation ZFPopoverLabel

/**
 *  初始化变量
 */
- (void)commonInit{
    self.alpha = 0.f;
    _animationDuration = 1.f;
    _shadowColor = ZFLightGray;
}

- (instancetype)initWithFrame:(CGRect)frame direction:(kAxisDirection)direction{
    self = [super initWithFrame:frame];
    if (self) {
        _direction = direction;
        [self commonInit];
        [self setUp];
    }
    return self;
}

- (void)setUp{
    self.label = [[UILabel alloc] init];
    self.label.numberOfLines = 0;
    self.label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.label];
}

#pragma mark - 坐标轴为垂直方向的样式

/**
 *  箭头在上方的bezierPath
 *
 *  @return UIBezierPath
 */
- (UIBezierPath *)arrowsOrientationOnTop{
    UIBezierPath * bezier = [UIBezierPath bezierPath];
    [bezier moveToPoint:CGPointMake(self.frame.size.width / 2, 0)];
    [bezier addLineToPoint:CGPointMake(self.frame.size.width / 2 + TriAngleHalfLength, TriAngleHalfLength * ZFTan(60))];
    [bezier addQuadCurveToPoint:CGPointMake(self.frame.size.width / 2 + (TriAngleHalfLength + 1) + 2, (TriAngleHalfLength + 1) * ZFTan(60)) controlPoint:CGPointMake(self.frame.size.width / 2 + (TriAngleHalfLength + 1), (TriAngleHalfLength + 1) * ZFTan(60))];
    [bezier addLineToPoint:CGPointMake(self.frame.size.width - 5, (TriAngleHalfLength + 1) * ZFTan(60))];
    [bezier addQuadCurveToPoint:CGPointMake(self.frame.size.width - 1, (TriAngleHalfLength + 1) * ZFTan(60) + 4) controlPoint:CGPointMake(self.frame.size.width - 1, (TriAngleHalfLength + 1) * ZFTan(60))];
    [bezier addLineToPoint:CGPointMake(self.frame.size.width - 1, self.frame.size.height - 5)];
    [bezier addQuadCurveToPoint:CGPointMake(self.frame.size.width - 5, self.frame.size.height - 1) controlPoint:CGPointMake(self.frame.size.width - 1, self.frame.size.height - 1)];
    [bezier addLineToPoint:CGPointMake(5, self.frame.size.height - 1)];
    [bezier addQuadCurveToPoint:CGPointMake(1, self.frame.size.height - 4) controlPoint:CGPointMake(1, self.frame.size.height - 1)];
    [bezier addLineToPoint:CGPointMake(1, (TriAngleHalfLength + 1) * ZFTan(60) + 4)];
    [bezier addQuadCurveToPoint:CGPointMake(5, (TriAngleHalfLength + 1) * ZFTan(60)) controlPoint:CGPointMake(1, (TriAngleHalfLength + 1) * ZFTan(60))];
    [bezier addLineToPoint:CGPointMake(self.frame.size.width / 2 - (TriAngleHalfLength + 1) - 2, (TriAngleHalfLength + 1) * ZFTan(60))];
    [bezier addQuadCurveToPoint:CGPointMake(self.frame.size.width / 2 - TriAngleHalfLength, TriAngleHalfLength * ZFTan(60)) controlPoint:CGPointMake(self.frame.size.width / 2 - (TriAngleHalfLength + 1), (TriAngleHalfLength + 1) * ZFTan(60))];
    [bezier closePath];
    
    return bezier;
}

/**
 *  箭头在下方的bezierPath
 *
 *  @return UIBezierPath
 */
- (UIBezierPath *)arrowsOrientationOnBelow{
    UIBezierPath * bezier = [UIBezierPath bezierPath];
    [bezier moveToPoint:CGPointMake(self.frame.size.width / 2, self.frame.size.height)];
    [bezier addLineToPoint:CGPointMake(self.frame.size.width / 2 - TriAngleHalfLength, self.frame.size.height - TriAngleHalfLength * ZFTan(60))];
    [bezier addQuadCurveToPoint:CGPointMake(self.frame.size.width / 2 - (TriAngleHalfLength + 1) - 2, self.frame.size.height - (TriAngleHalfLength + 1) * ZFTan(60)) controlPoint:CGPointMake(self.frame.size.width / 2 - (TriAngleHalfLength + 1), self.frame.size.height - (TriAngleHalfLength + 1) * ZFTan(60))];
    [bezier addLineToPoint:CGPointMake(5, self.frame.size.height - (TriAngleHalfLength + 1) * ZFTan(60))];
    [bezier addQuadCurveToPoint:CGPointMake(1, self.frame.size.height - (TriAngleHalfLength + 1) * ZFTan(60) - 4) controlPoint:CGPointMake(1, self.frame.size.height - (TriAngleHalfLength + 1) * ZFTan(60))];
    [bezier addLineToPoint:CGPointMake(1, 5)];
    [bezier addQuadCurveToPoint:CGPointMake(5, 1) controlPoint:CGPointMake(1, 1)];
    [bezier addLineToPoint:CGPointMake(self.frame.size.width - 5, 1)];
    [bezier addQuadCurveToPoint:CGPointMake(self.frame.size.width - 1, 5) controlPoint:CGPointMake(self.frame.size.width - 1, 1)];
    [bezier addLineToPoint:CGPointMake(self.frame.size.width - 1, self.frame.size.height - (TriAngleHalfLength + 1) * ZFTan(60) - 4)];
    [bezier addQuadCurveToPoint:CGPointMake(self.frame.size.width - 5, self.frame.size.height - (TriAngleHalfLength + 1) * ZFTan(60)) controlPoint:CGPointMake(self.frame.size.width - 1, self.frame.size.height - (TriAngleHalfLength + 1) * ZFTan(60))];
    [bezier addLineToPoint:CGPointMake(self.frame.size.width / 2 + (TriAngleHalfLength + 1) + 2, self.frame.size.height - (TriAngleHalfLength + 1) * ZFTan(60))];
    [bezier addQuadCurveToPoint:CGPointMake(self.frame.size.width / 2 + TriAngleHalfLength, self.frame.size.height - TriAngleHalfLength * ZFTan(60)) controlPoint:CGPointMake(self.frame.size.width / 2 + (TriAngleHalfLength + 1), self.frame.size.height - (TriAngleHalfLength + 1) * ZFTan(60))];
    [bezier closePath];
    
    return bezier;
}

- (CAShapeLayer *)shapeLayer{
    CAShapeLayer * shapeLayer = [CAShapeLayer layer];
    shapeLayer.strokeColor = ZFLightGray.CGColor;
    shapeLayer.fillColor = ZFWhite.CGColor;
    
    if (_isShadow) {
        shapeLayer.shadowColor = _shadowColor.CGColor;
        shapeLayer.shadowOffset = CGSizeMake(1.5, 1.5);
        shapeLayer.shadowOpacity = 0.7f;
    }
    
    if (_arrowsOrientation == kPopoverLaberArrowsOrientationOnTop) {
        shapeLayer.path = [self arrowsOrientationOnTop].CGPath;
        _isShadow ? shapeLayer.shadowPath = [self arrowsOrientationOnTop].CGPath : nil;
        
    }else if (_arrowsOrientation == kPopoverLaberArrowsOrientationOnBelow){
        shapeLayer.path = [self arrowsOrientationOnBelow].CGPath;
        _isShadow ? shapeLayer.shadowPath = [self arrowsOrientationOnBelow].CGPath : nil;
    }
    
    return shapeLayer;
}

#pragma mark - 坐标轴为水平方向的样式

/**
 *  水平label样式
 */
- (void)horizontalPattern{
    self.label.frame = self.bounds;
    
    if (_pattern == kPopoverLabelPatternPopover) {
        [self setBorderCornerRadius:4.0f andBorderWidth:0.6f andBorderColor:ZFLightGray];
        [self setShadow:_shadowColor];
        self.backgroundColor = ZFWhite;
    }
}

#pragma mark - 清除所有subLayers

/**
 *  清除所有subLayers
 */
- (void)removeAllLayer{
    NSArray * subLayers = [NSArray arrayWithArray:self.layer.sublayers];
    for (CALayer * layer in subLayers) {
        if ([layer isKindOfClass:[CAShapeLayer class]]) {
            [layer removeFromSuperlayer];
        }
    }
}

#pragma mark - public method

/**
 *  重绘
 */
- (void)strokePath{
    //坐标轴为垂直方向
    if (_direction == kAxisDirectionVertical) {
        [self removeAllLayer];
        _pattern == kPopoverLabelPatternPopover ? [self.layer addSublayer:[self shapeLayer]] : nil;
        
        if (_arrowsOrientation == kPopoverLaberArrowsOrientationOnTop) {
            self.label.frame = CGRectMake(2, TriAngleHalfLength * ZFTan(60) + 2, self.frame.size.width - 4, self.frame.size.height - TriAngleHalfLength * ZFTan(60) - 5);
        }else if (_arrowsOrientation == kPopoverLaberArrowsOrientationOnBelow){
            self.label.frame = CGRectMake(2, 2, self.frame.size.width - 4, self.frame.size.height - TriAngleHalfLength * ZFTan(60) - 5);
        }
        [self bringSubviewToFront:self.label];
    
    //坐标轴为水平方向
    }else{
        [self horizontalPattern];
    }
    
    //动画渐现
    if (_isAnimated) {
        [UIView animateWithDuration:_animationDuration animations:^{
            self.alpha = 1.f;
        }];
    }else{
        self.alpha = 1.f;
    }
}

#pragma mark - 重写setter,getter方法

- (void)setText:(NSString *)text{
    _text = text;
    self.label.text = _text;
}

- (void)setFont:(UIFont *)font{
    _font = font;
    self.label.font = _font;
}

- (void)setTextColor:(UIColor *)textColor{
    _textColor = textColor;
    self.label.textColor = _textColor;
}

@end
