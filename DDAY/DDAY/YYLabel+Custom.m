//
//  YYLabel+Custom.m
//  YCO SPACE
//
//  Created by yyj on 16/8/24.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "YYLabel+Custom.h"

@implementation YYLabel (Custom)
+(YYLabel *)getLabelWithAlignment:(NSInteger )_alignment WithTitle:(NSString *)_title WithFont:(CGFloat )_font WithTextColor:(UIColor *)_textColor WithSpacing:(CGFloat )_spacing
{
    YYLabel *label=[[YYLabel alloc] init];
    label.textAlignment=_alignment;
    if(_title)
    {
        if(_spacing)
        {
            [label setAttributedText:[regular createAttributeString:_title andFloat:@(_spacing)]];
        }else
        {
            label.text=_title;
        }
    }
    if(_textColor)
    {
        label.textColor=_textColor;
    }else
    {
        label.textColor=_define_black_color;
    }
    
    if(_font)
    {
        label.font=[regular getFont:_font];
    }
    return label;
}
@end
