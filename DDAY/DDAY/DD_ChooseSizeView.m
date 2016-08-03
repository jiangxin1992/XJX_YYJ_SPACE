//
//  DD_ChooseSizeView.m
//  DDAY
//
//  Created by yyj on 16/5/24.
//  Copyright © 2016年 YYJ. All rights reserved.
//
#import "DD_SizeModel.h"
#import "DD_ChooseSizeView.h"

@implementation DD_ChooseSizeView
{
    NSMutableArray *_sizeBtnArr;
    NSString *_sizeID;
    NSInteger _count;
    UIButton *countBtn;
}

#pragma mark - 初始化
-(instancetype)initWithSizeArr:(NSArray *)sizeArr WithColorID:(NSString *)colorID WithBlock:(void (^)(NSString *type,NSString *sizeid,NSString *colorid,NSInteger count))block
{
    
    self=[super init];
    if(self)
    {
        _sizeArr=sizeArr;
        _block=block;
        _colorid=colorID;
        [self SomePrepare];
        [self UIConfig];
    }
    return self;
}
-(void)NULLAction
{
    
}
#pragma mark - SomePrepare
-(void)SomePrepare
{
    [self PrepareData];
    [self PrepareUI];
}
-(void)PrepareData
{
    _sizeBtnArr=[[NSMutableArray alloc] init];
    _sizeID=@"";
    _count=1;
}
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
        make.left.mas_equalTo(26);
        make.right.mas_equalTo(-26);
        make.height.mas_equalTo(5);
        make.top.mas_equalTo(IsPhone6_gt?31:18);
    }];
    
    
    UIView *lastView=nil;
    for (int i=0; i<_sizeArr.count; i++) {
        DD_SizeModel *_sizeModel=[_sizeArr objectAtIndex:i];
        UIButton *_btn=[UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_btn];
//        40 20
        if(_sizeModel.stock)
        {
            [_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            _btn.backgroundColor=[UIColor whiteColor];
            _btn.userInteractionEnabled=YES;
            _btn.layer.masksToBounds=YES;
            _btn.layer.borderColor=[[UIColor blackColor] CGColor];
            _btn.layer.borderWidth=1;
        }else
        {
            [_btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            _btn.backgroundColor=[UIColor colorWithRed:250.0f/255.0f green:250.0f/255.0f blue:250.0f/255.0f alpha:1];
            _btn.userInteractionEnabled=NO;
        }
        [_btn setTitle:_sizeModel.sizeName forState:UIControlStateNormal];
        [_btn setTitle:_sizeModel.sizeName forState:UIControlStateSelected];
        [_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [_sizeBtnArr addObject:_btn];
        _btn.tag=100+i;
        [_btn addTarget:self action:@selector(chooseSizeAction:) forControlEvents:UIControlEventTouchUpInside];
        [_btn mas_makeConstraints:^(MASConstraintMaker *make) {
            if(lastView)
            {
                make.left.mas_equalTo(lastView.mas_right).with.offset(15);
            }else
            {
                make.left.mas_equalTo(26);
            }
            make.top.mas_equalTo(upLine.mas_bottom).with.offset(IsPhone6_gt?23:13);
            make.width.mas_equalTo(41);
            make.height.mas_equalTo(22);
        }];
        lastView=_btn;
    }
    
    UIButton *subtract=[UIButton getCustomImgBtnWithImageStr:@"System_Subtract" WithSelectedImageStr:nil];
    [self addSubview:subtract];
    [subtract addTarget:self action:@selector(subtractAction) forControlEvents:UIControlEventTouchUpInside];
    [subtract mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(26);
        make.width.and.height.mas_equalTo(22);
        make.top.mas_equalTo(lastView.mas_bottom).with.offset(IsPhone6_gt?23:13);
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

    
    UIView *downLine=[UIView getCustomViewWithColor:_define_black_color];
    [self addSubview:downLine];
    [downLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(26);
        make.right.mas_equalTo(-26);
        make.height.mas_equalTo(1);
        make.top.mas_equalTo(subtract.mas_bottom).with.offset(IsPhone6_gt?23:13);
    }];
    
    
    UIButton * buy=[UIButton getCustomTitleBtnWithAlignment:0 WithFont:18.0f WithSpacing:0 WithNormalTitle:@"结   算" WithNormalColor:_define_white_color WithSelectedTitle:nil WithSelectedColor:nil];
    [self addSubview:buy];
    buy.backgroundColor=_define_black_color;
    [buy addTarget:self action:@selector(buyAction) forControlEvents:UIControlEventTouchUpInside];
    [buy mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-26);
        make.top.mas_equalTo(downLine.mas_bottom).with.offset(15);
        make.width.mas_equalTo(IsPhone6_gt?115:95);
        make.height.mas_equalTo(45);
    }];
    
    
    UIButton * shop=[UIButton getCustomTitleBtnWithAlignment:0 WithFont:18.0f WithSpacing:0 WithNormalTitle:@"加入购物车" WithNormalColor:_define_white_color WithSelectedTitle:nil WithSelectedColor:nil];
    [self addSubview:shop];
    [shop addTarget:self action:@selector(shopAction) forControlEvents:UIControlEventTouchUpInside];
    shop.backgroundColor=_define_black_color;
    [shop mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(buy.mas_left).with.offset(-(IsPhone6_gt?59:43));
        make.top.mas_equalTo(buy);
        make.height.mas_equalTo(buy);
        make.left.mas_equalTo(26);
    }];
}

