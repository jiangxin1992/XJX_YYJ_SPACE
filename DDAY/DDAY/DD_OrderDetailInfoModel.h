//
//  DD_OrderDetailInfoModel.h
//  DDAY
//
//  Created by yyj on 16/6/7.
//  Copyright © 2016年 YYJ. All rights reserved.
//
#import "DD_OrderModel.h"
#import <Foundation/Foundation.h>

@interface DD_OrderDetailInfoModel : NSObject
/**
 * 获取解析model
 */
+(DD_OrderDetailInfoModel *)getOrderDetailInfoModel:(NSDictionary *)dict;
/**
 * 是否支付
 */
__bool(isPay);
/**
 * 订单备注
 */
__string(memo);

/**
 * order arr
 */
__array(orderList);

/**
 * 总运费
 */
__long(allFreight);
/**
 * 订单创建时间
 */
__long(createTime);
/**
 * 小计 不算运费
 */
__string(totalAmount);
/**
 * 数量
 */
__long(totalItemCount);
/**
 * 订单号
 */
__string(tradeOrderCode);

@end
