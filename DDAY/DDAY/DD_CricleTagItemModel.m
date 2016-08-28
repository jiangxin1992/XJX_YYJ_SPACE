//
//  DD_CricleTagItemModel.m
//  DDAY
//
//  Created by yyj on 16/6/16.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_CricleTagItemModel.h"

@implementation DD_CricleTagItemModel

+(DD_CricleTagItemModel *)getCricleTagItemModel:(NSDictionary *)dict
{
    DD_CricleTagItemModel *_tagModel=[DD_CricleTagItemModel objectWithKeyValues:dict];
//    _tagModel.createTime=_tagModel.createTime/1000;//java时间戳转换
    _tagModel.createTime=[[dict objectForKey:@"createTime"] longLongValue]/1000;//java时间戳转换
    _tagModel.is_select=NO;//初始化为未选中状态
    _tagModel.t_id=[dict objectForKey:@"id"];
    return _tagModel;
}
+(NSMutableArray *)getCricleTagItemModelArr:(NSArray *)arr
{
    NSMutableArray *TagsArr=[[NSMutableArray alloc] init];
    for (NSDictionary *dict in arr) {
        [TagsArr addObject:[self getCricleTagItemModel:dict]];
    }
    return TagsArr;
}
@end
