//
//  DD_SizeModel.m
//  DDAY
//
//  Created by yyj on 16/5/23.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_SizeModel.h"

@implementation DD_SizeModel

+(NSArray *)getSizeModelArr:(NSArray *)arr
{
    NSMutableArray *itemsArr=[[NSMutableArray alloc] init];
    [arr enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
        DD_SizeModel *_sizeModel=[DD_SizeModel mj_objectWithKeyValues:dict];
        [itemsArr addObject:_sizeModel];
    }];
    return itemsArr;
}

@end
