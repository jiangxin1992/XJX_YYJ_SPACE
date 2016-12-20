//
//  DD_CircleModel.m
//  DDAY
//
//  Created by yyj on 16/6/24.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_CircleModel.h"

#import "DD_CircleTagModel.h"
#import "DD_CricleTagItemModel.h"
#import "DD_CircleFavouriteDesignerModel.h"

@implementation DD_CircleModel
+(DD_CircleModel *)getCircleModel;
{
    DD_CircleModel *model=[[DD_CircleModel alloc] init];
    model.picArr=[[NSMutableArray alloc] init];
    model.tagMap=[[NSMutableDictionary alloc] init];
    model.chooseItem=[[NSMutableArray alloc] init];
    model.remark=@"";
    model.designerModel=[DD_CircleFavouriteDesignerModel initDesignerModel];
    return model;
}
-(NSMutableArray *)getTagArr
{
    NSMutableArray *arr=[[NSMutableArray alloc] init];

    [self.shareTags enumerateObjectsUsingBlock:^(DD_CircleTagModel *tagModel, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [tagModel.tags enumerateObjectsUsingBlock:^(DD_CricleTagItemModel *tagItemModel, NSUInteger idx2, BOOL * _Nonnull stop2) {
            if(tagItemModel.is_select)
            {
                [arr addObject:tagItemModel];
            }
        }];
    }];

    [self.personTags enumerateObjectsUsingBlock:^(DD_CircleTagModel *tagModel, NSUInteger idx, BOOL * _Nonnull stop) {
        [tagModel.tags enumerateObjectsUsingBlock:^(DD_CricleTagItemModel *tagItemModel, NSUInteger idx2, BOOL * _Nonnull stop2) {
            if(tagItemModel.is_select)
            {
                [arr addObject:tagItemModel];
            }
        }];
    }];

    return arr;
}
@end
