//
//  DD_ImageModel.m
//  YCO SPACE
//
//  Created by yyj on 16/7/21.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_ImageModel.h"

@implementation DD_ImageModel
+(DD_ImageModel *)getImageModel:(NSDictionary *)dict
{
    DD_ImageModel *_ItemsModel=[DD_ImageModel objectWithKeyValues:dict];
    return _ItemsModel;
}
+(NSArray *)getImageModelArr:(NSArray *)arr
{
    NSMutableArray *itemsArr=[[NSMutableArray alloc] init];
    for (NSDictionary *dict in arr) {
        [itemsArr addObject:[self getImageModel:dict]];
    }
    return itemsArr;
}
@end
