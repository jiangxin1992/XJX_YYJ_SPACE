//
//  DD_OrderDetailFootView.m
//  YCO SPACE
//
//  Created by yyj on 2016/11/9.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_OrderDetailFootView.h"

#import "DD_CustomContentView.h"

@implementation DD_OrderDetailFootView
{
    UIView *_countView;
    UILabel *_remarkLabel;
    UIView *_countUpLine;
    UILabel *_freightLabel;
    UILabel *_subtotalLabel;
    UILabel *_benefitTitleLabel;
    UILabel *_benefitLabel;
    UILabel *_integralTitleLabel;
    UILabel *_integralLabel;
    UIView *_countMiddleLine;
    UILabel *_actuallyPayLabel;
    UIView *_countDownLine;
    
    UIView *_orderDetailView;
    UILabel *_tradeOrderCodeLabel;
    UILabel *_tradeOrderCodeTitleLabel;
    UILabel *_payWayLabel;
    UILabel *_payWayTitleLabel;
    UILabel *_createTimeLabel;
    UILabel *_createTimeTitleLabel;
    UILabel *_orderPayTimeLabel;
    UILabel *_orderPayTimeTitleLabel;
    
    UIButton *_contactBtn;
    DD_CustomContentView *_contactView;
    UIButton *_contactLeftBtn;
    DD_CustomContentView *_contactLeftView;
    UIButton *_refundBtn;
    DD_CustomContentView *_refundView;
}

