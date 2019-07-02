//
//  Dwl_BezierPathShapeLayerView.m
//  CAShapeLayerDemo
//
//  Created by Mac on 2019/4/12.
//  Copyright © 2019 杜文亮. All rights reserved.
//

#import "Dwl_BezierPathShapeLayerView.h"


#define XYQColor(r, g, b)           [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define XYQColorRGBA(r, g, b, a)    [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]
#define XYQRandomColor              XYQColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

//使用方式一绘制扇形图时使用
typedef NS_ENUM(NSInteger, WLArcChartDrawType) {
    WLArcChartFill,
    WLArcChartStroke,
    WLArcChartFillAndStroke,
};


@interface Dwl_BezierPathShapeLayerView () <CAAnimationDelegate>
{
    NSArray *_titles;
    NSArray *_values;
    WLChartType _chartType;
    WLDrawParameters _drawParameters;
}
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,strong) UIImageView *errorImgView;

@end


@implementation Dwl_BezierPathShapeLayerView

#pragma mark - 懒加载

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
//        _scrollView.showsHorizontalScrollIndicator = NO;
//        _scrollView.bounces = NO;
    }
    return _scrollView;
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:self.bounds];
        _bgView.backgroundColor = [UIColor grayColor];
    }
    return _bgView;
}

- (UIImageView *)errorImgView {
    if (!_errorImgView) {
        _errorImgView = [[UIImageView alloc] initWithFrame:self.bounds];
        _errorImgView.image = [UIImage imageNamed:@"launchImg"];
    }
    return _errorImgView;
}

#pragma mark - 初始化

- (instancetype)initWithFrame:(CGRect)frame drawViewWithTitles:(NSArray <NSString *>*)titles values:(NSArray <NSNumber *>*)values chartType:(WLChartType)chartType drawParameters:(WLDrawParameters)drawParameters {
    if (self = [super initWithFrame:frame]) {
        if ((titles.count == values.count) && (titles.count != 0)) { //入参检查
            //成员变量赋值
            _titles = titles;
            _values = values;
            _chartType = chartType;
            _drawParameters = drawParameters;
            
            if (chartType == WLArcChart) {
                self.backgroundColor = [UIColor blackColor];
                
//                [self drawArcBarChartViewByPathsWithChartType:WLArcChartStroke];
                [self drawArcBarChartViewWithChartType];
            } else {
                [self addSubview:self.scrollView];
                [self.scrollView addSubview:self.bgView];
                
                //检查是否超宽或超长
                [self checkTotalWidthOrHeight];
                
                //绘制柱状图
                if (chartType == WLBarChartHorizontal) {
                    [self drawHorizontalBarChartView];
                } else {
                    [self drawVerticalBarChartView];
                }
            }
        } else { //参数传递有误，无法进行图表的绘制
            [self addSubview:self.errorImgView];
        }
    }
    return self;
}

#pragma mark - 柱形图

//待绘制总宽度超出self.frame.width ？更改self.bgView的frame ：修改属性值使绘制内容平均分布
- (void)checkTotalWidthOrHeight {
    CGFloat frame_w_h = 0;
    CGFloat realFrame_w_h = 0;
    if (_chartType == WLBarChartHorizontal) {
        frame_w_h = CGRectGetWidth(self.frame);
        realFrame_w_h = (_drawParameters.horizontal.margin + _drawParameters.horizontal.singleBarChartWidth)*_titles.count + _drawParameters.horizontal.margin;
    } else if (_chartType == WLBarChartVertical) {
        frame_w_h = CGRectGetHeight(self.frame);
        realFrame_w_h = (_drawParameters.vertical.margin + _drawParameters.vertical.singleBarChartWidth)*_titles.count + _drawParameters.vertical.margin;
    }
    
    if (realFrame_w_h > frame_w_h) { //需要滑动
        CGRect bgViewNewFrame = self.bgView.frame;
        if (_chartType == WLBarChartHorizontal) {
            bgViewNewFrame.size.width = realFrame_w_h;
        } else if (_chartType == WLBarChartVertical) {
            bgViewNewFrame.size.height = realFrame_w_h;
        }
        self.bgView.frame = bgViewNewFrame;
    } else if (realFrame_w_h < frame_w_h) { //未超宽或超长，重新设置绘制参数
        if (_chartType == WLBarChartHorizontal) {
            //均分
            _drawParameters.horizontal.singleBarChartWidth = frame_w_h/(_titles.count*2 + 1);
            _drawParameters.horizontal.margin = _drawParameters.horizontal.singleBarChartWidth;
        } else if (_chartType == WLBarChartVertical) {
            //固定一个不变，改边另一个值
            _drawParameters.vertical.margin = (frame_w_h - _drawParameters.vertical.singleBarChartWidth*_titles.count)/(_titles.count + 1);
        }
    }
    self.scrollView.contentSize = self.bgView.bounds.size;
}

