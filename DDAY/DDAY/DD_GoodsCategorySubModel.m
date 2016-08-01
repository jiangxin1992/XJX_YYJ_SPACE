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
    for (NSDictionary *dict in arr){
        [itemsArr addObject:[DD_GoodsCategorySubModel objectWithKeyValues:dict]];
    }
    return itemsArr;
}
@end
