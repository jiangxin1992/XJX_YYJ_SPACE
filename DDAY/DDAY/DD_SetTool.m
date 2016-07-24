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
             @"notice":NSLocalizedString(@"user_set_notice", @"")
             ,@"clean":NSLocalizedString(@"user_set_clean", @"")
             ,@"suggest":NSLocalizedString(@"user_set_suggest", @"")
             ,@"about":NSLocalizedString(@"user_set_about", @"")
             ,@"logout":NSLocalizedString(@"user_set_logout", @"")
             };
}
+(NSArray *)getSetListArr
{
    return @[@"notice"
             ,@"clean"
             ,@"suggest"
             ,@"about"
             ,@"logout"
             ];
}
@end
