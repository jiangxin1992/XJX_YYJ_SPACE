//
//  DD_OrderHeadView.m
//  DDAY
//
//  Created by yyj on 16/6/6.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_OrderHeadView.h"

@implementation DD_OrderHeadView
{
    UILabel *stateLabel;
    UILabel *orderIDLabel;
}

-(instancetype)initWithFrame:(CGRect)frame WithOrderModel:(DD_OrderModel *)orderModel WithSection:(NSInteger )Section WithBlock:(void(^)(NSString *type,NSInteger Section))block
{
    self=[super initWithFrame:frame];
    if(self)
    {
        _Section=Section;
        _orderModel=orderModel;
        _block=block;
        [self SomePrepare];
        [self UIConfig];
        [self SetState];
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
-(void)PrepareUI{}
#pragma mark - UIConfig
-(void)UIConfig{
    self.backgroundColor=_define_white_color;
    self.userInteractionEnabled=YES;
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickAction)]];
    
    UIView *leftLine=[UIView getCustomViewWithColor:_define_black_color];
    [self addSubview:leftLine];
    [leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kEdge);
        make.centerY.mas_equalTo(self);
        make.height.mas_equalTo(16);
        make.width.mas_equalTo(3);
    }];
    
    orderIDLabel=[UILabel getLabelWithAlignment:0 WithTitle:@"" WithFont:13.0f WithTextColor:nil WithSpacing:0];
    [self addSubview:orderIDLabel];
    [orderIDLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(leftLine.mas_right).with.offset(5);
        make.centerY.mas_equalTo(self);
    }];
    [orderIDLabel sizeToFit];

    
    stateLabel=[UILabel getLabelWithAlignment:2 WithTitle:@"" WithFont:13.0f WithTextColor:nil WithSpacing:0];
    [self addSubview:stateLabel];
    [stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-kEdge);
        make.centerY.mas_equalTo(self);
    }];
    [stateLabel sizeToFit];
    
    UIView *downLine=[UIView getCustomViewWithColor:_define_black_color];
    [self addSubview:downLine];
    [downLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self);
        make.height.mas_equalTo(1);
        make.left.mas_equalTo(kEdge);
        make.right.mas_equalTo(-kEdge);
    }];
    
}
-(void)clickAction
{
    _block(@"click",_Section);
}
#pragma mark - SetState
-(void)SetState
{
    if(_orderModel.isPay)
    {
        orderIDLabel.text=[[NSString alloc] initWithFormat:@"订单号 %@",_orderModel.subOrderCode];
    }else
    {
        orderIDLabel.text=[[NSString alloc] initWithFormat:@"订单号 %@",_orderModel.tradeOrderCode];
    }
    
    if(_orderModel.itemList.count)
    {
        if(_orderModel.orderStatus==0)
        {
            //待付款
            if(_orderModel.expire)
            {
                //已过期
                stateLabel.text=@"订单已取消";
            }else
            {
                //未过期
                stateLabel.text=@"待付款";
            }
        }else if(_orderModel.orderStatus==1)
        {
            //待发货
            stateLabel.text=@"待发货";
        }else if(_orderModel.orderStatus==2)
        {
            //待收货
            stateLabel.text=@"待收货";
        }else if(_orderModel.orderStatus==3)
        {
            //交易成功
            stateLabel.text=@"交易完成";
        }else if(_orderModel.orderStatus==4)
        {
            //申请退款
            stateLabel.text=@"退款申请中";
        }else if(_orderModel.orderStatus==5)
        {
            //退款处理中
            stateLabel.text=@"退款处理中";
        }else if(_orderModel.orderStatus==6)
        {
            //已退款
            stateLabel.text=@"已退款";
        }else if(_orderModel.orderStatus==7)
        {
            //拒绝退款
            stateLabel.text=@"拒绝退款";
        }else if(_orderModel.orderStatus==8)
        {
            //订单已取消
            stateLabel.text=@"订单已取消";
        }else if(_orderModel.orderStatus==8)
        {
            //订单已删除
            stateLabel.text=@"订单已删除";
        }else
        {
            stateLabel.text=@"";
        }
    }
}
@end
