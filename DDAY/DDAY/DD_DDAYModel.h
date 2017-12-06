//
//  DD_DDAYModel.h
//  DDAY
//
//  Created by yyj on 16/6/1.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DD_baseModel.h"

@interface DD_DDAYModel : DD_baseModel

/**
 * 获取解析model
 */
+(DD_DDAYModel *)getDDAYModel:(NSDictionary *)dict;

/**
 * 获取解析数组
 */
+(NSArray *)getDDAYModelArr:(NSArray *)arr;

/** 城市*/
__string(city);

/** 0表示线上 1表示线下*/
__long(stype);

/** 系列提示*/
__string(seriesTips);

/** 折扣*/
__string(discount);

/** 当前用户是否参加该系列*/
__bool(isJoin);

/** 该系列是否有名额限制*/
__bool(isQuotaLimt);

/** 系列剩余名额*/
__long(leftQuota);

/** 系列ID*/
__string(s_id);

/** 系列名*/
__string(name);

/** 系列封面照片*/
__string(pic);

/** 发布会结束时间*/
__long(saleEndTime);

/** 发布会开始时间*/
__long(saleStartTime);

/** 报名结束时间*/
__long(signEndTime);

/** 报名开始时间*/
__long(signStartTime);

/** 日历中是否被锁定*/
__bool(is_select);

/** 系列对应颜色*/
__string(seriesColor);

/** 发布会结束时间（date）*/
@property (nonatomic,strong) NSDate *signEndDate;

/** 发布会开始时间（date）*/
@property (nonatomic,strong) NSDate *signStartDate;

/** 报名结束时间（date）*/
@property (nonatomic,strong) NSDate *saleEndDate;

/** 报名开始时间（date）*/
@property (nonatomic,strong) NSDate *saleStartDate;

/** 活动时间范围str*/
__string(saleTimeStr);

@end