#pragma mark - init
-(instancetype)initWithOrderDetailModel:(DD_OrderDetailModel *)orderDetailModel WithBlock:(void (^)(NSString *type,CGFloat height))block
{
    self=[super init];
    if(self)
    {
        _orderDetailModel=orderDetailModel;
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
-(void)PrepareUI
{
    self.backgroundColor=_define_white_color;
}

#pragma mark - UIConfig
-(void)UIConfig
{
    [self CreateDetailCountView];
    [self CreateOrderDetailView];
    [self CreateActionBtn];

}
-(void)CreateActionBtn
{
    _contactBtn=[UIButton getCustomBtn];
    [self addSubview:_contactBtn];
    [regular setBorder:_contactBtn];
    [_contactBtn addTarget:self action:@selector(contactAction) forControlEvents:UIControlEventTouchUpInside];
    [_contactBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_orderDetailView.mas_bottom).with.offset(15);
        make.left.mas_equalTo(kEdge);
        make.right.mas_equalTo(-kEdge);
        make.height.mas_equalTo(40);
    }];
    _contactView=[[DD_CustomContentView alloc] initCustomViewWithTitle:@"联系我们" WithImg:@"Order_Contact"];
    [_contactBtn addSubview:_contactView];
    _contactView.userInteractionEnabled=NO;
    [_contactView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(_contactBtn);
        make.height.mas_equalTo(_contactView.size.height);
        make.width.mas_equalTo(_contactView.size.width);
    }];
    
    _contactLeftBtn=[UIButton getCustomBtn];
    [self addSubview:_contactLeftBtn];
    [regular setBorder:_contactLeftBtn];
    [_contactLeftBtn addTarget:self action:@selector(contactAction) forControlEvents:UIControlEventTouchUpInside];
    [_contactLeftBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_orderDetailView.mas_bottom).with.offset(15);
        make.left.mas_equalTo(kEdge);
        make.height.mas_equalTo(40);
    }];
    _contactLeftView=[[DD_CustomContentView alloc] initCustomViewWithTitle:@"联系我们" WithImg:@"Order_Contact"];
    [_contactLeftBtn addSubview:_contactLeftView];
    _contactLeftView.userInteractionEnabled=NO;
    [_contactLeftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(_contactLeftBtn);
        make.height.mas_equalTo(_contactLeftView.size.height);
        make.width.mas_equalTo(_contactLeftView.size.width);
    }];
    
    
    _refundBtn=[UIButton getCustomBtn];
    [self addSubview:_refundBtn];
    [regular setBorder:_refundBtn];
    [_refundBtn addTarget:self action:@selector(refundAction) forControlEvents:UIControlEventTouchUpInside];
    [_refundBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_orderDetailView.mas_bottom).with.offset(15);
        make.right.mas_equalTo(-kEdge);
        make.height.mas_equalTo(40);
        make.left.mas_equalTo(_contactLeftBtn.mas_right).with.offset(kEdge);
        make.width.mas_equalTo(_contactLeftBtn);
    }];
    _refundView=[[DD_CustomContentView alloc] initCustomViewWithTitle:@"退货" WithImg:@"Order_Return"];
    [_refundBtn addSubview:_refundView];
    _refundView.userInteractionEnabled=NO;
    [_refundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(_refundBtn);
        make.height.mas_equalTo(_refundView.size.height);
        make.width.mas_equalTo(_refundView.size.width);
    }];
}
-(void)CreateOrderDetailView
{
    _orderDetailView=[UIView getCustomViewWithColor:nil];
    [self addSubview:_orderDetailView];
    
    _tradeOrderCodeLabel=[UILabel getLabelWithAlignment:2 WithTitle:@"" WithFont:12  WithTextColor:_define_light_gray_color1 WithSpacing:0];
    [_orderDetailView addSubview:_tradeOrderCodeLabel];
    
    _tradeOrderCodeTitleLabel=[UILabel getLabelWithAlignment:0 WithTitle:@"" WithFont:12  WithTextColor:_define_light_gray_color1 WithSpacing:0];
    [_orderDetailView addSubview:_tradeOrderCodeTitleLabel];
    
    _payWayLabel=[UILabel getLabelWithAlignment:2 WithTitle:@"" WithFont:12  WithTextColor:_define_light_gray_color1 WithSpacing:0];
    [_orderDetailView addSubview:_payWayLabel];
    
    _payWayTitleLabel=[UILabel getLabelWithAlignment:0 WithTitle:@"" WithFont:12  WithTextColor:_define_light_gray_color1 WithSpacing:0];
    [_orderDetailView addSubview:_payWayTitleLabel];
    
    _createTimeLabel=[UILabel getLabelWithAlignment:2 WithTitle:@"" WithFont:12  WithTextColor:_define_light_gray_color1 WithSpacing:0];
    [_orderDetailView addSubview:_createTimeLabel];
    
    _createTimeTitleLabel=[UILabel getLabelWithAlignment:0 WithTitle:@"" WithFont:12  WithTextColor:_define_light_gray_color1 WithSpacing:0];
    [_orderDetailView addSubview:_createTimeTitleLabel];
    
    _orderPayTimeLabel=[UILabel getLabelWithAlignment:2 WithTitle:@"" WithFont:12  WithTextColor:_define_light_gray_color1 WithSpacing:0];
    [_orderDetailView addSubview:_orderPayTimeLabel];
    
    _orderPayTimeTitleLabel=[UILabel getLabelWithAlignment:0 WithTitle:@"" WithFont:12  WithTextColor:_define_light_gray_color1 WithSpacing:0];
    [_orderDetailView addSubview:_orderPayTimeTitleLabel];

}

