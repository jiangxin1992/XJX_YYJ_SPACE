//
//  DD_IntegralModel.m
//  YCO SPACE
//
//  Created by yyj on 2016/10/31.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_IntegralModel.h"

@implementation DD_IntegralModel

+(NSArray *)getIntegralModelArr:(NSArray *)arr
{
    NSMutableArray *integralArr=[[NSMutableArray alloc] init];
    [arr enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
        [integralArr addObject:[self getIntegralModel:dict]];
    }];
//    for (NSDictionary *dict in arr) {
//        [integralArr addObject:[self getIntegralModel:dict]];
//    }
    return integralArr;
}

+(DD_IntegralModel *)getIntegralModel:(NSDictionary *)dict
{
    DD_IntegralModel *_integralModel=[DD_IntegralModel mj_objectWithKeyValues:dict];
    _integralModel.happenTime=_integralModel.happenTime/1000;
    _integralModel.createTime=[regular getTimeStr:_integralModel.happenTime WithFormatter:@"YYYY/MM/dd HH:mm"];
    if(_integralModel.pointType)
    {
        _integralModel.pointStr=[[NSString alloc] initWithFormat:@"+%ld积分",_integralModel.points];
    }else
    {
        _integralModel.pointStr=[[NSString alloc] initWithFormat:@"-%ld积分",_integralModel.points];
    }
    return _integralModel;
}

@end
