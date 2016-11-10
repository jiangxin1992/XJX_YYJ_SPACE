//
//  DD_OrderTabBar.m
//  DDAY
//
//  Created by yyj on 16/6/8.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_OrderTabBar.h"

#import "DD_CustomBtn.h"

@implementation DD_OrderTabBar
{
    DD_CustomBtn *_ActionBtn;
}

#pragma mark - 初始化方法
-(instancetype)initWithOrderDetailModel:(DD_OrderDetailModel *)orderDetailModel WithBlock:(void (^)(NSString *type))block
{
    self=[super init];
    if(self)
    {
        _orderDetailModel=orderDetailModel;
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
-(void)PrepareData{}
-(void)PrepareUI
{
    self.backgroundColor=_define_white_color;
}
#pragma mark - UIConfig
-(void)UIConfig
{
    _ActionBtn=[DD_CustomBtn getCustomTitleBtnWithAlignment:0 WithFont:18.0f WithSpacing:0 WithNormalTitle:@"" WithNormalColor:_define_white_color WithSelectedTitle:nil WithSelectedColor:nil];
    [self addSubview:_ActionBtn];
    _ActionBtn.backgroundColor=_define_black_color;
    [_ActionBtn addTarget:self action:@selector(tabbarAction:) forControlEvents:UIControlEventTouchUpInside];
    
}
#pragma mark - SetState
-(void)SetState
{
    [_ActionBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.top.mas_equalTo(0);
        if(_orderDetailModel)
        {
            if(_orderDetailModel.orderInfo.orderStatus==0||_orderDetailModel.orderInfo.orderStatus==2)
            {
                make.height.mas_equalTo(ktabbarHeight);
            }else
            {
                make.height.mas_equalTo(0);
            }
        }else
        {
            make.height.mas_equalTo(0);
        }
    }];
    NSString *_title=nil;
    if(_orderDetailModel)
    {
        _title=_orderDetailModel.orderInfo.orderStatus==0?@"去支付":_orderDetailModel.orderInfo.orderStatus==2?@"确认收货":@"";
        _ActionBtn.type=_orderDetailModel.orderInfo.orderStatus==0?@"pay":_orderDetailModel.orderInfo.orderStatus==2?@"confirm":@"";
    }else
    {
        _title=@"";
        _ActionBtn.type=@"";
    }
    [_ActionBtn setTitle:_title forState:UIControlStateNormal];
}
#pragma mark - SomeActions
-(void)tabbarAction:(DD_CustomBtn *)btn
{
    if([btn.type isEqualToString:@"pay"])
    {
        _Block(btn.type);
    }else if([btn.type isEqualToString:@"confirm"])
    {
        _Block(btn.type);
    }
}

@end
