//
//  DD_CricleTagItemModel.h
//  DDAY
//
//  Created by yyj on 16/6/16.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DD_baseModel.h"

@interface DD_CricleTagItemModel : DD_baseModel

/**
 * 获取标签model
 */
+(DD_CricleTagItemModel *)getCricleTagItemModel:(NSDictionary *)dict;
/**
 * 获取标签model 数组
 */
+(NSMutableArray *)getCricleTagItemModelArr:(NSArray *)arr;

/** 标签ID*/
__string(t_id);

/** 标签名*/
__string(tagName);

/** 标签select状态*/
__bool(is_select);

/** 标签创建时间*/
__long(createTime);

@end
