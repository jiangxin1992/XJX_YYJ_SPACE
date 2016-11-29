//
//  DD_ItemTool.m
//  YCO SPACE
//
//  Created by yyj on 16/7/21.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_ItemTool.h"

#import "WaterflowCell.h"

#import "DD_ImageModel.h"
#import "DD_ItemsModel.h"

@implementation DD_ItemTool

+(WaterflowCell *)getCustomWaterflowCell:(Waterflow *)waterflow cellAtIndex:(NSInteger)index WithItemsModel:(DD_ItemsModel *)item WithHeight:(CGFloat )_height
{
    WaterflowCell *cell = [WaterflowCell waterflowCellWithWaterflow:waterflow];
    cell.backgroundColor=_define_white_color;
//    cell.index=@"1";
    
    UIImageView *imageview=nil;
    if(item.pics&&item.pics.count)
    {
        DD_ImageModel *imgModel=item.pics[0];
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
    
    UILabel *price_label=[UILabel getLabelWithAlignment:0 WithTitle:[[NSString alloc] initWithFormat:@"￥%@",item.price] WithFont:15.0f WithTextColor:nil WithSpacing:0];
    [cell addSubview:price_label];
    price_label.font=[regular getSemiboldFont:15.0f];
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

+(WaterflowCell *)getColCustomWaterflowCell:(Waterflow *)waterflow cellAtIndex:(NSUInteger)index WithItemsModel:(DD_ItemsModel *)item WithHeight:(CGFloat )_height
{
    WaterflowCell *cell = [WaterflowCell waterflowCellWithWaterflow:waterflow];
    cell.backgroundColor=_define_white_color;
    UIImageView *imageview=nil;
    if(item.pics&&item.pics.count)
    {
        DD_ImageModel *imgModel=item.pics[0];
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


+(WaterflowCell *)getHomePageCustomWaterflowCell:(Waterflow *)waterflow cellAtIndex:(NSUInteger)index WithItemsModel:(DD_ItemsModel *)item WithHeight:(CGFloat )_height
{
    WaterflowCell *cell = [WaterflowCell waterflowCellWithWaterflow:waterflow];
    cell.backgroundColor=_define_white_color;
    UIImageView *imageview=nil;
    if(item.pics&&item.pics.count)
    {
        DD_ImageModel *imgModel=item.pics[0];
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
    
    //    UIButton *price_label=[UIButton getCustomTitleBtnWithAlignment:1 WithFont:15.0f WithSpacing:0 WithNormalTitle:[[NSString alloc] initWithFormat:@"￥%@",item.price] WithNormalColor:nil WithSelectedTitle:nil WithSelectedColor:nil];
    UILabel *price_label=[UILabel getLabelWithAlignment:0 WithTitle:title WithFont:15.0f WithTextColor:nil WithSpacing:0];
    [cell addSubview:price_label];
//        price_label.backgroundColor=[UIColor blueColor];
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


@end
