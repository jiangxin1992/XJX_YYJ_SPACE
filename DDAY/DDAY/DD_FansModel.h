//
//  DD_FansModel.h
//  DDAY
//
//  Created by yyj on 16/6/28.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DD_baseModel.h"

@interface DD_FansModel : DD_baseModel

/**
 * 获取粉丝model数组
 */
+(NSArray *)getFansModelArr:(NSArray *)arr;

/** 是否已读*/
__bool(isNew);

/** 用户名*/
__string(userName);

/** 用户头像*/
__string(userHead);

/** 用户ID*/
__string(userId);

/** 用户类型 2设计师 3普通用户 4达人*/
__string(userType);

@end
