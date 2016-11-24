//
//  DD_CustomBtn.h
//  YCO SPACE
//
//  Created by yyj on 16/8/23.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_BaseButton.h"

@interface DD_CustomBtn : DD_BaseButton

/**
 * 创建带title 的自定义 btn
 */
+(DD_CustomBtn *)getCustomTitleBtnWithAlignment:(NSInteger )_alignment WithFont:(CGFloat )_font WithSpacing:(CGFloat )_spacing WithNormalTitle:(NSString *)_normalTitle WithNormalColor:(UIColor *)_normalColor WithSelectedTitle:(NSString *)_selectedTitle WithSelectedColor:(UIColor *)_selectedColor;

/**
 * 创建带image 的自定义 btn
 */
+(DD_CustomBtn *)getCustomImgBtnWithImageStr:(NSString *)_normalImageStr WithSelectedImageStr:(NSString *)_selectedImageStr;

/**
 * 创建带backimage 的自定义 btn
 */
+(DD_CustomBtn *)getCustomBackImgBtnWithImageStr:(NSString *)_normalImageStr WithSelectedImageStr:(NSString *)_selectedImageStr;

/**
 * 创建自定义 btn
 */
+(DD_CustomBtn *)getCustomBtn;

__string(type);

@end
