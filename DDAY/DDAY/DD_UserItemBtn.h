//
//  DD_UserItemBtn.h
//  YCO SPACE
//
//  Created by yyj on 16/8/6.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DD_UserItemBtn : UIButton

+(DD_UserItemBtn *)getUserItemBtnWithFrame:(CGRect )frame WithImgSize:(CGSize )size WithImgeStr:(NSString *)imgStr WithTitle:(NSString *)title;

@property (nonatomic,assign) CGSize size;

@property (nonatomic,assign) CGRect kframe;

__string(type);

__label(rewardPoints_label);

@end
