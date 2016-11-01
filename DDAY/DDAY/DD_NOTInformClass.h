//
//  DD_NOTInformClass.h
//  DDAY
//
//  Created by yyj on 16/6/29.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DD_NOTInformClass : NSObject

//有人关注了你

//        新的发布会通知
+(NSString *)GET_NEWSERIES_NOT_SERIESID;
+(void)SET_NEWSERIES_NOT_SERIESID:(NSDictionary *)dict;
+(void)REMOVE_NEWSERIES_NOT_SERIESID;

//        已报名发布会开始的通知
+(NSString *)GET_STARTSERIES_NOT_SERIESID;
+(void)SET_STARTSERIES_NOT_SERIESID:(NSDictionary *)dict;
+(void)REMOVE_STARTSERIES_NOT_SERIESID;

//        评论回复的通知
+(NSString *)GET_REPLYCOMMENT_NOT_COMMENTID;
+(NSString *)GET_REPLYCOMMENT_NOT_SHAREID;
+(void)SET_REPLYCOMMENT_NOT_COMMENT:(NSDictionary *)dict;
+(void)REMOVE_REPLYCOMMENT_NOT_COMMENT;

//        评论的通知
+(NSString *)GET_COMMENTSHARE_NOT_COMMENTID;
+(NSString *)GET_COMMENTSHARE_NOT_SHAREID;
+(void)SET_COMMENTSHARE_NOT_COMMENT:(NSDictionary *)dict;
+(void)REMOVE_COMMENTSHARE_NOT_COMMENT;

@end