//绘制横向柱状图
- (void)drawHorizontalBarChartView {
    //找出最大值，确定放大或缩小倍数
    CGFloat maxValue = [[_values valueForKeyPath:@"@max.floatValue"] floatValue];
    CGFloat maxDrawValueOfY = CGRectGetHeight(self.frame) - _drawParameters.horizontal.bottom - _drawParameters.horizontal.top;
    CGFloat drawScale = maxDrawValueOfY/maxValue;
    
    for (int i = 0; i < _values.count; i++) {
        CGFloat drawValueOfY = drawScale * [_values[i] floatValue];
        CGFloat X = _drawParameters.horizontal.margin + (_drawParameters.horizontal.singleBarChartWidth + _drawParameters.horizontal.margin)*i;//柱状图中左下角点所在X轴的坐标
        CGFloat Y = CGRectGetHeight(self.frame) - _drawParameters.horizontal.bottom - drawValueOfY;//柱状图顶部所在Y轴的坐标
        
        //1,柱状图底部的描述
        UILabel *bottomLab = [[UILabel alloc] initWithFrame:CGRectMake((X - _drawParameters.horizontal.margin/2), (CGRectGetHeight(self.frame) - _drawParameters.horizontal.bottom), (_drawParameters.horizontal.singleBarChartWidth + _drawParameters.horizontal.margin), _drawParameters.horizontal.bottom)];
        bottomLab.text = _titles[i];
        bottomLab.font = [UIFont systemFontOfSize:14];
        bottomLab.textAlignment = NSTextAlignmentCenter;
        bottomLab.textColor = [UIColor blueColor];
        [self.bgView addSubview:bottomLab];
        
        //2,柱状图
        //----2.1,构造path
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(X + _drawParameters.horizontal.singleBarChartWidth/2, Y + drawValueOfY)];
        [path addLineToPoint:CGPointMake(X + _drawParameters.horizontal.singleBarChartWidth/2, Y)];
        //----2.2,交给layer渲染
        CAShapeLayer *shapeLayer = [self setShapeLayerWithFillColor:nil strokeColor:XYQColor(0, 255, 0) lineWidth:_drawParameters.horizontal.singleBarChartWidth bezierPath:path];
//        [shapeLayer addSublayer:[self gradientWithFrame:CGRectMake(X, Y, _drawParameters.singleBarChartWidth, doubleValue) targetColor:shapeLayer.strokeColor]];
        [self.bgView.layer addSublayer:shapeLayer];
        //----2.3,添加动画
        [self addAnimationWithLayer:shapeLayer animationName:@"HorizontalBarChartStrokeEnd"];
 
        //3,柱状图顶部的描述
        UILabel *topLab = [[UILabel alloc] initWithFrame:CGRectMake((X - _drawParameters.horizontal.margin/2), (Y - _drawParameters.horizontal.top), (_drawParameters.horizontal.singleBarChartWidth + _drawParameters.horizontal.margin), _drawParameters.horizontal.top)];
        topLab.text = [NSString stringWithFormat:@"%.0f", drawValueOfY/drawScale];
        topLab.textColor = [UIColor purpleColor];
        topLab.textAlignment = NSTextAlignmentCenter;
        topLab.font = [UIFont systemFontOfSize:14];
        [self.bgView addSubview:topLab];
        topLab.alpha = 0.0;
        [UIView animateWithDuration:1.5 delay:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            topLab.alpha = 1.0;
        } completion:nil];
    }
}

