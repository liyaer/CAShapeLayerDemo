//
//  ViewController.m
//  CAShapeLayerDemo
//
//  Created by 杜文亮 on 2017/11/23.
//  Copyright © 2017年 杜文亮. All rights reserved.
//

#import "BaseVC.h"

@interface BaseVC ()
{
    UIBezierPath *_path;
    CAShapeLayer *_shapeLayer;
}
@end

@implementation BaseVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    [self setLines];
//    [self setCornerRectangle];
    [self setCircle];
//    [self setArc];
//    [self setLineAddArc];
//    [self setQuadraticCurve];
//    [self setCubicCurve];
    
//    [self infoOne];
//    [self infoTwo];
//    [self infoThree];
}

//直线、折线、多边形
-(void)setLines
{
    //设置Path
    _path = [UIBezierPath bezierPath];//最一般的初始化方法
    [_path moveToPoint:CGPointMake(20, 20)];
    [_path addLineToPoint:CGPointMake(160, 160)];
//    [_path addLineToPoint:CGPointMake(180, 50)];
//    [_path closePath];
    
    
    _shapeLayer = [CAShapeLayer layer];
    /*
     *   常用属性
     */
    _shapeLayer.bounds = CGRectMake(0, 0, 200, 200);
    _shapeLayer.position = self.view.center;//不修改anchorPoint的情况下，默认anchorPoint（0.5，0.5），即anchorPoint是shapeLayer的中心点位置。position是anchorPoint在父试图中的位置，这里将position设置在父试图中心点位置。简单来说，不修改anchorPoint，设置position在父试图中心点，那么shapeLayer最终位置(frame就确定了)就是在父试图中心位置。这里简单写一下，等下专门写一个二者的专题介绍
    _shapeLayer.lineWidth = 5.0;
    _shapeLayer.strokeColor = [UIColor brownColor].CGColor;
    _shapeLayer.fillColor = [UIColor lightGrayColor].CGColor;
//    _shapeLayer.strokeStart = 0.2;
//    _shapeLayer.strokeEnd = 0.8;//这两个属性不受Path是否闭合的影响
    
    /*
     *   不常用属性
     */
//    _shapeLayer.lineDashPattern = @[@(10),@(10),@(20),@(20)];//效果受lineWidth，长度为10的线，长度为10的空白，长度为20的线，长度为20的空白，按照如此循环
//    _shapeLayer.lineDashPhase = 8;//针对lineDashPattern而言，代表线的起始位置，对于上面设置，第一段线是长度为10的线，那么lineDashPhase就是这段线的起点位置，默认是0，如果设置为8，那么第一段线从8的位置开始绘制，等于说最终只能看到一段长度为2的线，对后面的线不产生任何影响，只对第一段线有影响
//    _shapeLayer.lineCap = kCALineCapRound;//线终点的样式,非闭合的Path才会看到效果
//    _shapeLayer.lineJoin = kCALineJoinBevel;//线拐点处的样式
    
    _shapeLayer.path = [_path CGPath];
    [self.view.layer addSublayer:_shapeLayer];
}

//圆角矩形、任意角变圆角的矩形
-(void)setCornerRectangle
{
//    _path = [UIBezierPath bezierPathWithRoundedRect:(CGRect){0,0,200,200} cornerRadius:50];
    _path = [UIBezierPath bezierPathWithRoundedRect:(CGRect){0,0,200,200} byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(80, 80)];//当指定的圆角大小超过矩形宽或高的一半时，自动取宽或高的一半作为圆角大小

    _shapeLayer = [CAShapeLayer layer];
    _shapeLayer.bounds = CGRectMake(0, 0, 200, 200);
    _shapeLayer.position = self.view.center;
    _shapeLayer.fillColor = [UIColor brownColor].CGColor;
    _shapeLayer.strokeColor = [UIColor redColor].CGColor;
    _shapeLayer.path = _path.CGPath;
    [self.view.layer addSublayer:_shapeLayer];
}

//圆、椭圆
-(void)setCircle
{
    //绘制圆、椭圆的快速初始化方法
    _path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 260, 200)];
    
    _shapeLayer = [CAShapeLayer layer];
    _shapeLayer.bounds = CGRectMake(0, 0, 260, 200);
    _shapeLayer.position = self.view.center;
    _shapeLayer.lineWidth = 3.0;
    _shapeLayer.fillColor = [UIColor yellowColor].CGColor;
    _shapeLayer.strokeColor = [UIColor brownColor].CGColor;
    _shapeLayer.path = [_path CGPath];
    [self.view.layer addSublayer:_shapeLayer];

#warning 这里提出动态绘制内容、动画效果两个概念，具体的使用请参考<环形进度条>（里面两个概念都用到了）
    /*
     *   一次绘制完成，drawRect方式想更新绘制内容只能通过【self setNeedsDisplay】来调用drawRect方法重新绘制实现（因为绘制代码只能写在drawRect中）
         一次绘制完成，CAShapeLayer可以通过直接修改绘制属性实现更新
     */
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
//    {
//        _shapeLayer.lineWidth = 10.0;
//        _shapeLayer.fillColor = [UIColor redColor].CGColor;
//        _shapeLayer.strokeColor = [UIColor greenColor].CGColor;
//        _shapeLayer.strokeStart = 0;
//        _shapeLayer.strokeEnd = 0.5;
//    });
    
//    CABasicAnimation *pathAnima = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
//    pathAnima.duration = 3.0f;
//    pathAnima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    pathAnima.fromValue = [NSNumber numberWithFloat:0.0f];
//    pathAnima.toValue = [NSNumber numberWithFloat:1.0f];
//    pathAnima.fillMode = kCAFillModeForwards;
//    pathAnima.removedOnCompletion = NO;
//    [_shapeLayer addAnimation:pathAnima forKey:@"strokeEndAnimation"];
}

