//
//  DD_GoodSeriesModel.m
//  DDAY
//
//  Created by yyj on 16/5/23.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_GoodSeriesModel.h"

@implementation DD_GoodSeriesModel
+(DD_GoodSeriesModel *)getGoodSeriesModel:(NSDictionary *)dict
{
    DD_GoodSeriesModel *_GoodSeriesModel=[DD_GoodSeriesModel objectWithKeyValues:dict];
    _GoodSeriesModel.s_id=[dict objectForKey:@"id"];
    return _GoodSeriesModel;
}
@end
