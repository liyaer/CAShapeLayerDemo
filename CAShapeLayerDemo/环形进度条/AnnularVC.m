//
//  AnnularVC.m
//  CAShapeLayerDemo
//
//  Created by 杜文亮 on 2017/11/29.
//  Copyright © 2017年 杜文亮. All rights reserved.
//

#import "AnnularVC.h"
#import "QLCycleProgressView.h"

@interface AnnularVC ()

@property (nonatomic, strong) QLCycleProgressView *progressView;

@end

@implementation AnnularVC

- (QLCycleProgressView *)progressView
{
    if (!_progressView)
    {
        _progressView = [[QLCycleProgressView alloc]initWithFrame:CGRectMake(100, 200, 200, 200)];
    }
    return _progressView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view addSubview:self.progressView];
    _progressView.animationDuration = 6.0;//故意让动画时长大于延时执行的时长，为了看到前一个动画的移除效果（有个Bug：动画是可以移除，但是滚动数字并未一同移除，所以会看到滚动数字的不理想效果，不过这里不是重点，无需在意）
    _progressView.progress = .3;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _progressView.mainColor = [UIColor purpleColor];
        _progressView.progress = .6;
    });
}

-(void)dealloc
{
    NSLog(@"%@ === 释放了！",[self class]);
}

@end
