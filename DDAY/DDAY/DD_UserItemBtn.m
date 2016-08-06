//
//  DD_UserItemBtn.m
//  YCO SPACE
//
//  Created by yyj on 16/8/6.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_UserItemBtn.h"

@implementation DD_UserItemBtn
+(DD_UserItemBtn *)getUserItemBtnWithFrame:(CGRect )frame WithImgSize:(CGSize )size WithImgeStr:(NSString *)imgStr WithTitle:(NSString *)title
{
    DD_UserItemBtn *shopBtn=[DD_UserItemBtn buttonWithType:UIButtonTypeCustom];
    if(shopBtn)
    {
        shopBtn.frame=frame;
        shopBtn.kframe=frame;
        shopBtn.size=size;
        shopBtn.titleLabel.font=[regular getFont:15.0f];
        shopBtn.titleLabel.textAlignment = 0;
        [shopBtn setTitleColor:_define_black_color forState:UIControlStateNormal];
        [shopBtn setImage:[UIImage imageNamed:imgStr] forState:UIControlStateNormal];
        [shopBtn setTitle:title forState:UIControlStateNormal];
    }
    return shopBtn;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(33, 0, _kframe.size.width-33, _kframe.size.height);
}
-(CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(0, (50-(_size.height/_size.width)*21)/2.0f, 21, (_size.height/_size.width)*21);
}

@end
