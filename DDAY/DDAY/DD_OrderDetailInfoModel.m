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
    _OrderModel.orderPayTime=[[dict objectForKey:@"orderPayTime"] longLongValue]/1000;
    _OrderModel.orderCancelTime=[[dict objectForKey:@"orderCancelTime"] longLongValue]/1000;
    
//    _OrderModel.memo=@"qsdqewqew";
//    _OrderModel.payWay=1;
//    _OrderModel.createTime = [NSDate nowTime]-400;
//    _OrderModel.orderPayTime = [NSDate nowTime]-200;
//    _OrderModel.orderCancelTime = [NSDate nowTime]+200;
//    _OrderModel.benefitAmount = 30;
//    _OrderModel.intergralAmout = 40;
//    _OrderModel.actuallyPay=_OrderModel.allFreight+[_OrderModel.totalAmount floatValue]-_OrderModel.benefitAmount-_OrderModel.intergralAmout;
    
    return _OrderModel;
}
@end
