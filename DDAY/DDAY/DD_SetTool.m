//
//  DD_SetTool.m
//  DDAY
//
//  Created by yyj on 16/5/21.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_SetTool.h"

@implementation DD_SetTool
+(NSDictionary *)getSetListMap
{

    return @{
             @"information":NSLocalizedString(@"user_set_information", @"")
             ,@"alertPSW":NSLocalizedString(@"user_info_alertPSW", @"")
             ,@"logout":NSLocalizedString(@"user_set_logout", @"")
             ,@"about":NSLocalizedString(@"user_set_about", @"")
             ,@"clean":NSLocalizedString(@"user_set_clean", @"")
             };
}
+(NSArray *)getSetListArr
{

    if([DD_UserModel isLogin])
    {
        return @[@"information"
                 ,@"alertPSW"
                 ,@"logout"
                 ,@"about"
                 ,@"clean"
                 
                 ];
    }
    return @[@"information"
             ,@"alertPSW"
             ,@"about"
             ,@"clean"
             
             ];
}
@end
