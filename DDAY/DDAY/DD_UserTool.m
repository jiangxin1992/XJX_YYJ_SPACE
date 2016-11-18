//
//  DD_UserTool.m
//  DDAY
//
//  Created by yyj on 16/5/21.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_UserTool.h"

#import "DD_UserModel.h"

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
             ,@"showroom":NSLocalizedString(@"user_showroom", @"")
             ,@"benefit":NSLocalizedString(@"user_benefit", @"")
             ,@"integral":NSLocalizedString(@"user_integral", @"")
             };
}
+(NSArray *)getUserImgListArr
{
    //    2 设计师 3 普通用户 4 达人
    NSInteger _usertype=[DD_UserModel getUserType];
    if(_usertype==0||_usertype==3)
    {
        //        3/0 未登录或普通用户
        
        return @[@"User_Conference"
                 ,@"System_Notcollection"
                 ,@"User_Order"
                 ,@"User_Discount"
                 ,@"User_Score"
                 ,@"User_ShowRoom"
                 ,@"User_SetUp"
                 ];
    }else if(_usertype==2)
    {
        //        2 设计师
        return @[@"User_Home"
                 ,@"User_Fans"
                 ,@"User_Order"
                 ,@"User_Conference"
                 ,@"System_Notcollection"
                 ,@"User_Discount"
                 ,@"User_Score"
                 ,@"User_ShowRoom"
                 ,@"User_SetUp"
                 ];
    }else
    {
        //        4 达人
        return @[@"User_Home"
                 ,@"User_Conference"
                 ,@"User_Order"
                 ,@"System_Notcollection"
                 ,@"User_Discount"
                 ,@"User_Score"
                 ,@"User_ShowRoom"
                 ,@"User_SetUp"
                 ];
    }
}
+(NSArray *)getUserListArr
{
//    2 设计师 3 普通用户 4 达人
    NSInteger _usertype=[DD_UserModel getUserType];
    if(_usertype==0||_usertype==3)
    {
//        0 未登录
        return @[@"conference"
                 ,@"collection"
                 ,@"order"
                 ,@"benefit"
                 ,@"integral"
                 ,@"showroom"
                 ,@"set"
                 ];
    }else if(_usertype==3)
    {
//        3 普通用户
        return @[@"conference"
                 ,@"collection"
                 ,@"order"
                 ,@"benefit"
                 ,@"integral"
                 ,@"showroom"
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
                 ,@"benefit"
                 ,@"integral"
                 ,@"showroom"
                 ,@"set"
                 ];
    }else
    {
//        4 达人
        return @[@"homepage"
                 ,@"conference"
                 ,@"order"
                 ,@"collection"
                 ,@"benefit"
                 ,@"integral"
                 ,@"showroom"
                 ,@"set"
                 ];
    }
}

@end
