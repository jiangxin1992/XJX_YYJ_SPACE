//
//  DD_ShopAlertSizeView.m
//  YCO SPACE
//
//  Created by yyj on 16/8/2.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_ShopAlertSizeView.h"

#import "DD_SizeModel.h"

@implementation DD_ShopAlertSizeView
{
    NSMutableArray *_sizeBtnArr;
    NSString *_sizeID;
    NSString *_sizeName;
    NSInteger _count;
    
}

#pragma mark - 初始化
-(instancetype)initWithSizeAlertModel:(DD_SizeAlertModel *)SizeAlertModel WithItem:(DD_ShopItemModel *)ItemModel WithBlock:(void (^)(NSString *type,NSString *sizeId,NSString *sizeName,NSInteger count))block
{
    
    self=[super init];
    if(self)
    {
        _SizeAlertModel=SizeAlertModel;
        _block=block;
        _ItemModel=ItemModel;
        _sizeID=_ItemModel.sizeId;
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
-(void)PrepareData
{
    _sizeBtnArr=[[NSMutableArray alloc] init];
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
    
    UIView *lastView=nil;
    for (int i=0; i<_SizeAlertModel.size.count; i++) {
        DD_SizeModel *_sizeModel=[_SizeAlertModel.size objectAtIndex:i];
        UIButton *_btn=[UIButton getCustomTitleBtnWithAlignment:0 WithFont:17.0f WithSpacing:0 WithNormalTitle:_sizeModel.sizeName WithNormalColor:nil WithSelectedTitle:_sizeModel.sizeName WithSelectedColor:_define_white_color];
        [self addSubview:_btn];
        
        if(_sizeModel.stock)
        {
            [_btn setTitleColor:_define_black_color forState:UIControlStateNormal];
            _btn.backgroundColor=_define_white_color;
            _btn.userInteractionEnabled=YES;
            [regular setBorder:_btn];
            if([_sizeModel.sizeId isEqualToString:_ItemModel.sizeId])
            {
                _btn.selected=YES;
                [_btn setBackgroundColor:_define_black_color];
                
            }else
            {
                _btn.selected=NO;
                [_btn setBackgroundColor:_define_white_color];
            }
        }else
        {
            [_btn setTitleColor:_define_light_gray_color1 forState:UIControlStateNormal];
            _btn.backgroundColor=_define_white_color;
            _btn.userInteractionEnabled=YES;
        }
        [_sizeBtnArr addObject:_btn];
        _btn.tag=100+i;
        [_btn addTarget:self action:@selector(chooseSizeAction:) forControlEvents:UIControlEventTouchUpInside];
        [_btn mas_makeConstraints:^(MASConstraintMaker *make) {
            if(lastView)
            {
                make.left.mas_equalTo(lastView.mas_right).with.offset(23);
            }else
            {
                make.left.mas_equalTo(kEdge);
            }
            make.top.mas_equalTo(IsPhone6_gt?25:15);
            make.width.mas_equalTo(28);
            make.height.mas_equalTo(28);
        }];
        lastView=_btn;
    }
    
    UIImageView *sizeBriefImg=nil;
    if(_SizeAlertModel.sizeBriefPic&&![_SizeAlertModel.sizeBriefPic isEqualToString:@""])
    {
        CGFloat _imgHeight=(((CGFloat)_SizeAlertModel.sizeBriefPicHeight)/((CGFloat)_SizeAlertModel.sizeBriefPicWidth))*(ScreenWidth-kEdge*2);
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
    
    UIButton * confirmBtn=[UIButton getCustomTitleBtnWithAlignment:0 WithFont:18.0f WithSpacing:0 WithNormalTitle:@"确   定" WithNormalColor:_define_white_color WithSelectedTitle:nil WithSelectedColor:nil];
    [self addSubview:confirmBtn];
    confirmBtn.backgroundColor=_define_black_color;
    [confirmBtn addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        if(sizeBriefImg)
        {
            make.top.mas_equalTo(sizeBriefImg.mas_bottom).with.offset(IsPhone6_gt?25:15);
        }else
        {
            make.top.mas_equalTo(lastView.mas_bottom).with.offset(IsPhone6_gt?25:15);
        }
//        make.right.mas_equalTo(-kEdge);
//        make.left.mas_equalTo(kEdge);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(ktabbarHeight);
    }];
}
-(void)confirmAction
{
    if([_sizeID isEqualToString:_ItemModel.sizeId])
    {
        _block(@"no_alert",_sizeID,_sizeName,_count);
    }else
    {
        _block(@"alert",_sizeID,_sizeName,_count);
    }
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
    
    DD_SizeModel *_sizeModel=[_SizeAlertModel.size objectAtIndex:_index];
    if(_sizeModel.stock)
    {
        for (int i=0; i<_sizeBtnArr.count; i++) {
            UIButton *_btn=[_sizeBtnArr objectAtIndex:i];
            if(_index==i)
            {
                DD_SizeModel *_sizeModel=[_SizeAlertModel.size objectAtIndex:i];
                if(_btn.selected)
                {
                    _btn.selected=NO;
                    _sizeID=@"";
                    _sizeName=@"";
                    _count=0;
                    [_btn setBackgroundColor:_define_white_color];
                }else
                {
                    _btn.selected=YES;
                    _sizeID=_sizeModel.sizeId;
                    _sizeName=_sizeModel.sizeName;
                    [_btn setBackgroundColor:_define_black_color];
                    if(_count>_sizeModel.stock)
                    {
                        _count=_sizeModel.stock;
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
        _block(@"no_stock",_sizeID,_sizeName,_count);
    }
    
    
}


@end
