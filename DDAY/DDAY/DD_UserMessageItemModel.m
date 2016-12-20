//
//  DD_UserMessageItemModel.m
//  YCO SPACE
//
//  Created by yyj on 16/9/14.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_UserMessageItemModel.h"

#import "DD_UserModel.h"

@implementation DD_UserMessageItemModel
/**
 * 获取消息列表model
 */
+(DD_UserMessageItemModel *)getUserMessageItemModel:(NSDictionary *)dict
{
    {
        DD_UserMessageItemModel *MessageModel=[DD_UserMessageItemModel mj_objectWithKeyValues:dict];
        MessageModel.messageID=[[NSString alloc] initWithFormat:@"%ld",[[dict objectForKey:@"id"] longValue]];
        MessageModel.createTime=MessageModel.createTime/1000;
        
        NSDate *_getDate=[NSDate dateWithTimeIntervalSince1970:MessageModel.createTime];
        long _get_first_time=[[_getDate getFirstTime] timeIntervalSince1970];
        long _get_now_time=[[[NSDate nowDate] getFirstTime] timeIntervalSince1970];
        if(_get_first_time==_get_now_time)
        {
            MessageModel.createTimeStr=[regular getTimeStr:MessageModel.createTime WithFormatter:@"YYYY-MM-dd HH:mm"];
        }else
        {
            MessageModel.createTimeStr=[regular getTimeStr:MessageModel.createTime WithFormatter:@"YYYY-MM-dd"];
        }
        
        MessageModel.fromUser=[DD_UserModel getUserModel:[dict objectForKey:@"fromUser"]];
        return MessageModel;
    }
}
/**
 * 获取消息列表model数组
 */
+(NSMutableArray *)getUserMessageItemModelArr:(NSArray *)arr
{
    {
        NSMutableArray *TagsArr=[[NSMutableArray alloc] init];
        [arr enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
            [TagsArr addObject:[self getUserMessageItemModel:dict]];
        }];
        return TagsArr;
    }
}
@end
