//
//  DD_CirclePublishTool.m
//  DDAY
//
//  Created by yyj on 16/6/24.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_CirclePublishTool.h"

@implementation DD_CirclePublishTool
/**
 * 标签网络获取成功之后，setter值
 */
+(void)SetWithDict:(NSDictionary *)dict WithCircleModel:(DD_CircleModel *)CircleModel
{
    CircleModel.shareTags=[DD_CircleTagModel getCircleTagModelArr:[dict objectForKey:@"shareTags"]];
    //    创建自定义标签
    DD_CircleTagModel *tagModel=[[DD_CircleTagModel alloc] init];
    tagModel.CategoryName=@"自定义标签";
    tagModel.parameterName=@"customTags";
    tagModel.tags=[[NSMutableArray alloc] init];
    [CircleModel.shareTags addObject:tagModel];
    
    CircleModel.personTags=[DD_CircleTagModel getCircleTagModelArr:[dict objectForKey:@"personTags"]];
    [self setTapMapWithCircleModel:CircleModel];
}
/**
 * 初始化tag参数字典
 */
+(void)setTapMapWithCircleModel:(DD_CircleModel *)CircleModel
{
    for (NSString *key in [self getTagArrWithCircleModel:CircleModel]) {
        [CircleModel.tagMap setValue:[[NSMutableArray alloc] init] forKey:key];
    }
    [CircleModel.tagMap setValue:[[NSMutableArray alloc] init] forKey:@"customTags"];
}

/**
 * 管理tagMap
 * 删除
 */
+(void)TagDelete:(long )index WithType:(NSInteger )type WithCircleModel:(DD_CircleModel *)CircleModel
{
    NSInteger index1=index/100;
    NSInteger index2=index%100;
    DD_CircleTagModel *_tagModel=[CircleModel.personTags objectAtIndex:index1];
    if(type==1)
    {
        _tagModel=[CircleModel.shareTags objectAtIndex:index1];
    }else if(type==2)
    {
        _tagModel=[CircleModel.personTags objectAtIndex:index1];
    }
    if(_tagModel)
    {
        DD_CricleTagItemModel *_tagItemModel=[_tagModel.tags objectAtIndex:index2];
        NSMutableArray *mut_arr=[CircleModel.tagMap objectForKey:_tagModel.parameterName];
        
        for (int i=0; i<mut_arr.count; i++) {
            NSString *str=[mut_arr objectAtIndex:i];
            if([str isEqualToString:_tagItemModel.tagName])
            {
                if(type==1)
                {
                    if([_tagModel.parameterName isEqualToString:@"customTags"])
                    {
                        [mut_arr removeAllObjects];
                        
                    }else
                    {
                        [mut_arr removeObjectAtIndex:i];
                        [_tagModel updateLastSelect];
                    }
                    
                }else if(type==2)
                {
                    [mut_arr removeAllObjects];
                }
                
                break;
            }
        }
    }
}
/**
 * 管理tagMap
 * 添加
 */
+(void)TagAdd:(long )index WithType:(NSInteger )type WithCircleModel:(DD_CircleModel *)CircleModel
{
    NSInteger index1=index/100;
    NSInteger index2=index%100;
    DD_CircleTagModel *_tagModel=nil;
    if(type==1)
    {
        _tagModel=[CircleModel.shareTags objectAtIndex:index1];
    }else if(type==2)
    {
        _tagModel=[CircleModel.personTags objectAtIndex:index1];
    }
    if(_tagModel)
    {
        DD_CricleTagItemModel *_tagItemModel=[_tagModel.tags objectAtIndex:index2];
        NSMutableArray *mut_arr=[CircleModel.tagMap objectForKey:_tagModel.parameterName];
        if(type==1)
        {
            if([_tagModel.parameterName isEqualToString:@"customTags"])
            {
                [mut_arr removeAllObjects];
                [mut_arr addObject:_tagItemModel.tagName];
                
            }else
            {
                NSString *lastTagName=nil;
                for (NSString *tagname in mut_arr) {
                    if([tagname isEqualToString:_tagModel.lastItem.tagName])
                    {
                        lastTagName=tagname;
                    }
                }
                [mut_arr removeAllObjects];
                [mut_arr addObject:_tagItemModel.tagName];
                if(lastTagName)
                {
                    [mut_arr addObject:lastTagName];
                }
                _tagModel.lastItem=_tagItemModel;
            }
        }else if(type==2)
        {
            [mut_arr removeAllObjects];
            [mut_arr addObject:_tagItemModel.tagName];
        }
        
    }
}
/**
 * 将刚创建的 标签model存入管理对象中
 */
