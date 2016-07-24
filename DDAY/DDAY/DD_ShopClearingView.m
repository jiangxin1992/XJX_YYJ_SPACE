//
//  DD_ShopClearingView.m
//  DDAY
//
//  Created by yyj on 16/5/30.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_ShopClearingView.h"

@implementation DD_ShopClearingView
{
    UIButton *selectBtn;
    UILabel *price_label;
    UIButton *ConfirmBtn;
}
#pragma mark - 初始化
-(instancetype)initWithFrame:(CGRect)frame WithShopModel:(DD_ShopModel *)shopModel WithBlock:(void (^)(NSString *))block
{
    self=[super initWithFrame:frame];
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
    
    selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:selectBtn];
    selectBtn.frame=CGRectMake(0, 0, 70, ktabbarHeight);
    [selectBtn addTarget:self action:@selector(chooseAction) forControlEvents:UIControlEventTouchUpInside];
    selectBtn.titleLabel.font=[regular getFont:13.0f];
    [selectBtn setTitle:@"全选" forState:UIControlStateNormal];
    [selectBtn setTitle:@"取消全选" forState:UIControlStateSelected];
    [selectBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [selectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    
    price_label=[[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-300, 0, 190, ktabbarHeight)];
    [self addSubview:price_label];
    price_label.textAlignment=2;
    price_label.textColor=[UIColor blackColor];
    
    
    ConfirmBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    ConfirmBtn.frame=CGRectMake(ScreenWidth-100, 0, 100, ktabbarHeight);
    [self addSubview:ConfirmBtn];
    [ConfirmBtn addTarget:self action:@selector(ConfirmAction) forControlEvents:UIControlEventTouchUpInside];
    ConfirmBtn.backgroundColor=[UIColor blackColor];
    [ConfirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [ConfirmBtn setTitle:@"结算" forState:UIControlStateNormal];
    
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
}
@end
