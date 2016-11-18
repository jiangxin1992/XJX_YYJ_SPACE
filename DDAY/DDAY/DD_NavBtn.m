//
//  DD_NavBtn.m
//  YCO SPACE
//
//  Created by yyj on 16/8/3.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_NavBtn.h"

@implementation DD_NavBtn
+(DD_NavBtn *)getNavBtnIsLeft:(BOOL )isLeft WithSize:(CGSize )size WithImgeStr:(NSString *)imgStr
{
    DD_NavBtn *shopBtn=[DD_NavBtn buttonWithType:UIButtonTypeCustom];
    if(shopBtn)
    {
        shopBtn.frame=CGRectMake(0, 0, 30, 44);
        [shopBtn setImage:[UIImage imageNamed:imgStr] forState:UIControlStateNormal];
        [shopBtn setImage:[UIImage imageNamed:imgStr] forState:UIControlStateSelected];
        shopBtn.isLeft=isLeft;
        shopBtn.size=size;
    }
    return shopBtn;
}
+(DD_NavBtn *)getNavBtnIsLeft:(BOOL )isLeft WithSize:(CGSize )size WithImgeStr:(NSString *)imgStr WithWidth:(CGFloat )width
{
    DD_NavBtn *shopBtn=[DD_NavBtn buttonWithType:UIButtonTypeCustom];
    if(shopBtn)
    {
        shopBtn.frame=CGRectMake(0, 0, width, 44);
        [shopBtn setImage:[UIImage imageNamed:imgStr] forState:UIControlStateNormal];
        [shopBtn setImage:[UIImage imageNamed:imgStr] forState:UIControlStateSelected];
        shopBtn.isLeft=isLeft;
        shopBtn.size=size;
    }
    return shopBtn;
}
+(DD_NavBtn *)getNavBtnWithSize:(CGSize )size WithImgeStr:(NSString *)imgStr
{
    DD_NavBtn *shopBtn=[DD_NavBtn buttonWithType:UIButtonTypeCustom];
    if(shopBtn)
    {
        shopBtn.frame=CGRectMake(0, 0, 30, 44);
        [shopBtn setImage:[UIImage imageNamed:imgStr] forState:UIControlStateNormal];
        [shopBtn setImage:[UIImage imageNamed:imgStr] forState:UIControlStateSelected];
        shopBtn.size=size;
        shopBtn.isNormal=YES;
    }
    return shopBtn;
}

+(DD_NavBtn *)getShopBtn
{
    DD_NavBtn *shopBtn=[DD_NavBtn buttonWithType:UIButtonTypeCustom];
    if(shopBtn)
    {
        shopBtn.frame=CGRectMake(0, 0, 30, 44);
        [shopBtn setImage:[UIImage imageNamed:@"Order_Buy"] forState:UIControlStateNormal];
        [shopBtn setImage:[UIImage imageNamed:@"Order_Buy"] forState:UIControlStateSelected];
        shopBtn.isLeft=NO;
        shopBtn.size=CGSizeMake(25, 25);
    }
    return shopBtn;
}
+(DD_NavBtn *)getBackBtn
{
    DD_NavBtn *shopBtn=[DD_NavBtn buttonWithType:UIButtonTypeCustom];
    if(shopBtn)
    {
        shopBtn.frame=CGRectMake(0, 0, 30, 44);
        [shopBtn setImage:[UIImage imageNamed:@"System_Back"] forState:UIControlStateNormal];
        [shopBtn setImage:[UIImage imageNamed:@"System_Back"] forState:UIControlStateSelected];
        shopBtn.isLeft=YES;
        shopBtn.size=CGSizeMake(11, 19);
    }
    return shopBtn;
}
+(DD_NavBtn *)getBackBtnNormal
{
    DD_NavBtn *shopBtn=[DD_NavBtn buttonWithType:UIButtonTypeCustom];
    if(shopBtn)
    {
        shopBtn.frame=CGRectMake(0, 0, 30, 44);
        [shopBtn setImage:[UIImage imageNamed:@"System_Back"] forState:UIControlStateNormal];
        [shopBtn setImage:[UIImage imageNamed:@"System_Back"] forState:UIControlStateSelected];
        shopBtn.isNormal=YES;
        shopBtn.size=CGSizeMake(11, 19);
    }
    return shopBtn;
}
-(CGRect)imageRectForContentRect:(CGRect)contentRect
{
    if(_isNormal)
    {
        return CGRectMake((44-_size.width)/2.0f ,(44-_size.height)/2.0f ,_size.width ,_size.height);
        
    }else
    {
        CGFloat _Offset=((30-_size.width)/2.0f)-9;
        if(_isLeft)
        {
//            [self setEnlargeEdgeWithTop:0 right:-_Offset bottom:0 left:((44-_size.width)/2.0f)-16+_Offset];
            return CGRectMake(_Offset,(44-_size.height)/2.0f , _size.width, _size.height);
            
        }else
        {
//            [self setEnlargeEdgeWithTop:0 right:+_Offset bottom:0 left:((44-_size.width)/2.0f)-16-_Offset];
            return CGRectMake(9+((30-_size.width)/2.0f),(44-_size.height)/2.0f , _size.width, _size.height);
        }
    }
    
}
@end
