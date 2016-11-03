//
//  DD_BenefitDetailModel.h
//  YCO SPACE
//
//  Created by yyj on 2016/11/3.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DD_ImageModel.h"

@interface DD_BenefitDetailModel : NSObject

/**
 * 获取优惠券model数组
 */
+(DD_BenefitDetailModel *)getBenefitDetailInfoModel:(NSDictionary *)dict;

/** 抵扣金额*/
__int(amount);

/** 优惠券ID*/
__string(benefitId);

/** 优惠券图片*/
@property(nonatomic,strong) DD_ImageModel *picInfo;

/** 最低使用金额*/
__int(lowLimit);

/** 优惠券名称*/
__string(name);

/** 规则标题*/
__string(ruleTitle);

/** 规则内容*/
__string(ruleContent);

@end
