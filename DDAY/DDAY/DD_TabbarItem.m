//
//  DD_TabbarItem.m
//  DDAY
//
//  Created by yyj on 16/5/20.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_TabbarItem.h"

#define t_width ScreenWidth/5.0f

@implementation DD_TabbarItem

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        //设置normal状态下 title的颜色
//        [self setTitleColor:_define_light_gray_color1 forState:UIControlStateNormal];
//        //设置select状态下 title的颜色
//        [self setTitleColor:_define_black_color forState:UIControlStateSelected];
//        //设置字体大小
//        self.titleLabel.font=[regular getFont:11.0f];
//        //设置居中
//        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}
//-(void)setType:(NSInteger)type
//{
//    if(type==0||type==1)
//    {
//        UIView *view=[UIView getCustomViewWithColor:_define_black_color];
//        view.frame=CGRectMake(t_width-3, 22, 3, ktabbarHeight-27);
//        [self addSubview:view];
//    }else if(type==3||type==4)
//    {
//        UIView *view=[UIView getCustomViewWithColor:_define_black_color];
//        view.frame=CGRectMake(0, 22, 3, ktabbarHeight-27);
//        [self addSubview:view];
//    }
//}
//- (CGRect)titleRectForContentRect:(CGRect)contentRect
//{
//    return CGRectMake(0, 0, t_width, 22);
//}
-(CGRect)imageRectForContentRect:(CGRect)contentRect
{
    
    if(IsPhone6_gt)
    {
        return CGRectMake((t_width-40)/2.0f, 16, 40, 40);
    }else
    {
        return CGRectMake((t_width-25)/2.0f, (ktabbarHeight-25)/2.0f, 25, 25);
    }
}


@end
