//
//  DD_UserMessageItemModel.h
//  YCO SPACE
//
//  Created by yyj on 16/9/14.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DD_UserModel.h"

@interface DD_UserMessageItemModel : NSObject

/**
 * 获取消息列表model
 */
+(DD_UserMessageItemModel *)getUserMessageItemModel:(NSDictionary *)dict;

/**
 * 获取消息列表model数组
 */
+(NSMutableArray *)getUserMessageItemModelArr:(NSArray *)arr;

/**
 * 前端动作类型（根据动作）
 * 1 跳转物流详情页（orderCode）
 * 2 跳转订单详情页 以支付（orderCode）未支付（tradeOrderCode） 还需要是否支付
 * 3 跳转发布品详情页 (itemId,colorCode)
 * 4 跳转搭配详情页 (shareId)
 * 5 跳转发布会详情页(seriesId)
 * 6 跳转粉丝列表 不需要
 * 7 跳转申请详情页 不需要
 */
__int(paramType);

/**
 * 后台类型
 * 1 订单更新
 * 2 关注动态
 * 3 发布会
 * 4 收到的回复
 * 5 收到的关注
 * 6 收到的评论
 * 7 收到的收藏
 * 8 收到的赞
 * 9 达人申请通知
 */
__int(type);

/** 用户信息*/
@property (nonatomic,strong)DD_UserModel *fromUser;

/** 是否已读*/
__bool(readStatus);

/** 创建时间*/
__long(createTime);

/** 创建时间str*/
__string(createTimeStr);

/** 消息ID*/
__string(messageID);

/** 消息内容*/
__string(message);

/** 参数列表*/
__dict(params);

@end
