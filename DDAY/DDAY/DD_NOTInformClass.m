//
//  DD_NOTInformClass.m
//  DDAY
//
//  Created by yyj on 16/6/29.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_NOTInformClass.h"

@implementation DD_NOTInformClass

//        新的发布会通知
+(NSString *)GET_NEWSERIES_NOT_SERIESID
{
    NSUserDefaults*_default=[NSUserDefaults standardUserDefaults];
    return [_default objectForKey:@"NEWSERIES_NOT_SERIESID"];
}
+(void)SET_NEWSERIES_NOT_SERIESID:(NSDictionary *)dict
{
    NSUserDefaults*_default=[NSUserDefaults standardUserDefaults];
    [_default setObject:[dict objectForKey:@"seriesId"] forKey:@"NEWSERIES_NOT_SERIESID"];
}
+(void)REMOVE_NEWSERIES_NOT_SERIESID
{
    NSUserDefaults*_default=[NSUserDefaults standardUserDefaults];
    [_default setObject:nil forKey:@"NEWSERIES_NOT_SERIESID"];
}

//        已报名发布会开始的通知
+(NSString *)GET_STARTSERIES_NOT_SERIESID
{
    NSUserDefaults*_default=[NSUserDefaults standardUserDefaults];
    return [_default objectForKey:@"STARTSERIES_NOT_SERIESID"];
}
+(void)SET_STARTSERIES_NOT_SERIESID:(NSDictionary *)dict
{
    NSUserDefaults*_default=[NSUserDefaults standardUserDefaults];
    [_default setObject:[dict objectForKey:@"seriesId"] forKey:@"STARTSERIES_NOT_SERIESID"];
}
+(void)REMOVE_STARTSERIES_NOT_SERIESID
{
    NSUserDefaults*_default=[NSUserDefaults standardUserDefaults];
    [_default setObject:nil forKey:@"STARTSERIES_NOT_SERIESID"];
}

//        评论回复的通知
+(NSString *)GET_REPLYCOMMENT_NOT_COMMENTID
{
    NSUserDefaults*_default=[NSUserDefaults standardUserDefaults];
    return [_default objectForKey:@"REPLYCOMMENT_NOT_COMMENTID"];
}
+(NSString *)GET_REPLYCOMMENT_NOT_SHAREID
{
    NSUserDefaults*_default=[NSUserDefaults standardUserDefaults];
    return [_default objectForKey:@"REPLYCOMMENT_NOT_SHAREID"];
}
+(void)SET_REPLYCOMMENT_NOT_COMMENT:(NSDictionary *)dict
{
    NSUserDefaults*_default=[NSUserDefaults standardUserDefaults];
    [_default setObject:[dict objectForKey:@"commentId"] forKey:@"REPLYCOMMENT_NOT_COMMENTID"];
    [_default setObject:[dict objectForKey:@"shareId"] forKey:@"REPLYCOMMENT_NOT_SHAREID"];
}
+(void)REMOVE_REPLYCOMMENT_NOT_COMMENT
{
    NSUserDefaults*_default=[NSUserDefaults standardUserDefaults];
    [_default setObject:nil forKey:@"REPLYCOMMENT_NOT_COMMENTID"];
}

//        评论的通知
+(NSString *)GET_COMMENTSHARE_NOT_COMMENTID
{
    NSUserDefaults*_default=[NSUserDefaults standardUserDefaults];
    return [_default objectForKey:@"COMMENTSHARE_NOT_COMMENTID"];
}
+(NSString *)GET_COMMENTSHARE_NOT_SHAREID
{
    NSUserDefaults*_default=[NSUserDefaults standardUserDefaults];
    return [_default objectForKey:@"COMMENTSHARE_NOT_SHAREID"];
}
+(void)SET_COMMENTSHARE_NOT_COMMENT:(NSDictionary *)dict
{
    NSUserDefaults*_default=[NSUserDefaults standardUserDefaults];
    [_default setObject:[dict objectForKey:@"commentId"] forKey:@"COMMENTSHARE_NOT_COMMENTID"];
    [_default setObject:[dict objectForKey:@"shareId"] forKey:@"COMMENTSHARE_NOT_SHAREID"];
}
+(void)REMOVE_COMMENTSHARE_NOT_COMMENT
{
    NSUserDefaults*_default=[NSUserDefaults standardUserDefaults];
    [_default setObject:nil forKey:@"COMMENTSHARE_NOT_COMMENTID"];
    [_default setObject:nil forKey:@"COMMENTSHARE_NOT_SHAREID"];
}
@end
