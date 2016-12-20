//
//  DD_OrderLogisticsModel.m
//  YCO SPACE
//
//  Created by yyj on 16/8/24.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_OrderLogisticsModel.h"

@implementation DD_OrderLogisticsModel
/**
 * 获取解析model
 */
+(DD_OrderLogisticsModel *)getLogisticsModel:(NSDictionary *)dict
{
    DD_OrderLogisticsModel *_SizeAlertModel=[DD_OrderLogisticsModel mj_objectWithKeyValues:dict];
    _SizeAlertModel.AcceptTime=[[dict objectForKey:@"AcceptTime"] longLongValue]/1000;
    return _SizeAlertModel;
}
/**
 * 获取解析数组
 */
+(NSArray *)getLogisticsModelArr:(NSArray *)arr
{
    NSMutableArray *itemsArr=[[NSMutableArray alloc] init];
    [arr enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
       [itemsArr addObject:[self getLogisticsModel:dict]];
    }];

    return itemsArr;
}
@end
