//
//  DD_ShopSeriesModel.m
//  DDAY
//
//  Created by yyj on 16/5/27.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_ShopSeriesModel.h"

#import "DD_ShopItemModel.h"

@implementation DD_ShopSeriesModel
+(DD_ShopSeriesModel *)getShopSeriesModel:(NSDictionary *)dict
{
    
    DD_ShopSeriesModel *_ShopSeries=[DD_ShopSeriesModel mj_objectWithKeyValues:dict];
    _ShopSeries.items=[DD_ShopItemModel getShopItemModelArr:[dict objectForKey:@"items"]];//获取item model数组
    _ShopSeries.signStartTime=[[dict objectForKey:@"signStartTime"] longLongValue]/1000;
    _ShopSeries.signEndTime=[[dict objectForKey:@"signEndTime"] longLongValue]/1000;
    _ShopSeries.saleStartTime=[[dict objectForKey:@"saleStartTime"] longLongValue]/1000;
    _ShopSeries.saleEndTime=[[dict objectForKey:@"saleEndTime"] longLongValue]/1000;

//    _ShopSeries.signStartTime=_ShopSeries.signStartTime/1000;
//    _ShopSeries.signEndTime=_ShopSeries.signEndTime/1000;
//    _ShopSeries.saleStartTime=_ShopSeries.saleStartTime/1000;
//    _ShopSeries.saleEndTime=_ShopSeries.saleEndTime/1000;
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
    _ShopItemModel.signStartTime=[NSDate nowTime]-10;
    _ShopItemModel.signEndTime=[NSDate nowTime]-5;
    _ShopItemModel.saleStartTime=[NSDate nowTime];
    _ShopItemModel.saleEndTime=[NSDate nowTime]+5;
}

@end
