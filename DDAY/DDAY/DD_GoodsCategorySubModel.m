//
//  DD_GoodsCategorySubModel.m
//  YCO SPACE
//
//  Created by yyj on 16/8/1.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_GoodsCategorySubModel.h"

@implementation DD_GoodsCategorySubModel

+(NSArray *)getGoodsCategorySubModelArr:(NSArray *)arr
{
    NSMutableArray *itemsArr=[[NSMutableArray alloc] init];
    [arr enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
        [itemsArr addObject:[DD_GoodsCategorySubModel mj_objectWithKeyValues:dict]];
    }];
//    for (NSDictionary *dict in arr){
//        [itemsArr addObject:[DD_GoodsCategorySubModel mj_objectWithKeyValues:dict]];
//    }
    return itemsArr;
}
@end