-(void)CreateDetailCountView
{
   
    
    _countView=[UIView getCustomViewWithColor:nil];
    [self addSubview:_countView];
    
    _remarkLabel=[UILabel getLabelWithAlignment:0 WithTitle:@"" WithFont:13.0f WithTextColor:_define_light_gray_color1 WithSpacing:0];
    [_countView addSubview:_remarkLabel];
    _remarkLabel.numberOfLines=2;
    
    _countUpLine=[UIView getCustomViewWithColor:_define_black_color];
    [_countView addSubview:_countUpLine];
    
    _freightLabel=[UILabel getLabelWithAlignment:0 WithTitle:@"" WithFont:13.0f WithTextColor:nil WithSpacing:0];
    [_countView addSubview:_freightLabel];
    
    _subtotalLabel=[UILabel getLabelWithAlignment:2 WithTitle:@"" WithFont:13.0f WithTextColor:nil WithSpacing:0];
    [_countView addSubview:_subtotalLabel];
    
    _benefitTitleLabel=[UILabel getLabelWithAlignment:0 WithTitle:@"" WithFont:13.0f WithTextColor:nil WithSpacing:0];
    [_countView addSubview:_benefitTitleLabel];
    
    _benefitLabel=[UILabel getLabelWithAlignment:2 WithTitle:@"" WithFont:13.0f WithTextColor:nil WithSpacing:0];
    [_countView addSubview:_benefitLabel];
    
    _integralTitleLabel=[UILabel getLabelWithAlignment:0 WithTitle:@"" WithFont:13.0f WithTextColor:nil WithSpacing:0];
    [_countView addSubview:_integralTitleLabel];
    
    _integralLabel=[UILabel getLabelWithAlignment:2 WithTitle:@"" WithFont:13.0f WithTextColor:nil WithSpacing:0];
    [_countView addSubview:_integralLabel];
    
    _countMiddleLine=[UIView getCustomViewWithColor:_define_light_gray_color1];
    [_countView addSubview:_countMiddleLine];

    _actuallyPayLabel=[UILabel getLabelWithAlignment:2 WithTitle:@"" WithFont:13.0f WithTextColor:nil WithSpacing:0];
    [_countView addSubview:_actuallyPayLabel];
    
    _countDownLine=[UIView getCustomViewWithColor:_define_black_color];
    [_countView addSubview:_countDownLine];
    
}

