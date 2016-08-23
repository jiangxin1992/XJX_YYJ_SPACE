//
//  DD_OrderCell.m
//  DDAY
//
//  Created by yyj on 16/6/6.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_OrderCell.h"

#import "DD_CustomBtn.h"

@implementation DD_OrderCell
{
    UIImageView *_itemImg;//图片
    
    UILabel *_itemNameLabel;//商品描述
    UILabel *_priceLabel;//商品价格
    
    UIView *_colorView;//商品颜色
    
    UIButton *_sizeNameBtn;//商品尺寸按钮
    UIButton *_numBtn;//商品数量按钮
    
    UILabel *_goodNumLabel;//商品数量
    UILabel *_totalPriceLabel;//总计
    
    DD_CustomBtn *_leftBtn;
    DD_CustomBtn *_rightBtn;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier WithBlock:(void(^)(NSString *type,NSIndexPath *indexPath))block
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        _cellblock=block;
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
        make.top.mas_equalTo(15);
        make.left.mas_equalTo(kEdge);
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
        make.right.mas_equalTo(-kEdge);
        make.top.mas_equalTo(17);
    }];
    [_itemNameLabel sizeToFit];
    
    _sizeNameBtn=[UIButton getCustomTitleBtnWithAlignment:1 WithFont:12.0f WithSpacing:0 WithNormalTitle:@"" WithNormalColor:nil WithSelectedTitle:@"" WithSelectedColor:nil];
    [self.contentView addSubview:_sizeNameBtn];
    _sizeNameBtn.userInteractionEnabled=NO;
    [_sizeNameBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(24);
        make.width.mas_equalTo(80);
        make.bottom.mas_equalTo(imageBack);
        make.left.mas_equalTo(_itemNameLabel);
    }];
    [_sizeNameBtn setEnlargeEdge:20];
    
    _numBtn=[UIButton getCustomTitleBtnWithAlignment:2 WithFont:12.0f WithSpacing:0 WithNormalTitle:@"" WithNormalColor:nil WithSelectedTitle:@"" WithSelectedColor:nil];
    [self.contentView addSubview:_numBtn];
    _numBtn.userInteractionEnabled=NO;
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
        make.bottom.mas_equalTo(_sizeNameBtn.mas_top).with.offset(-9);
        make.left.mas_equalTo(_itemNameLabel);
        make.width.mas_equalTo(32);
        make.height.mas_equalTo(9);
    }];
    
    _priceLabel=[UILabel getLabelWithAlignment:0 WithTitle:@"" WithFont:12.0f WithTextColor:_define_light_red_color WithSpacing:0];
    [self.contentView addSubview:_priceLabel];
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_colorView.mas_top).with.offset(-11);
        make.left.mas_equalTo(_itemNameLabel);
    }];
    [_priceLabel sizeToFit];
    
    UIView *downLine=[UIView getCustomViewWithColor:_define_black_color];
    [self.contentView addSubview:downLine];
    [downLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(imageBack.mas_bottom).with.offset(9);
        make.left.mas_equalTo(kEdge);
        make.right.mas_equalTo(-kEdge);
        make.height.mas_equalTo(1);
    }];
    
    _totalPriceLabel=[UILabel getLabelWithAlignment:2 WithTitle:@"" WithFont:12.0f WithTextColor:nil WithSpacing:0];
    [self.contentView addSubview:_totalPriceLabel];
    [_totalPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-kEdge);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(30);
        make.top.mas_equalTo(downLine.mas_bottom).with.offset(0);
    }];
    
    _goodNumLabel=[UILabel getLabelWithAlignment:2 WithTitle:@"" WithFont:12.0f WithTextColor:nil WithSpacing:0];
    [self.contentView addSubview:_goodNumLabel];
    [_goodNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_totalPriceLabel.mas_left).with.offset(0);
        make.width.mas_equalTo(_totalPriceLabel);
        make.height.mas_equalTo(_totalPriceLabel);
        make.top.mas_equalTo(_totalPriceLabel);
    }];
    
    _rightBtn=[DD_CustomBtn getCustomTitleBtnWithAlignment:0 WithFont:15.0f WithSpacing:0 WithNormalTitle:nil WithNormalColor:_define_white_color WithSelectedTitle:nil WithSelectedColor:nil];
    [self.contentView addSubview:_rightBtn];
    _rightBtn.backgroundColor=_define_black_color;
    [_rightBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-kEdge);
        make.top.mas_equalTo(_goodNumLabel.mas_bottom).with.offset(0);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(35);
    }];
    
    _leftBtn=[DD_CustomBtn getCustomTitleBtnWithAlignment:0 WithFont:15.0f WithSpacing:0 WithNormalTitle:nil WithNormalColor:_define_white_color WithSelectedTitle:nil WithSelectedColor:nil];
    [self.contentView addSubview:_leftBtn];
    _leftBtn.backgroundColor=_define_black_color;
    [_leftBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_rightBtn.mas_left).with.offset(-15);
        make.top.mas_equalTo(_rightBtn);
        make.width.mas_equalTo(_rightBtn);
        make.height.mas_equalTo(_rightBtn);
    }];  
}
#pragma mark - Setter
-(void)setOrderModel:(DD_OrderModel *)OrderModel
{
    _OrderModel=OrderModel;
    
    if(_OrderModel.itemList.count)
    {
        DD_OrderItemModel *_itemModel=[_OrderModel.itemList objectAtIndex:0];
        [_itemImg JX_loadImageUrlStr:_itemModel.pic WithSize:800 placeHolderImageName:nil radius:0];
        _colorView.backgroundColor=[UIColor colorWithHexString:_itemModel.colorCode];
        _itemNameLabel.text=_itemModel.itemName;
        [_sizeNameBtn setTitle:_itemModel.sizeName forState:UIControlStateNormal];
        [_numBtn setTitle:[[NSString alloc] initWithFormat:@"×%ld",_itemModel.itemCount] forState:UIControlStateNormal];
        
        if([_itemModel.price floatValue]<[_itemModel.originalPrice floatValue])
        {
            _priceLabel.text=[[NSString alloc] initWithFormat:@"￥%@ 原价￥%@",_itemModel.price,_itemModel.originalPrice];
        }else
        {
            _priceLabel.text=[[NSString alloc] initWithFormat:@"￥%@",_itemModel.price];
        }

        _goodNumLabel.text=[[NSString alloc] initWithFormat:@"共%ld件商品",_OrderModel.itemList.count];
        _totalPriceLabel.text=[[NSString alloc] initWithFormat:@"总计￥%.1lf",[_OrderModel.totalAmount floatValue]+_OrderModel.allFreight];
        
        if(_OrderModel.orderStatus==0)
        {
            //待付款
            _leftBtn.hidden=NO;
            _rightBtn.hidden=NO;
            [_leftBtn setTitle:@"去支付" forState:UIControlStateNormal];
            _leftBtn.type=@"pay";
            [_rightBtn setTitle:@"取消订单" forState:UIControlStateNormal];
            _rightBtn.type=@"cancel";
        }else if(_OrderModel.orderStatus==1||_OrderModel.orderStatus==4||_OrderModel.orderStatus==5)
        {
            //待发货 //申请退款 //退款处理中
            _leftBtn.hidden=YES;
            _leftBtn.type=@"";
            _rightBtn.hidden=NO;
            [_rightBtn setTitle:@"查看物流" forState:UIControlStateNormal];
            _rightBtn.type=@"logistics";
        }else if(_OrderModel.orderStatus==2)
        {
            //待收货
            _leftBtn.hidden=NO;
            _rightBtn.hidden=NO;
            [_leftBtn setTitle:@"确认收货" forState:UIControlStateNormal];
            _leftBtn.type=@"confirm";
            [_rightBtn setTitle:@"查看物流" forState:UIControlStateNormal];
            _rightBtn.type=@"logistics";
        }else if(_OrderModel.orderStatus==3||_OrderModel.orderStatus==6||_OrderModel.orderStatus==7)
        {
            //交易成功 //已退款 //拒绝退款
            _leftBtn.hidden=NO;
            _rightBtn.hidden=NO;
            [_leftBtn setTitle:@"删除订单" forState:UIControlStateNormal];
            _leftBtn.type=@"delect";
            [_rightBtn setTitle:@"查看物流" forState:UIControlStateNormal];
            _rightBtn.type=@"logistics";
        }
        
    }
    
}

#pragma mark - SomeAction
-(void)btnAction:(DD_CustomBtn *)btn
{
    if([btn.type isEqualToString:@"cancel"])
    {
        //取消订单
        _cellblock(btn.type,_indexPath);
    }else if([btn.type isEqualToString:@"confirm"])
    {
        //确认收货
        _cellblock(btn.type,_indexPath);
    }else if([btn.type isEqualToString:@"delect"])
    {
        //删除订单
        _cellblock(btn.type,_indexPath);
    }else if([btn.type isEqualToString:@"pay"])
    {
        //支付
        _cellblock(btn.type,_indexPath);
    }else if([btn.type isEqualToString:@"logistics"])
    {
        //查看物流
        _cellblock(btn.type,_indexPath);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
