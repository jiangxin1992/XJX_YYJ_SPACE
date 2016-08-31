//
//  DD_GoodsDesignerView.m
//  DDAY
//
//  Created by yyj on 16/5/24.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_GoodsDesignerView.h"

#import "UIButton+WebCache.h"

#import "DD_OtherItemModel.h"

#define ver_edge 15

@implementation DD_GoodsDesignerView
{
    UIButton *upView;
    UIButton *downView;
    
    UIButton *guanzhu;
}
#pragma mark - 初始化
-(instancetype)initWithGoodsDetailModel:(DD_GoodsDetailModel *)model WithBlock:(void (^)(NSString *type,NSInteger index))block
{
    self=[super init];
    if(self)
    {
        _detailModel=model;
        _block=block;
        [self SomePrepare];
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
-(void)PrepareData{}
-(void)PrepareUI{}
#pragma mark - UIConfig
-(void)UIConfig{
    [self CreateUpView];
//    [self CreateDownView];
}

-(void)CreateUpView
{
    upView=[UIButton getCustomBtn];
    [self addSubview:upView];
    [upView addTarget:self action:@selector(designerAction) forControlEvents:UIControlEventTouchUpInside];
    [upView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.bottom.mas_equalTo(self);
    }];
    
    UIView *view=[UIView getCustomViewWithColor:_define_black_color];
    [upView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.left.and.right.mas_equalTo(view.superview).with.offset(0);
        make.bottom.mas_equalTo(view.superview).with.offset(-1);
    }];
    
    
    UIImageView *_headImge=[UIImageView getloadImageUrlStr:_detailModel.designer.head WithSize:200 placeHolderImageName:nil radius:0 WithContentMode:0];
    [upView addSubview:_headImge];
    _headImge.userInteractionEnabled=NO;
    _headImge.contentMode=0;
    [regular setZeroBorder:_headImge];
    [_headImge mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kEdge);
        make.top.mas_equalTo(ver_edge);
        make.width.and.height.mas_equalTo(50);
        make.bottom.mas_equalTo(upView).with.offset(-ver_edge);
    }];
    
    UIImageView *_brandImge=[UIImageView getloadImageUrlStr:_detailModel.designer.brandIcon WithSize:200 placeHolderImageName:nil radius:0 WithContentMode:1];
    [upView addSubview:_brandImge];
    _brandImge.userInteractionEnabled=NO;
    _brandImge.contentMode=1;
    [regular setZeroBorder:_brandImge];
    [_brandImge mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_headImge.mas_right).with.offset(8);
        make.top.mas_equalTo(ver_edge);
        make.width.and.height.mas_equalTo(_headImge);
    }];
    
    UILabel *userName=[UILabel getLabelWithAlignment:0 WithTitle:_detailModel.designer.designerName WithFont:15.0f WithTextColor:_define_black_color WithSpacing:0];
    [upView addSubview:userName];
    [userName mas_makeConstraints:^(MASConstraintMaker *make) {

        make.top.mas_equalTo(_headImge);
        make.left.mas_equalTo(_brandImge.mas_right).with.offset(8);
    }];
    [userName sizeToFit];
    
    UILabel *brandName=[UILabel getLabelWithAlignment:0 WithTitle:_detailModel.designer.brandName WithFont:13.0f WithTextColor:_define_black_color WithSpacing:0];
    [upView addSubview:brandName];
    [brandName mas_makeConstraints:^(MASConstraintMaker *make) {

        make.bottom.mas_equalTo(_headImge);
        make.left.mas_equalTo(_brandImge.mas_right).with.offset(8);
    }];
    [brandName sizeToFit];
    
    guanzhu=[UIButton getCustomTitleBtnWithAlignment:0 WithFont:15.0f WithSpacing:0 WithNormalTitle:@"关注" WithNormalColor:_define_white_color WithSelectedTitle:@"已关注" WithSelectedColor:_define_white_color];
    [upView addSubview:guanzhu];
    guanzhu.backgroundColor=[UIColor blackColor];
    [guanzhu addTarget:self action:@selector(followAction:) forControlEvents:UIControlEventTouchUpInside];
    [guanzhu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-kEdge);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(25);
        make.centerY.mas_equalTo(upView);
    }];
    [self UpdateFollowBtnState];
}

-(void)CreateDownView
{
    downView=[UIButton getCustomBtn];
    [self addSubview:downView];
    [downView addTarget:self action:@selector(serviesAction) forControlEvents:UIControlEventTouchUpInside];
    [downView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(0);
        make.top.mas_equalTo(upView.mas_bottom).with.offset(0);
        make.bottom.mas_equalTo(self);
    }];
    UIView *view=[UIView getCustomViewWithColor:_define_black_color];
    [downView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.left.and.right.mas_equalTo(view.superview).with.offset(0);
        make.bottom.mas_equalTo(view.superview).with.offset(-1);
    }];
    
    UILabel *_series_label=[UILabel getLabelWithAlignment:1 WithTitle:_detailModel.item.series.name WithFont:13.0f WithTextColor:_define_white_color WithSpacing:0];
    [downView addSubview:_series_label];
    _series_label.backgroundColor=[UIColor blackColor];
    [_series_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kEdge);
        make.top.mas_equalTo(downView).with.offset(ver_edge);
        make.width.mas_equalTo(75);
        make.height.mas_equalTo(23);
    }];
    
    UIScrollView *_scrollview=[[UIScrollView alloc] init];
    [downView addSubview:_scrollview];
    NSInteger _item_count=_detailModel.item.otherItems.count;
    _scrollview.contentSize=CGSizeMake(102*_item_count+6*(_item_count-1), 102);
    for (int i=0; i<_item_count; i++) {
        DD_OtherItemModel *_OtherItem=[_detailModel.item.otherItems objectAtIndex:i];
        UIButton *imageview_btn=[UIButton buttonWithType:UIButtonTypeCustom];
        imageview_btn.frame=CGRectMake(108*i, 0,102, 102);
        [_scrollview addSubview:imageview_btn];
        [imageview_btn sd_setImageWithURL:[NSURL URLWithString:[regular getImgUrl:_OtherItem.itemPic WithSize:200]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"headImg_login1"]];
        imageview_btn.tag=100+i;
        [imageview_btn addTarget:self action:@selector(ItemAction:) forControlEvents:UIControlEventTouchUpInside];
        [regular setBorder:imageview_btn];
    }
    
    [_scrollview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_series_label.mas_bottom).with.offset(ver_edge);
        make.left.mas_equalTo(kEdge);
        make.right.mas_equalTo(-kEdge);
        make.height.mas_equalTo(102);
        make.bottom.mas_equalTo(-ver_edge);
    }];
    
}
#pragma mark - SomeAction
-(void)serviesAction
{
    _block(@"servies",0);
}
-(void)designerAction
{
    _block(@"designer",0);
}
-(void)UpdateFollowBtnState
{
    guanzhu.selected=_detailModel.guanzhu;
}
-(void)followAction:(UIButton *)btn
{
    if (btn.selected) {
        _block(@"unfollow",0);
    }else
    {
        _block(@"follow",0);
    }
}
-(void)ItemAction:(UIButton *)btn
{
    NSInteger _index=btn.tag-100;
    _block(@"item",_index);
}
@end
