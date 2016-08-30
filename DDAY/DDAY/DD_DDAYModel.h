//
//  DD_DDAYModel.h
//  DDAY
//
//  Created by yyj on 16/6/1.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DD_DDAYModel : NSObject

/**
 * 获取解析model
 */
+(DD_DDAYModel *)getDDAYModel:(NSDictionary *)dict;
/**
 * 获取解析数组
 */
+(NSArray *)getDDAYModelArr:(NSArray *)arr;

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

__bool(is_select);

@property (nonatomic,strong) NSDate *signStartDate;
@property (nonatomic,strong) NSDate *saleEndDate;
@property (nonatomic,strong) NSDate *signEndDate;
@property (nonatomic,strong) NSDate *saleStartDate;

/**
 * 系列对应颜色
 */
__string(seriesColor);
@end
