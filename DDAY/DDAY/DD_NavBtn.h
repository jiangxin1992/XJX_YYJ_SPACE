//
//  DD_NavBtn.h
//  YCO SPACE
//
//  Created by yyj on 16/8/3.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_BaseButton.h"

@interface DD_NavBtn : DD_BaseButton

+(DD_NavBtn *)getNavBtnIsLeft:(BOOL )isLeft WithSize:(CGSize )size WithImgeStr:(NSString *)imgStr;

+(DD_NavBtn *)getNavBtnIsLeft:(BOOL )isLeft WithSize:(CGSize )size WithImgeStr:(NSString *)imgStr WithWidth:(CGFloat )width;

+(DD_NavBtn *)getNavBtnWithSize:(CGSize )size WithImgeStr:(NSString *)imgStr;

+(DD_NavBtn *)getShopBtn;

+(DD_NavBtn *)getBackBtn;

+(DD_NavBtn *)getBackBtnNormal;

@property (nonatomic,assign)CGSize size;
@property(nonatomic,assign) BOOL isLeft;
@property(nonatomic,assign) BOOL isNormal;

@end
