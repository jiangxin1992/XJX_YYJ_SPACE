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
    /**
     * public static Integer ITEM_STATUS_WSJ = 0; //未上架
     * public static Integer ITEM_STATUS_YSJ = 1; //已上架
     * public static Integer ITEM_STATUS_YXJ = 2; //已下架
     * public static Integer ITEM_STATUS_YSC = 3; //已删除
     * public static Integer ITEM_STATUS_YSC = -1; //已售罄
     */
    NSString *title=nil;
    if(item.status==1)
    {
        title=[[NSString alloc] initWithFormat:@"￥%@",item.price] ;
    }else
    {
        title=item.status==0?@"未上架":item.status==2?@"已下架":item.status==3?@"已删除":item.status==-1?@"已售罄":@"";
    }
    UILabel *price_label=[UILabel getLabelWithAlignment:0 WithTitle:title WithFont:15.0f WithTextColor:nil WithSpacing:0];
    [cell addSubview:price_label];
    price_label.font=[regular getSemiboldFont:15.0f];
    [price_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(-2);
    }];

    if(item.status==1)
    {
        if([item.price integerValue]!=[item.originalPrice integerValue])
        {
            UILabel *original_label=[UILabel getLabelWithAlignment:0 WithTitle:[[NSString alloc] initWithFormat:@"￥%@",item.originalPrice] WithFont:15.0f WithTextColor:_define_light_gray_color1 WithSpacing:0];
            [cell addSubview:original_label];
            [original_label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(price_label.mas_right).with.offset(5);
                make.centerY.mas_equalTo(price_label);
            }];
            
            UIView *middleLine=[UIView getCustomViewWithColor:_define_light_gray_color1];
            [original_label addSubview:middleLine];
            [middleLine mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(original_label);
                make.left.right.mas_equalTo(0);
                make.height.mas_equalTo(1);
            }];
        }
    }
    
    UILabel *titleLabel=[UILabel getLabelWithAlignment:0 WithTitle:@"" WithFont:13.0f WithTextColor:nil WithSpacing:0];
    [cell addSubview:titleLabel];
    if(item.cooperateTag==1)
    {
        titleLabel.text=[[NSString alloc] initWithFormat:@"合作款 | %@",item.name];
    }else
    {
        titleLabel.text=item.name;
    }
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
    /**
     * public static Integer ITEM_STATUS_WSJ = 0; //未上架
     * public static Integer ITEM_STATUS_YSJ = 1; //已上架
     * public static Integer ITEM_STATUS_YXJ = 2; //已下架
     * public static Integer ITEM_STATUS_YSC = 3; //已删除
     * public static Integer ITEM_STATUS_YSC = -1; //已售罄
     */
    NSString *title=nil;
    if(item.status==1)
    {
        title=[[NSString alloc] initWithFormat:@"￥%@",item.price] ;
    }else
    {
        title=item.status==0?@"未上架":item.status==2?@"已下架":item.status==3?@"已删除":item.status==-1?@"已售罄":@"";
    }
    UILabel *price_label=[UILabel getLabelWithAlignment:0 WithTitle:title WithFont:15.0f WithTextColor:nil WithSpacing:0];
    [cell addSubview:price_label];
    price_label.font=[regular getSemiboldFont:15.0f];
    [price_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(-2);
    }];

    if(item.status==1)
    {
        if([item.price integerValue]!=[item.originalPrice integerValue])
        {
            UILabel *original_label=[UILabel getLabelWithAlignment:0 WithTitle:[[NSString alloc] initWithFormat:@"￥%@",item.originalPrice] WithFont:15.0f WithTextColor:_define_light_gray_color1 WithSpacing:0];
            [cell addSubview:original_label];
            [original_label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(price_label.mas_right).with.offset(5);
                make.centerY.mas_equalTo(price_label);
            }];
            
            UIView *middleLine=[UIView getCustomViewWithColor:_define_light_gray_color1];
            [original_label addSubview:middleLine];
            [middleLine mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(original_label);
                make.left.right.mas_equalTo(0);
                make.height.mas_equalTo(1);
            }];
        }
    }
    
    UILabel *titleLabel=[UILabel getLabelWithAlignment:0 WithTitle:@"" WithFont:13.0f WithTextColor:nil WithSpacing:0];
    [cell addSubview:titleLabel];
    if(item.cooperateTag==1)
    {
        titleLabel.text=[[NSString alloc] initWithFormat:@"合作款 | %@",item.name];
    }else
    {
        titleLabel.text=item.name;
    }
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
     * public static Integer ITEM_STATUS_YSC = -1; //已售罄
     */
    NSString *title=nil;
    if(item.status==1)
    {
        title=[[NSString alloc] initWithFormat:@"￥%@",item.price] ;
    }else
    {
        title=item.status==0?@"未上架":item.status==2?@"已下架":item.status==3?@"已删除":item.status==-1?@"已售罄":@"";
    }
    
    UILabel *price_label=[UILabel getLabelWithAlignment:0 WithTitle:title WithFont:15.0f WithTextColor:nil WithSpacing:0];
    [cell addSubview:price_label];
    price_label.font=[regular getSemiboldFont:15.0f];
    [price_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(-2);
    }];

    if(item.status==1)
    {
        if([item.price integerValue]!=[item.originalPrice integerValue])
        {
            UILabel *original_label=[UILabel getLabelWithAlignment:0 WithTitle:[[NSString alloc] initWithFormat:@"￥%@",item.originalPrice] WithFont:15.0f WithTextColor:_define_light_gray_color1 WithSpacing:0];
            [cell addSubview:original_label];
            [original_label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(price_label.mas_right).with.offset(5);
                make.centerY.mas_equalTo(price_label);
            }];
            
            UIView *middleLine=[UIView getCustomViewWithColor:_define_light_gray_color1];
            [original_label addSubview:middleLine];
            [middleLine mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(original_label);
                make.left.right.mas_equalTo(0);
                make.height.mas_equalTo(1);
            }];
        }
    }
    
    
    UILabel *titleLabel=[UILabel getLabelWithAlignment:0 WithTitle:@"" WithFont:13.0f WithTextColor:nil WithSpacing:0];
    [cell addSubview:titleLabel];
    if(item.cooperateTag==1)
    {
        titleLabel.text=[[NSString alloc] initWithFormat:@"合作款 | %@",item.name];
    }else
    {
        titleLabel.text=item.name;
    }
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(price_label.mas_top).with.offset(-4);
        make.left.right.mas_equalTo(0);
    }];

    return cell;
}


@end
