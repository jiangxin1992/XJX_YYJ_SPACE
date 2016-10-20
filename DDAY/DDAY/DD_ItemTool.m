//
//  DD_ItemTool.m
//  YCO SPACE
//
//  Created by yyj on 16/7/21.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_ItemTool.h"

#import "DD_ImageModel.h"

@implementation DD_ItemTool
+(WaterflowCell *)getCustomWaterflowCell:(Waterflow *)waterflow cellAtIndex:(NSInteger)index WithItemsModel:(DD_ItemsModel *)item WithHeight:(CGFloat )_height
{
    WaterflowCell *cell = [WaterflowCell waterflowCellWithWaterflow:waterflow];
    cell.backgroundColor=_define_white_color;
//    cell.index=@"1";
    
    UIImageView *imageview=nil;
    if(item.pics&&item.pics.count)
    {
        DD_ImageModel *imgModel=[item.pics objectAtIndex:0];
        imageview=[[UIImageView alloc] init];
        [cell addSubview:imageview];
        imageview.contentMode=2;
        [regular setZeroBorder:imageview];
        [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(water_Top);
            make.height.mas_equalTo(_height);
        }];
        [imageview JX_ScaleAspectFill_loadImageUrlStr:imgModel.pic WithSize:800 placeHolderImageName:nil radius:0];
    }
    
    UIButton *price_label=[UIButton getCustomTitleBtnWithAlignment:1 WithFont:15.0f WithSpacing:0 WithNormalTitle:[[NSString alloc] initWithFormat:@"￥%@",item.price] WithNormalColor:_define_white_color WithSelectedTitle:nil WithSelectedColor:nil];
    [imageview addSubview:price_label];
    [price_label setBackgroundImage:[UIImage imageNamed:@"Circle_PriceFrame"] forState:UIControlStateNormal];
    price_label.titleLabel.font=[regular getSemiboldFont:15.0f];
    price_label.titleEdgeInsets=UIEdgeInsetsMake(0, 5, 0, 5);
    [price_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(25);
    }];
    
    UILabel *titleLabel=[UILabel getLabelWithAlignment:0 WithTitle:item.name WithFont:13.0f WithTextColor:nil WithSpacing:0];
    [cell addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
    }];

    return cell;
}

+(WaterflowCell *)getColCustomWaterflowCell:(Waterflow *)waterflow cellAtIndex:(NSUInteger)index WithItemsModel:(DD_ItemsModel *)item WithHeight:(CGFloat )_height
{
    WaterflowCell *cell = [WaterflowCell waterflowCellWithWaterflow:waterflow];
    cell.backgroundColor=_define_white_color;
    UIImageView *imageview=nil;
    if(item.pics&&item.pics.count)
    {
        DD_ImageModel *imgModel=[item.pics objectAtIndex:0];
        imageview=[[UIImageView alloc] init];
        [cell addSubview:imageview];
        imageview.contentMode=2;
        [regular setZeroBorder:imageview];
        [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(water_Top);
            make.height.mas_equalTo(_height);
        }];
        [imageview JX_ScaleAspectFill_loadImageUrlStr:imgModel.pic WithSize:800 placeHolderImageName:nil radius:0];
    }
    UIButton *price_label=[UIButton getCustomTitleBtnWithAlignment:1 WithFont:15.0f WithSpacing:0 WithNormalTitle:[[NSString alloc] initWithFormat:@"￥%@",item.price] WithNormalColor:_define_white_color WithSelectedTitle:nil WithSelectedColor:nil];
    [imageview addSubview:price_label];
    [price_label setBackgroundImage:[UIImage imageNamed:@"Circle_PriceFrame"] forState:UIControlStateNormal];
    price_label.titleLabel.font=[regular getSemiboldFont:15.0f];
    price_label.titleEdgeInsets=UIEdgeInsetsMake(0, 5, 0, 5);
    [price_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(25);
    }];
    
    UILabel *titleLabel=[UILabel getLabelWithAlignment:0 WithTitle:item.name WithFont:13.0f WithTextColor:nil WithSpacing:0];
    [cell addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
    }];
    
    return cell;

}


+(WaterflowCell *)getHomePageCustomWaterflowCell:(Waterflow *)waterflow cellAtIndex:(NSUInteger)index WithItemsModel:(DD_ItemsModel *)item WithHeight:(CGFloat )_height
{
    WaterflowCell *cell = [WaterflowCell waterflowCellWithWaterflow:waterflow];
    cell.backgroundColor=_define_white_color;
    UIImageView *imageview=nil;
    if(item.pics&&item.pics.count)
    {
        DD_ImageModel *imgModel=[item.pics objectAtIndex:0];
        imageview=[[UIImageView alloc] init];
        [cell addSubview:imageview];
        imageview.contentMode=2;
        [regular setZeroBorder:imageview];

        [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(water_margin);
            make.height.mas_equalTo(_height);
        }];
        [imageview JX_ScaleAspectFill_loadImageUrlStr:imgModel.pic WithSize:800 placeHolderImageName:nil radius:0];
    }
    
    /**
     * public static Integer ITEM_STATUS_WSJ = 0; //未上架
     * public static Integer ITEM_STATUS_YSJ = 1; //已上架
     * public static Integer ITEM_STATUS_YXJ = 2; //已下架
     * public static Integer ITEM_STATUS_YSC = 3; //已删除
     */
    NSString *title=nil;
    if(item.status==1)
    {
        title=[[NSString alloc] initWithFormat:@"￥%@",item.price] ;
    }else
    {
        title=@"已下架";
    }
    
    UIButton *price_label=[UIButton getCustomTitleBtnWithAlignment:1 WithFont:15.0f WithSpacing:0 WithNormalTitle:title WithNormalColor:_define_white_color WithSelectedTitle:nil WithSelectedColor:nil];
    [imageview addSubview:price_label];
    [price_label setBackgroundImage:[UIImage imageNamed:@"Circle_PriceFrame"] forState:UIControlStateNormal];
    price_label.titleLabel.font=[regular getSemiboldFont:15.0f];
    price_label.titleEdgeInsets=UIEdgeInsetsMake(0, 5, 0, 5);
    [price_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(25);
    }];
    
    UILabel *titleLabel=[UILabel getLabelWithAlignment:0 WithTitle:item.name WithFont:13.0f WithTextColor:nil WithSpacing:0];
    [cell addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
    }];

    return cell;
}


@end
