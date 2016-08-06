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
    UIImageView *itemImg;//图片
    
    UILabel *itemNameLabel;//商品描述
    UILabel *typeLabel;//商品类型
    UILabel *priceLabel;//商品价格
    
    UIView *colorView;//商品颜色
    
    UIButton *sizeNameBtn;//商品尺寸按钮
    UIButton *numBtn;//商品数量按钮
}

- (void)awakeFromNib {
    [super awakeFromNib];
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellForRowAtIndexPath:(NSIndexPath *)indexPath WithIsInvalid:(BOOL)isInvalid WithBlock:(void(^)(NSString *type,NSIndexPath *indexPath))block
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        _isInvalid=isInvalid;
        _indexPath=indexPath;
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
        make.right.mas_equalTo(-kEdge);
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
    [sizeNameBtn addTarget:self action:@selector(sizeAction) forControlEvents:UIControlEventTouchUpInside];
    [sizeNameBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(24);
        make.width.mas_equalTo(80);
        make.bottom.mas_equalTo(imageBack);
        make.left.mas_equalTo(itemNameLabel);
    }];
    [sizeNameBtn setEnlargeEdge:20];
    
    numBtn=[UIButton getCustomTitleBtnWithAlignment:2 WithFont:12.0f WithSpacing:0 WithNormalTitle:@"" WithNormalColor:nil WithSelectedTitle:@"" WithSelectedColor:nil];
    [self.contentView addSubview:numBtn];
    [numBtn addTarget:self action:@selector(numAction) forControlEvents:UIControlEventTouchUpInside];
    [numBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(24);
        make.width.mas_equalTo(80);
        make.bottom.mas_equalTo(imageBack);
        make.right.mas_equalTo(-kEdge);
    }];
    [numBtn setEnlargeEdge:20];
    
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
        [itemImg JX_loadImageUrlStr:[ItemModel.pics objectAtIndex:0] WithSize:800 placeHolderImageName:nil radius:0];
    }
    colorView.backgroundColor=[UIColor colorWithHexString:_ItemModel.colorCode];
    itemNameLabel.text=ItemModel.itemName;
    typeLabel.text=ItemModel.categoryName;
    
    [sizeNameBtn setTitle:ItemModel.sizeName forState:UIControlStateNormal];
    [numBtn setTitle:[[NSString alloc] initWithFormat:@"×%@",ItemModel.number] forState:UIControlStateNormal];
    
    if(ItemModel.saleEndTime>[regular date])
    {
        priceLabel.text=[[NSString alloc] initWithFormat:@"￥%@ 原价￥%@",ItemModel.price,ItemModel.originalPrice];
    }else
    {
        if(ItemModel.discountEnable)
        {
            priceLabel.text=[[NSString alloc] initWithFormat:@"￥%@ 原价￥%@",ItemModel.price,ItemModel.originalPrice];
            
        }else
        {
            priceLabel.text=[[NSString alloc] initWithFormat:@"￥%@",ItemModel.originalPrice];
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
