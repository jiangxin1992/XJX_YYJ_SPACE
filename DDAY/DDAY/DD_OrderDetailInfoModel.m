//
//  DD_OrderDetailInfoModel.m
//  DDAY
//
//  Created by yyj on 16/6/7.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_OrderDetailInfoModel.h"

#import "DD_OrderModel.h"

@implementation DD_OrderDetailInfoModel
+(DD_OrderDetailInfoModel *)getOrderDetailInfoModel:(NSDictionary *)dict
{
    DD_OrderDetailInfoModel *_OrderModel=[DD_OrderDetailInfoModel mj_objectWithKeyValues:dict];
    _OrderModel.orderList=[DD_OrderModel getOrderModelArr:[dict objectForKey:@"orderList"]];
    _OrderModel.createTime=[[dict objectForKey:@"createTime"] longLongValue]/1000;
    
//    /** 未支付的情况下，订单取消时间*/
//    __long(orderCancelTime);
//    
//    /** 订单支付时间*/
//    __long(orderPayTime);;
//    
//    /** 优惠券优惠金额*/
//    __float(benefitAmount);
//    
//    /** 积分优惠金额*/
//    __float(intergralAmout);
//    
//    /** 实际支付金额*/
//    __float(actuallyPay);
//    
//    /** 支付方式 1 支付宝 2 微信 3 银联 */
//    __int(payWay);
    return _OrderModel;
}
@end
