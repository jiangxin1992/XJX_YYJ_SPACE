//
//  DD_UserMessageModel.m
//  YCO SPACE
//
//  Created by yyj on 16/9/14.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_UserMessageModel.h"

#import "DD_UserMessageItemModel.h"

@implementation DD_UserMessageModel
/**
 * 获取消息列表model
 */
+(DD_UserMessageModel *)getUserMessageModel:(NSDictionary *)dict
{
    DD_UserMessageModel *MessageModel=[DD_UserMessageModel mj_objectWithKeyValues:dict];
    MessageModel.is_expand=NO;
    MessageModel.messages=[DD_UserMessageItemModel getUserMessageItemModelArr:[dict objectForKey:@"messages"]];
    return MessageModel;
}
/**
 * 获取搭配列表model数组
 */
+(NSMutableArray *)getUserMessageModelArr:(NSArray *)arr
{
    NSMutableArray *TagsArr=[[NSMutableArray alloc] init];
    [arr enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
        [TagsArr addObject:[self getUserMessageModel:dict]];
    }];
    return TagsArr;
}


@end
