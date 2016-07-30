//
//  Xiexian.m
//  asadsadsads
//
//  Created by yyj on 16/7/28.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DrawView.h"

@implementation DrawView
-(instancetype)initWithFrame:(CGRect)frame WithStartP:(CGPoint )start_point WithEndP:(CGPoint )end_point WithLineWidth:(CGFloat )width WithColorType:(NSInteger )type
{
    self=[super initWithFrame:frame];
    if(self)
    {
        _start_point=start_point;
        _end_point=end_point;
        _width=width;
        _type=type;
        self.backgroundColor=[UIColor clearColor];
    }
    return self;
}

-(void)drawRect:(CGRect)rect
{   
    CGContextRef
    context = UIGraphicsGetCurrentContext();//获得处理的上下文
    
    CGContextSetLineCap(context,
                        kCGLineCapSquare);//指定直线样式
    
    CGContextSetLineWidth(context,
                          _width);//直线宽度
    
    //设置颜色
    if(_type==1){
        CGContextSetRGBStrokeColor(context,
                                   0, 0, 0, 1.0);
    }else if(_type==2)
    {
        CGContextSetRGBStrokeColor(context,
                                   1, 42.0f/255.0f, 67.0f/255.0f, 1.0);
    }
    
    CGContextBeginPath(context);//开始绘制
    
    CGContextMoveToPoint(context,
                         _start_point.x, _start_point.y);//画笔移动到点(31,170)

    CGContextAddLineToPoint(context,
                            _end_point.x, _end_point.y);//下一点
    
    CGContextStrokePath(context);//绘制完成
}
@end
