//
//  DD_NavBtn.h
//  YCO SPACE
//
//  Created by yyj on 16/8/3.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DD_NavBtn : UIButton

+(DD_NavBtn *)getNavBtnIsLeft:(BOOL )isLeft WithSize:(CGSize )size WithImgeStr:(NSString *)imgStr;
+(DD_NavBtn *)getNavBtnWithSize:(CGSize )size WithImgeStr:(NSString *)imgStr;
+(DD_NavBtn *)getShopBtn;
+(DD_NavBtn *)getBackBtn;
+(DD_NavBtn *)getBackBtnNormal;



@property (nonatomic,assign)CGSize size;
@property(nonatomic,assign) BOOL isLeft;
@property(nonatomic,assign) BOOL isNormal;

@end
