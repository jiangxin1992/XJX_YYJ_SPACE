//
//  DD_ClearingTableViewCell.m
//  DDAY
//
//  Created by yyj on 16/5/18.
//  Copyright © 2016年 mike_xie. All rights reserved.
//

#import "DD_ClearingTableViewCell.h"

@implementation DD_ClearingTableViewCell
{
    UIImageView *itemImg;//图片
    
    UILabel *itemNameLabel;//商品描述
    UILabel *typeLabel;//商品类型
    UILabel *priceLabel;//商品价格
    
    UIView *colorView;//商品颜色
    
    UIButton *sizeNameBtn;//商品尺寸按钮
    UIButton *numBtn;//商品数量按钮
}

- (void)awakeFromNib {
    // Initialization code
}
#pragma mark - 初始化
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier WithBlock:(void(^)(NSString *type))block
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        _clickblock=block;
        [self SomePrepare];
        [self UIConfig];
    }
    return self;
}

#pragma mark - SomePrepare
-(void)SomePrepare
{
    [self PrepareData];
    [self PrepareUI];
}
-(void)PrepareData{}
-(void)PrepareUI
{
    self.contentView.backgroundColor=_define_white_color;
}
#pragma mark - UIConfig
-(void)UIConfig
{
    UIView *imageBack=[UIView getCustomViewWithColor:_define_white_color];
    [self.contentView addSubview:imageBack];
    [imageBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.left.mas_equalTo(26);
        make.height.width.mas_equalTo(123);
    }];
    [regular setBorder:imageBack];
    
    //    款式照片
    itemImg=[UIImageView getCustomImg];
    [imageBack addSubview:itemImg];
    [itemImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(imageBack).with.insets(UIEdgeInsetsMake(7.5, 7.5, 7.5, 7.5));
    }];
    
    //    款式信息
    itemNameLabel=[UILabel getLabelWithAlignment:0 WithTitle:@"" WithFont:12.0f WithTextColor:nil WithSpacing:0];
    [self.contentView addSubview:itemNameLabel];
    [itemNameLabel sizeToFit];
    [itemNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(imageBack.mas_right).with.offset(15);
        make.top.mas_equalTo(17);
        make.right.mas_equalTo(-26);
    }];
    
    typeLabel=[UILabel getLabelWithAlignment:0 WithTitle:@"" WithFont:12.0f WithTextColor:nil WithSpacing:0];
    [self.contentView addSubview:typeLabel];
    [typeLabel sizeToFit];
    [typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(itemNameLabel.mas_bottom).with.offset(0);
        make.left.mas_equalTo(itemNameLabel);
        make.right.mas_equalTo(itemNameLabel);
    }];
    
    priceLabel=[UILabel getLabelWithAlignment:0 WithTitle:@"" WithFont:12.0f WithTextColor:_define_light_red_color WithSpacing:0];
    [self.contentView addSubview:priceLabel];
    [priceLabel sizeToFit];
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(typeLabel.mas_bottom).with.offset(15);
        make.left.mas_equalTo(itemNameLabel);
        make.right.mas_equalTo(itemNameLabel);
    }];
    
    
    colorView=[UIView getCustomViewWithColor:nil];
    [self.contentView addSubview:colorView];
    [colorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(priceLabel.mas_bottom).with.offset(11);
        make.left.mas_equalTo(itemNameLabel);
        make.width.mas_equalTo(32);
        make.height.mas_equalTo(9);
    }];
    
    sizeNameBtn=[UIButton getCustomTitleBtnWithAlignment:1 WithFont:12.0f WithSpacing:0 WithNormalTitle:@"" WithNormalColor:nil WithSelectedTitle:@"" WithSelectedColor:nil];
    [self.contentView addSubview:sizeNameBtn];

    [sizeNameBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(24);
        make.width.mas_equalTo(80);
        make.bottom.mas_equalTo(imageBack);
        make.left.mas_equalTo(itemNameLabel);
    }];
    [sizeNameBtn setEnlargeEdge:20];
    
    numBtn=[UIButton getCustomTitleBtnWithAlignment:2 WithFont:12.0f WithSpacing:0 WithNormalTitle:@"" WithNormalColor:nil WithSelectedTitle:@"" WithSelectedColor:nil];
    [self.contentView addSubview:numBtn];
    [numBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(24);
        make.width.mas_equalTo(80);
        make.bottom.mas_equalTo(imageBack);
        make.right.mas_equalTo(-26);
    }];
    [numBtn setEnlargeEdge:20];
}
#pragma mark - Setter Model
-(void)setClearingModel:(DD_ClearingOrderModel *)ClearingModel
{
    _ClearingModel=ClearingModel;
    if(ClearingModel.pic)
    {
        [itemImg JX_loadImageUrlStr:ClearingModel.pic WithSize:800 placeHolderImageName:nil radius:0];
    }
    colorView.backgroundColor=[UIColor colorWithHexString:ClearingModel.colorCode];
    itemNameLabel.text=ClearingModel.itemName;
    typeLabel.text=ClearingModel.categoryName;
    
    [sizeNameBtn setTitle:ClearingModel.sizeName forState:UIControlStateNormal];
    [numBtn setTitle:[[NSString alloc] initWithFormat:@"×%@",ClearingModel.numbers] forState:UIControlStateNormal];
    
    if(ClearingModel.saleEndTime>[regular date])
    {
        priceLabel.text=[[NSString alloc] initWithFormat:@"￥%@ 原价￥%@",ClearingModel.price,ClearingModel.originalPrice];
    }else
    {
        if(ClearingModel.discountEnable)
        {
            priceLabel.text=[[NSString alloc] initWithFormat:@"￥%@ 原价￥%@",ClearingModel.price,ClearingModel.originalPrice];
            
        }else
        {
            priceLabel.text=[[NSString alloc] initWithFormat:@"￥%@",ClearingModel.originalPrice];
        }
        
    }

}

#pragma mark - Other
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
