//
//  Dwl_BezierPathShapeLayerView.h
//  CAShapeLayerDemo
//
//  Created by Mac on 2019/4/12.
//  Copyright © 2019 杜文亮. All rights reserved.
//

#import <UIKit/UIKit.h>


// 图表类型
typedef NS_ENUM(NSInteger, WLChartType) {
    WLBarChartHorizontal,//柱形图(横向)
    WLBarChartVertical,//柱形图（纵向）
    WLArcChart,//扇形图
};

// 根据所需参数构造结构体
//单个柱形图宽度，柱形图间隔，顶部描述高度，底部描述高度
typedef struct WLDrawBarChartHorizontal {
    CGFloat singleBarChartWidth, margin, top, bottom;
}WLDrawBarChartHorizontal;

//单个柱形图宽度，柱形图间隔，左部描述高度，右部描述高度
typedef struct WLDrawBarChartVertical {
    CGFloat singleBarChartWidth, margin, left, right;
}WLDrawBarChartVertical;

//距离四边缘的距离，中间空心圆的半径，是否使用遮罩
typedef struct WLDrawArcChart {
    CGFloat top, left, bottom, right, hollowCircleRadius;
    BOOL isMask;
}WLDrawArcChart;

typedef struct WLDrawParameters {
    WLDrawBarChartHorizontal horizontal;
    WLDrawBarChartVertical vertical;
    WLDrawArcChart arc;
} WLDrawParameters;

// 内联函数
UIKIT_STATIC_INLINE WLDrawBarChartHorizontal WLDrawBarChartHorizontalMake(CGFloat singleBarChartWidth, CGFloat margin, CGFloat top, CGFloat bottom) {
    WLDrawBarChartHorizontal horizontal = {singleBarChartWidth, margin, top, bottom};
    return horizontal;
}

CG_INLINE WLDrawBarChartVertical WLDrawBarChartVerticalMake(CGFloat singleBarChartWidth, CGFloat margin, CGFloat left, CGFloat right) {
    WLDrawBarChartVertical vertical = {singleBarChartWidth, margin, left, right};
    return vertical;
}

CG_INLINE WLDrawArcChart WLDrawArcChartMake(CGFloat top, CGFloat left, CGFloat bottom, CGFloat right, CGFloat hollowCircleRadius, BOOL isMask) {
    WLDrawArcChart arc = {top, left, bottom, right, hollowCircleRadius, isMask};
    return arc;
}

CG_INLINE WLDrawParameters WLDrawParametersMake(WLDrawBarChartHorizontal horizontal, WLDrawBarChartVertical vertical, WLDrawArcChart arc) {
    WLDrawParameters parameters = {horizontal, vertical, arc};
    return parameters;
}


@interface Dwl_BezierPathShapeLayerView : UIView

/**  --- DWL ---
 *   方法说明 : 全屏撑满绘制。以横向为例，图示关系：_H_H_H_（_：柱形间隔，H:柱形图）
 *   @parem frame : view的frame
 *   @parem titles : 柱形图底部说明
 *   @parem values : 柱形图顶部说明
 *   @parem chartType : 图表类型
 *   @parem drawParameters : 绘制参数
 */
- (instancetype)initWithFrame:(CGRect)frame drawViewWithTitles:(NSArray <NSString *>*)titles values:(NSArray <NSNumber *>*)values chartType:(WLChartType)chartType drawParameters:(WLDrawParameters)drawParameters;

@end


