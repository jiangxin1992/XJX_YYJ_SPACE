//
//  DD_UserMessageItemModel.m
//  YCO SPACE
//
//  Created by yyj on 16/9/14.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_UserMessageItemModel.h"

@implementation DD_UserMessageItemModel
/**
 * 获取消息列表model
 */
+(DD_UserMessageItemModel *)getUserMessageItemModel:(NSDictionary *)dict
{
    {
        DD_UserMessageItemModel *MessageModel=[DD_UserMessageItemModel objectWithKeyValues:dict];
        MessageModel.messageID=[[NSString alloc] initWithFormat:@"%ld",[[dict objectForKey:@"id"] longValue]];
        MessageModel.createTime=[[dict objectForKey:@"createTime"] longValue]/1000;
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
        for (NSDictionary *dict in arr) {
            [TagsArr addObject:[self getUserMessageItemModel:dict]];
        }
        return TagsArr;
    }
}
@end
