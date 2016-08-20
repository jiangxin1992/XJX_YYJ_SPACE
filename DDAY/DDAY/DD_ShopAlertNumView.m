//
//  DD_ShopAlertNumView.m
//  YCO SPACE
//
//  Created by yyj on 16/8/2.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_ShopAlertNumView.h"

#import "DD_SizeModel.h"

@implementation DD_ShopAlertNumView
{
    NSInteger _count;   
    UIButton *countBtn;
}

#pragma mark - 初始化
-(instancetype)initWithSizeArr:(NSArray *)sizeArr WithItem:(DD_ShopItemModel *)ItemModel WithBlock:(void (^)(NSString *type,NSInteger count))block
{
    
    self=[super init];
    if(self)
    {
        _sizeArr=sizeArr;
        _block=block;
        _ItemModel=ItemModel;
        _count=[_ItemModel.number integerValue];
        [self SomePrepare];
        [self UIConfig];
    }
    return self;
}
-(void)NULLAction{}
#pragma mark - SomePrepare
-(void)SomePrepare
{
    [self PrepareData];
    [self PrepareUI];
}
-(void)PrepareData{}
-(void)PrepareUI
{
    self.userInteractionEnabled=YES;
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(NULLAction)]];
    self.backgroundColor=_define_white_color;
}
#pragma mark - UIConfig
-(void)UIConfig
{
    UIView *upLine=[UIView getCustomViewWithColor:_define_black_color];
    [self addSubview:upLine];
    [upLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kEdge);
        make.right.mas_equalTo(-kEdge);
        make.height.mas_equalTo(5);
        make.top.mas_equalTo(IsPhone6_gt?31:18);
    }];
    
    UIButton *subtract=[UIButton getCustomImgBtnWithImageStr:@"System_Subtract" WithSelectedImageStr:nil];
    [self addSubview:subtract];
    [subtract addTarget:self action:@selector(subtractAction) forControlEvents:UIControlEventTouchUpInside];
    [subtract mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kEdge);
        make.width.and.height.mas_equalTo(22);
        make.top.mas_equalTo(upLine.mas_bottom).with.offset(IsPhone6_gt?23:13);
    }];
    
    countBtn=[UIButton getCustomTitleBtnWithAlignment:0 WithFont:17.0f WithSpacing:0 WithNormalTitle:[[NSString alloc] initWithFormat:@"%ld",_count] WithNormalColor:_define_black_color WithSelectedTitle:nil WithSelectedColor:nil];
    [self addSubview:countBtn];
    [regular setBorder:countBtn];
    [countBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(subtract.mas_right).with.offset(10);
        make.top.mas_equalTo(subtract);
        make.height.mas_equalTo(subtract);
        make.width.mas_equalTo(90);
    }];
    
    UIButton *add=[UIButton getCustomImgBtnWithImageStr:@"System_Add" WithSelectedImageStr:nil];
    [self addSubview:add];
    [add addTarget:self action:@selector(addAction) forControlEvents:UIControlEventTouchUpInside];
    [add mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(countBtn.mas_right).with.offset(10);
        make.width.and.height.mas_equalTo(22);
        make.top.mas_equalTo(subtract);
    }];
    
    
//    UIView *downLine=[UIView getCustomViewWithColor:_define_black_color];
//    [self addSubview:downLine];
//    [downLine mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(kEdge);
//        make.right.mas_equalTo(-kEdge);
//        make.height.mas_equalTo(1);
//        make.top.mas_equalTo(subtract.mas_bottom).with.offset(IsPhone6_gt?23:13);
//    }];
    
    
    UIButton * confirmBtn=[UIButton getCustomTitleBtnWithAlignment:0 WithFont:18.0f WithSpacing:0 WithNormalTitle:@"确   定" WithNormalColor:_define_white_color WithSelectedTitle:nil WithSelectedColor:nil];
    [self addSubview:confirmBtn];
    confirmBtn.backgroundColor=_define_black_color;
    [confirmBtn addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(subtract.mas_bottom).with.offset(15);
        make.right.mas_equalTo(-kEdge);
        make.left.mas_equalTo(kEdge);
        make.height.mas_equalTo(45);
    }];
}

-(void)addAction
{
    DD_SizeModel *sizeModel=[self getSizeModel];
    if(_count<sizeModel.stock)
    {
        _count++;
        [countBtn setTitle:[[NSString alloc] initWithFormat:@"%ld",_count] forState:UIControlStateNormal];
    }else
    {
        _block(@"stock_warning",_count);
    }
}
-(void)subtractAction
{
    if(_count>1)
    {
        _count--;
        [countBtn setTitle:[[NSString alloc] initWithFormat:@"%ld",_count] forState:UIControlStateNormal];
    }
    
}
-(void)confirmAction
{
    _block(@"alert",_count);
}
-(DD_SizeModel *)getSizeModel
{
    for (DD_SizeModel *sizemodel in _sizeArr) {
        if([sizemodel.sizeId isEqualToString:_ItemModel.sizeId])
        {
            return sizemodel;
        }
    }
    return nil;
}

@end
