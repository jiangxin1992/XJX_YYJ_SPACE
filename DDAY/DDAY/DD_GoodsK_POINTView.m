//
//  DD_GoodK-POINTView.m
//  YCO SPACE
//
//  Created by yyj on 16/7/30.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_GoodsK_POINTView.h"

#import "DD_ShowRoomModel.h"

@implementation DD_GoodsK_POINTView
{
    NSMutableArray *viewArr;
    
    MASConstraint *_hide;
    MASConstraint *_show;
    
    UIButton *backBtn;
    UILabel *label;
    UIView *lastView;
}
#pragma mark - 初始化

-(instancetype)initWithShowRoomModelArr:(NSArray *)showroomArr WithBlock:(void (^)(NSString *type,DD_ShowRoomModel *model))block
{
    self=[super init];
    if(self)
    {
        _block=block;
        _showroomArr=showroomArr;
        [self PrepareData];
        [self UIConfig];
    }
    return self;
}
#pragma mark - SomePrepare
-(void)SomePrepare
{
    [self PrepareData];
    [self PrepareUI];
}

-(void)PrepareData
{
    viewArr=[[NSMutableArray alloc] init];
}
-(void)PrepareUI{}
#pragma mark - UIConfig
-(void)UIConfig
{
    backBtn=[UIButton getCustomBtn];
    [self addSubview:backBtn];
    [backBtn addTarget:self action:@selector(clickAction) forControlEvents:UIControlEventTouchUpInside];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    UIView *view=[UIView getCustomViewWithColor:_define_black_color];
    [backBtn addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.left.and.right.mas_equalTo(view.superview).with.offset(0);
        make.bottom.mas_equalTo(view.superview).with.offset(0);
    }];
    
    label=[UILabel getLabelWithAlignment:0 WithTitle:NSLocalizedString(@"goods_detail_k_ponit", nil) WithFont:15.0f WithTextColor:_define_black_color WithSpacing:0];
    [backBtn addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kEdge);
        make.right.mas_equalTo(-kEdge);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(48);
    }];
    for (int i=0; i<_showroomArr.count; i++) {
        DD_ShowRoomModel *model=_showroomArr[i];
        UIView *backView=[UIView getCustomViewWithColor:nil];
        [backBtn addSubview:backView];
        backView.userInteractionEnabled=YES;
        backView.tag=100+i;
        [backView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ChooseAction:)]];
        [viewArr addObject:backView];
        [backView mas_makeConstraints:^(MASConstraintMaker *make) {
            if(lastView)
            {
                make.top.mas_equalTo(lastView.mas_bottom).with.offset(12);
            }else
            {
                make.top.mas_equalTo(label.mas_bottom).with.offset(5);
            }
            make.left.right.mas_equalTo(0);
        }];
        
        UIImageView *_head=[UIImageView getImgWithImageStr:@"User_ShowRoom"];
        [backView addSubview:_head];
        [_head mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(kEdge);
            make.top.mas_equalTo(5);
            make.width.height.mas_equalTo(23);
        }];
        
        UIImageView *_imageview=[UIImageView getCustomImg];
        [backView addSubview:_imageview];
        _imageview.contentMode=2;
        [regular setZeroBorder:_imageview];
        [_imageview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-kEdge);
            make.top.mas_equalTo(0);
            make.height.width.mas_equalTo(60);
        }];
        [_imageview JX_ScaleAspectFill_loadImageUrlStr:model.listImg.pic WithSize:400 placeHolderImageName:nil radius:0];
        
        UILabel *storeName=[UILabel getLabelWithAlignment:0 WithTitle:model.storeName WithFont:13.0f WithTextColor:nil WithSpacing:0];
        [backView addSubview:storeName];
        [storeName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_head.mas_right).with.offset(10);
            make.right.mas_equalTo(_imageview.mas_left).with.offset(-10);
            make.centerY.mas_equalTo(_head);
        }];
        [storeName sizeToFit];
        
        UILabel *address=[UILabel getLabelWithAlignment:0 WithTitle:model.address WithFont:13.0f WithTextColor:nil WithSpacing:0];
        [backView addSubview:address];
        address.numberOfLines=1;
        [address mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(kEdge);
            make.right.mas_equalTo(_imageview.mas_left).with.offset(-10);
            make.top.mas_equalTo(_head.mas_bottom).with.offset(6);
            make.bottom.mas_equalTo(backView.mas_bottom).with.offset(0);
        }];
        [address sizeToFit];
        
        lastView=backView;
    }
    
}
#pragma mark - SomeAction
-(void)ChooseAction:(UIGestureRecognizer *)ges
{
    NSInteger index = ges.view.tag-100;
    DD_ShowRoomModel *model=_showroomArr[index];
    _block(@"choose",model);
    
}
-(void)setIs_show:(BOOL)is_show
{
    _is_show=is_show;
    for (UIView *view in viewArr) {
        view.hidden=!is_show;
    }
    if(_is_show)
    {
        [_hide uninstall];
        [lastView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(backBtn.mas_bottom).with.offset(-20);
        }];
    }else
    {
        [_show uninstall];
        [label mas_updateConstraints:^(MASConstraintMaker *make) {
            _hide=make.bottom.mas_equalTo(backBtn.mas_bottom).with.offset(-1);
        }];
    }
}
-(void)clickAction
{
    _block(@"click",nil);
}
@end
