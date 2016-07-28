//
//  DD_ItemTool.m
//  YCO SPACE
//
//  Created by yyj on 16/7/21.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_ItemTool.h"

@implementation DD_ItemTool
+(WaterflowCell *)getCustomWaterflowCell:(Waterflow *)waterflow cellAtIndex:(NSUInteger)index WithItemsModel:(DD_ItemsModel *)item WithHeight:(CGFloat )_height
{
    WaterflowCell *cell = [WaterflowCell waterflowCellWithWaterflow:waterflow];
    cell.backgroundColor=[UIColor colorWithHexString:_define_white_color];
    UIImageView *imageview=nil;
    if(item.pics&&item.pics.count)
    {
        DD_ImageModel *imgModel=[item.pics objectAtIndex:0];
        imageview=[[UIImageView alloc] init];
        [cell addSubview:imageview];
        [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(index%2?0:10);
            make.right.mas_equalTo(index%2?-10:0);
            make.top.mas_equalTo(0);
            make.height.mas_equalTo(_height);
        }];
        [imageview JX_loadImageUrlStr:imgModel.pic WithSize:800 placeHolderImageName:nil radius:0];
    }
    
    UIView *whiteWire=[UIView getCustomViewWithColor:_define_white_color];
    [imageview addSubview:whiteWire];
    [whiteWire mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.mas_equalTo(0);
        make.width.mas_equalTo(1);
        make.right.mas_equalTo(imageview.mas_right).with.offset(-9);
    }];
    
    UILabel *name_label=[UILabel getLabelWithAlignment:0 WithTitle:item.name WithFont:15.0f WithTextColor:nil WithSpacing:0];
    [cell addSubview:name_label];
    
    [name_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(index%2?0:10);
        make.right.mas_equalTo(index%2?-10:0);
        if(imageview){
            make.top.mas_equalTo(imageview.mas_bottom).with.offset(7);
        }else
        {
            make.top.mas_equalTo(0);
        }
        make.height.mas_equalTo(25);
    }];
    
    UILabel *price_label=[UILabel getLabelWithAlignment:0 WithTitle:[[NSString alloc] initWithFormat:@"￥%@",item.price] WithFont:15.0f WithTextColor:_define_light_red_color WithSpacing:0];
    [cell addSubview:price_label];
    [price_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(index%2?0:10);
        make.right.mas_equalTo(index%2?-10:0);
        make.top.mas_equalTo(name_label.mas_bottom).with.offset(3);
        make.height.mas_equalTo(name_label);
    }];
    return cell;
}
@end
