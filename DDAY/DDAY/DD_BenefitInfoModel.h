//
//  DD_BenefitInfoModel.h
//  YCO SPACE
//
//  Created by yyj on 2016/10/27.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DD_ImageModel.h"

@interface DD_BenefitInfoModel : NSObject

/**
 * 获取优惠券model
 */
+(DD_BenefitInfoModel *)getBenefitInfoModel:(NSDictionary *)dict;

/**
 * 获取优惠券model数组
 */
+(NSArray *)getBenefitInfoModelArr:(NSArray *)arr;

/** 是否已读*/
__bool(isReadBenefit);

/** 抵扣金额*/
__int(amount);

/** 优惠券ID*/
__string(benefitId);

/** 优惠券图片*/
@property(nonatomic,strong) DD_ImageModel *picInfo;

/** 优惠券描述信息*/
__string(describeInfo);

/** 有效时间-开始时间*/
__long(effectStartTime);

/** 有效时间-结束时间*/
__long(effectEndTime);

/** 是否已用*/
__bool(isUse);

/** 最低使用金额*/
__int(lowLimit);

/** 优惠券名称*/
__string(name);

/** 当前访问用户ID*/
__string(userId);

@end
