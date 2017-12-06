//
//  DD_BenefitInfoModel.h
//  YCO SPACE
//
//  Created by yyj on 2016/10/27.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DD_baseModel.h"

@class DD_ImageModel;

#define __bool(__k__) @property(nonatomic,assign) BOOL __k__
#define __long(__k__) @property(nonatomic,assign) long __k__
#define __int(__k__) @property(nonatomic,assign) NSInteger __k__

@interface DD_BenefitInfoModel : DD_baseModel

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

/** 有效时间-开始时间*/
__long(effectStartTime);

/** 有效时间-结束时间*/
__long(effectEndTime);

/** 是否已用*/
__bool(isUse);

/** 本地是否已读*/
__bool(localRead);

/** 最低使用金额*/
__int(lowLimit);

/** 优惠券名称*/
__string(name);

/** 当前访问用户ID*/
__string(userId);

/** 使用范围*/
__string(useRange);

/** 满多少的描述*/
__string(lowLimitDesc);

@end
