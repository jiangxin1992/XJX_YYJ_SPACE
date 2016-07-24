//
//  DD_OrderItemModel.m
//  DDAY
//
//  Created by yyj on 16/6/6.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_OrderItemModel.h"

@implementation DD_OrderItemModel
+(NSArray *)getOrderItemModelArr:(NSArray *)arr
{
    NSMutableArray *itemsArr=[[NSMutableArray alloc] init];
    for (NSDictionary *dict in arr) {
        [itemsArr addObject:[DD_OrderItemModel objectWithKeyValues:dict]];
    }
    return itemsArr;
}
@end
