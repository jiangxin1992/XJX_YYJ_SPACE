//
//  DD_CircleListModel.m
//  DDAY
//
//  Created by yyj on 16/6/21.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_CircleListModel.h"

#import "DD_ImageModel.h"
#import "DD_OrderItemModel.h"
#import "DD_CircleTagModel.h"

@implementation DD_CircleListModel
+(DD_CircleListModel *)getCircleListModel:(NSDictionary *)dict
{
    DD_CircleListModel *_tagModel=[DD_CircleListModel objectWithKeyValues:dict];
    _tagModel.createTime=[[dict objectForKey:@"createTime"] longLongValue]/1000;
    _tagModel.items=[DD_OrderItemModel getOrderItemModelArr:[dict objectForKey:@"items"]];
    //    _tagModel.suggestHeight=[regular getHeightWithContent:_tagModel.shareAdvise WithWidth:ScreenWidth-40 WithFont:13.0f] ;
    return _tagModel;
}
+(NSMutableArray *)getCircleListModelArr:(NSArray *)arr
{
    NSMutableArray *TagsArr=[[NSMutableArray alloc] init];
    for (NSDictionary *dict in arr) {
        [TagsArr addObject:[self getCircleListModel:dict]];
    }
    return TagsArr;
}

+(NSMutableArray *)getCircleListImgModelArr:(NSArray *)arr
{
    NSMutableArray *TagsArr=[[NSMutableArray alloc] init];
    for (NSDictionary *dict in arr) {
        [TagsArr addObject:[self getCircleListImgModel:dict]];
    }
    return TagsArr;
}
+(DD_CircleListModel *)getCircleListImgModel:(NSDictionary *)dict
{
    DD_CircleListModel *_tagModel=[DD_CircleListModel objectWithKeyValues:dict];
    _tagModel.createTime=[[dict objectForKey:@"createTime"] longLongValue]/1000;
    _tagModel.items=[DD_OrderItemModel getOrderItemModelArr:[dict objectForKey:@"items"]];
    _tagModel.tags=[DD_CircleTagModel getCircleTagModelArr:[dict objectForKey:@"personTags"]];
    _tagModel.pics=[DD_ImageModel getImageModelArr:[dict objectForKey:@"pics"]];
    return _tagModel;
}
-(NSMutableArray *)getTagArr
{
    NSMutableArray *arr=[[NSMutableArray alloc] init];
    for (DD_CircleTagModel *tag in self.tags) {
        [arr addObjectsFromArray:tag.tags];
    }
    return arr;
}
@end
