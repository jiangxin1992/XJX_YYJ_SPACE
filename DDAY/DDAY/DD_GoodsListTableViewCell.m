//
//  DD_GoodsListTableViewCell.m
//  YCO SPACE
//
//  Created by yyj on 16/8/1.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_GoodsListTableViewCell.h"

@implementation DD_GoodsListTableViewCell
{
    UILabel *label;
}
#pragma mark - 初始化
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {

        [self UIConfig];
    }
    return  self;
}
#pragma mark - UIConfig
-(void)UIConfig
{
    UIView *view=[UIView getCustomViewWithColor:_define_black_color];
    [self.contentView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(5);
        make.left.mas_equalTo(26);
        make.height.mas_equalTo(self.contentView);
        make.centerY.mas_equalTo(self.contentView);
    }];
    
    label=[UILabel getLabelWithAlignment:0 WithTitle:@"" WithFont:12 WithTextColor:_define_light_gray_color1 WithSpacing:0];
    [self.contentView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(view.mas_right).with.offset(22);
        make.width.mas_equalTo(200);
        make.centerY.mas_equalTo(self.contentView);
        make.height.mas_equalTo(self.contentView);
    }];
}
-(void)setCategoryModel:(DD_GoodsCategorySubModel *)CategoryModel
{
    _CategoryModel=CategoryModel;
    label.text=CategoryModel.catTwoName;
}

@end
