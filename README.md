# CAShapeLayerDemo
CAShapeLayer配合UIBezierPath实现绘制内容


两种绘制图形CAShapeLayer和drawRect的比较：
    drawRect：属于CoreGraphics框架，占用CPU，性能消耗大（drawRect只是一个方法而已，是UIView的方法，重写此方法可以完成我们的绘制图形功能）
    CAShapeLayer：属于CoreAnimation框架，通过GPU来渲染图形，节省性能。动画渲染直接提交给手机GPU，不消耗内存
    这两者各有各的用途，而不是说有了CAShapeLayer就不需要drawRect。
        
注意：
    drawRect、CAShapeLayer可以看成是两种制图渲染器，但是无论哪一种，都需要一个绘制样式传递给制图渲染器，才能开始绘制。
    对于drawRect而言，写在里面的方法就是在构造绘制样式，而这个构造样式的过程，可以通过CoreGraphics框架中的CGContextRef来实现，也可以通过UIBezierPath来实现
    对于CAShapeLayer而言也一样，通过UIBezierPath或者CoreGraphics框架中的CGContextRef实现复杂样式的构造

===================================================================

关于本篇Demo学习深度介绍：
    BaseVC：基础知识介绍，绘制一些基本图形；
    柱状图、折线图、饼状图：折线图加入了动画效果；
    模拟语音动态显示：通过属性的改变动态更新绘制内容；
    环形进度条：动态绘制+动画的大综合
