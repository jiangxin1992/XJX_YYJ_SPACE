//
//  DD_UserMessageModel.h
//  YCO SPACE
//
//  Created by yyj on 16/9/14.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DD_UserMessageModel : NSObject
/**
 * 获取消息列表model
 */
+(DD_UserMessageModel *)getUserMessageModel:(NSDictionary *)dict;
/**
 * 获取消息列表model数组
 */
+(NSMutableArray *)getUserMessageModelArr:(NSArray *)arr;
/**
 * 是否已读
 */
__bool(readStatus);
/**
 * 消息组名
 */
__string(messageCategory);
/**
 * 消息列表
 */
__array(messages);
/**
 * 消息组类型
 */
__array(type);
/**
 * 是否展开
 */
__bool(is_expand);
@end
