//
//  CircleView.m
//  Bracelet
//
//  Created by 丁付德 on 16/3/14.
//  Copyright © 2016年 dfd. All rights reserved.
//

#import "CircleView.h"

@interface CircleView ()
{
    CGFloat circleWidth;
    CGFloat circleRadius;
    int type;
    CGFloat r;
    CGFloat g;
    CGFloat b;
    CGFloat a;
}
@end


@implementation CircleView

@synthesize circleRadius;
@synthesize circleWidth;

-(id) initWithFrameAndValue:(CGRect)frame  width:(CGFloat)width
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        circleWidth = width;
        circleRadius = frame.size.width / 2;
    }
    return self;
}

-(id) initWithFrameAndValue:(CGRect)frame R:(CGFloat)R G:(CGFloat)G B:(CGFloat)B A:(CGFloat)A
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        r = R;
        g = G;
        b = B;
        a = A;
        circleRadius = frame.size.width / 2;
    }
    return self;
}

-(void)setArrColor:(NSArray *)arrColor
{
    _arrColor = arrColor;
    [self setNeedsDisplay];
}


// 覆盖drawRect方法，你可以在此自定义绘画和动画
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (circleWidth) {
        CGContextSetRGBFillColor (context,  1, 0, 0, 1.0);//设置填充颜色
        
        if (!self.arrColor) {
            CGContextSetRGBStrokeColor(context,1,1,1,1);//画笔线的颜色
        }else{
            double R = [self.arrColor[0] doubleValue] / 255.0;
            double G = [self.arrColor[1] doubleValue] / 255.0;
            double B = [self.arrColor[2] doubleValue] / 255.0;
            CGContextSetRGBStrokeColor(context,R,G,B,1);//画笔线的颜色
        }
        
        CGContextSetLineWidth(context, circleWidth);//线的宽度
        //void CGContextAddArc(CGContextRef c,CGFloat x, CGFloat y,CGFloat radius,CGFloat startAngle,CGFloat endAngle, int clockwise)1弧度＝180°/π （≈57.3°） 度＝弧度×180°/π 360°＝360×π/180 ＝2π 弧度
        // x,y为圆点坐标，radius半径，startAngle为开始的弧度，endAngle为 结束的弧度，clockwise 0为顺时针，1为逆时针。
        CGContextAddArc(context, circleRadius, circleRadius, circleRadius - circleWidth, 0, 2*PI, 0); //添加一个圆
        CGContextDrawPath(context, kCGPathStroke); //绘制路径
    }else
    {
        CGContextSetRGBStrokeColor(context,1,1,1,1.0);//画笔线的颜色
        CGContextSetLineWidth(context, 1.0);//线的宽度
        //void CGContextAddArc(CGContextRef c,CGFloat x, CGFloat y,CGFloat radius,CGFloat startAngle,CGFloat endAngle, int clockwise)1弧度＝180°/π （≈57.3°） 度＝弧度×180°/π 360°＝360×π/180 ＝2π 弧度
        // x,y为圆点坐标，radius半径，startAngle为开始的弧度，endAngle为 结束的弧度，clockwise 0为顺时针，1为逆时针。
        CGContextAddArc(context, circleRadius, circleRadius, circleRadius, 0, 2*PI, 0); //添加一个圆
        CGContextDrawPath(context, kCGPathStroke); //绘制路径
    }
    
    
}



@end
