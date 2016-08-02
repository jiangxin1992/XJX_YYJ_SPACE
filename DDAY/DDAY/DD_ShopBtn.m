//
//  DD_ShopBtn.m
//  YCO SPACE
//
//  Created by yyj on 16/8/2.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_ShopBtn.h"

@implementation DD_ShopBtn
+(DD_ShopBtn *)getShopBtn
{
    DD_ShopBtn *shopBtn=[DD_ShopBtn buttonWithType:UIButtonTypeCustom];
    if(shopBtn)
    {
        shopBtn.frame=CGRectMake(0, 0, 44, 44);
        [shopBtn setImage:[UIImage imageNamed:@"System_Buy"] forState:UIControlStateNormal];
        [shopBtn setImage:[UIImage imageNamed:@"System_Buy"] forState:UIControlStateSelected];
    }
    return shopBtn;
}
-(CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(44-25,(44-24)/2.0f , 25, 24);
}
@end
