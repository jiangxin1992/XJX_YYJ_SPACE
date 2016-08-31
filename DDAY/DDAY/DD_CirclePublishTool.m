//
//  DD_CirclePublishTool.m
//  DDAY
//
//  Created by yyj on 16/6/24.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_CirclePublishTool.h"

#import "DD_CircleTagModel.h"

@implementation DD_CirclePublishTool

+(WaterflowCell *)getColCustomWaterflowCell:(Waterflow *)waterflow cellAtIndex:(NSUInteger)index WithItemsModel:(DD_CricleChooseItemModel *)item WithHeight:(CGFloat )_height
{
    WaterflowCell *cell = [WaterflowCell waterflowCellWithWaterflow:waterflow];
    cell.backgroundColor=[UIColor whiteColor];
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
            make.top.mas_equalTo(0);
            make.height.mas_equalTo(_height);
        }];
        [imageview JX_ScaleAspectFill_loadImageUrlStr:item.pic.pic WithSize:800 placeHolderImageName:nil radius:0];
    }
    UILabel *price_label=[UILabel getLabelWithAlignment:0 WithTitle:[[NSString alloc] initWithFormat:@"￥%@",item.price] WithFont:15.0f WithTextColor:_define_white_color WithSpacing:0];
    [imageview addSubview:price_label];
    price_label.font=[regular getSemiboldFont:15.0f];
    [price_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.bottom.mas_equalTo(-8);
    }];
    
    UILabel *titleLabel=[UILabel getLabelWithAlignment:0 WithTitle:item.name WithFont:13.0f WithTextColor:nil WithSpacing:0];
    [cell addSubview:titleLabel];
    //    titleLabel.backgroundColor=[UIColor redColor];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
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
//    cell.backgroundColor=[UIColor yellowColor];
    
    UIView *backView=[UIView getCustomViewWithColor:nil];
    [cell addSubview:backView];
//    backView.backgroundColor=[UIColor redColor];
    if(item.isSelect)
    {
        [regular setBorder:backView];
    }
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
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
    
    UILabel *priceLabel=[UILabel getLabelWithAlignment:0 WithTitle:[[NSString alloc] initWithFormat:@"￥%@",item.price] WithFont:15.0f WithTextColor:_define_white_color WithSpacing:0];
    [imgView addSubview:priceLabel];
    priceLabel.font=[regular get_en_Font:15.0f];
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.bottom.mas_equalTo(-8);
    }];
    
    
//    UIButton *itemBtn=[UIButton getCustomImgBtnWithImageStr:@"Circle_No_choose" WithSelectedImageStr:@"System_Select"];
//    [cell addSubview:itemBtn];
//    [itemBtn addTarget:self action:@selector(selectAction) forControlEvents:UIControlEventTouchUpInside];
//    itemBtn.selected=item.isSelect;
//    [itemBtn setEnlargeEdge:20];
//    [itemBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.right.mas_equalTo(0);
//        make.width.height.mas_equalTo(20);
//    }];
    
    UILabel *titleLabel=[UILabel getLabelWithAlignment:0 WithTitle:item.name WithFont:13.0f WithTextColor:nil WithSpacing:0];
    [cell addSubview:titleLabel];
//    titleLabel.backgroundColor=[UIColor redColor];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
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
                            ,@"pic":_model.pic.pic
                            ,@"height":_model.pic.height
                            ,@"width":_model.pic.width
                            ,@"colorCode":_model.colorCode
                            }
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
+(NSArray *)getPicDataArrWithCircleModel:(DD_CircleModel *)CircleModel
{
    NSMutableArray *mu_Arr=[[NSMutableArray alloc] init];
    for (NSDictionary *dict in CircleModel.picArr) {
        [mu_Arr addObject:[dict objectForKey:@"data"]];
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
