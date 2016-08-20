//
//  DD_OrderDetailModel.h
//  DDAY
//
//  Created by yyj on 16/6/7.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DD_OrderDetailInfoModel.h"
#import "DD_AddressModel.h"

@interface DD_OrderDetailModel : NSObject
/**
 * 获取解析model
 */
+(DD_OrderDetailModel *)getOrderDetailModel:(NSDictionary *)dict;

@property (nonatomic,strong)DD_OrderDetailInfoModel *orderInfo;
@property (nonatomic,strong)DD_AddressModel *address;
@end
