//
//  DD_CircleTagModel.m
//  DDAY
//
//  Created by yyj on 16/6/16.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_CircleTagModel.h"

@implementation DD_CircleTagModel
+(DD_CircleTagModel *)getCircleTagModel:(NSDictionary *)dict
{
    DD_CircleTagModel *_tagModel=[DD_CircleTagModel mj_objectWithKeyValues:dict];
    _tagModel.tags=[DD_CricleTagItemModel getCricleTagItemModelArr:[dict objectForKey:@"tags"]];
    _tagModel.CategoryName=[dict objectForKey:@"name"];
    return _tagModel;
}
//+(DD_CircleTagModel *)getCircleTagModel_no:(NSDictionary *)dict
//{
//    DD_CircleTagModel *_tagModel=[DD_CircleTagModel objectWithKeyValues:dict];
//    _tagModel.tags=[dict objectForKey:@"tags"];
//    _tagModel.CategoryName=[dict objectForKey:@"name"];
//    return _tagModel;
//}

//+(NSMutableArray *)getCircleTagModelArr_no:(NSArray *)arr
//{
//    NSMutableArray *TagsArr=[[NSMutableArray alloc] init];
//    for (NSDictionary *dict in arr) {
//        [TagsArr addObject:[self getCircleTagModel_no:dict]];
//    }
//    return TagsArr;
//}
+(NSMutableArray *)getCircleTagModelArr:(NSArray *)arr
{
    NSMutableArray *TagsArr=[[NSMutableArray alloc] init];
    for (NSDictionary *dict in arr) {
        [TagsArr addObject:[self getCircleTagModel:dict]];
    }
    return TagsArr;
}
-(void )updateLastSelect
{
    BOOL isExist=NO;
    for (DD_CricleTagItemModel *item in self.tags) {
        if(item.is_select)
        {
            self.lastItem=item;
            isExist=YES;
            break;
        }
    }
    if(!isExist)
    {
        self.lastItem=nil;
    }
}
@end
