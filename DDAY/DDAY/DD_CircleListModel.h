//
//  DD_CircleListModel.h
//  DDAY
//
//  Created by yyj on 16/6/21.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DD_CircleListModel : NSObject
/**
 * 获取搭配列表model
 */
+(DD_CircleListModel *)getCircleListModel:(NSDictionary *)dict;
/**
 * 获取搭配列表model数组
 */
+(NSMutableArray *)getCircleListModelArr:(NSArray *)arr;

+(NSMutableArray *)getCircleListImgModelArr:(NSArray *)arr;

+(DD_CircleListModel *)getCircleListImgModel:(NSDictionary *)dict;

-(NSMutableArray *)getTagArr;

/**
 * 用户职业
 */
__string(career);
/**
 * 用户头像
 */
__string(userHead);
/**
 * 用户名
 */
__string(userName);
/**
 * 用户id
 */
__string(userId);
/**
 * 用户类型 2设计师 3普通用户 4达人
 */
__string(userType);

/**
 * 搭配ID
 */
__string(shareId);
/**
 * 建议高度
 */
//__float(suggestHeight);
/**
 * 评论数量
 */
__long(commentTimes);
/**
 * 点赞数量
 */
__long(likeTimes);
/**
 * 收藏数量
 */
__long(collectTimes);
/**
 * 该搭配创建时间
 */
__long(createTime);

/**
 * 搭配建议
 */
__string(shareAdvise);
/**
 * 是否收藏
 */
__bool(isCollect);
/**
 * 是否点赞
 */
__bool(isLike);
/**
 * 搭配图片
 */
__array(pics);
/**
 * 搭配中的单品
 */
__array(items);
/**
 * 搭配标记
 */
__array(tags);
@end