//绘制纵向柱状图
- (void)drawVerticalBarChartView {
    //画Y轴
    UIBezierPath *pathY = [UIBezierPath bezierPath];
    [pathY moveToPoint:CGPointMake(_drawParameters.vertical.left, 0)];
    [pathY addLineToPoint:CGPointMake(_drawParameters.vertical.left, CGRectGetHeight(self.bgView.frame))];
    CAShapeLayer *shapeLayer = [self setShapeLayerWithFillColor:nil strokeColor:[UIColor lightGrayColor] lineWidth:2 bezierPath:pathY];
    [self.bgView.layer addSublayer:shapeLayer];
    
    //找出最大值，确定放大或缩小倍数
    CGFloat maxValue = [[_values valueForKeyPath:@"@max.floatValue"] floatValue];
    CGFloat maxDrawValueOfX = CGRectGetWidth(self.frame) - _drawParameters.vertical.left - _drawParameters.vertical.right;
    CGFloat drawScale = maxDrawValueOfX/maxValue;
    
    for (int i = 0; i < _values.count; i++) {
        CGFloat drawValueOfX = drawScale * [_values[i] floatValue];
        CGFloat Y = _drawParameters.vertical.margin + (_drawParameters.vertical.singleBarChartWidth + _drawParameters.vertical.margin)*i;//柱状图中左上角点所在Y轴的坐标
        CGFloat X = _drawParameters.vertical.left + drawValueOfX;//柱状图顶部所在X轴的坐标
        
        //1,柱状图底部的描述
        UILabel *bottomLab = [[UILabel alloc] initWithFrame:CGRectMake(0, (Y - _drawParameters.vertical.margin/2), _drawParameters.vertical.left, (_drawParameters.vertical.singleBarChartWidth + _drawParameters.vertical.margin))];
        bottomLab.text = _titles[i];
        bottomLab.font = [UIFont systemFontOfSize:14];
        bottomLab.textAlignment = NSTextAlignmentCenter;
        bottomLab.textColor = [UIColor blueColor];
        [self.bgView addSubview:bottomLab];
        
        //2,柱状图
        //----2.1,构造path
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(_drawParameters.vertical.left, Y + _drawParameters.vertical.singleBarChartWidth/2)];
        [path addLineToPoint:CGPointMake(X, Y + _drawParameters.vertical.singleBarChartWidth/2)];
        //----2.2,交给layer渲染
        CAShapeLayer *shapeLayer = [self setShapeLayerWithFillColor:nil strokeColor:XYQColor(0, 255, 0) lineWidth:_drawParameters.vertical.singleBarChartWidth bezierPath:path];
        [self.bgView.layer addSublayer:shapeLayer];
        //----2.3,添加动画
        [self addAnimationWithLayer:shapeLayer animationName:@"VerticalBarChartStrokeEnd"];
        
        //3,柱状图顶部的描述
        UILabel *topLab = [[UILabel alloc] initWithFrame:CGRectMake(X, (Y - _drawParameters.vertical.margin/2), _drawParameters.vertical.right, (_drawParameters.vertical.singleBarChartWidth + _drawParameters.vertical.margin))];
        topLab.text = [NSString stringWithFormat:@"%.0f", drawValueOfX/drawScale];
        topLab.textColor = [UIColor purpleColor];
        topLab.textAlignment = NSTextAlignmentCenter;
        topLab.font = [UIFont systemFontOfSize:14];
        [self.bgView addSubview:topLab];
        topLab.alpha = 0.0;
        [UIView animateWithDuration:1.5 delay:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            topLab.alpha = 1.0;
        } completion:nil];
    }
}

#pragma mark - 扇形图
/* --------复杂图形绘制+动画的思考II：三步走策略
 
    1，UIBezierPath：（在BaseVC底部的思考中有解释）
        一个path不断add；
        多个path不断appendPath;
        多个path；
    前两种最终得到的是一个path，而第三种是多个path。
 
    2，CAShapeLayer:(给定一个path，进行渲染)
        strokeStart，strokeEnd这两个属性控制path的渲染范围，默认值默认是0-1，也就是传入的path全部渲染。
 
    3，前两者构造完成，加入动画CABasicAnimation：
        只有stroke部分才有动画效果，fill部分没有，因此确保shapeLayer有stroke部分
 */