//圆弧（这里和【infoThree】写法一致，其实很好理解，简单来说，设置了layer的frame（或者bounds，position），那么Path的坐标是相对于layer来说的；未设置的话，Path坐标相对于layer的父layer）
-(void)setArc
{
    //圆心  半径  开始位置   结束位置  是否顺时针
    _path = [UIBezierPath bezierPathWithArcCenter:self.view.center radius:100 startAngle:M_PI_2 endAngle:M_PI clockwise:YES];

    _shapeLayer = [CAShapeLayer layer];
//    _shapeLayer.bounds = CGRectMake(0, 0, 300, 300);
//    _shapeLayer.position = self.view.center;
    _shapeLayer.strokeColor = [UIColor redColor].CGColor;
    _shapeLayer.fillColor = [UIColor yellowColor].CGColor;
//    _path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(150, 150) radius:100 startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
    _shapeLayer.path = _path.CGPath;
    [self.view.layer addSublayer:_shapeLayer];
}

//折线和弧线构成的图形
-(void)setLineAddArc
{
    _path = [UIBezierPath bezierPath];
    [_path moveToPoint:(CGPoint){100,100}];
    [_path addLineToPoint:self.view.center];
    [_path addArcWithCenter:self.view.center radius:50 startAngle:0 endAngle:M_PI clockwise:YES];//添加一条弧线
    
    _shapeLayer = [CAShapeLayer layer];
    _shapeLayer.lineWidth = 2.0;
    _shapeLayer.strokeColor = [UIColor redColor].CGColor;
//    _shapeLayer.fillColor = nil;//默认黑色，观察效果也印证了.h中说的4
    _shapeLayer.path = _path.CGPath;
    [self.view.layer addSublayer:_shapeLayer];
}

//二次贝塞尔曲线
-(void)setQuadraticCurve
{
    _path = [UIBezierPath bezierPath];
    [_path moveToPoint:CGPointMake(100, 100)];
    [_path addQuadCurveToPoint:CGPointMake(300, 200) controlPoint:CGPointMake(200, 400)];
    
    _shapeLayer = [CAShapeLayer layer];
    _shapeLayer.strokeColor = [UIColor redColor].CGColor;
    _shapeLayer.fillColor = [UIColor lightGrayColor].CGColor;
    _shapeLayer.path = _path.CGPath;
    [self.view.layer addSublayer:_shapeLayer];
}

//三次贝塞尔曲线
-(void)setCubicCurve
{
    _path = [UIBezierPath bezierPath];
    [_path moveToPoint:CGPointMake(50, 200)];
    [_path addCurveToPoint:CGPointMake(300, 300) controlPoint1:CGPointMake(100, 450) controlPoint2:CGPointMake(200, 50)];
    
    _shapeLayer = [CAShapeLayer layer];
    _shapeLayer.strokeColor = [UIColor redColor].CGColor;
    _shapeLayer.fillColor = nil;
    _shapeLayer.path = [_path CGPath];
    [self.view.layer addSublayer:_shapeLayer];
}

//清除上次绘制的内容
-(void)clearSubLayers
{
    [_path removeAllPoints];
    _path = nil;
    [_shapeLayer removeFromSuperlayer];
    _shapeLayer = nil;
}




#pragma mark - 特别说明

//CAShapeLayer不是必须配合UIBezierPath才能使用的，单独也可以使用，只不过配合UIBezierPath功能更强大
-(void)infoOne
{
    _shapeLayer = [CAShapeLayer layer];
    _shapeLayer.bounds = CGRectMake(0, 0, 200, 200);
    _shapeLayer.position = self.view.center;
    _shapeLayer.backgroundColor = [UIColor greenColor].CGColor;
    [self.view.layer addSublayer:_shapeLayer];
}

//CAShapeLayer创建的layer，不设置backgroundColor默认是透明的，这一点对于使用mask遮罩时需要注意
-(void)infoTwo
{
    _path = [UIBezierPath bezierPathWithRect:CGRectMake(20, 20, 200, 200)];
    
    _shapeLayer = [CAShapeLayer layer];
    _shapeLayer.bounds = CGRectMake(0, 0, 200, 200);
    _shapeLayer.position = self.view.center;
//    _shapeLayer.backgroundColor = [UIColor yellowColor].CGColor;
    _shapeLayer.fillColor = [UIColor clearColor].CGColor;
    _shapeLayer.strokeColor = [UIColor blackColor].CGColor;
    _shapeLayer.path = [_path CGPath];
    [self.view.layer addSublayer:_shapeLayer];
}

/*
 *   [infoTwo]（包括上面几种图形的绘制），都是指定_shapeLayer的bounds、position，然后_path在bounds中进行绘制；这里我们不指定_shapeLayer的bounds、position（注意这两个属性是用来确定layer在父layer中的位置和大小，此时打印bounds是0），直接给layer一个Path，发现依然可以绘制，并且Path中的rect对应当前坐标系
 
     猜测：根据响应者链，Path的rect匹配到了self.view.layer（即_shapeLayer的父layer）中,这种写法在开发中很常见
 */
-(void)infoThree
{
    _path = [UIBezierPath bezierPathWithRect:CGRectMake(20, 20, 200, 200)];
    
    _shapeLayer = [CAShapeLayer layer];
    _shapeLayer.fillColor = [UIColor clearColor].CGColor;
    _shapeLayer.strokeColor = [UIColor blackColor].CGColor;
    _shapeLayer.path = [_path CGPath];
    [self.view.layer addSublayer:_shapeLayer];
}


@end