-(void)addAction
{
    if([_sizeID isEqualToString:@""])
    {
        _count++;
        [countBtn setTitle:[[NSString alloc] initWithFormat:@"%ld",_count] forState:UIControlStateNormal];
    }else
    {
        DD_SizeModel *sizeModel=[_sizeArr objectAtIndex:[self getSelectSize]];
        if(_count<sizeModel.stock)
        {
            _count++;
            [countBtn setTitle:[[NSString alloc] initWithFormat:@"%ld",_count] forState:UIControlStateNormal];
        }else
        {
            _block(@"stock_warning",_sizeID,_colorid,_count);
        }
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
-(void)buyAction
{
    _block(@"buy",_sizeID,_colorid,_count);
}
-(void)shopAction
{
    _block(@"shop",_sizeID,_colorid,_count);
}

/**
 * 0表示没有选中尺寸
 * 大于0表示有选中尺寸
 */
-(NSInteger )getSelectSize
{
    for (int i=0; i<_sizeBtnArr.count; i++) {
        UIButton *_btn=[_sizeBtnArr objectAtIndex:i];
        if(_btn.selected)
        {
            return i;
        }
    }
    return 0;
}
-(void)chooseSizeAction:(UIButton *)btn
{
    NSInteger _index=btn.tag-100;
    for (int i=0; i<_sizeBtnArr.count; i++) {
        UIButton *_btn=[_sizeBtnArr objectAtIndex:i];
        if(_index==i)
        {
            DD_SizeModel *_sizeModel=[_sizeArr objectAtIndex:i];
            if(_btn.selected)
            {
                _btn.selected=NO;
                _sizeID=@"";
                [_btn setBackgroundColor:[UIColor whiteColor]];
            }else
            {
                _btn.selected=YES;
                _sizeID=_sizeModel.sizeId;
                [_btn setBackgroundColor:[UIColor blackColor]];
                if(_count>_sizeModel.stock)
                {
                    _count=_sizeModel.stock;
                    [countBtn setTitle:[[NSString alloc] initWithFormat:@"%ld",_count] forState:UIControlStateNormal];
                }
            }
            
        }else
        {
            _btn.selected=NO;
            [_btn setBackgroundColor:[UIColor whiteColor]];
        }
    }
}

//-(void)CreateBuyShopBtn
//{
//    
//    UIButton *buyBtn=[UIButton buttonWithType:UIButtonTypeCustom];
//    [self addSubview:buyBtn];
//    buyBtn.frame=CGRectMake(0, 360, 300, 40);
//    [buyBtn setBackgroundColor:[UIColor blackColor]];
//    NSString *_title=nil;
//    if([_type isEqualToString:@"shop"])
//    {
//        _title=@"加入购物车";
//    }else if([_type isEqualToString:@"buy"])
//    {
//        _title=@"立即购买";
//    }else if([_type isEqualToString:@"alert"])
//    {
//        _title=@"确定";
//    }
//    [buyBtn setTitle:_title forState:UIControlStateNormal];
//    [buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [buyBtn addTarget:self action:@selector(shop_buy_action) forControlEvents:UIControlEventTouchUpInside];
//    
//}
@end
