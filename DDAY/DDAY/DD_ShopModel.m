//
//  DD_ShopModel.m
//  DDAY
//
//  Created by yyj on 16/5/27.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_ShopModel.h"

@implementation DD_ShopModel
+(DD_ShopModel *)getShopModel:(NSDictionary *)dict
{
     DD_ShopModel *_ShopModel=[DD_ShopModel objectWithKeyValues:dict];
    _ShopModel.seriesNormal=[DD_ShopSeriesModel getShopSeriesModelArr:[dict objectForKey:@"seriesNormal"]];
    _ShopModel.seriesInvalid=[DD_ShopSeriesModel getShopSeriesModelArr:[dict objectForKey:@"seriesInvalid"]];
    return _ShopModel;
}

@end
