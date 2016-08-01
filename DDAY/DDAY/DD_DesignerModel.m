//
//  DD_DesignerModel.m
//  DDAY
//
//  Created by yyj on 16/5/22.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_DesignerModel.h"

@implementation DD_DesignerModel
+(DD_DesignerModel *)getDesignerModel:(NSDictionary *)dict
{
    DD_DesignerModel *_DesignerModel=[DD_DesignerModel objectWithKeyValues:dict];
    return _DesignerModel;
}
+(NSArray *)getDesignerModelArr:(NSArray *)arr
{
    NSMutableArray *itemsArr=[[NSMutableArray alloc] init];
    for (NSDictionary *dict in arr) {
        [itemsArr addObject:[self getDesignerModel:dict]];
    }
    return itemsArr;
}
@end