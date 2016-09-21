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
//    _OrderModel.createTime=_OrderModel.createTime/1000;
    return _OrderModel;
}
@end
