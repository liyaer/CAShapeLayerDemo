//
//  QLProgressView.m
//  Test2
//
//  Created by MQL-IT on 2017/8/16.
//  Copyright © 2017年 MQL-IT. All rights reserved.
//

#import "QLCycleProgressView.h"

@interface QLCycleProgressView ()

@property (nonatomic, strong) CAShapeLayer *backBorderLayer;//大圆
@property (nonatomic, strong) CAShapeLayer *backLayer; //小圆
@property (nonatomic, strong) CAShapeLayer *progressLayer;
@property (nonatomic, strong) UILabel *countJump;

@end




@implementation QLCycleProgressView

#pragma mark - 懒加载

- (UILabel *)countJump
{
    if (!_countJump)
    {
        _countJump = [[UILabel alloc] init];
        _countJump.textColor = [UIColor redColor];
        _countJump.font = [UIFont systemFontOfSize:25];
        _countJump.textAlignment = NSTextAlignmentCenter;
    }
    return _countJump;
}

#pragma mark - 初始化

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        _needAnimation = 1.0;
        [self backgroundCyclePath];
    }
    return self;
}

// 绘制圆形路径
- (void)backgroundCyclePath
{
    /*
     *   环形
     */
    CGPoint center = CGPointMake(CGRectGetWidth(self.bounds)/2, CGRectGetHeight(self.bounds)/2);
    CGFloat radius = 90;
    CGFloat startA =  M_PI_4 * 3;  //设置进度条起点位置
    CGFloat endA = M_PI * 2 + M_PI_4;  //设置进度条终点位置(写成M_PI_4也能达到效果，但是还是按正常逻辑来写)
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startA endAngle:endA clockwise:YES];//上面说明过了用来构建圆 YES：顺时针
    
    _backBorderLayer = [CAShapeLayer layer];
    _backBorderLayer.frame = self.bounds;
    _backBorderLayer.fillColor = [[UIColor clearColor] CGColor];
    _backBorderLayer.strokeColor = [UIColor redColor].CGColor;
    _backBorderLayer.opacity = 1; //背景颜色的透明度
    _backBorderLayer.lineCap = kCALineCapRound;//指定线的边缘是圆的
    _backBorderLayer.lineWidth = 12;//线的宽度
    _backBorderLayer.path = path.CGPath;
    [self.layer addSublayer:_backBorderLayer];
    
    //获取环形路径（画一个圆形，填充色透明，设置线框宽度为10，这样就获得了一个环形）
    _backLayer = [CAShapeLayer layer];//创建一个track shape layer
    _backLayer.frame = self.bounds;
    _backLayer.fillColor = [[UIColor clearColor] CGColor];  //填充色为无色
    _backLayer.strokeColor = [[UIColor lightGrayColor] CGColor]; //指定path的渲染颜色,这里可以设置任意不透明颜色
    _backLayer.opacity = 1; //背景颜色的透明度
    _backLayer.lineCap = kCALineCapRound;//指定线的边缘是圆的
    _backLayer.lineWidth = 10;//线的宽度
    _backLayer.path =[path CGPath]; //把path传递給layer，然后layer会处理相应的渲染，整个逻辑和CoreGraph是一致的。
    [self.layer addSublayer:_backLayer];
    
    
    /*
     *   进度条
     */
    _progressLayer = [CAShapeLayer layer];
    _progressLayer.frame = self.bounds;
    _progressLayer.fillColor = [UIColor clearColor].CGColor;
    _progressLayer.strokeColor = [UIColor redColor].CGColor;
    _progressLayer.opacity = 1;
    _progressLayer.lineCap = kCALineCapRound;
    _progressLayer.lineWidth = 10;
    [self.layer addSublayer:_progressLayer];
    
    
    //label
    [self addSubview:self.countJump];
    _countJump.translatesAutoresizingMaskIntoConstraints = NO;
    [_countJump.centerXAnchor constraintEqualToAnchor:self.centerXAnchor].active = YES;
    [_countJump.centerYAnchor constraintEqualToAnchor:self.centerYAnchor].active = YES;
}




#pragma mark ******** setter / getter

//下面四个方法，体现出相对于drawRect方式的灵活性，直接修改绘制属性即可更新绘制内容
- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    
    //根据进度，重新设置Label内容动态显示
    [self countJumpAction];
    
    //根据进度，重新设置Path
    CGPoint center = CGPointMake(CGRectGetWidth(self.bounds)/2, CGRectGetHeight(self.bounds)/2);
    CGFloat radius = 90;
    CGFloat startA =  M_PI_4 * 3;  //设置进度条起点位置
    CGFloat endA = M_PI_4*3 + M_PI_2*3/*开始点至结束点的弧度*/ *_progress;//设置进度条终点位置
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startA endAngle:endA clockwise:YES];
    _progressLayer.path = path.CGPath;
    
    //动画效果
    [_progressLayer removeAnimationForKey:@"animation1"];//防止上个动画未执行完，所以手动提前移除动画；若上个动画已执行完，那么实际上这里的移除时多余的，默认动画完成会自动移除
    CABasicAnimation *pathAniamtion = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAniamtion.duration = self.animationDuration;// 时间
    pathAniamtion.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];//动画节奏
    //动画范围0~1代表全程动画,对应strokeStart=0.0,strokeEnd=1.0的属性设置
    pathAniamtion.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAniamtion.toValue = [NSNumber numberWithFloat:1.0];
    //    pathAniamtion.autoreverses = YES; //动画逆方向
    [_progressLayer addAnimation:pathAniamtion forKey:@"animation1"];
}

- (void)setMainColor:(UIColor *)mainColor
{
    _mainColor = mainColor;
    _backBorderLayer.strokeColor = mainColor.CGColor;
    _progressLayer.strokeColor = mainColor.CGColor;
    _countJump.textColor = mainColor;
}

- (void)setFillColor:(UIColor *)fillColor
{
    _fillColor = fillColor;
    _backLayer.strokeColor = fillColor.CGColor;
}

- (void)setLine_width:(CGFloat)line_width
{
    _line_width = line_width;
    _backLayer.lineWidth = line_width;
    _progressLayer.lineWidth = line_width;
    _backBorderLayer.lineWidth = line_width + 2;
}

- (CGFloat)animationDuration
{
    if (_animationDuration == 0)
    {
        return _needAnimation;
    }
    return _needAnimation ? _animationDuration : 0.0;
}




#pragma mark - 封装方法调用集合

// 启动数字滚动
- (void)countJumpAction
{
    __block int _numText = 0;
    //全局队列    默认优先级
    dispatch_queue_t quene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //定时器模式  事件源
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, quene);
    //NSEC_PER_SEC是秒，＊1是每秒
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), NSEC_PER_SEC * (self.animationDuration/(_progress * 100)), 0);
    //设置响应dispatch源事件的block，在dispatch源指定的队列上运行
    dispatch_source_set_event_handler(_timer, ^{
        //回调主线程，在主线程中操作UI
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_numText < _progress * 100)
            {
                _countJump.text = [NSString stringWithFormat:@"%d%%",_numText];
                _numText++;
            }
            else
            {
                _countJump.text = [NSString stringWithFormat:@"%d%%",_numText];
                dispatch_source_cancel(_timer);
            }
        });
    });
    //启动源
    dispatch_resume(_timer);
}


@end
