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
             ,@"set":NSLocalizedString(@"user_set_title", @"")
             };
}
+(NSArray *)getUserImgListArr
{
    //    2 设计师 3 普通用户 4 达人
    NSInteger _usertype=[DD_UserModel getUserType];
    if(_usertype==0||_usertype==3)
    {
        //        3/0 未登录或普通用户
        
        return @[@"System_Conference"
                 ,@"System_Notcollection"
                 ,@"System_Order"
                 ,@"System_set_up"
                 ];
    }else if(_usertype==2)
    {
        //        2 设计师
        return @[@"System_Home"
                 ,@"System_Fans"
                 ,@"System_Order"
                 ,@"System_Conference"
                 ,@"System_Notcollection"
                 ,@"System_set_up"
                 ];
    }else
    {
        //        4 达人
        return @[@"System_Home"
                 ,@"System_Conference"
                 ,@"System_Order"
                 ,@"System_set_up"
                 ,@"System_Notcollection"
                 ];
    }
}
+(NSArray *)getUserListArr
{
//    2 设计师 3 普通用户 4 达人
    NSInteger _usertype=[DD_UserModel getUserType];
    if(_usertype==0||_usertype==3)
    {
//        3/0 未登录或普通用户

        return @[@"conference"
                 ,@"collection"
                 ,@"order"
                 ,@"set"
                 ];
    }else if(_usertype==2)
    {
//        2 设计师
        return @[@"homepage"
                 ,@"fans"
                 ,@"order"
                 ,@"conference"
                 ,@"collection"
                 ,@"set"
                 ];
    }else
    {
//        4 达人
        return @[@"homepage"
                 ,@"conference"
                 ,@"order"
                 ,@"set"
                 ,@"collection"
                 ];
    }
}

@end
