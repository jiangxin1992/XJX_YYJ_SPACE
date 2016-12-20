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
    [arr enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
        [itemsArr addObject:[DD_CricleCategoryModel mj_objectWithKeyValues:dict]];
    }];

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
