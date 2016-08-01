//
//  DD_CricleCategoryModel.m
//  DDAY
//
//  Created by yyj on 16/6/20.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_CricleCategoryModel.h"

@implementation DD_CricleCategoryModel

+(NSArray *)getCricleCategoryModelArr:(NSArray *)arr
{
    NSMutableArray *itemsArr=[[NSMutableArray alloc] init];
    for (NSDictionary *dict in arr) {
        [itemsArr addObject:[DD_CricleCategoryModel objectWithKeyValues:dict]];
    }
    return itemsArr;
}
+(DD_CricleCategoryModel *)getInitModel
{
    DD_CricleCategoryModel *model=[[DD_CricleCategoryModel alloc] init];
    model.name=@"所有的";
    model.level=@"";
    model.code=@"";
    return model;
}

@end