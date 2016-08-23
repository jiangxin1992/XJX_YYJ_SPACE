//
//  DD_OrderTabBar.m
//  DDAY
//
//  Created by yyj on 16/6/8.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_OrderTabBar.h"

#import "DD_CustomBtn.h"
#import "DD_OrderModel.h"

@implementation DD_OrderTabBar

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
-(void)UIConfig
{
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    if(_orderInfo.orderList.count)
    {
        DD_OrderModel *_OrderModel=[_orderInfo.orderList objectAtIndex:0];
        if(_OrderModel.orderStatus==1)
        {
            //待发货 waiting_delivery
            DD_CustomBtn *tabBarBtn=(DD_CustomBtn *)[DD_CustomBtn getCustomImgBtnWithImageStr:@"System_Contact" WithSelectedImageStr:@"System_Contact"];
            [self addSubview:tabBarBtn];
            tabBarBtn.type=@"contact";
            tabBarBtn.frame=CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
            [tabBarBtn addTarget:self action:@selector(tabbarAction:) forControlEvents:UIControlEventTouchUpInside];
        }else
        {
            CGFloat _width=ScreenWidth/3.0f;
            for (int i=0; i<3; i++) {
                
                DD_CustomBtn *tabBarBtn=nil;
                if(i==1)
                {
                    tabBarBtn=[DD_CustomBtn getCustomImgBtnWithImageStr:@"System_Contact" WithSelectedImageStr:@"System_Contact"];
                    [self addSubview:tabBarBtn];
                    tabBarBtn.type=@"contact";
                    [tabBarBtn addTarget:self action:@selector(tabbarAction:) forControlEvents:UIControlEventTouchUpInside];
                }else
                {
//                    查看物流 logistics
//                    取消订单 cancel
//                    去支付 pay
//                    确认收货 confirm
//                    删除订单 delect
//                    退款申请中 applying_refund
//                    退款处理中 dealing_refund
//                    退款 refund
                    tabBarBtn=[DD_CustomBtn getCustomTitleBtnWithAlignment:0 WithFont:18.0f WithSpacing:0 WithNormalTitle:@"" WithNormalColor:_define_white_color WithSelectedTitle:nil WithSelectedColor:nil];
                    tabBarBtn.backgroundColor=_define_black_color;
                    if(_OrderModel.orderStatus==0)
                    {
                        //待付款 obligation
                        [tabBarBtn setTitle:i==0?@"取消订单":@"去支付" forState:UIControlStateNormal];
                        tabBarBtn.type=i==0?@"cancel":@"pay";
                        
                    }else if(_OrderModel.orderStatus==2)
                    {
                        //待收货 waiting_goods
                        [tabBarBtn setTitle:i==0?@"查看物流":@"确认收货" forState:UIControlStateNormal];
                        tabBarBtn.type=i==0?@"logistics":@"confirm";
                        
                    }else if(_OrderModel.orderStatus==3||_OrderModel.orderStatus==6||_OrderModel.orderStatus==7)
                    {
                        //交易成功 successful_trade //已退款 refunded //拒绝退款 refused_refund
                        [tabBarBtn setTitle:i==0?@"查看物流":@"删除订单" forState:UIControlStateNormal];
                        tabBarBtn.type=i==0?@"logistics":@"delect";
                        
                    }else if(_OrderModel.orderStatus==4)
                    {
                        //申请退款 application_drawback
                        [tabBarBtn setTitle:i==0?@"查看物流":@"退款申请中" forState:UIControlStateNormal];
                        tabBarBtn.type=i==0?@"logistics":@"applying_refund";
                    }else if(_OrderModel.orderStatus==5)
                    {
                        //退款处理中 refunding
                        [tabBarBtn setTitle:i==0?@"查看物流":@"退款处理中" forState:UIControlStateNormal];
                        tabBarBtn.type=i==0?@"logistics":@"dealing_refund";
                    }
                }
                
                [self addSubview:tabBarBtn];
                tabBarBtn.frame=CGRectMake(_width*i, 0, _width, ktabbarHeight);
                [tabBarBtn addTarget:self action:@selector(tabbarAction:) forControlEvents:UIControlEventTouchUpInside];
                
            }
        }
        
        UIView *upLine=[UIView getCustomViewWithColor:_define_black_color];
        [self addSubview:upLine];
        upLine.frame=CGRectMake(0, 0, ScreenWidth, 1);
    }
}
#pragma mark - SomeActions
-(void)tabbarAction:(DD_CustomBtn *)btn
{

    if([btn.type isEqualToString:@"logistics"])
    {
        _Block(btn.type);
    }else if([btn.type isEqualToString:@"cancel"])
    {
        _Block(btn.type);
    }else if([btn.type isEqualToString:@"pay"])
    {
        _Block(btn.type);
    }else if([btn.type isEqualToString:@"confirm"])
    {
        _Block(btn.type);
    }else if([btn.type isEqualToString:@"delect"])
    {
        _Block(btn.type);
    }else if([btn.type isEqualToString:@"applying_refund"])
    {
    }else if([btn.type isEqualToString:@"dealing_refund"])
    {
    }else if([btn.type isEqualToString:@"contact"])
    {
        _Block(btn.type);
    }
}
//-(void)leftBtnAction
//{
//
//    if(_orderInfo.isPay)
//    {
//        if(_orderInfo.orderList.count)
//        {
//            DD_OrderModel *_OrderModel=[_orderInfo.orderList objectAtIndex:0];
//            if(_OrderModel.orderStatus==0)
//            {
//                //待付款
//                _Block(@"pay");
//            }else if(_OrderModel.orderStatus==1)
//            {
//                //待发货
//            }else if(_OrderModel.orderStatus==2)
//            {
//                //待收货
//                _Block(@"logistics");
//            }else if(_OrderModel.orderStatus==3)
//            {
//                //交易成功
//                _Block(@"logistics");
//            }else if(_OrderModel.orderStatus==4)
//            {
//                //申请退款
//                _Block(@"logistics");
//            }else if(_OrderModel.orderStatus==5)
//            {
//                //退款处理中
//                _Block(@"logistics");
//            }else if(_OrderModel.orderStatus==6)
//            {
//                //已退款
//                _Block(@"logistics");
//            }else if(_OrderModel.orderStatus==7)
//            {
//                //拒绝退款
//                _Block(@"logistics");
//            }
//        }
//    }else
//    {
//        //待付款
//        _Block(@"pay");
//    }
//}
//-(void)middleBtnAction
//{
//    if(_orderInfo.isPay)
//    {
//        if(_orderInfo.orderList.count)
//        {
//            DD_OrderModel *_OrderModel=[_orderInfo.orderList objectAtIndex:0];
//            if(_OrderModel.orderStatus==0)
//            {
//                //待付款
//                _Block(@"cancel");
//            }else if(_OrderModel.orderStatus==1)
//            {
//                //待发货
//            }else if(_OrderModel.orderStatus==2)
//            {
//                //待收货
//                _Block(@"confirm");
//            }else if(_OrderModel.orderStatus==3)
//            {
//                //交易成功
//                _Block(@"delect");
//            }else if(_OrderModel.orderStatus==4)
//            {
//                //申请退款
//            }else if(_OrderModel.orderStatus==5)
//            {
//                //退款处理中
//            }else if(_OrderModel.orderStatus==6)
//            {
//                //已退款
//                _Block(@"delect");
//            }else if(_OrderModel.orderStatus==7)
//            {
//                //拒绝退款
//                _Block(@"delect");
//            }
//        }
//    }else
//    {
//        //待付款
//        _Block(@"cancel");
//    }
//}
//-(void)rightBtnAction
//{
//    if(_orderInfo.isPay)
//    {
//        if(_orderInfo.orderList.count)
//        {
//            DD_OrderModel *_OrderModel=[_orderInfo.orderList objectAtIndex:0];
//            if(_OrderModel.orderStatus==0)
//            {
//                //待付款
//            }else if(_OrderModel.orderStatus==1)
//            {
//                //待发货
//                _Block(@"refund");
//            }else if(_OrderModel.orderStatus==2)
//            {
//                //待收货
//                _Block(@"refund");
//            }else if(_OrderModel.orderStatus==3)
//            {
//                //交易成功
//                _Block(@"refund");
//            }else if(_OrderModel.orderStatus==4)
//            {
//                //申请退款
//                _Block(@"refund");
//            }else if(_OrderModel.orderStatus==5)
//            {
//                //退款处理中
//                _Block(@"refund");
//            }else if(_OrderModel.orderStatus==6)
//            {
//                //已退款
//                _Block(@"refund");
//            }else if(_OrderModel.orderStatus==7)
//            {
//                //拒绝退款
//                _Block(@"refund");
//            }
//        }
//    }
//}

