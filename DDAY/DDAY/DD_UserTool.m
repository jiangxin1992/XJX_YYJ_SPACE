//
//  DD_UserTool.m
//  DDAY
//
//  Created by yyj on 16/5/21.
//  Copyright © 2016年 YYJ. All rights reserved.
//
#import "DD_UserModel.h"
#import "DD_UserTool.h"

@implementation DD_UserTool
+(NSDictionary *)getUserListMap
{
    return @{
             @"homepage":NSLocalizedString(@"user_home_page", @"")
             ,@"fans":NSLocalizedString(@"user_fans", @"")
             ,@"order":NSLocalizedString(@"user_order", @"")
             ,@"coupons":NSLocalizedString(@"user_coupons", @"")
             ,@"consumption":NSLocalizedString(@"user_consumption", @"")
             ,@"conference":NSLocalizedString(@"user_conference", @"")
             ,@"collection":NSLocalizedString(@"user_collection", @"")
             ,@"customer":NSLocalizedString(@"user_contact_customer", @"")
             };
}
+(NSArray *)getUserListArr
{
//    2 设计师 3 普通用户 4 达人
    NSInteger _usertype=[DD_UserModel getUserType];
    if(_usertype==0||_usertype==3)
    {
//        3/0 未登录或普通用户
        return @[@"order"
                 ,@"coupons"
                 ,@"consumption"
                 ,@"conference"
                 ,@"collection"
                 ,@"customer"
                 ];
    }else if(_usertype==2)
    {
//        2 设计师
        return @[@"homepage"
                 ,@"fans"
                 ,@"order"
                 ,@"coupons"
                 ,@"consumption"
                 ,@"conference"
                 ,@"collection"
                 ,@"customer"];
    }else
    {
//        4 达人
        return @[@"homepage"
                 ,@"order"
                 ,@"coupons"
                 ,@"consumption"
                 ,@"conference"
                 ,@"collection"
                 ,@"customer"];
    }
    
}

@end
