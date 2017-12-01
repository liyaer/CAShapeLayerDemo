//
//  VoiceView.m
//  test
//
//  Created by 杜文亮 on 2017/11/28.
//  Copyright © 2017年 杜文亮. All rights reserved.
//

#import "VoiceView.h"
#import "CAShapeLayer+ViewMask.h"

static CGFloat h,w;

@implementation VoiceView
{
    UIBezierPath *_path;
    CAShapeLayer *_layer;
    UIView *_sv;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        h = frame.size.height;
        w = frame.size.width;
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
        /*
         *   基础绘制
         */
        //1，支架部分
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(w/2 -30, h/2 +80)];
        [path addLineToPoint:CGPointMake(w/2 +30, h/2 +80)];
        [path moveToPoint:CGPointMake(w/2, h/2 +80)];
        [path addLineToPoint:CGPointMake(w/2, h/2 +60)];
        [path addQuadCurveToPoint:CGPointMake(w/2 -40, h/2 +10) controlPoint:CGPointMake(w/2 -40, h/2 +60)];
        [path moveToPoint:CGPointMake(w/2, h/2 +60)];
        [path addQuadCurveToPoint:CGPointMake(w/2 +40, h/2 +10) controlPoint:CGPointMake(w/2 +40, h/2 +60)];
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.lineWidth = 5.0;
        layer.lineCap = kCALineCapRound;
        layer.strokeColor = [UIColor whiteColor].CGColor;
        layer.fillColor = [UIColor clearColor].CGColor;
        layer.path = path.CGPath;
        [self.layer addSublayer:layer];
        
        //2，显示部分(因为UIBezierPath默认都是闭合的，所以需要分两部分绘制，否则会出现不理想的连接线)
        path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(w/2 -25, h/2 -45, 50, 90) cornerRadius:25];
        layer = [CAShapeLayer layer];
        layer.lineWidth = 3.0;
        layer.strokeColor = [UIColor whiteColor].CGColor;
        layer.fillColor = [UIColor clearColor].CGColor;
        layer.path = path.CGPath;
        [self.layer addSublayer:layer];
        
        /*
         *   添加子视图，为动态显示做准备(将一个View放在上面绘制的第2部分)
         */
        _sv = [[UIView alloc] initWithFrame:CGRectMake(w/2 -25, h/2 -45, 50, 90)];
        _sv.backgroundColor = [UIColor redColor];
    //    _sv.layer.cornerRadius = 25;//将View切成和上面绘制的第二部分一样的形状
    //    _sv.layer.masksToBounds = YES;//和下面使用mask效果一致，貌似下面的节省性能
        _sv.layer.mask = [CAShapeLayer createMaskLayerWithView:_sv];//这个类别不具有通用性，可以不使用类别，将方法写到本类中调用
        [self addSubview:_sv];
        
        _layer = [CAShapeLayer layer];
        _layer.fillColor = [UIColor whiteColor].CGColor;
        _layer.strokeColor = [UIColor whiteColor].CGColor;
        [_sv.layer addSublayer:_layer];
    }
    return self;
}

//根据<环形进度条>中_progressLayer的绘制方式得到启发（这种方式充分体现了CAShapeLayer相对于drawRect方式的优点）
-(void)setVoiceValue:(CGFloat)voiceValue
{
    _path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 90 -voiceValue, 50, voiceValue)];
    _layer.path = _path.CGPath;
}

//这是第一次的做法，每次移除layer再添加layer的方式，显得比较笨拙，废弃（这种方式本质和drawRect更新时调用【self setNeedsDisplay】重新绘制全部内容类似，没有发挥CAShapeLayer的优点）
//-(void)setVoiceValue:(CGFloat)voiceValue;
//{
//    //移除上次添加的显示进度的layer(保证_sv.layer每次只添加一个subLayer显示)
//    [_path removeAllPoints];
//    _path = nil;
//    [_layer removeFromSuperlayer];
//    _layer = nil;
//
//    _path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 90 -voiceValue, 50, voiceValue)];
//    _layer = [CAShapeLayer layer];
//    _layer.fillColor = [UIColor whiteColor].CGColor;
//    _layer.strokeColor = [UIColor whiteColor].CGColor;
//    _layer.path = _path.CGPath;
//    [_sv.layer addSublayer:_layer];
//    
//    //self.layer的子layer有三个，但是类型不同，两个CAShapeLayer（用于绘制）,一个CALayer（子视图_sv的layer）；_sv.layer的子layer只有_layer一个
//    NSLog(@"=====%.2f=======%ld======%ld",voiceValue,self.layer.sublayers.count,_sv.layer.sublayers.count);
//}


@end
