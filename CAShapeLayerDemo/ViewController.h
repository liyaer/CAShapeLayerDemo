//
//  ViewController.h
//  CAShapeLayerDemo
//
//  Created by 杜文亮 on 2017/11/23.
//  Copyright © 2017年 杜文亮. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

/*
 *   UIBezierPath：（贝塞尔曲线）
        使用UIBezierPath类可以创建基于矢量的路径，这个类在UIKit中。此类是Core Graphics框架关于CGPathRef的一个封装。使用此类可以定义简单的形状，如椭圆或者矩形，或者有多个直线和曲线段组成的形状。
 
     CAShapeLayer：
        CAShapeLayer继承自CALayer，因此，可使用CALayer的所有属性。但是，CAShapeLayer需要和贝塞尔曲线配合使用才有意义（注意并不是必须）。
 
     CAShapeLayer与UIBezierPath的关系：
        1，CAShapeLayer中shape代表形状的意思，所以需要形状才能生效
        2，贝塞尔曲线可以创建基于矢量的路径，而UIBezierPath类是对CGPathRef的封装
        3，贝塞尔曲线给CAShapeLayer提供路径，CAShapeLayer在提供的路径中进行渲染。路径会闭环，所以绘制出了Shape
        4，用于CAShapeLayer的贝塞尔曲线作为path，其path是一个首尾相接的闭环的曲线，即使该贝塞尔曲线不是一个闭环的曲线
 
 -------------------------------------------------------------------------------------
 
     两种绘制图形CAShapeLayer和drawRect的比较：
        drawRect：属于CoreGraphics框架，占用CPU，性能消耗大（drawRect只是一个方法而已，是UIView的方法，重写此方法可以完成我们的绘制图形功能）
        CAShapeLayer：属于CoreAnimation框架，通过GPU来渲染图形，节省性能。动画渲染直接提交给手机GPU，不消耗内存
        这两者各有各的用途，而不是说有了CAShapeLayer就不需要drawRect。
*/

@end

