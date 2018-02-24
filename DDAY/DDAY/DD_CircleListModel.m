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
    DD_CircleListModel *_tagModel=[DD_CircleListModel mj_objectWithKeyValues:dict];
    _tagModel.createTime=[[dict objectForKey:@"createTime"] longLongValue]/1000;
    _tagModel.items=[DD_OrderItemModel getOrderItemModelArr:[dict objectForKey:@"items"]];
    _tagModel.height=ceilf([regular getHeightWithWidth:ScreenWidth-2*kEdge WithContent:_tagModel.shareAdvise WithFont:[regular getFont:13.0f]])+9+44+19+300+19+8+44+20+30;
    if([_tagModel.shareType longValue]==4)
    {
        if(!(IsPhone6_gt))
        {
           _tagModel.height=_tagModel.height+66+20;
        }
    }

    _tagModel.contentHeight=ceilf([regular getHeightWithWidth:ScreenWidth-2*kEdge WithContent:_tagModel.shareAdvise WithFont:[regular getFont:13.0f]]);
    return _tagModel;
}
+(NSMutableArray *)getCircleListModelArr:(NSArray *)arr
{
    NSMutableArray *TagsArr=[[NSMutableArray alloc] init];
    [arr enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
        [TagsArr addObject:[self getCircleListModel:dict]];
    }];

    return TagsArr;
}

+(NSMutableArray *)getCircleListImgModelArr:(NSArray *)arr
{
    NSMutableArray *TagsArr=[[NSMutableArray alloc] init];
    [arr enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
        [TagsArr addObject:[self getCircleListImgModel:dict]];
    }];

    return TagsArr;
}
+(DD_CircleListModel *)getCircleListImgModel:(NSDictionary *)dict
{
    DD_CircleListModel *_tagModel=[DD_CircleListModel mj_objectWithKeyValues:dict];
    _tagModel.createTime=[[dict objectForKey:@"createTime"] longLongValue]/1000;
    _tagModel.items=[DD_OrderItemModel getOrderItemModelArr:[dict objectForKey:@"items"]];
    _tagModel.tags=[DD_CircleTagModel getCircleTagModelArr:[dict objectForKey:@"personTags"]];
    _tagModel.pics=[DD_ImageModel getImageModelArr:[dict objectForKey:@"pics"]];
    _tagModel.height=ceilf([regular getHeightWithWidth:ScreenWidth-2*kEdge WithContent:_tagModel.shareAdvise WithFont:[regular getFont:13.0f]])+9+44+19+300+19+8+44+20+30;
    if([_tagModel.shareType longValue]==4)
    {
        if(!(IsPhone6_gt))
        {
            _tagModel.height=_tagModel.height+66+20;
        }
    }
    _tagModel.contentHeight=ceilf([regular getHeightWithWidth:ScreenWidth-2*kEdge WithContent:_tagModel.shareAdvise WithFont:[regular getFont:13.0f]]);
    return _tagModel;
}
-(NSMutableArray *)getTagArr
{
    NSMutableArray *arr=[[NSMutableArray alloc] init];
    [self.tags enumerateObjectsUsingBlock:^(DD_CircleTagModel *tag, NSUInteger idx, BOOL * _Nonnull stop) {
        [arr addObjectsFromArray:tag.tags];
    }];

    return arr;
}
@end
