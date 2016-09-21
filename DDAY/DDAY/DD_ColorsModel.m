//
//  DD_ColorsModel.m
//  DDAY
//
//  Created by yyj on 16/5/23.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_ColorsModel.h"

#import "DD_SizeModel.h"
#import "DD_ImageModel.h"

@implementation DD_ColorsModel
+(DD_ColorsModel *)getColorsModel:(NSDictionary *)dict
{
    DD_ColorsModel *_ColorsModel=[DD_ColorsModel mj_objectWithKeyValues:dict];
    _ColorsModel.size=[DD_SizeModel getSizeModelArr:[dict objectForKey:@"size"]];
    _ColorsModel.pics=[DD_ImageModel getImageModelArr:[dict objectForKey:@"pics"]];
    return _ColorsModel;
}

+(NSArray *)getColorsModelArr:(NSArray *)arr
{
    NSMutableArray *itemsArr=[[NSMutableArray alloc] init];
    for (NSDictionary *dict in arr) {
        [itemsArr addObject:[self getColorsModel:dict]];
    }
    return itemsArr;
}

@end
