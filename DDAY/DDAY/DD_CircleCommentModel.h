//
//  DD_CircleCommentModel.h
//  DDAY
//
//  Created by yyj on 16/6/22.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DD_baseModel.h"

@interface DD_CircleCommentModel : DD_baseModel

/**
 * 获取搭配评论列表model
 */
+(DD_CircleCommentModel *)getCircleCommentModel:(NSDictionary *)dict;
/**
 * 获取搭配评论列表model数组
 */
+(NSMutableArray *)getCircleCommentModelArr:(NSArray *)arr;

/** 评论高度*/
__float(commHeight);

/** 回复人的ID*/
__string(commToId);

/** 回复人的昵称*/
__string(commToName);

/** 评论ID*/
__string(commId);

/** 评论内容*/
__string(comment);

/** 评论创建时间*/
__long(createTime);

/** 是否点赞*/
__bool(isLike);

/** 点赞数量*/
__long(likeTimes);

/** 用户头像*/
__string(userHead);

/** 用户ID*/
__string(userId);

/** 用户昵称*/
__string(userName);

@end
