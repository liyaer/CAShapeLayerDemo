//
//  QLProgressView.h
//  Test2
//
//  Created by MQL-IT on 2017/8/16.
//  Copyright © 2017年 MQL-IT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QLCycleProgressView : UIView

@property (nonatomic, assign) CGFloat progress;//进度
@property (nonatomic, strong) UIColor *mainColor;// 主色调,进度条颜色和边界颜色
@property (nonatomic, strong) UIColor *fillColor;// 背景色（进度条未到达区域颜色）
@property (nonatomic, assign) CGFloat line_width;//线宽
@property (nonatomic, assign) CGFloat animationDuration;//动画时长
@property (nonatomic, assign) BOOL needAnimation;//是否有动画

@end
