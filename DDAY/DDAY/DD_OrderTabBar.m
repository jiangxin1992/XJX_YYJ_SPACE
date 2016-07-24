//
//  DD_OrderTabBar.m
//  DDAY
//
//  Created by yyj on 16/6/8.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_OrderTabBar.h"

@implementation DD_OrderTabBar
{
    UIButton *_leftBtn;
    UIButton *_middleBtn;
    UIButton *_rightBtn;
}
#pragma mark - 初始化方法
-(instancetype)initWithFrame:(CGRect)frame WithOrderDetailInfoModel:(DD_OrderDetailInfoModel *)orderInfo WithBlock:(void (^)(NSString *type))block;
{
    self=[super initWithFrame:frame];
    if(self)
    {
        _orderInfo=orderInfo;
        _Block=block;
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
-(void)PrepareData
{
    _leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _middleBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _rightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
}
-(void)PrepareUI{}
#pragma mark - UIConfig
-(void)UIConfig
{
    CGFloat _width=(ScreenWidth-100-30)/3.0f;
    for (int i=0; i<3; i++) {
        UIButton *btn=i==0?_leftBtn:i==1?_middleBtn:_rightBtn;
        [self addSubview:btn];
        btn.frame=CGRectMake(100+(10+_width)*i, 9, _width, 30);
        if(i==0)
        {
            [btn addTarget:self action:@selector(leftBtnAction) forControlEvents:UIControlEventTouchUpInside];
        }else if(i==1)
        {
            [btn addTarget:self action:@selector(middleBtnAction) forControlEvents:UIControlEventTouchUpInside];
        }else if(i==2)
        {
            [btn addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
        }
        btn.titleLabel.font=[regular getFont:13.0f];
        btn.backgroundColor=[UIColor blackColor];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}
#pragma mark - SomeActions
-(void)leftBtnAction
{

    if(_orderInfo.isPay)
    {
        if(_orderInfo.orderList.count)
        {
            DD_OrderModel *_OrderModel=[_orderInfo.orderList objectAtIndex:0];
            if(_OrderModel.orderStatus==0)
            {
                //待付款
                _Block(@"pay");
            }else if(_OrderModel.orderStatus==1)
            {
                //待发货
            }else if(_OrderModel.orderStatus==2)
            {
                //待收货
                _Block(@"logistics");
            }else if(_OrderModel.orderStatus==3)
            {
                //交易成功
                _Block(@"logistics");
            }else if(_OrderModel.orderStatus==4)
            {
                //申请退款
                _Block(@"logistics");
            }else if(_OrderModel.orderStatus==5)
            {
                //退款处理中
                _Block(@"logistics");
            }else if(_OrderModel.orderStatus==6)
            {
                //已退款
                _Block(@"logistics");
            }else if(_OrderModel.orderStatus==7)
            {
                //拒绝退款
                _Block(@"logistics");
            }
        }
    }else
    {
        //待付款
        _Block(@"pay");
    }
}
-(void)middleBtnAction
{
    if(_orderInfo.isPay)
    {
        if(_orderInfo.orderList.count)
        {
            DD_OrderModel *_OrderModel=[_orderInfo.orderList objectAtIndex:0];
            if(_OrderModel.orderStatus==0)
            {
                //待付款
                _Block(@"cancel");
            }else if(_OrderModel.orderStatus==1)
            {
                //待发货
            }else if(_OrderModel.orderStatus==2)
            {
                //待收货
                _Block(@"confirm");
            }else if(_OrderModel.orderStatus==3)
            {
                //交易成功
                _Block(@"delect");
            }else if(_OrderModel.orderStatus==4)
            {
                //申请退款
            }else if(_OrderModel.orderStatus==5)
            {
                //退款处理中
            }else if(_OrderModel.orderStatus==6)
            {
                //已退款
                _Block(@"delect");
            }else if(_OrderModel.orderStatus==7)
            {
                //拒绝退款
                _Block(@"delect");
            }
        }
    }else
    {
        //待付款
        _Block(@"cancel");
    }
}
-(void)rightBtnAction
{
    if(_orderInfo.isPay)
    {
        if(_orderInfo.orderList.count)
        {
            DD_OrderModel *_OrderModel=[_orderInfo.orderList objectAtIndex:0];
            if(_OrderModel.orderStatus==0)
            {
                //待付款
            }else if(_OrderModel.orderStatus==1)
            {
                //待发货
                _Block(@"refund");
            }else if(_OrderModel.orderStatus==2)
            {
                //待收货
                _Block(@"refund");
            }else if(_OrderModel.orderStatus==3)
            {
                //交易成功
                _Block(@"refund");
            }else if(_OrderModel.orderStatus==4)
            {
                //申请退款
                _Block(@"refund");
            }else if(_OrderModel.orderStatus==5)
            {
                //退款处理中
                _Block(@"refund");
            }else if(_OrderModel.orderStatus==6)
            {
                //已退款
                _Block(@"refund");
            }else if(_OrderModel.orderStatus==7)
            {
                //拒绝退款
                _Block(@"refund");
            }
        }
    }
}

-(void)SetState
{
    if(_orderInfo.isPay)
    {
        if(_orderInfo.orderList.count)
        {
            DD_OrderModel *_OrderModel=[_orderInfo.orderList objectAtIndex:0];
            if(_OrderModel.orderStatus==0)
            {
                //待付款
                _leftBtn.hidden=NO;
                _middleBtn.hidden=NO;
                _rightBtn.hidden=YES;

                [_leftBtn setTitle:@"继续支付" forState:UIControlStateNormal];
                [_middleBtn setTitle:@"取消订单" forState:UIControlStateNormal];
            }else if(_OrderModel.orderStatus==1)
            {
                //待发货
                _leftBtn.hidden=YES;
                _middleBtn.hidden=YES;
                _rightBtn.hidden=NO;
                [_rightBtn setTitle:@"申请退款" forState:UIControlStateNormal];
            }else if(_OrderModel.orderStatus==2)
            {
                //待收货
                _leftBtn.hidden=NO;
                _middleBtn.hidden=NO;
                _rightBtn.hidden=NO;
                [_leftBtn setTitle:@"查看物流" forState:UIControlStateNormal];
                [_middleBtn setTitle:@"确认收货" forState:UIControlStateNormal];
                [_rightBtn setTitle:@"申请退款" forState:UIControlStateNormal];
            }else if(_OrderModel.orderStatus==3)
            {
                //交易成功
                _leftBtn.hidden=NO;
                _middleBtn.hidden=NO;
                _rightBtn.hidden=NO;
                [_leftBtn setTitle:@"查看物流" forState:UIControlStateNormal];
                [_middleBtn setTitle:@"删除订单" forState:UIControlStateNormal];
                [_rightBtn setTitle:@"申请退款" forState:UIControlStateNormal];
            }else if(_OrderModel.orderStatus==4)
            {
                //申请退款
                _leftBtn.hidden=NO;
                _middleBtn.hidden=YES;
                _rightBtn.hidden=NO;
                [_leftBtn setTitle:@"查看物流" forState:UIControlStateNormal];
                [_rightBtn setTitle:@"退款申请中" forState:UIControlStateNormal];
            }else if(_OrderModel.orderStatus==5)
            {
                //退款处理中
                _leftBtn.hidden=NO;
                _middleBtn.hidden=YES;
                _rightBtn.hidden=NO;
                [_leftBtn setTitle:@"查看物流" forState:UIControlStateNormal];
                [_rightBtn setTitle:@"退款处理中" forState:UIControlStateNormal];
            }else if(_OrderModel.orderStatus==6)
            {
                
                //已退款
                _leftBtn.hidden=NO;
                _middleBtn.hidden=NO;
                _rightBtn.hidden=NO;
                [_leftBtn setTitle:@"查看物流" forState:UIControlStateNormal];
                [_middleBtn setTitle:@"删除订单" forState:UIControlStateNormal];
                [_rightBtn setTitle:@"已退款" forState:UIControlStateNormal];
            }else if(_OrderModel.orderStatus==7)
            {
                
                //拒绝退款
                _leftBtn.hidden=NO;
                _middleBtn.hidden=NO;
                _rightBtn.hidden=NO;
                [_leftBtn setTitle:@"查看物流" forState:UIControlStateNormal];
                [_middleBtn setTitle:@"删除订单" forState:UIControlStateNormal];
                [_rightBtn setTitle:@"拒绝退款" forState:UIControlStateNormal];
            }
        }else
        {
            _leftBtn.hidden=YES;
            _middleBtn.hidden=YES;
            _rightBtn.hidden=YES;
        }
        
    }else
    {
        //待付款
        _leftBtn.hidden=NO;
        _middleBtn.hidden=NO;
        _rightBtn.hidden=YES;
        
        [_leftBtn setTitle:@"继续支付" forState:UIControlStateNormal];
        [_middleBtn setTitle:@"取消订单" forState:UIControlStateNormal];
    }
}
@end