#pragma mark 方法一：构造不同path（即多个扇形），最终拼接处目标path（圆形）

//fill无动画；stroke有动画（多个UIBezierPath，多次绘制，多次动画）
- (void)drawArcBarChartViewByPathsWithChartType:(WLArcChartDrawType)drwaType {
    //入参检查 & 设置扇形参数
    CGFloat safeWidth = CGRectGetWidth(self.frame) -_drawParameters.arc.left -_drawParameters.arc.right;
    CGFloat safeHeight = CGRectGetHeight(self.frame) -_drawParameters.arc.top -_drawParameters.arc.bottom;
    if (safeWidth <= 0 || safeHeight <= 0) {
        NSLog(@"参数有误，无法正确绘制扇形图表!");
        return;
    }
    CGPoint point = CGPointMake(_drawParameters.arc.left +safeWidth/2, _drawParameters.arc.top +safeHeight/2);
    CGFloat radiusMax = (safeWidth > safeHeight) ? safeHeight/2 : safeWidth/2;
    CGFloat radius = 0.0;
    CGFloat lineWidth = 0.0;
    switch (drwaType) {
        case WLArcChartFill: {
            radius = radiusMax;
            break;
        }
        case WLArcChartStroke: {
            radius = radiusMax/2;
            lineWidth = radiusMax;
            
            CGFloat hollowCircleRadius = _drawParameters.arc.hollowCircleRadius;
            if (hollowCircleRadius >= radiusMax) {
                hollowCircleRadius = 0;
                _drawParameters.arc.hollowCircleRadius = hollowCircleRadius;
            }
            if (hollowCircleRadius) {
                lineWidth -= hollowCircleRadius;
                radius = hollowCircleRadius +lineWidth/2;
            }
            break;
        }
        case WLArcChartFillAndStroke: {
            lineWidth = 2.0;
            radius = radiusMax -1;
            break;
        }
        default:
            break;
    }
    __block CGFloat startAngle = 0;
    __block CGFloat endAngle = 0;
    
    //计算总数
    CGFloat allValue = 0;
    for (NSNumber *value in _values) {
        allValue += value.floatValue;
    }
    //开始绘制
    [_values enumerateObjectsUsingBlock:^(NSNumber *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        endAngle = startAngle + obj.floatValue/allValue * 2*M_PI;
        
        //设置path
        UIBezierPath *bezierPath = [UIBezierPath bezierPathWithArcCenter:point radius:radius startAngle:startAngle                                                             endAngle:endAngle clockwise:YES];
        switch (drwaType) {
            case WLArcChartFill: case WLArcChartFillAndStroke: {
                [bezierPath addLineToPoint:point];
                [bezierPath closePath];
                break;
            }
            default:
                break;
        }
        startAngle = endAngle;
        
        //渲染
        switch (drwaType) {
            case WLArcChartFill: {
                CAShapeLayer *shapeLayer = [self setShapeLayerWithFillColor:XYQRandomColor strokeColor:[UIColor clearColor] lineWidth:lineWidth bezierPath:bezierPath];
                [self.layer addSublayer:shapeLayer];
                break;
            }
            case WLArcChartStroke: {
                CAShapeLayer *shapeLayer = [self setShapeLayerWithFillColor:[UIColor clearColor] strokeColor:XYQRandomColor lineWidth:lineWidth bezierPath:bezierPath];
                [self.layer addSublayer:shapeLayer];
                //动画
                if (!_drawParameters.arc.isMask) {
                    [self addAnimationWithLayer:shapeLayer animationName:@"arcChartStrokeEnd"];
                }
                break;
            }
            case WLArcChartFillAndStroke: { //lineWidth越大，效果越不完美，基本弃用
                CAShapeLayer *shapeLayer = [self setShapeLayerWithFillColor:XYQRandomColor strokeColor:[UIColor whiteColor] lineWidth:lineWidth bezierPath:bezierPath];
                [self.layer addSublayer:shapeLayer];
                //动画
                if (!_drawParameters.arc.isMask) {
                    [self addAnimationWithLayer:shapeLayer animationName:@"arcChartStrokeEnd"];
                }
                break;
            }
            default:
                break;
        }
    }];
    
    //是否使用mask进行裁剪(使用了mask，既可以使用原动画，也可以使用mask动画，也可以都使用，这里统一使用mask动画代替原动画)
    if (_drawParameters.arc.isMask) {
        CGFloat maskRadius = 0.0;
        switch (drwaType) {
            case WLArcChartFill:
                maskRadius = (radius +2)/2;
                break;
            case WLArcChartStroke: {
                CGFloat hollowCircleRadius = _drawParameters.arc.hollowCircleRadius;
                maskRadius = hollowCircleRadius ? ((lineWidth +hollowCircleRadius)/2 +1) : radius+1;
                break;
            }
            case WLArcChartFillAndStroke:
                maskRadius = (radius +1 +2)/2;
                break;
            default:
                break;
        }
        UIBezierPath *bgPath = [UIBezierPath bezierPathWithArcCenter:point radius:maskRadius startAngle:-M_PI_2 endAngle:M_PI_2 * 3 clockwise:YES];
        CAShapeLayer *bgCircleLayer = [self setShapeLayerWithFillColor:[UIColor clearColor] strokeColor:[UIColor lightGrayColor] lineWidth:maskRadius*2 bezierPath:bgPath];
        self.layer.mask = bgCircleLayer;
        [self addAnimationWithLayer:bgCircleLayer animationName:@"maskLayerStrokeEnd"];
    }
}

