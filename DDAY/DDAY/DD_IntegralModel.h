//
//  DD_IntegralModel.h
//  YCO SPACE
//
//  Created by yyj on 2016/10/31.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DD_IntegralModel : NSObject

/**
 * 获取积分model数组
 */
+(NSArray *)getIntegralModelArr:(NSArray *)arr;

/**
 * 获取积分model
 */
+(DD_IntegralModel *)getIntegralModel:(NSDictionary *)dict;

/**
 * 1 未过期积分
 * 2 标题
 * 3 已过期积分
 */
__long(type);

/** 内容*/
__string(tips);

/** 1进/0出*/
__bool(pointType);

/** 积分数量*/
__int(points);

/** 积分数量（描述）*/
__string(pointStr);

/** 创建时间*/
__long(happenTime);

/** 创建时间（转具体时间）*/
__string(createTime);

@end
