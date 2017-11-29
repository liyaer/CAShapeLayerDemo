//
//  VoiceVC.m
//  CAShapeLayerDemo
//
//  Created by 杜文亮 on 2017/11/28.
//  Copyright © 2017年 杜文亮. All rights reserved.
//

#import "VoiceVC.h"
#import "CAShapeLayer+ViewMask.h"
#import "VoiceView.h"

@interface VoiceVC ()

@end

@implementation VoiceVC
{
    VoiceView *voice;
    CGFloat _voice;
    BOOL _isDown;
    
    NSTimer *timer;
    CADisplayLink *_dispaly;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    voice = [[VoiceView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    voice.center = self.view.center;
    [self.view addSubview:voice];
    
    //NSTimer模拟不断重绘实现动画效果
    timer = [NSTimer timerWithTimeInterval:.5 repeats:YES block:^(NSTimer * _Nonnull timer)
    {
         if (_isDown)
         {
             if (_voice == 0)
             {
                 _voice += 10;
                 _isDown = NO;
             }
             else
             {
                 _voice -= 10;
             }
         }
         else
         {
             if (_voice == 90)
             {
                 _voice -= 10;
                 _isDown = YES;
             }
             else
             {
                 _voice += 10;
             }
         }
         [voice setVoiceValue:_voice];
     }];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    
    
    //CADisplayLink模拟不断重绘实现动画效果
//    _dispaly = [CADisplayLink displayLinkWithTarget:self selector:@selector(animationVoice)];
//    _dispaly.preferredFramesPerSecond = 10;
//    [_dispaly addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

-(void)animationVoice
{
    if (_isDown)
    {
     if (_voice == 0)
     {
         _voice += 1;
         _isDown = NO;
     }
     else
     {
         _voice -= 1;
     }
    }
    else
    {
     if (_voice == 90)
     {
         _voice -= 1;
         _isDown = YES;
     }
     else
     {
         _voice += 1;
     }
    }
    [voice setVoiceValue:_voice];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    if (timer)
    {
        if ([timer isValid])
        {
            [timer invalidate];
        }
        timer = nil;
    }
    
    if (_dispaly)
    {
        [_dispaly invalidate];
        _dispaly = nil;
    }
}

-(void)dealloc
{
    NSLog(@"====%@ 释放了！",[self class]);
}


@end
