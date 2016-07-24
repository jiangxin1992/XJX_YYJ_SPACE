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
    for (NSDictionary *dict in arr) {
        [itemsArr addObject:[DD_OtherItemModel objectWithKeyValues:dict]];
    }
    return itemsArr;
}
@end
