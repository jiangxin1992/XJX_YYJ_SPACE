//
//  DD_OrderLogisticsManageModel.h
//  YCO SPACE
//
//  Created by yyj on 16/8/24.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DD_OrderLogisticsManageModel : NSObject

+(DD_OrderLogisticsManageModel *)getLogisticsManageModel:(NSDictionary *)dict;

/** 物流号*/
__string(LogisticCode);

/** 物流信息*/
__array(Traces);

/** 状态 0 无轨迹（还没有快递信息）/ 1 已揽件/ 2 途中/ 3 已签收/ 4 问题件/ 201 到达派件城市*/
__int(State);

/** 快递公司名称*/
__string(deliver);

/** 快递公司Code*/
__string(ShipperCode);

/** 快递公司LOGO*/
__string(logo);

/** 操作是否成功*/
__bool(Success);

/** 当前状态*/
__string(State_Str);

@end
