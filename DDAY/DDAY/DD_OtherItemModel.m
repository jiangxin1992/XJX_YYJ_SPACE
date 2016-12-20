//
//  DD_OtherItemModel.m
//  DDAY
//
//  Created by yyj on 16/5/23.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_OtherItemModel.h"

@implementation DD_OtherItemModel
+(NSArray *)getOtherItemModelArr:(NSArray *)arr
{
    NSMutableArray *itemsArr=[[NSMutableArray alloc] init];
    [arr enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
        [itemsArr addObject:[DD_OtherItemModel mj_objectWithKeyValues:dict]];
    }];

    return itemsArr;
}
@end