+(void)addCustomModel:(DD_CricleTagItemModel *)tagModel WithCircleModel:(DD_CircleModel *)CircleModel
{
    for (DD_CircleTagModel *tm in CircleModel.shareTags) {
        if([tm.parameterName isEqualToString:@"customTags"])
        {
            [tm.tags addObject:tagModel];
            break;
        }
    }
}
+(BOOL)isExistCustomModelWithTagName:(NSString *)tagName WithCircleModel:(DD_CircleModel *)CircleModel
{
    for (DD_CircleTagModel *tm in CircleModel.shareTags) {
        if([tm.parameterName isEqualToString:@"customTags"])
        {
            for (DD_CricleTagItemModel *item in tm.tags) {
                if([item.tagName isEqualToString:tagName])
                {
                    return YES;
                }
            }
            break;
        }
    }
    return NO;
}
+(void)delChooseItemModel:(DD_CricleChooseItemModel *)model WithCircleModel:(DD_CircleModel *)CircleModel
{
    NSInteger _index=0;
    for (int i=0; i<CircleModel.chooseItem.count; i++) {
        DD_CricleChooseItemModel *_model=[CircleModel.chooseItem objectAtIndex:i];
        if([_model.colorId isEqualToString:model.colorId]&&[_model.g_id isEqualToString:model.g_id])
        {
            _index=i;
            break;
        }
    }
    [CircleModel.chooseItem removeObjectAtIndex:_index];
}
+(NSArray *)getParameterItemArrWithCircleModel:(DD_CircleModel *)CircleModel
{
    NSMutableArray *mutArr=[[NSMutableArray alloc] init];
    for (int i=0; i<CircleModel.chooseItem.count; i++) {
        DD_CricleChooseItemModel *_model=[CircleModel.chooseItem objectAtIndex:i];
        [mutArr addObject:@{
                            @"itemId":_model.g_id
                            ,@"colorId":_model.colorId
                            ,@"itemName":_model.name
                            ,@"price":_model.price
                            ,@"pic":_model.pic}
         ];
    }
    return mutArr;
}
+(NSInteger)getParameterTagsNumWithCircleModel:(DD_CircleModel *)CircleModel
{
    NSInteger _num=0;
    NSArray *keys=[CircleModel.tagMap allKeys];
    for (NSString *key in keys) {
        NSArray *arr=[CircleModel.tagMap objectForKey:key];
        _num+=arr.count;
    }
    return _num;
}
+(NSArray *)getPicArrWithCircleModel:(DD_CircleModel *)CircleModel
{
    NSMutableArray *mu_Arr=[[NSMutableArray alloc] init];
    for (NSDictionary *dict in CircleModel.picArr) {
        [mu_Arr addObject:[dict objectForKey:@"key"]];
    }
    return mu_Arr;
}
/**
 * 获取当前shareTags personTags中DD_CircleTagModel的parameterName
 * 返回参数数组
 */
+(NSArray *)getTagArrWithCircleModel:(DD_CircleModel *)CircleModel
{
    NSMutableArray *muArr=[[NSMutableArray alloc] init];
    for (DD_CircleTagModel *_tag in CircleModel.shareTags) {
        [muArr addObject:_tag.parameterName];
    }
    
    for (DD_CircleTagModel *_tag in CircleModel.personTags) {
        [muArr addObject:_tag.parameterName];
    }
    return muArr;
}

@end
