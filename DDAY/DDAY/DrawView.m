//
//  Xiexian.m
//  asadsadsads
//
//  Created by yyj on 16/7/28.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DrawView.h"

//#import "DD_PointModel.h"
#import "DD_RGBModel.h"

@implementation DrawView
-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if(self)
    {
        self.backgroundColor=_define_white_color;
    }
    return self;
}
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
-(instancetype)initWithStartP:(CGPoint )start_point WithEndP:(CGPoint )end_point WithLineWidth:(CGFloat )width WithColorType:(NSInteger )type
{
    self=[super init];
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
//-(instancetype)initWithPonitArr:(NSArray *)pointArr WithLineWidth:(CGFloat )width WityType:(NSInteger )type
//{
//    self=[super init];
//    if(self)
//    {
//        _type=type;
//        _pointArr=pointArr;
//        _width=width;
//        self.backgroundColor=[UIColor clearColor];
//    }
//    return self;
//}
-(void)Update
{
    [self setNeedsDisplay];//重新绘制
}
-(void)drawRect:(CGRect)rect
{
//    if(_type==3)
//    {
//        if(_pointArr&&_pointArr.count)
//        {
//            CGContextRef
//            context = UIGraphicsGetCurrentContext();//获得处理的上下文
//            
//            CGContextSetLineCap(context,kCGLineCapSquare);//指定直线样式
//            
//            CGContextSetLineWidth(context,_width);//直线宽度
//            CGContextBeginPath(context);//开始绘制
//            for (int i=0; i<_pointArr.count; i++) {
//                NSDictionary *_line_dict=[_pointArr objectAtIndex:i];
//                DD_RGBModel *RGBModel=[DD_RGBModel initWithColorCode:[_line_dict objectForKey:@"colorCode"]];
//                CGContextSetRGBStrokeColor(context,RGBModel.R/255.0 ,RGBModel.G/255.0 ,RGBModel.B/255.0 , 1.0);
//                NSArray *_point_arr=[_line_dict objectForKey:@"pointarr"];
//                for (int j=0; j<_point_arr.count; j++)
//                {
//                    NSDictionary *_point=[_point_arr objectAtIndex:j];
//                    if(j==0)
//                    {
//                        CGContextMoveToPoint(context,[[_point objectForKey:@"x_p"] integerValue], [[_point objectForKey:@"y_p"] integerValue]);//画笔移动到点(31,170)
//                    }else
//                    {
//                        CGContextAddLineToPoint(context,[[_point objectForKey:@"x_p"] integerValue], [[_point objectForKey:@"y_p"] integerValue]);//下一点
//                    }
//                }
//                CGContextStrokePath(context);//绘制完成
//            }
//            
//        }
//        
//    }else
//    {
        CGContextRef
        context = UIGraphicsGetCurrentContext();//获得处理的上下文
        
        CGContextSetLineCap(context,
                            kCGLineCapSquare);//指定直线样式
        
        CGContextSetLineWidth(context,
                              _width);//直线宽度
        
        //设置颜色
        if(_type==1){
            CGContextSetRGBStrokeColor(context, 0, 0, 0, 1.0);
        }else if(_type==2)
        {
            CGContextSetRGBStrokeColor(context,1, 42.0f/255.0f, 67.0f/255.0f, 1.0);
        }
        
        CGContextBeginPath(context);//开始绘制
        
        CGContextMoveToPoint(context,_start_point.x, _start_point.y);//画笔移动到点(31,170)
        
        CGContextAddLineToPoint(context,_end_point.x, _end_point.y);//下一点
        
        CGContextStrokePath(context);//绘制完成
//    }
    
}
@end
