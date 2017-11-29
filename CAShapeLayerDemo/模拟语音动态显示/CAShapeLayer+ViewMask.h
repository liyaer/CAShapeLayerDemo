//
//  CAShapeLayer+ViewMask.h
//  test
//
//  Created by 杜文亮 on 2017/11/27.
//  Copyright © 2017年 杜文亮. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface CAShapeLayer (ViewMask)

+ (instancetype)createMaskLayerWithView : (UIView *)view;

@end
