//
//  CAShapeLayer+ViewMask.m
//  test
//
//  Created by 杜文亮 on 2017/11/27.
//  Copyright © 2017年 杜文亮. All rights reserved.
//

#import "CAShapeLayer+ViewMask.h"

@implementation CAShapeLayer (ViewMask)

+ (instancetype)createMaskLayerWithView : (UIView *)view
{
    CGFloat viewWidth = CGRectGetWidth(view.frame);
    CGFloat viewHeight = CGRectGetHeight(view.frame);
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, viewWidth, viewHeight) cornerRadius:viewWidth/2];
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = path.CGPath;
    
    return layer;
}


@end
