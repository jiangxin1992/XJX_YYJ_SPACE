//
//  DD_BenefitInfoModel.h
//  YCO SPACE
//
//  Created by yyj on 2016/10/27.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DD_BenefitInfoModel : NSObject
/**
 * 获取优惠券model
 */
+(DD_BenefitInfoModel *)getBenefitInfoModel:(NSDictionary *)dict;
/**
 * 获取优惠券model数组
 */
+(NSArray *)getBenefitInfoModelArr:(NSArray *)arr;

/**
 * 是否已读
 */
__bool(isReadBenefit);
@end
