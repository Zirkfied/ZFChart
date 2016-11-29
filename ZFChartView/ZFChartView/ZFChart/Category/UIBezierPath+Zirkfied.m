//
//  UIBezierPath+Zirkfied.m
//  ZFChartView
//
//  Created by apple on 16/4/6.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UIBezierPath+Zirkfied.h"

@implementation UIBezierPath (Zirkfied)

void getPointsFromBezier(void * info, const CGPathElement * element){
    NSMutableArray *bezierPoints = (__bridge NSMutableArray *)info;
    CGPathElementType type = element->type;
    CGPoint * points = element->points;
    
    if (type != kCGPathElementCloseSubpath) {
        [bezierPoints addObject:[NSValue valueWithCGPoint:points[0]]];
        if ((type != kCGPathElementAddLineToPoint) && (type != kCGPathElementMoveToPoint)) {
            [bezierPoints addObject:[NSValue valueWithCGPoint:points[1]]];
        }
    }
    if (type == kCGPathElementAddCurveToPoint) {
        [bezierPoints addObject:[NSValue valueWithCGPoint:points[2]]];
    }
}

- (NSMutableArray *)pointsFromBezierPath:(UIBezierPath *)bezierPath{
    NSMutableArray * points = [NSMutableArray array];
    CGPathApply(bezierPath.CGPath, (__bridge void *)points, getPointsFromBezier);
    return points;
}

- (UIBezierPath *)smoothedPathWithGranularity:(NSInteger)granularity{
    NSMutableArray * points = [NSMutableArray arrayWithArray:[self pointsFromBezierPath:self]];

    if (points.count < 3) {
        return [self copy];
    }
    
    [points insertObject:[points objectAtIndex:0] atIndex:0];
    [points addObject:[points lastObject]];
    
    UIBezierPath * smoothedPath = [self copy];
    [smoothedPath removeAllPoints];
    [smoothedPath moveToPoint:[(NSValue *)[points objectAtIndex:0] CGPointValue]];
    
    for (NSUInteger i = 1; i < points.count - 2; i++) {
        CGPoint p0 = [(NSValue *)[points objectAtIndex:i-1] CGPointValue];
        CGPoint p1 = [(NSValue *)[points objectAtIndex:i] CGPointValue];
        CGPoint p2 = [(NSValue *)[points objectAtIndex:i+1] CGPointValue];
        CGPoint p3 = [(NSValue *)[points objectAtIndex:i+2] CGPointValue];
        
        for (int i = 1; i < granularity; i++)
        {
            float t = (float) i * (1.0f / (float) granularity);
            float tt = t * t;
            float ttt = tt * t;
            
            CGPoint pi;
            pi.x = 0.5 * (2*p1.x+(p2.x-p0.x)*t + (2*p0.x-5*p1.x+4*p2.x-p3.x)*tt + (3*p1.x-p0.x-3*p2.x+p3.x)*ttt);
            pi.y = 0.5 * (2*p1.y+(p2.y-p0.y)*t + (2*p0.y-5*p1.y+4*p2.y-p3.y)*tt + (3*p1.y-p0.y-3*p2.y+p3.y)*ttt);
            [smoothedPath addLineToPoint:pi];
        }
        
        [smoothedPath addLineToPoint:p2];
    }
    
    [smoothedPath addLineToPoint:[(NSValue *)[points objectAtIndex:points.count - 1] CGPointValue]];
    return smoothedPath;
}

@end
