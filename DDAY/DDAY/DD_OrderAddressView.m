//
//  DD_OrderAddressView.m
//  DDAY
//
//  Created by yyj on 16/6/8.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_OrderAddressView.h"

#import "DD_OrderModel.h"

#define _jiange 9

@implementation DD_OrderAddressView
{
    UIView *_upView;
    UIView *_downView;
}
#pragma mark - 初始化
-(instancetype)initWithOrderDetailInfoModel:(DD_OrderDetailModel *)OrderDetailModel WithBlock:(void (^)(NSString *type))block
{
    self=[super init];
    if(self)
    {
        _DetailModel=OrderDetailModel;
        _addressBlock=block;
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
-(void)PrepareUI{
    self.backgroundColor=_define_white_color;
}
#pragma mark - UIConfig
-(void)UIConfig
{
    [self CreateUpView];
    [self CreateDownView];
}
-(void)CreateUpView
{
    _upView=[UIView getCustomViewWithColor:nil];
    [self addSubview:_upView];
    [_upView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
    }];
    
    UIView *backView=[UIView getCustomViewWithColor:nil];
    [_upView addSubview:backView];
    [regular setBorder:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kEdge);
        make.right.mas_equalTo(-kEdge);
        make.top.mas_equalTo(_jiange);
        make.bottom.mas_equalTo(_upView);
    }];
    
    
    NSString *status=nil;
    if(_DetailModel.orderInfo.isPay)
    {
        if(_DetailModel.orderInfo.orderList.count)
        {
            
            DD_OrderModel *_OrderModel=[_DetailModel.orderInfo.orderList objectAtIndex:0];
            long _status=_OrderModel.orderStatus;
            status=_status==0?@"待付款":_status==1?@"待发货":_status==2?@"待收货":_status==3?@"交易成功":_status==4?@"申请退款":_status==5?@"退款处理中":_status==6?@"已退款":@"拒绝退款";
        }
    }else
    {
        status=@"待付款";
    }
    UIView *lastView=nil;
    for (int i=0; i<2; i++) {
        UILabel *titleLabel=[UILabel getLabelWithAlignment:0 WithTitle:i==0?@"订单号":@"订单状态" WithFont:12.0f WithTextColor:nil WithSpacing:0];
        [backView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            if(lastView)
            {
                make.top.mas_equalTo(lastView.mas_bottom).with.offset(_jiange);
            }else
            {
                make.top.mas_equalTo(backView).with.offset(_jiange);
            }
            make.left.mas_equalTo(backView).with.offset(_jiange);
            
        }];
        [titleLabel sizeToFit];
        
        UILabel *conLabel=[UILabel getLabelWithAlignment:0 WithTitle:i==0?_DetailModel.orderInfo.tradeOrderCode:status WithFont:12.0f WithTextColor:nil WithSpacing:0];
        [backView addSubview:conLabel];
        [conLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(titleLabel.mas_right).with.offset(_jiange);
            make.centerY.mas_equalTo(titleLabel);
        }];
        [conLabel sizeToFit];
        
        lastView=titleLabel;
    }
    [lastView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(backView.mas_bottom).with.offset(-_jiange);
    }];
}
-(void)CreateDownView
{
    _downView=[UIView getCustomViewWithColor:nil];
    [self addSubview:_downView];
    [_downView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_upView.mas_bottom).with.offset(0);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    
    UIView *lastView=nil;
    for (int i=0; i<3; i++) {
        UILabel *label=[UILabel getLabelWithAlignment:0 WithTitle:i==0?_DetailModel.address.deliverName:i==1?_DetailModel.address.deliverPhone:_DetailModel.address.detailAddress WithFont:i==0?15:i==1?14:12 WithTextColor:nil WithSpacing:0];
        [_downView addSubview:label];
        label.tag=100+i;
        if(i==2)
        {
            label.numberOfLines=2;
        }else if(i==0)
        {
            _refundBtn=[UIButton getCustomTitleBtnWithAlignment:0 WithFont:12.0f WithSpacing:0 WithNormalTitle:@"退款" WithNormalColor:_define_white_color WithSelectedTitle:nil WithSelectedColor:nil];
            [_downView addSubview:_refundBtn];
            _refundBtn.backgroundColor=_define_black_color;
            _refundBtn.hidden=YES;
            [_refundBtn addTarget:self action:@selector(refundAction) forControlEvents:UIControlEventTouchUpInside];
            [_refundBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(-kEdge);
                make.centerY.mas_equalTo(label);
                make.width.mas_equalTo(49);
                make.height.mas_equalTo(22);
            }];
            
        }
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(kEdge);
            if(i==2)
            {
                make.right.mas_equalTo(-kEdge);
            }
            if(lastView)
            {
                make.top.mas_equalTo(lastView.mas_bottom).with.offset(_jiange);
                
            }else
            {
                make.top.mas_equalTo(_downView.mas_top).with.offset(_jiange);
            }
        }];
        [label sizeToFit];
        lastView=label;
    }

    UIView *upLine=[UIView getCustomViewWithColor:_define_black_color];
    [_downView addSubview:upLine];
    [upLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kEdge);
        make.right.mas_equalTo(-kEdge);
        make.height.mas_equalTo(1);
        make.top.mas_equalTo(lastView.mas_bottom).with.offset(_jiange);
        make.bottom.mas_equalTo(_downView.mas_bottom).with.offset(0);
    }];
    
}
#pragma mark - SomeAction
-(void)refundAction
{
    _addressBlock(@"refund");
}

#pragma mark - SetState
-(void)SetState
{
    if(_DetailModel.address==nil)
    {
        for (int i=0; i<3; i++) {
            UILabel *label=(UILabel *)[self viewWithTag:100+i];
            label.text=@"";
        }
        
    }else
    {
        for (int i=0; i<3; i++) {
            UILabel *label=(UILabel *)[self viewWithTag:100+i];
            label.text=i==0?_DetailModel.address.deliverName:i==1?_DetailModel.address.deliverPhone:_DetailModel.address.detailAddress;
        }
    }
    
    if(_DetailModel.orderInfo.orderList.count)
    {
        DD_OrderModel *_order=[_DetailModel.orderInfo.orderList objectAtIndex:0];
        if(_order.orderStatus==1||_order.orderStatus==2||_order.orderStatus==3)
        {
            //待发货
            //待收货
            //交易成功
            _refundBtn.hidden=NO;
        }else
        {
            _refundBtn.hidden=YES;
        }
    }
    
}
@end
