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

-(instancetype)initWithFrame:(CGRect)frame WithOrderModel:(DD_OrderModel *)orderModel
{
    self=[super initWithFrame:frame];
    if(self)
    {
        _orderModel=orderModel;
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
    self.backgroundColor = [UIColor clearColor];
    UIView *backview=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 38)];
    [self addSubview:backview];
    backview.backgroundColor=[UIColor whiteColor];
    
    orderIDLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, 38)];
    [backview addSubview:orderIDLabel];
    orderIDLabel.textAlignment=0;
    
    orderIDLabel.textColor=[UIColor blackColor];
    orderIDLabel.font=[regular getFont:13.0f];
    
    stateLabel=[[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-110, 0, 100, 38)];
    [backview addSubview:stateLabel];
    stateLabel.textAlignment=2;
    stateLabel.textColor=[UIColor blackColor];
    stateLabel.font=[regular getFont:13.0f];
    
}
#pragma mark - SetState
-(void)SetState
{
    if(_orderModel.isPay)
    {
        orderIDLabel.text=[[NSString alloc] initWithFormat:@"子订单号:%@",_orderModel.subOrderCode];
    }else
    {
        orderIDLabel.text=[[NSString alloc] initWithFormat:@"订单号:%@",_orderModel.tradeOrderCode];
    }
    
    if(_orderModel.itemList.count)
    {
        if(_orderModel.orderStatus==0)
        {
            //待付款
            stateLabel.text=@"待付款";
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
            stateLabel.text=@"交易成功";
        }else if(_orderModel.orderStatus==4)
        {
            //申请退款
            stateLabel.text=@"申请退款";
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
        }
    }
}
@end
