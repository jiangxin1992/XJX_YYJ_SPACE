//
//  DD_ChooseSizeView.m
//  DDAY
//
//  Created by yyj on 16/5/24.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_ChooseSizeView.h"

#import "DD_SizeModel.h"
#import "DD_ColorsModel.h"
#import "DD_SizeAlertModel.h"

@implementation DD_ChooseSizeView
{
    NSMutableArray *_sizeBtnArr;
    NSString *_sizeID;
    NSInteger _count;
    UIButton *countBtn;
}

#pragma mark - 初始化
-(instancetype)initWithColorModel:(DD_ColorsModel *)colorModel WithSizeAlertModel:(DD_SizeAlertModel *)sizeAlertModel WithBlock:(void (^)(NSString *type,NSString *sizeid,NSString *colorid,NSInteger count))block
{
    
    self=[super init];
    if(self)
    {
        _SizeAlertModel=sizeAlertModel;
        _sizeArr=sizeAlertModel.size;
        _sizeID=colorModel.colorId;
        _block=block;
        _ColorsModel=colorModel;
        [self SomePrepare];
        [self UIConfig];
    }
    return self;
}
//-(void)NULLAction
//{
//    
//}
+(CGFloat )getHeightWithColorModel:(DD_ColorsModel *)colorModel WithSizeAlertModel:(DD_SizeAlertModel *)sizeAlertModel
{
    DD_ChooseSizeView *_sizeView = [[DD_ChooseSizeView alloc] initWithColorModel:colorModel WithSizeAlertModel:sizeAlertModel WithBlock:^(NSString *type, NSString *sizeid, NSString *colorid, NSInteger count) {
        
    }];
    [_sizeView layoutIfNeeded];
    CGRect frame =  _sizeView.shop.frame;
    return frame.origin.y + frame.size.height;
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
//    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(NULLAction)]];
    [self bk_whenTapped:^{
//        NULLAction
    }];
    self.backgroundColor=_define_white_color;
}
#pragma mark - UIConfig
-(void)UIConfig
{
    
    UIView *lastView=nil;
    // 间距为10
    int intes = 10;
    int num = 0;
    CGFloat _x_p=kEdge;
    for (int i=0; i<_sizeArr.count; i++) {
        DD_SizeModel *_sizeModel=_sizeArr[i];
        UIButton *_btn=[UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_btn];
        _btn.titleLabel.font=[regular getFont:15.0f];
//        42 20
        if(_sizeModel.stock)
        {
            [_btn setTitleColor:_define_black_color forState:UIControlStateNormal];
            _btn.backgroundColor=_define_white_color;
            _btn.userInteractionEnabled=YES;
            _btn.layer.masksToBounds=YES;
            _btn.layer.borderColor=[_define_black_color CGColor];
            _btn.layer.borderWidth=1;
        }else
        {
            
            [_btn setTitleColor:_define_light_gray_color1 forState:UIControlStateNormal];
            _btn.backgroundColor=_define_white_color;
            _btn.userInteractionEnabled=YES;
        }
        [_btn setTitle:_sizeModel.sizeName forState:UIControlStateNormal];
        [_btn setTitle:_sizeModel.sizeName forState:UIControlStateSelected];
        [_btn setTitleColor:_define_white_color forState:UIControlStateSelected];
        [_sizeBtnArr addObject:_btn];
        _btn.tag=100+i;
        [_btn addTarget:self action:@selector(chooseSizeAction:) forControlEvents:UIControlEventTouchUpInside];
        
        CGFloat __width=[regular getWidthWithHeight:28 WithContent:_sizeModel.sizeName WithFont:[regular getFont:13.0f]]+25;
        if((_x_p+__width+intes)>ScreenWidth-kEdge)
        {
            num++;
            _x_p=kEdge;
        }
        
        [_btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_btn.superview).offset(40+35*num);
            make.left.mas_equalTo(_x_p);
            make.width.mas_equalTo(__width);
            make.height.mas_equalTo(28);
        }];
        if((_x_p+__width+intes)>ScreenWidth-kEdge)
        {
        }else
        {
            _x_p+=__width+intes;
        }
        lastView=_btn;
    }
    
    UIImageView *sizeBriefImg=nil;
    
    if(_SizeAlertModel.sizeBriefPic&&![_SizeAlertModel.sizeBriefPic isEqualToString:@""])
    {
        CGFloat _h = _SizeAlertModel.sizeBriefPicHeight;
        CGFloat _w = _SizeAlertModel.sizeBriefPicWidth;
        CGFloat _imgHeight=(_h/_w)*(ScreenWidth-kEdge*2);
        sizeBriefImg=[UIImageView getCustomImg];
        [self addSubview:sizeBriefImg];
        sizeBriefImg.contentMode=2;
        [regular setZeroBorder:sizeBriefImg];
        [sizeBriefImg JX_ScaleAspectFill_loadImageUrlStr:_SizeAlertModel.sizeBriefPic WithSize:800 placeHolderImageName:nil radius:0];
        [sizeBriefImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(kEdge);
            make.right.mas_equalTo(-kEdge);
            make.top.mas_equalTo(lastView.mas_bottom).with.offset(IsPhone6_gt?25:15);
            make.height.mas_equalTo(_imgHeight);
        }];
    }
    
    UIButton *subtract=[UIButton getCustomImgBtnWithImageStr:@"System_Subtract" WithSelectedImageStr:nil];
    [self addSubview:subtract];
    [subtract addTarget:self action:@selector(subtractAction) forControlEvents:UIControlEventTouchUpInside];
    [subtract mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kEdge);
        make.width.and.height.mas_equalTo(20);
        if(sizeBriefImg)
        {
            make.top.mas_equalTo(sizeBriefImg.mas_bottom).with.offset(IsPhone6_gt?25:15);
        }else
        {
            make.top.mas_equalTo(lastView.mas_bottom).with.offset(IsPhone6_gt?25:15);
        }
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

    
    
    _shop=[UIButton getCustomTitleBtnWithAlignment:0 WithFont:18.0f WithSpacing:0 WithNormalTitle:@"加入购物车" WithNormalColor:nil WithSelectedTitle:nil WithSelectedColor:nil];
    [self addSubview:_shop];
    _shop.backgroundColor=_define_white_color;
    [_shop addTarget:self action:@selector(shopAction) forControlEvents:UIControlEventTouchUpInside];
    [_shop mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(add.mas_bottom).with.offset(IsPhone6_gt?25:15);
        make.left.mas_equalTo(0);
        make.height.mas_equalTo(ktabbarHeight);
        make.width.mas_equalTo(ScreenWidth/2.0f);
    }];
    
    UIView *lineView=[UIView getCustomViewWithColor:_define_black_color];
    [_shop addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.left.right.top.mas_equalTo(0);
    }];
    
    UIButton * buy=[UIButton getCustomTitleBtnWithAlignment:0 WithFont:18.0f WithSpacing:0 WithNormalTitle:@"结   算" WithNormalColor:_define_white_color WithSelectedTitle:nil WithSelectedColor:nil];
    [self addSubview:buy];
    buy.backgroundColor=_define_black_color;
    [buy addTarget:self action:@selector(buyAction) forControlEvents:UIControlEventTouchUpInside];
    [buy mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(_shop);
        make.height.mas_equalTo(_shop);
        make.width.mas_equalTo(ScreenWidth/2.0f);
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
        DD_SizeModel *sizeModel=_sizeArr[[self getSelectSize]];
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
        UIButton *_btn=_sizeBtnArr[i];
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
    DD_SizeModel *_sizeModel=_sizeArr[_index];
    if(_sizeModel.stock)
    {
        for (int i=0; i<_sizeBtnArr.count; i++) {
            UIButton *_btn=_sizeBtnArr[i];
            if(_index==i)
            {
                if(_btn.selected)
                {
                    _btn.selected=NO;
                    _sizeID=@"";
                    [_btn setBackgroundColor:_define_white_color];
                }else
                {
                    _btn.selected=YES;
                    _sizeID=_sizeModel.sizeId;
                    [_btn setBackgroundColor:_define_black_color];
                    if(_count>_sizeModel.stock)
                    {
                        _count=_sizeModel.stock;
                        [countBtn setTitle:[[NSString alloc] initWithFormat:@"%ld",_count] forState:UIControlStateNormal];
                    }
                }
            }else
            {
                _btn.selected=NO;
                [_btn setBackgroundColor:_define_white_color];
            }
        }
    }else
    {
        _block(@"no_stock",_sizeID,_colorid,_count);
    }
    
    
}

//-(void)CreateBuyShopBtn
//{
//    
//    UIButton *buyBtn=[UIButton buttonWithType:UIButtonTypeCustom];
//    [self addSubview:buyBtn];
//    buyBtn.frame=CGRectMake(0, 360, 300, 40);
//    [buyBtn setBackgroundColor:_define_black_color];
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
//    [buyBtn setTitleColor:_define_white_color forState:UIControlStateNormal];
//    [buyBtn addTarget:self action:@selector(shop_buy_action) forControlEvents:UIControlEventTouchUpInside];
//    
//}
@end
