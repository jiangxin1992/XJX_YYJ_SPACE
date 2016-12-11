//
//  DD_ItemsModel.m
//  DDAY
//
//  Created by yyj on 16/5/22.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_ItemsModel.h"

#import "DD_ImageModel.h"

@implementation DD_ItemsModel
+(DD_ItemsModel *)getItemsModel:(NSDictionary *)dict
{
    DD_ItemsModel *_ItemsModel=[DD_ItemsModel mj_objectWithKeyValues:dict];
    _ItemsModel.g_id=[dict objectForKey:@"id"];
    _ItemsModel.pics=[DD_ImageModel getImageModelArr:[dict objectForKey:@"pics"]];
    return _ItemsModel;
}
+(NSArray *)getItemsModelArr:(NSArray *)arr
{
    NSMutableArray *itemsArr=[[NSMutableArray alloc] init];
    [arr enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
        [itemsArr addObject:[self getItemsModel:dict]];
    }];
//    for (NSDictionary *dict in arr) {
//        [itemsArr addObject:[self getItemsModel:dict]];
//    }
    return itemsArr;
}
@end
