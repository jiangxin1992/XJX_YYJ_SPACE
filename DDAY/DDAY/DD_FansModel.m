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
    for (NSDictionary *dict in arr) {
        [itemsArr addObject:[DD_FansModel objectWithKeyValues:dict]];
    }
    return itemsArr;
}
@end
