//
//  DD_ClearingTableViewCell.m
//  DDAY
//
//  Created by yyj on 16/5/18.
//  Copyright © 2016年 mike_xie. All rights reserved.
//

#import "DD_ClearingTableViewCell.h"

#import "DD_ClearingOrderModel.h"

@implementation DD_ClearingTableViewCell
{
    UIImageView *itemImg;//图片
    
    UILabel *itemNameLabel;//商品描述
    UILabel *priceLabel;//商品价格
    
    UIView *colorView;//商品颜色
    
    UIButton *sizeNameBtn;//商品尺寸按钮
    UIButton *numBtn;//商品数量按钮
}

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}
#pragma mark - 初始化
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier IsOrderDetail:(BOOL )isOrderDetail WithBlock:(void(^)(NSString *type))block
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        _clickblock=block;
        _isOrderDetail=isOrderDetail;
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
    
    //    款式照片
    itemImg=[UIImageView getCustomImg];
    [self.contentView addSubview:itemImg];
    itemImg.contentMode=2;
    [regular setZeroBorder:itemImg];
    [itemImg mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(imageBack).with.insets(UIEdgeInsetsMake(7.5, 7.5, 7.5, 7.5));
        make.centerY.mas_equalTo(self.contentView);
        make.left.mas_equalTo(kEdge);
        make.height.width.mas_equalTo(90);
    }];
    
    //    款式信息
    itemNameLabel=[UILabel getLabelWithAlignment:0 WithTitle:@"" WithFont:13 WithTextColor:nil WithSpacing:0];
    [self.contentView addSubview:itemNameLabel];
//    [itemNameLabel sizeToFit];
    [itemNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(itemImg.mas_right).with.offset(17);
        make.top.mas_equalTo(itemImg);
        make.right.mas_equalTo(-kEdge);
    }];
    
    priceLabel=[UILabel getLabelWithAlignment:0 WithTitle:@"" WithFont:13 WithTextColor:nil WithSpacing:0];
    [self.contentView addSubview:priceLabel];
//    [priceLabel sizeToFit];
    priceLabel.font=[regular getSemiboldFont:13.0f];
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(itemNameLabel.mas_bottom).with.offset(8);
        make.left.mas_equalTo(itemNameLabel);
        make.right.mas_equalTo(itemNameLabel);
    }];
    
    
    colorView=[UIView getCustomViewWithColor:nil];
    [self.contentView addSubview:colorView];
    [colorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(priceLabel.mas_bottom).with.offset(8);
        make.left.mas_equalTo(itemNameLabel);
        make.width.mas_equalTo(32);
        make.height.mas_equalTo(9);
    }];
    
    sizeNameBtn=[UIButton getCustomTitleBtnWithAlignment:1 WithFont:13 WithSpacing:0 WithNormalTitle:@"" WithNormalColor:nil WithSelectedTitle:@"" WithSelectedColor:nil];
    [self.contentView addSubview:sizeNameBtn];
    
    CGFloat _height = [regular getHeightWithContent:@"今天" WithWidth:80 WithFont:13.0f];
    [sizeNameBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(_height);
        make.width.mas_equalTo(80);
        make.left.mas_equalTo(itemNameLabel);
        make.bottom.mas_equalTo(itemImg.mas_bottom);
    }];
    [sizeNameBtn setEnlargeEdge:20];
    
    numBtn=[UIButton getCustomTitleBtnWithAlignment:2 WithFont:13 WithSpacing:0 WithNormalTitle:@"" WithNormalColor:nil WithSelectedTitle:@"" WithSelectedColor:nil];
    [self.contentView addSubview:numBtn];
    [numBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(24);
        make.width.mas_equalTo(80);
        make.bottom.mas_equalTo(itemImg);
        make.right.mas_equalTo(-kEdge);
    }];
    [numBtn setEnlargeEdge:20];
}
#pragma mark - Setter Model
-(void)setClearingModel:(DD_ClearingOrderModel *)ClearingModel
{
    _ClearingModel=ClearingModel;
    if(ClearingModel.pic)
    {
        [itemImg JX_ScaleAspectFill_loadImageUrlStr:ClearingModel.pic WithSize:800 placeHolderImageName:nil radius:0];
    }
    
    colorView.backgroundColor=[UIColor colorWithHexString:ClearingModel.colorCode];
    itemNameLabel.text=ClearingModel.itemName;
//    typeLabel.text=ClearingModel.categoryName;
    
    [sizeNameBtn setTitle:ClearingModel.sizeName forState:UIControlStateNormal];
    [numBtn setTitle:[[NSString alloc] initWithFormat:@"×%@",ClearingModel.numbers] forState:UIControlStateNormal];
    
    if(_isOrderDetail)
    {
        priceLabel.text=[[NSString alloc] initWithFormat:@"￥%@",ClearingModel.price];
    }else
    {
        if(ClearingModel.saleEndTime>[NSDate nowTime])
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
}

#pragma mark - Other
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
