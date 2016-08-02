//
//  DD_ShopAlertSizeView.m
//  YCO SPACE
//
//  Created by yyj on 16/8/2.
//  Copyright © 2016年 YYJ. All rights reserved.
//
#import "DD_SizeModel.h"
#import "DD_ShopAlertSizeView.h"

@implementation DD_ShopAlertSizeView
{
    NSMutableArray *_sizeBtnArr;
    NSString *_sizeID;
    NSString *_sizeName;
    NSInteger _count;
    
}

#pragma mark - 初始化
-(instancetype)initWithSizeArr:(NSArray *)sizeArr WithItem:(DD_ShopItemModel *)ItemModel WithBlock:(void (^)(NSString *type,NSString *sizeId,NSString *sizeName,NSInteger count))block
{
    
    self=[super init];
    if(self)
    {
        _sizeArr=sizeArr;
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
        UIButton *_btn=[UIButton getCustomTitleBtnWithAlignment:0 WithFont:17.0f WithSpacing:0 WithNormalTitle:_sizeModel.sizeName WithNormalColor:nil WithSelectedTitle:_sizeModel.sizeName WithSelectedColor:_define_white_color];
        [self addSubview:_btn];
        
        if(_sizeModel.stock)
        {
            [_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            _btn.backgroundColor=[UIColor whiteColor];
            _btn.userInteractionEnabled=YES;
            [regular setBorder:_btn];
            if([_sizeModel.sizeId isEqualToString:_ItemModel.sizeId])
            {
                _btn.selected=YES;
                [_btn setBackgroundColor:[UIColor blackColor]];
                
            }else
            {
                _btn.selected=NO;
                [_btn setBackgroundColor:[UIColor whiteColor]];
            }
        }else
        {
            [_btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            _btn.backgroundColor=_define_light_gray_color2;
            _btn.userInteractionEnabled=NO;
        }
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
    
    DD_SizeModel *_sizeModel=[_sizeArr objectAtIndex:0];
    CGFloat _imgHeight=(((CGFloat)_sizeModel.sizeBriefPicHeight)/((CGFloat)_sizeModel.sizeBriefPicWidth))*(ScreenWidth-26*2);
    UIImageView *sizeBriefImg=[UIImageView getCustomImg];
    [self addSubview:sizeBriefImg];
    [sizeBriefImg JX_loadImageUrlStr:_sizeModel.sizeBrief WithSize:800 placeHolderImageName:nil radius:0];
    [sizeBriefImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(26);
        make.right.mas_offset(-26);
        make.top.mas_equalTo(lastView.mas_bottom).with.offset(IsPhone6_gt?23:13);
        make.height.mas_offset(_imgHeight);
    }];
    
    UIView *downLine=[UIView getCustomViewWithColor:_define_black_color];
    [self addSubview:downLine];
    [downLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(26);
        make.right.mas_equalTo(-26);
        make.height.mas_equalTo(1);
        make.top.mas_equalTo(sizeBriefImg.mas_bottom).with.offset(IsPhone6_gt?23:13);
    }];
    
    UIButton * confirmBtn=[UIButton getCustomTitleBtnWithAlignment:0 WithFont:18.0f WithSpacing:0 WithNormalTitle:@"确   定" WithNormalColor:_define_white_color WithSelectedTitle:nil WithSelectedColor:nil];
    [self addSubview:confirmBtn];
    confirmBtn.backgroundColor=_define_black_color;
    [confirmBtn addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(downLine.mas_bottom).with.offset(15);
        make.right.mas_equalTo(-26);
        make.left.mas_equalTo(26);
        make.height.mas_equalTo(45);
    }];
}
-(void)confirmAction
{
    if([_sizeID isEqualToString:_ItemModel.sizeId])
    {
        _block(@"no_alert",_sizeID,_sizeName,_count);
    }else
    {
        _block(@"alert",_sizeID,_sizeName,1);
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
    for (int i=0; i<_sizeBtnArr.count; i++) {
        UIButton *_btn=[_sizeBtnArr objectAtIndex:i];
        if(_index==i)
        {
            DD_SizeModel *_sizeModel=[_sizeArr objectAtIndex:i];
            if(_btn.selected)
            {
                _btn.selected=NO;
                _sizeID=@"";
                _sizeName=@"";
                _count=0;
                [_btn setBackgroundColor:[UIColor whiteColor]];
            }else
            {
                _btn.selected=YES;
                _sizeID=_sizeModel.sizeId;
                _sizeName=_sizeModel.sizeName;
                [_btn setBackgroundColor:[UIColor blackColor]];
                if(_count>_sizeModel.stock)
                {
                    _count=_sizeModel.stock;
                }
            }
            
        }else
        {
            _btn.selected=NO;
            [_btn setBackgroundColor:[UIColor whiteColor]];
        }
    }
}


@end
