//
//  DD_UserInfoTool.m
//  DDAY
//
//  Created by yyj on 16/5/22.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_UserInfoTool.h"

@implementation DD_UserInfoTool
+(NSDictionary *)getUserInfoListMap
{
    
    return @{
             @"head":NSLocalizedString(@"user_info_head", @"")
             ,@"nickname":NSLocalizedString(@"user_info_nickname", @"")
             ,@"sex":NSLocalizedString(@"user_info_sex", @"")
             ,@"career":NSLocalizedString(@"user_info_career", @"")
             ,@"body":NSLocalizedString(@"user_info_body", @"")
             ,@"address":NSLocalizedString(@"user_info_address", @"")
             };
    
}
+(NSArray *)getUserInfoListArr
{
    return @[@"head"
             ,@"nickname"
             ,@"sex"
             ,@"career"
             ,@"body"
             ,@"address"
             ];
}
@end
