//
//  UIView+Custom.m
//  YCO SPACE
//
//  Created by yyj on 16/7/20.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "UIView+Custom.h"

@implementation UIView (Custom)
+(UIView *)getCustomViewWithColor:(NSString *)_color
{
    UIView *view=[[UIView alloc] init];
    if(_color)
    {
        view.backgroundColor=[UIColor colorWithHexString:_color];
    }
    return view;
}
@end
