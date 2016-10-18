//
//  DD_OrderMoreCell.m
//  DDAY
//
//  Created by yyj on 16/6/6.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_OrderMoreCell.h"

#import "DD_CustomBtn.h"

@interface DD_OrderMoreCell()<UIScrollViewDelegate>

@end

@implementation DD_OrderMoreCell
{
    UIScrollView *_scrollview;
    UILabel *_goodNumLabel;//商品数量
    UILabel *_totalPriceLabel;//总计
    
    DD_CustomBtn *_leftBtn;
    DD_CustomBtn *_rightBtn;
    NSMutableArray *itemArr;
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
-(void)PrepareData{
    itemArr=[[NSMutableArray alloc] init];
}
-(void)PrepareUI
{
    self.contentView.backgroundColor=_define_white_color;
}
#pragma mark - UIConfig
-(void)UIConfig
{
    
    _scrollview=[[UIScrollView alloc] initWithFrame:CGRectMake(kEdge, 0, ScreenWidth-2*kEdge, 130)];
    [self.contentView addSubview:_scrollview];
    _scrollview.alwaysBounceHorizontal=YES;
    _scrollview.alwaysBounceVertical=NO;
    _scrollview.showsHorizontalScrollIndicator=NO;
    _scrollview.scrollEnabled=YES;
    [_scrollview addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickAction)]];
    
    
    UIView *downLine=[UIView getCustomViewWithColor:_define_black_color];
    [self.contentView addSubview:downLine];
    [downLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(130);
        make.left.mas_equalTo(kEdge);
        make.right.mas_equalTo(-kEdge);
        make.height.mas_equalTo(1);
    }];
    
    _totalPriceLabel=[UILabel getLabelWithAlignment:2 WithTitle:@"" WithFont:15.0f WithTextColor:nil WithSpacing:0];
    [self.contentView addSubview:_totalPriceLabel];
    [_totalPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-kEdge);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(40);
        make.top.mas_equalTo(downLine.mas_bottom).with.offset(0);
    }];
    
    _goodNumLabel=[UILabel getLabelWithAlignment:2 WithTitle:@"" WithFont:15.0f WithTextColor:nil WithSpacing:0];
    [self.contentView addSubview:_goodNumLabel];
    [_goodNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_totalPriceLabel.mas_left).with.offset(-15);
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
        _goodNumLabel.text=[[NSString alloc] initWithFormat:@"共%ld件商品",_OrderModel.itemList.count];
        _totalPriceLabel.text=[[NSString alloc] initWithFormat:@"总计￥%.1lf",[_OrderModel.totalAmount floatValue]+_OrderModel.allFreight];
        UIView *lastView=nil;
        for (int i=0; i<_OrderModel.itemList.count; i++) {
            DD_OrderItemModel *_itemModel=[_OrderModel.itemList objectAtIndex:i];
            //    款式照片
            UIImageView *_itemImg=[UIImageView getCustomImg];
            [_scrollview addSubview:_itemImg];
            _itemImg.contentMode=2;
            [regular setZeroBorder:_itemImg];
            _itemImg.userInteractionEnabled=NO;
            _itemImg.frame=CGRectMake(i*(15+90), 20, 90, 90);
            [_itemImg JX_ScaleAspectFill_loadImageUrlStr:_itemModel.pic WithSize:400 placeHolderImageName:nil radius:0];
            lastView=_itemImg;
            [itemArr addObject:_itemImg];
        }
        NSInteger _count=_OrderModel.itemList.count;
        CGFloat __w=90*_count+15*(_count-1);
        _scrollview.contentSize=CGSizeMake(__w, 130);
        
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
-(void)clickAction
{
    _cellblock(@"click",_indexPath);
}
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
