//
//  DD_CirclePublishTool.m
//  DDAY
//
//  Created by yyj on 16/6/24.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_CirclePublishTool.h"

#import "WaterflowCell.h"

#import "DD_CircleModel.h"
#import "DD_CricleTagItemModel.h"
#import "DD_CricleChooseItemModel.h"
#import "DD_CircleTagModel.h"
#import "DD_ImageModel.h"

@implementation DD_CirclePublishTool

+(WaterflowCell *)getColCustomWaterflowCell:(Waterflow *)waterflow cellAtIndex:(NSUInteger)index WithItemsModel:(DD_CricleChooseItemModel *)item WithHeight:(CGFloat )_height
{
    WaterflowCell *cell = [WaterflowCell waterflowCellWithWaterflow:waterflow];
    cell.backgroundColor=_define_white_color;
    UIImageView *imageview=nil;
    
    if(item.pic)
    {
        imageview=[[UIImageView alloc] init];
        [cell addSubview:imageview];
        imageview.contentMode=2;
        [regular setZeroBorder:imageview];
        [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
            //            make.left.mas_equalTo(index%2?0:10);
            //            make.right.mas_equalTo(index%2?-10:0);
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(water_Top);
            make.height.mas_equalTo(_height);
        }];
        [imageview JX_ScaleAspectFill_loadImageUrlStr:item.pic.pic WithSize:800 placeHolderImageName:nil radius:0];
    }
//    UILabel *price_label=[UILabel getLabelWithAlignment:0 WithTitle:[[NSString alloc] initWithFormat:@"￥%@",item.price] WithFont:15.0f WithTextColor:_define_white_color WithSpacing:0];
//    [imageview addSubview:price_label];
//    price_label.font=[regular getSemiboldFont:15.0f];
//    [price_label mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(8);
//        make.bottom.mas_equalTo(-8);
//    }];
    //    UIButton *price_label=[UIButton getCustomTitleBtnWithAlignment:1 WithFont:15.0f WithSpacing:0 WithNormalTitle:[[NSString alloc] initWithFormat:@"￥%@",item.price] WithNormalColor:nil WithSelectedTitle:nil WithSelectedColor:nil];
    UILabel *price_label=[UILabel getLabelWithAlignment:0 WithTitle:[[NSString alloc] initWithFormat:@"￥%@",item.price] WithFont:15.0f WithTextColor:nil WithSpacing:0];
    [cell addSubview:price_label];
    //    price_label.backgroundColor=[UIColor blueColor];
    price_label.font=[regular getSemiboldFont:15.0f];
    //    [price_label setBackgroundImage:[UIImage imageNamed:@"Item_PriceFrame"] forState:UIControlStateNormal];
    //    price_label.titleEdgeInsets=UIEdgeInsetsMake(0, 5, 0, 5);
    [price_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-2);
    }];
//    [price_label sizeToFit];
    
    UILabel *titleLabel=[UILabel getLabelWithAlignment:0 WithTitle:item.name WithFont:13.0f WithTextColor:nil WithSpacing:0];
    [cell addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(price_label.mas_top).with.offset(-4);
        make.left.right.mas_equalTo(0);
    }];
        
    return cell;
}