//-(void)SetState
//{
//    if(_orderInfo.isPay)
//    {
//        if(_orderInfo.orderList.count)
//        {
//            DD_OrderModel *_OrderModel=[_orderInfo.orderList objectAtIndex:0];
//            if(_OrderModel.orderStatus==0)
//            {
//                //待付款
//                _leftBtn.hidden=NO;
//                _middleBtn.hidden=NO;
//                _rightBtn.hidden=YES;
//
//                [_leftBtn setTitle:@"继续支付" forState:UIControlStateNormal];
//                [_middleBtn setTitle:@"取消订单" forState:UIControlStateNormal];
//            }else if(_OrderModel.orderStatus==1)
//            {
//                //待发货
//                _leftBtn.hidden=YES;
//                _middleBtn.hidden=YES;
//                _rightBtn.hidden=NO;
//                [_rightBtn setTitle:@"申请退款" forState:UIControlStateNormal];
//            }else if(_OrderModel.orderStatus==2)
//            {
//                //待收货
//                _leftBtn.hidden=NO;
//                _middleBtn.hidden=NO;
//                _rightBtn.hidden=NO;
//                [_leftBtn setTitle:@"查看物流" forState:UIControlStateNormal];
//                [_middleBtn setTitle:@"确认收货" forState:UIControlStateNormal];
//                [_rightBtn setTitle:@"申请退款" forState:UIControlStateNormal];
//            }else if(_OrderModel.orderStatus==3)
//            {
//                //交易成功
//                _leftBtn.hidden=NO;
//                _middleBtn.hidden=NO;
//                _rightBtn.hidden=NO;
//                [_leftBtn setTitle:@"查看物流" forState:UIControlStateNormal];
//                [_middleBtn setTitle:@"删除订单" forState:UIControlStateNormal];
//                [_rightBtn setTitle:@"申请退款" forState:UIControlStateNormal];
//            }else if(_OrderModel.orderStatus==4)
//            {
//                //申请退款
//                _leftBtn.hidden=NO;
//                _middleBtn.hidden=YES;
//                _rightBtn.hidden=NO;
//                [_leftBtn setTitle:@"查看物流" forState:UIControlStateNormal];
//                [_rightBtn setTitle:@"退款申请中" forState:UIControlStateNormal];
//            }else if(_OrderModel.orderStatus==5)
//            {
//                //退款处理中
//                _leftBtn.hidden=NO;
//                _middleBtn.hidden=YES;
//                _rightBtn.hidden=NO;
//                [_leftBtn setTitle:@"查看物流" forState:UIControlStateNormal];
//                [_rightBtn setTitle:@"退款处理中" forState:UIControlStateNormal];
//            }else if(_OrderModel.orderStatus==6)
//            {
//                
//                //已退款
//                _leftBtn.hidden=NO;
//                _middleBtn.hidden=NO;
//                _rightBtn.hidden=NO;
//                [_leftBtn setTitle:@"查看物流" forState:UIControlStateNormal];
//                [_middleBtn setTitle:@"删除订单" forState:UIControlStateNormal];
//                [_rightBtn setTitle:@"已退款" forState:UIControlStateNormal];
//            }else if(_OrderModel.orderStatus==7)
//            {
//                
//                //拒绝退款
//                _leftBtn.hidden=NO;
//                _middleBtn.hidden=NO;
//                _rightBtn.hidden=NO;
//                [_leftBtn setTitle:@"查看物流" forState:UIControlStateNormal];
//                [_middleBtn setTitle:@"删除订单" forState:UIControlStateNormal];
//                [_rightBtn setTitle:@"拒绝退款" forState:UIControlStateNormal];
//            }
//        }else
//        {
//            _leftBtn.hidden=YES;
//            _middleBtn.hidden=YES;
//            _rightBtn.hidden=YES;
//        }
//        
//    }else
//    {
//        //待付款
//        _leftBtn.hidden=NO;
//        _middleBtn.hidden=NO;
//        _rightBtn.hidden=YES;
//        
//        [_leftBtn setTitle:@"继续支付" forState:UIControlStateNormal];
//        [_middleBtn setTitle:@"取消订单" forState:UIControlStateNormal];
//    }
//}
@end
