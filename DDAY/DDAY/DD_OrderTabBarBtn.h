//
//  DD_OrderTabBarBtn.h
//  YCO SPACE
//
//  Created by yyj on 16/8/8.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DD_OrderTabBarBtn : UIButton
+(DD_OrderTabBarBtn *)getCustomTitleBtnWithAlignment:(NSInteger )_alignment WithFont:(CGFloat )_font WithSpacing:(CGFloat )_spacing WithNormalTitle:(NSString *)_normalTitle WithNormalColor:(UIColor *)_normalColor WithSelectedTitle:(NSString *)_selectedTitle WithSelectedColor:(UIColor *)_selectedColor;
+(DD_OrderTabBarBtn *)getCustomImgBtnWithImageStr:(NSString *)_normalImageStr WithSelectedImageStr:(NSString *)_selectedImageStr;
__string(type);
@end
