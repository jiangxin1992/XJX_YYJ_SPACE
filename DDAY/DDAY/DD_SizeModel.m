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
    for (NSDictionary *dict in arr) {
        DD_SizeModel *_sizeModel=[DD_SizeModel objectWithKeyValues:dict];
        [itemsArr addObject:_sizeModel];
    }
    return itemsArr;
}

@end
