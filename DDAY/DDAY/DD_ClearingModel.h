//
//  DD_ClearingModel.h
//  DDAY
//
//  Created by yyj on 16/5/18.
//  Copyright © 2016年 mike_xie. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DD_AddressModel.h"
#import "DD_BenefitInfoModel.h"

@interface DD_ClearingModel : NSObject
+(DD_ClearingModel *)getClearingModel:(NSDictionary *)dict;

/**
 * 获取结算请求 itemarr
 * 结算请求参数
 */
-(NSArray *)getItemsArr;

/**
 * 将上个页面传入的model转换成map
 * 如果 address 为nil 则不加入address
 * 并返回
 */
-(NSDictionary *)getOrderInfo;

/** 积分变化*/
-(void)IntegralUpdate;

/** 优惠券变化*/
-(void)BenefitUpdate;

/** 获取当前选中的优惠券model*/
-(DD_BenefitInfoModel *)getChoosedBenefitInfo;

/** 订单model 数组*/
__array(orders);

/** 地址model*/
@property (nonatomic,strong)DD_AddressModel *address;

/** 单个订单运费*/
__string(freight);

/** 默认优惠券*/
__array(benefitInfo);

/** 用户当前积分*/
__long(rewardPoints);

/** 是否使用当前积分*/
__bool(use_rewardPoints);

/** 使用的积分*/
__long(employ_rewardPoints);

/** 当前选择的优惠券*/
__string(choosedBenefitId);

@end
