//
//  DD_DDAYDeatilBarBtn.m
//  YCO SPACE
//
//  Created by yyj on 16/8/9.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_DDAYDeatilBarBtn.h"

@implementation DD_DDAYDeatilBarBtn
+(DD_DDAYDeatilBarBtn *)getCustomTitleBtnWithAlignment:(NSInteger )_alignment WithFont:(CGFloat )_font WithSpacing:(CGFloat )_spacing WithNormalTitle:(NSString *)_normalTitle WithNormalColor:(UIColor *)_normalColor WithSelectedTitle:(NSString *)_selectedTitle WithSelectedColor:(UIColor *)_selectedColor;
{
    DD_DDAYDeatilBarBtn *btn=[DD_DDAYDeatilBarBtn buttonWithType:UIButtonTypeCustom];
    
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
@end
