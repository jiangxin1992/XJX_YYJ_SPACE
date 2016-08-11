//
//  DD_ShopCell.m
//  DDAY
//
//  Created by yyj on 16/5/27.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_ShopCell.h"

@implementation DD_ShopCell
{
    UIButton *selectBtn;//选中
    UIImageView *_itemImg;//图片
    
    UILabel *_itemNameLabel;//商品描述

    UILabel *_priceLabel;//商品价格
    
    UIView *_colorView;//商品颜色
    
    UIButton *_sizeNameBtn;//商品尺寸按钮
    UIButton *_numBtn;//商品数量按钮
}

- (void)awakeFromNib {
    [super awakeFromNib];
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier WithBlock:(void(^)(NSString *type,NSIndexPath *indexPath))block
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
    
    selectBtn=[UIButton getCustomImgBtnWithImageStr:@"System_nocheck" WithSelectedImageStr:@"System_check"];
    [self.contentView addSubview:selectBtn];
    [selectBtn addTarget:self action:@selector(chooseAction) forControlEvents:UIControlEventTouchUpInside];
    [selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(15);
        make.centerY.mas_equalTo(self.contentView);
        make.left.mas_equalTo(kEdge);
    }];
    [selectBtn setEnlargeEdge:20];
    
    UIView *imageBack=[UIView getCustomViewWithColor:_define_white_color];
    [self.contentView addSubview:imageBack];
    [imageBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.left.mas_equalTo(selectBtn.mas_right).with.offset(16);
        make.height.width.mas_equalTo(123);
    }];
    [regular setBorder:imageBack];
    
    //    款式照片
    _itemImg=[UIImageView getCustomImg];
    [imageBack addSubview:_itemImg];
    [_itemImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(imageBack).with.insets(UIEdgeInsetsMake(7.5, 7.5, 7.5, 7.5));
    }];
    
    //    款式信息
    _itemNameLabel=[UILabel getLabelWithAlignment:0 WithTitle:@"" WithFont:12.0f WithTextColor:nil WithSpacing:0];
    [self.contentView addSubview:_itemNameLabel];
    _itemNameLabel.numberOfLines=2;
    [_itemNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(imageBack.mas_right).with.offset(15);
        make.top.mas_equalTo(17);
        make.right.mas_equalTo(-kEdge);
        //        make.right.mas_equalTo(-kEdge);
    }];
    [_itemNameLabel sizeToFit];
    
    _sizeNameBtn=[UIButton getCustomTitleBtnWithAlignment:1 WithFont:12.0f WithSpacing:0 WithNormalTitle:@"" WithNormalColor:nil WithSelectedTitle:@"" WithSelectedColor:nil];
    [self.contentView addSubview:_sizeNameBtn];
    [_sizeNameBtn addTarget:self action:@selector(sizeAction) forControlEvents:UIControlEventTouchUpInside];
    [_sizeNameBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(24);
        make.width.mas_equalTo(80);
        make.bottom.mas_equalTo(imageBack);
        make.left.mas_equalTo(_itemNameLabel);
    }];
    [_sizeNameBtn setEnlargeEdge:20];
    
    _numBtn=[UIButton getCustomTitleBtnWithAlignment:2 WithFont:12.0f WithSpacing:0 WithNormalTitle:@"" WithNormalColor:nil WithSelectedTitle:@"" WithSelectedColor:nil];
    [self.contentView addSubview:_numBtn];
    [_numBtn addTarget:self action:@selector(numAction) forControlEvents:UIControlEventTouchUpInside];
    [_numBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(24);
        make.width.mas_equalTo(80);
        make.bottom.mas_equalTo(imageBack);
        make.right.mas_equalTo(-kEdge);
    }];
    [_numBtn setEnlargeEdge:20];
    
    _colorView=[UIView getCustomViewWithColor:nil];
    [self.contentView addSubview:_colorView];
    [_colorView mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.top.mas_equalTo(_priceLabel.mas_bottom).with.offset(11);
        make.bottom.mas_equalTo(_sizeNameBtn.mas_top).with.offset(-9);
        make.left.mas_equalTo(_itemNameLabel);
        make.width.mas_equalTo(32);
        make.height.mas_equalTo(9);
    }];
    
    
    _priceLabel=[UILabel getLabelWithAlignment:0 WithTitle:@"" WithFont:12.0f WithTextColor:_define_light_red_color WithSpacing:0];
    [self.contentView addSubview:_priceLabel];
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.top.mas_equalTo(_typeLabel.mas_bottom).with.offset(15);
        make.bottom.mas_equalTo(_colorView.mas_top).with.offset(-11);
        make.left.mas_equalTo(_itemNameLabel);
        //        make.right.mas_equalTo(_itemNameLabel);
    }];
    [_priceLabel sizeToFit];
    
    //    失效
    if(_isInvalid)
    {
        
        UIImageView *invalidImg=[UIImageView getImgWithImageStr:@"System_Mask"];
        [self.contentView addSubview:invalidImg];
        [invalidImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.mas_equalTo(0);
        }];
        
        UILabel *invalidLabel=[UILabel getLabelWithAlignment:1 WithTitle:@"失效" WithFont:15.0f WithTextColor:_define_white_color WithSpacing:0];
        [invalidImg addSubview:invalidLabel];
        invalidLabel.backgroundColor=_define_black_color;
        [invalidLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(50);
            make.height.mas_equalTo(20);
            make.left.mas_equalTo(57);
            make.top.mas_equalTo(10);
        }];
    }
}
#pragma mark - Setter
-(void)setItemModel:(DD_ShopItemModel *)ItemModel
{
    _ItemModel=ItemModel;
    
    selectBtn.selected=ItemModel.is_select;
    
    if(ItemModel.pics.count)
    {
        [_itemImg JX_loadImageUrlStr:[ItemModel.pics objectAtIndex:0] WithSize:800 placeHolderImageName:nil radius:0];
    }
    _colorView.backgroundColor=[UIColor colorWithHexString:_ItemModel.colorCode];
    _itemNameLabel.text=ItemModel.itemName;
    
    [_sizeNameBtn setTitle:ItemModel.sizeName forState:UIControlStateNormal];
    [_numBtn setTitle:[[NSString alloc] initWithFormat:@"×%@",ItemModel.number] forState:UIControlStateNormal];
    
    if(ItemModel.saleEndTime>[regular date])
    {
        _priceLabel.text=[[NSString alloc] initWithFormat:@"￥%@ 原价￥%@",ItemModel.price,ItemModel.originalPrice];
    }else
    {
        if(ItemModel.discountEnable)
        {
            _priceLabel.text=[[NSString alloc] initWithFormat:@"￥%@ 原价￥%@",ItemModel.price,ItemModel.originalPrice];
            
        }else
        {
            _priceLabel.text=[[NSString alloc] initWithFormat:@"￥%@",ItemModel.originalPrice];
        }
        
    }
    
}
#pragma mark - SomeAction
-(void)chooseAction
{
    if(!_isInvalid)
    {
        if(selectBtn.selected)
        {
            selectBtn.selected=NO;
            _clickblock(@"cancel",_indexPath);
        }else
        {
            selectBtn.selected=YES;
            _clickblock(@"select",_indexPath);
        }
    }
}
-(void)numAction
{
    _clickblock(@"num_alert",_indexPath);
}
-(void)sizeAction
{
    _clickblock(@"size_alert",_indexPath);
}
#pragma mark - Other
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
