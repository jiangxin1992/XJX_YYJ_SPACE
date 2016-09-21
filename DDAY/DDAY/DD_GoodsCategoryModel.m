//
//  DD_GoodsCategoryModel.m
//  YCO SPACE
//
//  Created by yyj on 16/8/1.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_GoodsCategoryModel.h"

@implementation DD_GoodsCategoryModel
+(DD_GoodsCategoryModel *)getGoodsCategoryModel:(NSDictionary *)dict
{
    DD_GoodsCategoryModel *_GoodsItemModel=[DD_GoodsCategoryModel mj_objectWithKeyValues:dict];
    _GoodsItemModel.catTwoList=[DD_GoodsCategorySubModel getGoodsCategorySubModelArr:[dict objectForKey:@"catTwoList"]];
    return _GoodsItemModel;
}
+(NSArray *)getGoodsCategoryModelArr:(NSArray *)arr
{
    NSMutableArray *itemsArr=[[NSMutableArray alloc] init];
    for (NSDictionary *dict in arr) {
        [itemsArr addObject:[self getGoodsCategoryModel:dict]];
    }
    return itemsArr;
}
@end
