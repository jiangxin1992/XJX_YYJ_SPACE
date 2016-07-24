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
}

#pragma mark - 初始化
-(instancetype)initWithFrame:(CGRect)frame WithSizeArr:(NSArray *)sizeArr WithColorID:(NSString *)colorID WithType:(NSString *)type WithBlock:(void (^)(NSString *type,NSString *sizeid,NSString *colorid))block
{
    self=[super initWithFrame:frame];
    if(self)
    {
        _type=type;
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
}
-(void)PrepareUI
{
    self.userInteractionEnabled=YES;
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(NULLAction)]];
    self.backgroundColor=[UIColor whiteColor];
}
#pragma mark - UIConfig
-(void)UIConfig
{
    [self CreateChooseSizeView];
    [self CreateSizeIntroduceView];
    [self CreateBuyShopBtn];
}
-(void)CreateBuyShopBtn
{
    
    UIButton *buyBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:buyBtn];
    buyBtn.frame=CGRectMake(0, 360, 300, 40);
    [buyBtn setBackgroundColor:[UIColor blackColor]];
    NSString *_title=nil;
    if([_type isEqualToString:@"shop"])
    {
        _title=@"加入购物车";
    }else if([_type isEqualToString:@"buy"])
    {
        _title=@"立即购买";
    }else if([_type isEqualToString:@"alert"])
    {
        _title=@"确定";
    }
    [buyBtn setTitle:_title forState:UIControlStateNormal];
    [buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buyBtn addTarget:self action:@selector(shop_buy_action) forControlEvents:UIControlEventTouchUpInside];

}
-(void)shop_buy_action
{
    _block(_type,_sizeID,_colorid);
}
-(void)CreateSizeIntroduceView
{
    
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(10, 90,280, 40)];
    [self addSubview:label];
    label.textColor=[UIColor blackColor];
    label.textAlignment=0;
    label.text=@"尺码说明";
    UIImageView *image=[[UIImageView alloc] initWithFrame:CGRectMake(10, 140, 280, 200)];
    [self addSubview:image];
    [image JX_loadImageUrlStr:@"http://source.yunejian.com/ufile/20160513/58d43a6108aa42d8a957e4f47e16951a" WithSize:800 placeHolderImageName:nil radius:0];
}
-(void)CreateChooseSizeView
{
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(10, 10,280, 40)];
    [self addSubview:label];
    label.textColor=[UIColor blackColor];
    label.textAlignment=0;
    label.text=@"选择尺码";
    
    for (int i=0; i<_sizeArr.count; i++) {
        DD_SizeModel *_sizeModel=[_sizeArr objectAtIndex:i];
        UIButton *_btn=[UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_btn];
        _btn.frame=CGRectMake(10+70*i, 60, 60, 30);
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
    }
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
            }
            
        }else
        {
            _btn.selected=NO;
            [_btn setBackgroundColor:[UIColor whiteColor]];
        }
    }
    

}

@end
