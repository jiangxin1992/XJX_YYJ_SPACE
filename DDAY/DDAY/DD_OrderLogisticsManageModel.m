//
//  DD_OrderLogisticsManageModel.m
//  YCO SPACE
//
//  Created by yyj on 16/8/24.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_OrderLogisticsManageModel.h"

@implementation DD_OrderLogisticsManageModel

+(DD_OrderLogisticsManageModel *)getLogisticsManageModel:(NSDictionary *)dict
{
    DD_OrderLogisticsManageModel *_SizeAlertModel=[DD_OrderLogisticsManageModel mj_objectWithKeyValues:dict];
    _SizeAlertModel.Traces=[DD_OrderLogisticsModel getLogisticsModelArr:[dict objectForKey:@"Traces"]];
//    0 无轨迹（还没有快递信息） 1 已揽件 2 途中 3 已签收 4 问题件 201 到达派件城市
    _SizeAlertModel.State_Str=_SizeAlertModel.State==0?@"还没有快递信息哦":_SizeAlertModel.State==1?@"已揽件":_SizeAlertModel.State==2?@"在途中":_SizeAlertModel.State==3?@"已签收":_SizeAlertModel.State==4?@"问题件":_SizeAlertModel.State==201?@"到达派件城市啦":@"";
    return _SizeAlertModel;
}

@end
