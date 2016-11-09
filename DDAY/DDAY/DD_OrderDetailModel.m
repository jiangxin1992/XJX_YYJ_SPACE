//
//  DD_OrderDetailModel.m
//  DDAY
//
//  Created by yyj on 16/6/7.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_OrderDetailModel.h"

@implementation DD_OrderDetailModel
+(DD_OrderDetailModel *)getOrderDetailModel:(NSDictionary *)dict
{
    DD_OrderDetailModel *_OrderModel=[DD_OrderDetailModel mj_objectWithKeyValues:dict];
    _OrderModel.address=[DD_AddressModel getAddressModel:[dict objectForKey:@"address"]];
    _OrderModel.orderInfo=[DD_OrderDetailInfoModel getOrderDetailInfoModel:[dict objectForKey:@"orderInfo"]];
    _OrderModel.logisticsModel=[DD_OrderLogisticsModel getLogisticsModel:[dict objectForKey:@"logistical "]];
//    _OrderModel.logisticsModel=nil;
    return _OrderModel;
}
@end
