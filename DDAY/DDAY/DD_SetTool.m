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

//    return @{
//             @"notice":NSLocalizedString(@"user_set_notice", @"")
//             ,@"clean":NSLocalizedString(@"user_set_clean", @"")
//             ,@"suggest":NSLocalizedString(@"user_set_suggest", @"")
//             ,@"about":NSLocalizedString(@"user_set_about", @"")
//             ,@"logout":NSLocalizedString(@"user_set_logout", @"")
//             };
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
//    return @[@"notice"
//             ,@"clean"
//             ,@"suggest"
//             ,@"about"
//             ,@"logout"
//             ];
    return @[@"information"
             ,@"alertPSW"
             ,@"logout"
             ,@"about"
             ,@"clean"
             ];
}
@end
