//
//  DD_CustomBtn.m
//  YCO SPACE
//
//  Created by yyj on 16/8/23.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_CustomBtn.h"

@implementation DD_CustomBtn

+(DD_CustomBtn *)getCustomTitleBtnWithAlignment:(NSInteger )_alignment WithFont:(CGFloat )_font WithSpacing:(CGFloat )_spacing WithNormalTitle:(NSString *)_normalTitle WithNormalColor:(UIColor *)_normalColor WithSelectedTitle:(NSString *)_selectedTitle WithSelectedColor:(UIColor *)_selectedColor;
{
    DD_CustomBtn *btn=[DD_CustomBtn buttonWithType:UIButtonTypeCustom];
    
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
+(DD_CustomBtn *)getCustomImgBtnWithImageStr:(NSString *)_normalImageStr WithSelectedImageStr:(NSString *)_selectedImageStr
{
    DD_CustomBtn *btn=[DD_CustomBtn buttonWithType:UIButtonTypeCustom];
    if(_normalImageStr){
        [btn setImage:[UIImage imageNamed:_normalImageStr] forState:UIControlStateNormal];
    }
    
    if(_selectedImageStr)
    {
        [btn setImage:[UIImage imageNamed:_selectedImageStr] forState:UIControlStateSelected];
    }
    
    return btn;
}
+(DD_CustomBtn *)getCustomBackImgBtnWithImageStr:(NSString *)_normalImageStr WithSelectedImageStr:(NSString *)_selectedImageStr
{
    DD_CustomBtn *btn=[DD_CustomBtn buttonWithType:UIButtonTypeCustom];
    if(_normalImageStr){
        [btn setBackgroundImage:[UIImage imageNamed:_normalImageStr] forState:UIControlStateNormal];
    }
    
    if(_selectedImageStr)
    {
        [btn setBackgroundImage:[UIImage imageNamed:_selectedImageStr] forState:UIControlStateSelected];
    }
    return btn;
}
+(DD_CustomBtn *)getCustomBtn
{
    return [DD_CustomBtn buttonWithType:UIButtonTypeCustom];
}

@end
