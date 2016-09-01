//
//  DD_DDayDetailModel.h
//  DDAY
//
//  Created by yyj on 16/6/2.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DD_ImageModel.h"

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
 * 品牌简介
 */
__string(brandBrief);
/**
 * 系列封面照片
 */
@property (nonatomic,strong) DD_ImageModel *seriesFrontPic;
/**
 * 系列提示
 */
__string(seriesTips);

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
/**
 * 该系列是否有名额限制
 */
__bool(isQuotaLimt);
/**
 * 当前用户是否参加该系列
 */
__bool(isJoin);
/**
 * 系列简介
 */
__string(seriesBrief);
/**
 * 系列名
 */
__string(name);
/**
 * 系列颜色
 */
__string(seriesColor);
/**
 * 系列id
 */
__string(s_id);
/**
 * 系列baner封面
 */
@property (nonatomic,strong) DD_ImageModel *seriesBannerPic;
/**
 * 系列剩余名额
 */
__long(leftQuota);
/**
 * 品牌图片
 */
@property (nonatomic,strong) DD_ImageModel *brandPic;

@end
