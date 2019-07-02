//
//  DemoVC.m
//  CAShapeLayerDemo
//
//  Created by 杜文亮 on 2017/11/27.
//  Copyright © 2017年 杜文亮. All rights reserved.
//

#import "DemoVC.h"
#import "BezierCurveView.h"
#import "Dwl_BezierPathShapeLayerView.h"


#define SCREEN_W  [UIScreen mainScreen].bounds.size.width
#define SCREEN_H  [UIScreen mainScreen].bounds.size.height


@interface DemoVC ()

@property (strong,nonatomic)BezierCurveView *bezierView;
@property (strong,nonatomic)NSMutableArray *x_names;
@property (strong,nonatomic)NSMutableArray *targets;

@end




@implementation DemoVC

/**
 *  X轴值
 */
-(NSMutableArray *)x_names{
    if (!_x_names) {
        _x_names = [NSMutableArray arrayWithArray:@[@"语文",@"数学",@"英语",@"物理",@"化学",@"生物",@"政治",@"历史",@"地理"]];
    }
    return _x_names;
}
/**
 *  Y轴值
 */
-(NSMutableArray *)targets{
    if (!_targets) {
        _targets = [NSMutableArray arrayWithArray:@[@200,@40,@20,@50,@30,@90,@30,@200,@70]];
    }
    return _targets;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //1.初始化
//    _bezierView = [BezierCurveView initWithFrame:CGRectMake(30, 30, SCREEN_W-60, 280)];
//    _bezierView.center = self.view.center;
//    [self.view addSubview:_bezierView];
    
    //2.折线图
//    [self drawLineChart];
    
    //3.柱状图
//    [self drawBaseChart];
    
    //4.饼状图
//    [self drawPieChart];

    WLDrawBarChartHorizontal horizontal = WLDrawBarChartHorizontalMake(5, 27, 20, 30);
    WLDrawBarChartVertical vertical = WLDrawBarChartVerticalMake(5, 40, 40, 40);
    WLDrawArcChart arc = WLDrawArcChartMake(10, 10, 30, 30, 70, NO);
    WLDrawParameters drawParameters = WLDrawParametersMake(horizontal, vertical, arc);
        
    Dwl_BezierPathShapeLayerView *bezier = [[Dwl_BezierPathShapeLayerView alloc] initWithFrame:CGRectMake(30, 30, SCREEN_W-60, 280) drawViewWithTitles:self.x_names values:self.targets chartType:WLArcChart drawParameters:drawParameters];
    bezier.center = self.view.center;
    [self.view addSubview:bezier];
}

//画折线图
-(void)drawLineChart
{
    //直线
    //    [_bezierView drawLineChartViewWithX_Value_Names:self.x_names TargetValues:self.targets LineType:LineType_Straight];
    
    //曲线
    [_bezierView drawLineChartViewWithX_Value_Names:self.x_names TargetValues:self.targets LineType:LineType_Curve];
}


//画柱状图
-(void)drawBaseChart
{
    [_bezierView drawBarChartViewWithX_Value_Names:self.x_names TargetValues:self.targets];
}


//画饼状图
-(void)drawPieChart
{
    [_bezierView drawPieChartViewWithX_Value_Names:self.x_names TargetValues:self.targets];
}


@end
