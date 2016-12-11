//
//  DD_CircleApplyDesignerModel.m
//  DDAY
//
//  Created by yyj on 16/6/24.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_CircleApplyDesignerModel.h"

@implementation DD_CircleApplyDesignerModel

+(NSArray *)getApplyDesignerModelArr:(NSArray *)arr
{
    NSMutableArray *itemsArr=[[NSMutableArray alloc] init];
    [arr enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
        [itemsArr addObject:[DD_CircleApplyDesignerModel mj_objectWithKeyValues:dict]];
    }];
//    for (NSDictionary *dict in arr) {
//        [itemsArr addObject:[DD_CircleApplyDesignerModel mj_objectWithKeyValues:dict]];
//    }
    return itemsArr;
}
@end
