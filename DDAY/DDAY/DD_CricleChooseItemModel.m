//
//  DD_CricleChooseItemModel.m
//  DDAY
//
//  Created by yyj on 16/6/20.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_CricleChooseItemModel.h"

#import "DD_ImageModel.h"

@implementation DD_CricleChooseItemModel
+(DD_CricleChooseItemModel *)getCricleChooseItemModel:(NSDictionary *)dict WithDetail:(NSArray *)chooseItem
{
    DD_CricleChooseItemModel *_ItemsModel=[DD_CricleChooseItemModel mj_objectWithKeyValues:dict];
    _ItemsModel.g_id=[dict objectForKey:@"id"];
    __block BOOL _is_exit=NO;
//    遍历查询chooseItem中是否有_ItemsModel
//    有的话isSelect设置为YES
    [chooseItem enumerateObjectsUsingBlock:^(DD_CricleChooseItemModel *_model, NSUInteger idx, BOOL * _Nonnull stop) {
        if([_model.colorId isEqualToString:_ItemsModel.colorId]&&[_model.g_id isEqualToString:_ItemsModel.g_id])
        {
            _is_exit=YES;
            *stop=YES;
        }
    }];

    _ItemsModel.isSelect=_is_exit;
    return _ItemsModel;
}
+(DD_CricleChooseItemModel *)getCricleChooseItemModel:(NSDictionary *)dict
{
    DD_CricleChooseItemModel *_ItemsModel=[DD_CricleChooseItemModel mj_objectWithKeyValues:dict];
    _ItemsModel.g_id=[dict objectForKey:@"id"];
    _ItemsModel.isSelect=NO;
    return _ItemsModel;
}
+(NSArray *)getItemsModelArr:(NSArray *)arr WithDetail:(NSArray *)chooseItem
{
    NSMutableArray *itemsArr=[[NSMutableArray alloc] init];
    [arr enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
        [itemsArr addObject:[self getCricleChooseItemModel:dict WithDetail:chooseItem]];
    }];

    return itemsArr;
}
+(NSArray *)getItemsModelArr:(NSArray *)arr
{
    NSMutableArray *itemsArr=[[NSMutableArray alloc] init];
    [arr enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
        [itemsArr addObject:[self getCricleChooseItemModel:dict]];
    }];

    return itemsArr;
}
@end
