//
//  DD_ItemCell.m
//  DDAY
//
//  Created by yyj on 16/5/22.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_ItemCell.h"

#import "DD_ImageModel.h"

@implementation DD_ItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setItem:(DD_ItemsModel *)item
{
    _price_label.text=[[NSString alloc] initWithFormat:@"￥%@",item.price];
    _name_label.text=item.name;
    if(item.pics&&item.pics.count)
    {
        DD_ImageModel *imgModel=[item.pics objectAtIndex:0];
        [_item_img JX_ScaleAspectFit_loadImageUrlStr:imgModel.pic WithSize:200 placeHolderImageName:nil radius:CGRectGetWidth(_item_img.frame)/2.0f];
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
