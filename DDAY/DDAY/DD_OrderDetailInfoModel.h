//
//  DD_OrderDetailInfoModel.h
//  DDAY
//
//  Created by yyj on 16/6/7.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DD_OrderDetailInfoModel : NSObject

/**
 * 获取解析model
 */
+(DD_OrderDetailInfoModel *)getOrderDetailInfoModel:(NSDictionary *)dict;

/** 是否支付*/
__bool(isPay);

/** 订单备注*/
__string(memo);

/** order arr*/
__array(orderList);

/** 总运费*/
__long(allFreight);

/** 小计 不算运费*/
__string(totalAmount);

/** 数量*/
__long(totalItemCount);

/** 订单号*/
__string(tradeOrderCode);

/** 订单创建时间*/
__long(createTime);

/** 客服电话号码*/
__string(customerServicePhone);

/** 未支付的情况下，订单取消时间*/
__long(orderCancelTime);

/** 订单支付时间*/
__long(orderPayTime);

/** 优惠券优惠金额*/
__float(benefitAmount);

/** 积分优惠金额*/
__float(intergralAmout);

/** 实际支付金额*/
__float(actuallyPay);

/** 支付方式 1 支付宝 2 微信 3 银联 */
__int(payWay);

/**
 * 初始化方法
 * public static Integer ORDER_STATUS_DFK = 0; //待付款
 * public static Integer ORDER_STATUS_DFH = 1; //待发货
 * public static Integer ORDER_STATUS_DSH = 2; //待收货
 * public static Integer ORDER_STATUS_JYCG = 3; //交易成功
 * public static Integer ORDER_STATUS_SQTK = 4; //申请退款
 * public static Integer ORDER_STATUS_TKCLZ = 5; //退款处理中
 * public static Integer ORDER_STATUS_YTK = 6; //已退款
 * public static Integer ORDER_STATUS_JJTK = 7; //拒绝退款
 //订单已取消
 */

__long(orderStatus);


@end
