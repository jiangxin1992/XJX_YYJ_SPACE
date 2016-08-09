//
//  DD_DDAYDeatilBarBtn.h
//  YCO SPACE
//
//  Created by yyj on 16/8/9.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DD_DDAYDeatilBarBtn : UIButton
+(DD_DDAYDeatilBarBtn *)getCustomTitleBtnWithAlignment:(NSInteger )_alignment WithFont:(CGFloat )_font WithSpacing:(CGFloat )_spacing WithNormalTitle:(NSString *)_normalTitle WithNormalColor:(UIColor *)_normalColor WithSelectedTitle:(NSString *)_selectedTitle WithSelectedColor:(UIColor *)_selectedColor;
__string(type);
@end