#pragma mark 方法二：同一个path（圆形），通过控制渲染范围（strokeStart、strokeEnd）实现，该方式显然只支持stroke绘制

//（一个UIBezierPath，多次绘制，多次动画）
- (void)drawArcBarChartViewWithChartType {
    //入参检查 & 设置扇形参数
    CGFloat safeWidth = CGRectGetWidth(self.frame) -_drawParameters.arc.left -_drawParameters.arc.right;
    CGFloat safeHeight = CGRectGetHeight(self.frame) -_drawParameters.arc.top -_drawParameters.arc.bottom;
    if (safeWidth <= 0 || safeHeight <= 0) {
        NSLog(@"参数有误，无法正确绘制扇形图表!");
        return;
    }
    CGPoint centerPoint = CGPointMake(_drawParameters.arc.left +safeWidth/2, _drawParameters.arc.top +safeHeight/2);
    CGFloat radiusBasic = (safeWidth > safeHeight) ? safeHeight/4 : safeWidth/4;
    CGFloat lineWidth = radiusBasic*2;
    CGFloat hollowCircleRadius = _drawParameters.arc.hollowCircleRadius;
    if (hollowCircleRadius >= lineWidth) {
        hollowCircleRadius = 0;
    }
    if (hollowCircleRadius) {
        lineWidth -= hollowCircleRadius;
        radiusBasic = hollowCircleRadius +lineWidth/2;
    }
    __block CGFloat startPercent = 0;
    __block CGFloat endPercent = 0;
    //设置path
    UIBezierPath *otherPath = [UIBezierPath bezierPathWithArcCenter:centerPoint radius:radiusBasic startAngle:-M_PI_2 endAngle:M_PI_2 * 3 clockwise:YES];

    //计算总数
    CGFloat allValue = 0;
    for (NSNumber *value in _values) {
        allValue += value.floatValue;
    }
    //开始绘制
    [_values enumerateObjectsUsingBlock:^(NSNumber *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //计算当前end位置 = 上一个结束位置 + 当前部分百分比
        endPercent = [obj floatValue] / allValue + startPercent;

        //渲染
        CAShapeLayer *pie = [self setShapeLayerWithFillColor:[UIColor clearColor] strokeColor:XYQRandomColor lineWidth:lineWidth bezierPath:otherPath];
        pie.strokeStart = startPercent;
        pie.strokeEnd = endPercent;
        [self.layer addSublayer:pie];
        
        //添加文字(因为path从-M_PI_2开始，所以都减去初始值M_PI_2)
        CGFloat halfRadian = (endPercent -startPercent)*M_PI +startPercent*M_PI*2 -M_PI_2;
        CGFloat maxRudius = lineWidth +hollowCircleRadius;
        CGFloat X = centerPoint.x +(maxRudius +10)*cos(halfRadian);
        CGFloat Y = centerPoint.y +(maxRudius +10)*sin(halfRadian);
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(X, Y, 3, 3)];
        label.backgroundColor = [UIColor whiteColor];
        [self addSubview:label];

        //计算下一个start位置 = 当前end位置
        startPercent = endPercent;
        
        //这里虽然和方式一同样采取多次动画，但是动画效果却不一样，这里可以完美平滑的过渡。原因有：
        //1,方式一中每个path都不同；这里所有CAShapeLayer的path都是同一个
        //2,方式一每次动画针对不同的path，方式二每次动画针对同一个path（只不过path的渲染范围不同，但是这对动画毫无影响）
        //注意：strokeStart、strokeEnd只控制path渲染范围，但是动画不受这两个属性限制，仍然是针对整个path的
        if (!_drawParameters.arc.isMask) {
            [self addAnimationWithLayer:pie animationName:@"arcChartStrokeEnd"];
        }
    }];
    
    //是否使用mask进行裁剪(使用了mask，既可以使用原动画，也可以使用mask动画，也可以都使用，这里统一使用mask动画代替原动画)
    if (_drawParameters.arc.isMask) {
        CGFloat maskRadius = hollowCircleRadius ? ((lineWidth +hollowCircleRadius)/2 +1) : radiusBasic+1;
        UIBezierPath *bgPath = [UIBezierPath bezierPathWithArcCenter:centerPoint radius:maskRadius startAngle:-M_PI_2 endAngle:M_PI_2 * 3 clockwise:YES];
        CAShapeLayer *bgCircleLayer = [self setShapeLayerWithFillColor:[UIColor clearColor] strokeColor:[UIColor lightGrayColor] lineWidth:maskRadius*2 bezierPath:bgPath];
        self.layer.mask = bgCircleLayer;
        [self addAnimationWithLayer:bgCircleLayer animationName:@"maskLayerStrokeEnd"];
    }
}