-(WaterflowCell *)getCustomWaterflowCell:(Waterflow *)waterflow cellAtIndex:(NSUInteger)index WithItemsModel:(DD_CricleChooseItemModel *)item WithHeight:(CGFloat )_height WithBlock:(void(^)(NSString *type,NSInteger index))block
{
    _block=block;
    _index=index;
    WaterflowCell *cell = [WaterflowCell waterflowCellWithWaterflow:waterflow];
    cell.userInteractionEnabled=YES;
    
    UIView *backView=[UIView getCustomViewWithColor:nil];
    [cell addSubview:backView];
    if(item.isSelect)
    {
        [regular setBorder:backView];
    }
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(water_Top);
        make.height.mas_equalTo(_height);
    }];
    
    UIImageView *imgView=[UIImageView getCustomImg];
    [backView addSubview:imgView];
    imgView.contentMode=2;
    [regular setZeroBorder:imgView];
    imgView.userInteractionEnabled=NO;
    [imgView JX_ScaleAspectFill_loadImageUrlStr:item.pic.pic WithSize:400 placeHolderImageName:nil radius:0];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        if(item.isSelect)
        {
            make.left.top.mas_equalTo(11);
            make.bottom.right.mas_equalTo(-11);
           
        }else
        {
            make.edges.mas_equalTo(backView);
        }
    }];
    
    //    UIButton *price_label=[UIButton getCustomTitleBtnWithAlignment:1 WithFont:15.0f WithSpacing:0 WithNormalTitle:[[NSString alloc] initWithFormat:@"￥%@",item.price] WithNormalColor:nil WithSelectedTitle:nil WithSelectedColor:nil];
    UILabel *price_label=[UILabel getLabelWithAlignment:0 WithTitle:[[NSString alloc] initWithFormat:@"￥%@",item.price] WithFont:15.0f WithTextColor:nil WithSpacing:0];
    [cell addSubview:price_label];
    //    price_label.backgroundColor=[UIColor blueColor];
    price_label.font=[regular getSemiboldFont:15.0f];
    //    [price_label setBackgroundImage:[UIImage imageNamed:@"Item_PriceFrame"] forState:UIControlStateNormal];
    //    price_label.titleEdgeInsets=UIEdgeInsetsMake(0, 5, 0, 5);
    [price_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-2);
    }];
//    [price_label sizeToFit];
    
    UILabel *titleLabel=[UILabel getLabelWithAlignment:0 WithTitle:item.name WithFont:13.0f WithTextColor:nil WithSpacing:0];
    [cell addSubview:titleLabel];

    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(price_label.mas_top).with.offset(-4);
        make.left.right.mas_equalTo(0);
    }];
    
    return cell;
}
//-(void)selectAction
//{
//    _block(@"select",_index);
//}
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
    [CircleModel.shareTags insertObject:tagModel atIndex:0];
    
    CircleModel.personTags=[DD_CircleTagModel getCircleTagModelArr:[dict objectForKey:@"personTags"]];
    [self setTapMapWithCircleModel:CircleModel];
}
/**
 * 初始化tag参数字典
 */
+(void)setTapMapWithCircleModel:(DD_CircleModel *)CircleModel
{
    [[self getTagArrWithCircleModel:CircleModel] enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL * _Nonnull stop) {
        [CircleModel.tagMap setValue:[[NSMutableArray alloc] init] forKey:key];
    }];
    
