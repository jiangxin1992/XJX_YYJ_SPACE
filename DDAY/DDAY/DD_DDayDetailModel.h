//
//  DD_DDayDetailModel.h
//  DDAY
//
//  Created by yyj on 16/6/2.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DD_DDayDetailModel : NSObject
/**
 * 获取解析model
 */
+(DD_DDayDetailModel *)getDDayDetailModel:(NSDictionary *)dict;
/**
 * 获取解析数组
 */
+(NSArray *)getDDayDetailModelArr:(NSArray *)arr;

/**
 * 当前用户是否参加该系列
 */
__bool(isJoin);
/**
 * 该系列是否有名额限制
 */
__bool(isQuotaLimt);
/**
 * 系列剩余名额
 */
__long(leftQuota);

/**
 * 系列id
 */
__string(s_id);

/**
 * 系列名
 */
__string(name);
/**
 * 系列封面照片
 */
__string(pic);

/**
 * 发布会结束时间
 */
__long(saleEndTime);
/**
 * 发布会开始时间
 */
__long(saleStartTime);
/**
 * 报名结束时间
 */
__long(signEndTime);
/**
 * 报名开始时间
 */
__long(signStartTime);
@end
