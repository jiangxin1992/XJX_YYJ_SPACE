//
//  DD_ShopClearingView.m
//  DDAY
//
//  Created by yyj on 16/5/30.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_ShopClearingView.h"

#import "DD_ShopTool.h"

@implementation DD_ShopClearingView
{
    UIButton *selectBtn;
    UILabel *price_label;
    UIButton *ConfirmBtn;
}
#pragma mark - 初始化
-(instancetype)initWithShopModel:(DD_ShopModel *)shopModel WithBlock:(void (^)(NSString *))block
{
    self=[super init];
    if(self)
    {
        _shopModel=shopModel;
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
-(void)UIConfig
{
    self.backgroundColor=[UIColor whiteColor];
    
    UIView *upLine=[UIView getCustomViewWithColor:_define_black_color];
    [self addSubview:upLine];
    [upLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.top.left.right.mas_equalTo(0);
    }];
    
    selectBtn=[UIButton getCustomImgBtnWithImageStr:@"System_nocheck" WithSelectedImageStr:@"System_check"];
    [self addSubview:selectBtn];
    [selectBtn addTarget:self action:@selector(chooseAction) forControlEvents:UIControlEventTouchUpInside];
    [selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(15);
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(kEdge);
    }];
    [selectBtn setEnlargeEdge:20];

    UILabel *selectLabel=[UILabel getLabelWithAlignment:0 WithTitle:@"全选" WithFont:14.0f WithTextColor:nil WithSpacing:0];
    [self addSubview:selectLabel];
    [selectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self);
        make.left.mas_equalTo(selectBtn.mas_right).with.offset(16);
        make.width.mas_equalTo(50);
        make.centerY.mas_equalTo(selectBtn);
    }];
    
    ConfirmBtn=[UIButton getCustomTitleBtnWithAlignment:0 WithFont:18.0f WithSpacing:0 WithNormalTitle:@"结算" WithNormalColor:_define_white_color WithSelectedTitle:nil WithSelectedColor:nil];
    [self addSubview:ConfirmBtn];
    [ConfirmBtn addTarget:self action:@selector(ConfirmAction) forControlEvents:UIControlEventTouchUpInside];
    ConfirmBtn.backgroundColor=[UIColor blackColor];
    [ConfirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self);
        make.right.mas_equalTo(0);
        make.width.mas_equalTo(110);
        make.centerY.mas_equalTo(self);
    }];
    
    price_label=[UILabel getLabelWithAlignment:2 WithTitle:@"" WithFont:15.0f WithTextColor:_define_black_color WithSpacing:0];
    [self addSubview:price_label];
    [price_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(selectLabel.mas_right).with.offset(0);
        make.right.mas_equalTo(ConfirmBtn.mas_left).with.offset(-16);
        make.height.mas_equalTo(self);
    }];
    
}
#pragma mark - SomeAction
/**
 * 全选
 */
-(void)chooseAction
{
    if(selectBtn.selected)
    {
        selectBtn.selected=NO;
        _block(@"cancel_all");
    }else
    {
        selectBtn.selected=YES;
        _block(@"select_all");
    }
}
/**
 * 结算
 */
-(void)ConfirmAction
{
    _block(@"confirm");
}
#pragma mark - SetState
-(void)SetState
{
    price_label.text=[DD_ShopTool getAllPriceWithModel:_shopModel];
    if([DD_ShopTool selectAllWithModel:_shopModel])
    {
        selectBtn.selected=YES;
    }else
    {
        selectBtn.selected=NO;
    }
}
@end