#pragma mark - 封装方法调用集合

//设置单个柱形图颜色渐变
- (CAGradientLayer *)gradientWithFrame:(CGRect)frame targetColor:(CGColorRef)color {
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = frame;
    //设置渐变梯度（垂直）
    [gradientLayer setStartPoint:CGPointMake(0.0, 1.0)];
    [gradientLayer setEndPoint:CGPointMake(0.0, 0.0)];
    //设置过渡颜色
//    gradientLayer.colors = @[(id)[UIColor colorWithWhite:1 alpha:0.7].CGColor, (__bridge id)color];
    gradientLayer.colors = @[(id)[UIColor colorWithWhite:1 alpha:[self getAlphaWithColor:[UIColor colorWithCGColor:color]]].CGColor, (__bridge id)color];
    return gradientLayer;
}

//获取RGB和Alpha
- (CGFloat)getAlphaWithColor:(UIColor *)color {
    CGFloat red = 0.0;
    CGFloat green = 0.0;
    CGFloat blue = 0.0;
    CGFloat alpha = 0.0;
    [color getRed:&red green:&green blue:&blue alpha:&alpha];
    return alpha;
}

//layer渲染
- (CAShapeLayer *)setShapeLayerWithFillColor:(UIColor *)fillColor strokeColor:(UIColor *)strokeColor lineWidth:(CGFloat)lineWidth bezierPath:(UIBezierPath *)path {
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.lineWidth = lineWidth;
    shapeLayer.strokeColor = strokeColor.CGColor;
    shapeLayer.fillColor = fillColor.CGColor;
    shapeLayer.path = path.CGPath;
    return shapeLayer;
}

//给layer添加动画
- (void)addAnimationWithLayer:(CAShapeLayer *)shapeLayer animationName:(NSString *)aniName {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.duration = 2.0;
    animation.fromValue = @0.0f;
    animation.toValue = @1.0f;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [shapeLayer addAnimation:animation forKey:aniName];
}

@end
