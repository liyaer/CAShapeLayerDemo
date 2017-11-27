//
//  ViewController.h
//  CAShapeLayerDemo
//
//  Created by 杜文亮 on 2017/11/23.
//  Copyright © 2017年 杜文亮. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseVC : UIViewController

/*
 *   UIBezierPath：（贝塞尔曲线）
        使用UIBezierPath类可以创建基于矢量的路径，这个类在UIKit中。此类是对Core Graphics框架中CGPathRef的一个封装。使用此类可以定义简单的形状，如椭圆或者矩形，或者有多个直线和曲线段组成的形状。
 
     CAShapeLayer：
        CAShapeLayer继承自CALayer，因此，可使用CALayer的所有属性。但是，CAShapeLayer需要和贝塞尔曲线配合使用才有意义（注意并不是必须，.m中有例子说明）。
 
     CAShapeLayer与UIBezierPath的关系：
        1，CAShapeLayer中shape代表形状的意思，所以需要形状才能生效
        2，贝塞尔曲线可以创建基于矢量的路径，而UIBezierPath类是对CGPathRef的封装
        3，贝塞尔曲线给CAShapeLayer提供路径，CAShapeLayer在提供的路径中进行渲染。路径会闭环，所以绘制出了Shape
        4，用于CAShapeLayer的贝塞尔曲线作为path，其path是一个首尾相接的闭环的曲线，即使该贝塞尔曲线不是一个闭环的曲线
*/

@end

