//
//  DD_OrderTabBarBtn.m
//  YCO SPACE
//
//  Created by yyj on 16/8/8.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_OrderTabBarBtn.h"

@implementation DD_OrderTabBarBtn
+(DD_OrderTabBarBtn *)getCustomTitleBtnWithAlignment:(NSInteger )_alignment WithFont:(CGFloat )_font WithSpacing:(CGFloat )_spacing WithNormalTitle:(NSString *)_normalTitle WithNormalColor:(UIColor *)_normalColor WithSelectedTitle:(NSString *)_selectedTitle WithSelectedColor:(UIColor *)_selectedColor;
{
    DD_OrderTabBarBtn *btn=[DD_OrderTabBarBtn buttonWithType:UIButtonTypeCustom];
    
    if(_normalTitle)
    {
        [btn setTitle:_normalTitle forState:UIControlStateNormal];
    }
    if(_normalColor)
    {
        [btn setTitleColor:_normalColor forState:UIControlStateNormal];
    }else
    {
        [btn setTitleColor:_define_black_color forState:UIControlStateNormal];
    }
    
    if(_selectedTitle)
    {
        [btn setTitle:_selectedTitle forState:UIControlStateSelected];
    }
    
    if(_selectedColor)
    {
        [btn setTitleColor:_selectedColor forState:UIControlStateSelected];
    }else
    {
        [btn setTitleColor:_define_black_color forState:UIControlStateSelected];
    }
    
    btn.contentHorizontalAlignment=_alignment;
    if(_font)
    {
        btn.titleLabel.font=[regular getFont:_font];
    }
    
    return btn;
}
+(DD_OrderTabBarBtn *)getCustomImgBtnWithImageStr:(NSString *)_normalImageStr WithSelectedImageStr:(NSString *)_selectedImageStr
{
    DD_OrderTabBarBtn *btn=[DD_OrderTabBarBtn buttonWithType:UIButtonTypeCustom];
    if(_normalImageStr){
        [btn setImage:[UIImage imageNamed:_normalImageStr] forState:UIControlStateNormal];
    }
    
    if(_selectedImageStr)
    {
        [btn setImage:[UIImage imageNamed:_selectedImageStr] forState:UIControlStateSelected];
    }
    return btn;
}

-(CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake((CGRectGetWidth(self.frame)-25)/2.0f, (CGRectGetHeight(self.frame)-25)/2.0f, 25, 25);
}
@end