//    for (NSString *key in [self getTagArrWithCircleModel:CircleModel]) {
//        [CircleModel.tagMap setValue:[[NSMutableArray alloc] init] forKey:key];
//    }
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
    DD_CircleTagModel *_tagModel=CircleModel.personTags[index1];
    if(type==1)
    {
        _tagModel=CircleModel.shareTags[index1];
    }else if(type==2)
    {
        _tagModel=CircleModel.personTags[index1];
    }
    if(_tagModel)
    {
        DD_CricleTagItemModel *_tagItemModel=_tagModel.tags[index2];
        NSMutableArray *mut_arr=[CircleModel.tagMap objectForKey:_tagModel.parameterName];
        
        [mut_arr enumerateObjectsUsingBlock:^(NSString *str, NSUInteger idx, BOOL * _Nonnull stop) {
            if([str isEqualToString:_tagItemModel.tagName])
            {
                if(type==1)
                {
                    if([_tagModel.parameterName isEqualToString:@"customTags"])
                    {
                        [mut_arr removeAllObjects];
                        
                    }else
                    {
                        [mut_arr removeObjectAtIndex:idx];
                        [_tagModel updateLastSelect];
                    }
                    
                }else if(type==2)
                {
                    [mut_arr removeAllObjects];
                }
                
                *stop=YES;
            }
        }];
        
//        for (int i=0; i<mut_arr.count; i++) {
//            NSString *str=mut_arr[i];
//            if([str isEqualToString:_tagItemModel.tagName])
//            {
//                if(type==1)
//                {
//                    if([_tagModel.parameterName isEqualToString:@"customTags"])
//                    {
//                        [mut_arr removeAllObjects];
//                        
//                    }else
//                    {
//                        [mut_arr removeObjectAtIndex:i];
//                        [_tagModel updateLastSelect];
//                    }
//                    
//                }else if(type==2)
//                {
//                    [mut_arr removeAllObjects];
//                }
//                
//                break;
//            }
//        }
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
        _tagModel=CircleModel.shareTags[index1];
    }else if(type==2)
    {
        _tagModel=CircleModel.personTags[index1];
    }
    if(_tagModel)
    {
        DD_CricleTagItemModel *_tagItemModel=_tagModel.tags[index2];
        NSMutableArray *mut_arr=[CircleModel.tagMap objectForKey:_tagModel.parameterName];
        if(type==1)
        {
            if([_tagModel.parameterName isEqualToString:@"customTags"])
            {
                [mut_arr removeAllObjects];
                [mut_arr addObject:_tagItemModel.tagName];
                
            }else
            {
                __block NSString *lastTagName=nil;
                [mut_arr enumerateObjectsUsingBlock:^(NSString *tagname, NSUInteger idx, BOOL * _Nonnull stop) {
                    if([tagname isEqualToString:_tagModel.lastItem.tagName])
                    {
                        lastTagName=tagname;
                    }
                }];
//                for (NSString *tagname in mut_arr) {
//                    if([tagname isEqualToString:_tagModel.lastItem.tagName])
//                    {
//                        lastTagName=tagname;
//                    }
//                }
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
    [CircleModel.shareTags enumerateObjectsUsingBlock:^(DD_CircleTagModel *tm, NSUInteger idx, BOOL * _Nonnull stop) {
        if([tm.parameterName isEqualToString:@"customTags"])
        {
            
            [tm.tags enumerateObjectsUsingBlock:^(DD_CricleTagItemModel *ttm, NSUInteger idx2, BOOL * _Nonnull stop2) {
                ttm.is_select=NO;
            }];
        }
    }];
//    for (DD_CircleTagModel *tm in CircleModel.shareTags) {
//        if([tm.parameterName isEqualToString:@"customTags"])
//        {
//            for (DD_CricleTagItemModel *ttm in tm.tags) {
//                ttm.is_select=NO;
//            }
//        }
//    }
    
    [CircleModel.shareTags enumerateObjectsUsingBlock:^(DD_CircleTagModel *tm, NSUInteger idx, BOOL * _Nonnull stop) {
        if([tm.parameterName isEqualToString:@"customTags"])
        {
            tagModel.is_select=YES;
            [tm.tags addObject:tagModel];
            *stop=YES;
        }
    }];
//    for (DD_CircleTagModel *tm in CircleModel.shareTags) {
//        if([tm.parameterName isEqualToString:@"customTags"])
//        {
//            tagModel.is_select=YES;
//            [tm.tags addObject:tagModel];
//            break;
//        }
//    }
    
    [[CircleModel.tagMap objectForKey:@"shareTags"] addObject:tagModel.tagName];
    
}
+(BOOL)isExistCustomModelWithTagName:(NSString *)tagName WithCircleModel:(DD_CircleModel *)CircleModel
{
    __block BOOL isExist=NO;
    [CircleModel.shareTags enumerateObjectsUsingBlock:^(DD_CircleTagModel *tm, NSUInteger idx, BOOL * _Nonnull stop) {
        if([tm.parameterName isEqualToString:@"customTags"])
        {
            
            [tm.tags enumerateObjectsUsingBlock:^(DD_CricleTagItemModel *item, NSUInteger idx2, BOOL * _Nonnull stop2) {
                if([item.tagName isEqualToString:tagName])
                {
                    isExist=YES;
                }
            }];
            *stop=YES;
        }
    }];
//    for (DD_CircleTagModel *tm in CircleModel.shareTags) {
//        if([tm.parameterName isEqualToString:@"customTags"])
//        {
//            for (DD_CricleTagItemModel *item in tm.tags) {
//                if([item.tagName isEqualToString:tagName])
//                {
//                    return YES;
//                }
//            }
//            break;
//        }
//    }
    return isExist;
}
+(void)delChooseItemModel:(DD_CricleChooseItemModel *)model WithCircleModel:(DD_CircleModel *)CircleModel
{
    __block NSInteger _index=0;
    [CircleModel.chooseItem enumerateObjectsUsingBlock:^(DD_CricleChooseItemModel *_model, NSUInteger idx, BOOL * _Nonnull stop) {
        if([_model.colorId isEqualToString:model.colorId]&&[_model.g_id isEqualToString:model.g_id])
        {
            _index=idx;
            *stop=YES;
        }
    }];
//    for (int i=0; i<CircleModel.chooseItem.count; i++) {
//        DD_CricleChooseItemModel *_model=CircleModel.chooseItem[i];
//        if([_model.colorId isEqualToString:model.colorId]&&[_model.g_id isEqualToString:model.g_id])
//        {
//            _index=i;
//            break;
//        }
//    }
    [CircleModel.chooseItem removeObjectAtIndex:_index];
}
+(NSArray *)getParameterItemArrWithCircleModel:(DD_CircleModel *)CircleModel
{
    NSMutableArray *mutArr=[[NSMutableArray alloc] init];
    [CircleModel.chooseItem enumerateObjectsUsingBlock:^(DD_CricleChooseItemModel *_model, NSUInteger idx, BOOL * _Nonnull stop) {
        [mutArr addObject:@{
                            @"itemId":_model.g_id
                            ,@"colorId":_model.colorId
                            ,@"itemName":_model.name
                            ,@"price":_model.price
                            ,@"pic":_model.pic.pic
                            ,@"height":_model.pic.height
                            ,@"width":_model.pic.width
                            ,@"colorCode":_model.colorCode
                            }
         ];
    }];
//    for (int i=0; i<CircleModel.chooseItem.count; i++) {
//        DD_CricleChooseItemModel *_model=CircleModel.chooseItem[i];
//        [mutArr addObject:@{
//                            @"itemId":_model.g_id
//                            ,@"colorId":_model.colorId
//                            ,@"itemName":_model.name
//                            ,@"price":_model.price
//                            ,@"pic":_model.pic.pic
//                            ,@"height":_model.pic.height
//                            ,@"width":_model.pic.width
//                            ,@"colorCode":_model.colorCode
//                            }
//         ];
//    }
    return mutArr;
}
+(NSInteger)getParameterTagsNumWithCircleModel:(DD_CircleModel *)CircleModel
{
    __block NSInteger _num=0;
    NSArray *keys=[CircleModel.tagMap allKeys];
    [keys enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray *arr=[CircleModel.tagMap objectForKey:key];
        _num+=arr.count;
    }];
//    for (NSString *key in keys) {
//        NSArray *arr=[CircleModel.tagMap objectForKey:key];
//        _num+=arr.count;
//    }
    return _num;
}
+(NSArray *)getPicArrWithCircleModel:(DD_CircleModel *)CircleModel
{
    NSMutableArray *mu_Arr=[[NSMutableArray alloc] init];
    [CircleModel.picArr enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
        [mu_Arr addObject:[dict objectForKey:@"key"]];
    }];
//    for (NSDictionary *dict in CircleModel.picArr) {
//        [mu_Arr addObject:[dict objectForKey:@"key"]];
//    }
    return mu_Arr;
}
+(NSArray *)getPicDataArrWithCircleModel:(DD_CircleModel *)CircleModel
{
    NSMutableArray *mu_Arr=[[NSMutableArray alloc] init];
    [CircleModel.picArr enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
        [mu_Arr addObject:[dict objectForKey:@"data"]];
    }];
//    for (NSDictionary *dict in CircleModel.picArr) {
//        [mu_Arr addObject:[dict objectForKey:@"data"]];
//    }
    return mu_Arr;
}
/**
 * 获取当前shareTags personTags中DD_CircleTagModel的parameterName
 * 返回参数数组
 */
+(NSArray *)getTagArrWithCircleModel:(DD_CircleModel *)CircleModel
{
    NSMutableArray *muArr=[[NSMutableArray alloc] init];
    [CircleModel.shareTags enumerateObjectsUsingBlock:^(DD_CircleTagModel *_tag, NSUInteger idx, BOOL * _Nonnull stop) {
        [muArr addObject:_tag.parameterName];
    }];
//    for (DD_CircleTagModel *_tag in CircleModel.shareTags) {
//        [muArr addObject:_tag.parameterName];
//    }
    [CircleModel.personTags enumerateObjectsUsingBlock:^(DD_CircleTagModel *_tag, NSUInteger idx, BOOL * _Nonnull stop) {
        [muArr addObject:_tag.parameterName];
    }];
//    for (DD_CircleTagModel *_tag in CircleModel.personTags) {
//        [muArr addObject:_tag.parameterName];
//    }
    return muArr;
}

@end