#pragma mark - SetState
-(void)SetState
{
    [self SetDetailCountView];
    [self SetOrderDetailView];
    [self SetActionBtn];
    [self layoutIfNeeded];
    CGFloat _y_p=_contactBtn.origin.y + _contactBtn.size.height+30;
    _block(@"height",_y_p);
}
-(void)SetActionBtn
{
    if(_orderDetailModel.orderInfo.orderStatus==0||_orderDetailModel.orderInfo.orderStatus==4||_orderDetailModel.orderInfo.orderStatus==5||_orderDetailModel.orderInfo.orderStatus==6||_orderDetailModel.orderInfo.orderStatus==7||_orderDetailModel.orderInfo.orderStatus==8)
    {
        _contactBtn.hidden=NO;
        _contactView.hidden=NO;
        _contactLeftBtn.hidden=YES;
        _contactLeftView.hidden=YES;
        _refundBtn.hidden=YES;
        _refundView.hidden=YES;
    }else
    {
        _contactBtn.hidden=YES;
        _contactView.hidden=YES;
        _contactLeftBtn.hidden=NO;
        _contactLeftView.hidden=NO;
        _refundBtn.hidden=NO;
        _refundView.hidden=NO;
    }
}
-(void)SetDetailCountView
{
    
    [_countView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
    }];
    
    [_remarkLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kEdge);
        make.right.mas_equalTo(-kEdge);
        make.top.mas_equalTo(0);
    }];
    
    [_countUpLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kEdge);
        make.right.mas_equalTo(-kEdge);
        make.height.mas_equalTo(1);
        if(![NSString isNilOrEmpty:_orderDetailModel.orderInfo.memo])
        {
            make.top.mas_equalTo(_remarkLabel.mas_bottom).with.offset(15);
        }else
        {
            make.top.mas_equalTo(_remarkLabel.mas_bottom).with.offset(0);
        }
    }];
    
    [_subtotalLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-kEdge);
        make.top.mas_equalTo(_countUpLine.mas_bottom).with.offset(15);
    }];
    
    [_freightLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kEdge);
        make.top.mas_equalTo(_countUpLine.mas_bottom).with.offset(15);
        make.right.mas_equalTo(_subtotalLabel.mas_left).with.offset(5);
    }];
    
    [_benefitLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-kEdge);
        if(_orderDetailModel.orderInfo.benefitAmount)
        {
            make.top.mas_equalTo(_subtotalLabel.mas_bottom).with.offset(8);
        }else
        {
            make.top.mas_equalTo(_subtotalLabel.mas_bottom).with.offset(0);
        }
    }];
    
    [_benefitTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kEdge);
        make.right.mas_equalTo(_benefitLabel.mas_left).with.offset(5);
        if(_orderDetailModel.orderInfo.benefitAmount)
        {
            make.top.mas_equalTo(_freightLabel.mas_bottom).with.offset(8);
        }else
        {
            make.top.mas_equalTo(_freightLabel.mas_bottom).with.offset(0);
        }
    }];
    
    [_integralLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-kEdge);
        if(_orderDetailModel.orderInfo.intergralAmout)
        {
            make.top.mas_equalTo(_benefitLabel.mas_bottom).with.offset(8);
        }else
        {
            make.top.mas_equalTo(_benefitLabel.mas_bottom).with.offset(0);
        }
    }];
    
    [_integralTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kEdge);
        make.right.mas_equalTo(_integralLabel.mas_left).with.offset(5);
        if(_orderDetailModel.orderInfo.intergralAmout)
        {
            make.top.mas_equalTo(_benefitTitleLabel.mas_bottom).with.offset(8);
        }else
        {
            make.top.mas_equalTo(_benefitTitleLabel.mas_bottom).with.offset(0);
        }
    }];
    
    [_countMiddleLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_integralTitleLabel.mas_bottom).with.offset(15);
        make.left.mas_equalTo(kEdge);
        make.right.mas_equalTo(-kEdge);
        make.height.mas_equalTo(1);
    }];
    
    [_actuallyPayLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-kEdge);
        make.top.mas_equalTo(_countMiddleLine.mas_bottom).with.offset(15);
    }];
    
    [_countDownLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_actuallyPayLabel.mas_bottom).with.offset(15);
        make.height.mas_equalTo(1);
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(kEdge);
        make.right.mas_equalTo(-kEdge);
    }];
    
    if(![NSString isNilOrEmpty:_orderDetailModel.orderInfo.memo])
    {
        _remarkLabel.text=[[NSString alloc] initWithFormat:@"订单备注：%@",_orderDetailModel.orderInfo.memo];
    }else
    {
        _remarkLabel.text=@"";
    }
    
    _subtotalLabel.text=[[NSString alloc] initWithFormat:@"小计￥%@",[regular getRoundNum:[_orderDetailModel.orderInfo.totalAmount floatValue]+_orderDetailModel.orderInfo.allFreight]];
    _freightLabel.text=[[NSString alloc] initWithFormat:@"共%ld件商品（含邮费￥%ld）",_orderDetailModel.orderInfo.totalItemCount,_orderDetailModel.orderInfo.allFreight];
    if(_orderDetailModel.orderInfo.benefitAmount)
    {
        
        _benefitLabel.text=[[NSString alloc] initWithFormat:@"-￥%@",[regular getRoundNum:_orderDetailModel.orderInfo.benefitAmount]];
        _benefitTitleLabel.text=@"优惠";
    }else
    {
        _benefitLabel.text=@"";
        _benefitTitleLabel.text=@"";
    }
    
    if(_orderDetailModel.orderInfo.intergralAmout)
    {
        _integralLabel.text=[[NSString alloc] initWithFormat:@"-￥%@",[regular getRoundNum:_orderDetailModel.orderInfo.intergralAmout]];
        _integralTitleLabel.text=@"积分抵扣";
    }else
    {
        _integralLabel.text=@"";
        _integralTitleLabel.text=@"";
    }
    _actuallyPayLabel.text=[[NSString alloc] initWithFormat:@"实付￥%@",[regular getRoundNum:_orderDetailModel.orderInfo.actuallyPay]];
    
}
-(void)SetOrderDetailView
{
    
    [_orderDetailView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_countView.mas_bottom).with.offset(0);
        make.left.right.mas_equalTo(0);
    }];
    
    [_tradeOrderCodeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-kEdge);
        make.top.mas_equalTo(15);
    }];
    
    [_tradeOrderCodeTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kEdge);
        make.top.mas_equalTo(_tradeOrderCodeLabel);
        make.right.mas_equalTo(_tradeOrderCodeLabel.mas_left).with.offset(5);
    }];
    
    [_payWayLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-kEdge);
        if(_orderDetailModel.orderInfo.payWay)
        {
            make.top.mas_equalTo(_tradeOrderCodeLabel.mas_bottom).with.offset(8);
        }else
        {
            make.top.mas_equalTo(_tradeOrderCodeLabel.mas_bottom).with.offset(0);
        }
    }];
    
    [_payWayTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kEdge);
        make.top.mas_equalTo(_payWayLabel);
        make.right.mas_equalTo(_payWayLabel.mas_left).with.offset(5);
    }];
    
    [_createTimeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-kEdge);
        if(_orderDetailModel.orderInfo.createTime)
        {
            make.top.mas_equalTo(_payWayLabel.mas_bottom).with.offset(8);
        }else
        {
            make.top.mas_equalTo(_payWayLabel.mas_bottom).with.offset(0);
        }
    }];
    
    [_createTimeTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kEdge);
        make.top.mas_equalTo(_createTimeLabel);
        make.right.mas_equalTo(_createTimeLabel.mas_left).with.offset(5);
    }];
    
    [_orderPayTimeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-kEdge);
        if(_orderDetailModel.orderInfo.orderPayTime)
        {
            make.top.mas_equalTo(_createTimeLabel.mas_bottom).with.offset(8);
        }else
        {
            make.top.mas_equalTo(_createTimeLabel.mas_bottom).with.offset(0);
        }
    }];
    
    [_orderPayTimeTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kEdge);
        make.top.mas_equalTo(_orderPayTimeLabel);
        make.right.mas_equalTo(_orderPayTimeLabel.mas_left).with.offset(5);
        make.bottom.mas_equalTo(0);
    }];
    
    _tradeOrderCodeTitleLabel.text=@"订单号";
    _tradeOrderCodeLabel.text=_orderDetailModel.orderInfo.tradeOrderCode;
    
    if(_orderDetailModel.orderInfo.payWay)
    {
        _payWayTitleLabel.text=@"支付方式";
        _payWayLabel.text=_orderDetailModel.orderInfo.payWay==1?@"支付宝":_orderDetailModel.orderInfo.payWay==2?@"微信":@"银联";
    }else
    {
        _payWayTitleLabel.text=@"";
        _payWayLabel.text=@"";
    }
    if(_orderDetailModel.orderInfo.createTime)
    {
        _createTimeTitleLabel.text=@"下单时间";
        _createTimeLabel.text=[regular getTimeStr:_orderDetailModel.orderInfo.createTime WithFormatter:@"YYYY MM.dd HH:mm"];
    }else
    {
        _createTimeTitleLabel.text=@"";
        _createTimeLabel.text=@"";
    }
    if(_orderDetailModel.orderInfo.orderPayTime)
    {
        _orderPayTimeTitleLabel.text=@"付款时间";
        _orderPayTimeLabel.text=[regular getTimeStr:_orderDetailModel.orderInfo.orderPayTime WithFormatter:@"YYYY MM.dd HH:mm"];
    }else
    {
        _orderPayTimeTitleLabel.text=@"";
        _orderPayTimeLabel.text=@"";
    }
}
#pragma mark - SomeAction
-(void)contactAction
{
    _block(@"contact",0);
}
-(void)refundAction
{
    _block(@"refund",0);
}
@end
