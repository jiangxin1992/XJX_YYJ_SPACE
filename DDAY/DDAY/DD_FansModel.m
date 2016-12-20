//
//  DD_FansModel.m
//  DDAY
//
//  Created by yyj on 16/6/28.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_FansModel.h"

@implementation DD_FansModel

+(NSArray *)getFansModelArr:(NSArray *)arr
{
    NSMutableArray *itemsArr=[[NSMutableArray alloc] init];
    [arr enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
        [itemsArr addObject:[DD_FansModel mj_objectWithKeyValues:dict]];
    }];
    return itemsArr;
}
@end
