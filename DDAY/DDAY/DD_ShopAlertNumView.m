//
//  DD_ShopAlertNumView.m
//  YCO SPACE
//
//  Created by yyj on 16/8/2.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_ShopAlertNumView.h"

#import "DD_SizeModel.h"
#import "DD_ShopItemModel.h"

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
//-(void)NULLAction{}
+(CGFloat )getHeightWithSizeArr:(NSArray *)sizeArr WithItem:(DD_ShopItemModel *)ItemModel
{
    DD_ShopAlertNumView *_sizeView = [[DD_ShopAlertNumView alloc] initWithSizeArr:sizeArr WithItem:ItemModel WithBlock:^(NSString *type, NSInteger count) {
        
    }];
    [_sizeView layoutIfNeeded];
    CGRect frame =  _sizeView.confirmBtn.frame;
    return frame.origin.y + frame.size.height;
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
    self.userInteractionEnabled=YES;
//    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(NULLAction)]];
    [self bk_whenTapped:^{
//        NULLAction
    }];
    self.backgroundColor=_define_white_color;
}
#pragma mark - UIConfig
-(void)UIConfig
{    
    UIButton *subtract=[UIButton getCustomImgBtnWithImageStr:@"System_Subtract" WithSelectedImageStr:nil];
    [self addSubview:subtract];
    [subtract addTarget:self action:@selector(subtractAction) forControlEvents:UIControlEventTouchUpInside];
    [subtract mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kEdge);
        make.width.and.height.mas_equalTo(20);
        make.top.mas_equalTo(IsPhone6_gt?25:15);
    }];
    
    countBtn=[UIButton getCustomTitleBtnWithAlignment:0 WithFont:17.0f WithSpacing:0 WithNormalTitle:[[NSString alloc] initWithFormat:@"%ld",_count] WithNormalColor:_define_black_color WithSelectedTitle:nil WithSelectedColor:nil];
    [self addSubview:countBtn];
    [regular setBorder:countBtn];
    [countBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(subtract.mas_right).with.offset(13);
        make.top.mas_equalTo(subtract);
        make.height.mas_equalTo(subtract);
        make.width.mas_equalTo(70);
    }];
    
    UIButton *add=[UIButton getCustomImgBtnWithImageStr:@"System_Add" WithSelectedImageStr:nil];
    [self addSubview:add];
    [add addTarget:self action:@selector(addAction) forControlEvents:UIControlEventTouchUpInside];
    [add mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(countBtn.mas_right).with.offset(13);
        make.width.and.height.mas_equalTo(20);
        make.top.mas_equalTo(subtract);
    }];
    
    
    _confirmBtn=[UIButton getCustomTitleBtnWithAlignment:0 WithFont:18.0f WithSpacing:0 WithNormalTitle:@"确   定" WithNormalColor:_define_white_color WithSelectedTitle:nil WithSelectedColor:nil];
    [self addSubview:_confirmBtn];
    _confirmBtn.backgroundColor=_define_black_color;
    [_confirmBtn addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
    [_confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(subtract.mas_bottom).with.offset(IsPhone6_gt?25:15);
//        make.right.mas_equalTo(-kEdge);
//        make.left.mas_equalTo(kEdge);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(ktabbarHeight);
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
    __block DD_SizeModel *getSizeModel=nil;
    [_sizeArr enumerateObjectsUsingBlock:^(DD_SizeModel *sizemodel, NSUInteger idx, BOOL * _Nonnull stop) {
        if([sizemodel.sizeId isEqualToString:_ItemModel.sizeId])
        {
            getSizeModel=sizemodel;
            *stop=YES;
        }
    }];
    return getSizeModel;
}

@end
