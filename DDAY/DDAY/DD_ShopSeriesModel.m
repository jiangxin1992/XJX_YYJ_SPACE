//
//  DD_ShopSeriesModel.m
//  DDAY
//
//  Created by yyj on 16/5/27.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_ShopSeriesModel.h"

@implementation DD_ShopSeriesModel
+(DD_ShopSeriesModel *)getShopSeriesModel:(NSDictionary *)dict
{
    
    DD_ShopSeriesModel *_ShopSeries=[DD_ShopSeriesModel objectWithKeyValues:dict];
    _ShopSeries.items=[DD_ShopItemModel getShopItemModelArr:[dict objectForKey:@"items"]];//获取item model数组
    _ShopSeries.signStartTime=_ShopSeries.signStartTime/1000;
    _ShopSeries.signEndTime=_ShopSeries.signEndTime/1000;
    _ShopSeries.saleStartTime=_ShopSeries.saleStartTime/1000;
    _ShopSeries.saleEndTime=_ShopSeries.saleEndTime/1000;
//    [self testDate:_ShopSeries];
    return _ShopSeries;
}
+(NSArray *)getShopSeriesModelArr:(NSArray *)arr
{
    NSMutableArray *itemsArr=[[NSMutableArray alloc] init];
    for (NSDictionary *dict in arr) {
        [itemsArr addObject:[self getShopSeriesModel:dict]];
    }
    return itemsArr;
}
+(void)testDate:(DD_ShopSeriesModel *)_ShopItemModel
{
    _ShopItemModel.signStartTime=[regular date]-10;
    _ShopItemModel.signEndTime=[regular date]-5;
    _ShopItemModel.saleStartTime=[regular date];
    _ShopItemModel.saleEndTime=[regular date]+5;
}

@end
