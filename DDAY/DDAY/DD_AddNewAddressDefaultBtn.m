//
//  DD_AddNewAddressDefaultBtn.m
//  YCO SPACE
//
//  Created by yyj on 16/8/4.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_AddNewAddressDefaultBtn.h"

@implementation DD_AddNewAddressDefaultBtn
+(DD_AddNewAddressDefaultBtn *)getBtn
{
    DD_AddNewAddressDefaultBtn *btn=[DD_AddNewAddressDefaultBtn buttonWithType:UIButtonTypeCustom];
    if(btn)
    {
        //设置normal状态下 title的颜色
        [btn setTitleColor:_define_black_color forState:UIControlStateNormal];
        //设置select状态下 title的颜色
        [btn setTitleColor:_define_black_color forState:UIControlStateSelected];
        [btn setImage:[UIImage imageNamed:@"System_nocheck"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"System_check"] forState:UIControlStateSelected];
        [btn setTitle:@"设为默认地址" forState:UIControlStateNormal];
        [btn setTitle:@"设为默认地址" forState:UIControlStateSelected];
        //设置字体大小
        btn.titleLabel.font=[regular getFont:14.0f];
        //设置居中
        btn.titleLabel.textAlignment = 1;
    }
    return btn;
}


- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(30, 0, 174-56, 57);
}
-(CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(0, (57-15)/2.0f, 15, 15);
}

@end
