//
//  DD_ShopSeriesModel.h
//  DDAY
//
//  Created by yyj on 16/5/27.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DD_ShopSeriesModel : NSObject

/**
 * 获取解析model
 */
+(DD_ShopSeriesModel *)getShopSeriesModel:(NSDictionary *)dict;

/**
 * 获取解析数组
 */
+(NSArray *)getShopSeriesModelArr:(NSArray *)arr;

/** 定时器*/
@property (nonatomic,strong)dispatch_source_t timer;

/** 该系列下对应的item 数组*/
__array(items);

/** 系列ID*/
__string(seriesId);

/** 系列名称*/
__string(seriesName);

/** 报名开始时间*/
__long(signStartTime);

/** 报名结束时间*/
__long(signEndTime);

/** 发布会开始时间*/
__long(saleStartTime);

/** 发布会结束时间*/
__long(saleEndTime);

@end
