//
//  DD_GoodsDesignerView.m
//  DDAY
//
//  Created by yyj on 16/5/24.
//  Copyright © 2016年 YYJ. All rights reserved.
//
#import "UIButton+WebCache.h"
#import "DD_GoodsDesignerView.h"

@implementation DD_GoodsDesignerView
{
    UIButton *upView;
    UIButton *downView;
    UIButton *guanzhu;
}
#pragma mark - 初始化
-(instancetype)initWithFrame:(CGRect)frame WithGoodsDetailModel:(DD_GoodsDetailModel *)model WithBlock:(void (^)(NSString *type,NSInteger index))block
{
    self=[super initWithFrame:frame];
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
-(void)PrepareUI
{
//    self.backgroundColor=_define_backview_color;
}
#pragma mark - UIConfig
-(void)UIConfig
{
    [self CreateUpView];
    [self CreateDownView];
}
-(void)serviesAction
{
    _block(@"servies",0);
}
-(void)designerAction
{
    _block(@"designer",0);
}
-(void)CreateUpView
{
    upView=[UIButton buttonWithType:UIButtonTypeCustom];
    upView.frame=CGRectMake(0, 0, ScreenWidth , 80);
    [self addSubview:upView];
    upView.backgroundColor=[UIColor whiteColor];
    [upView addTarget:self action:@selector(designerAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *_headImge=[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 60, 60)];
    [upView addSubview:_headImge];
    
    [_headImge JX_loadImageUrlStr:_detailModel.designer.head WithSize:200 placeHolderImageName:nil radius:CGRectGetWidth(_headImge.frame)/2.0f];
    
    
    UILabel *namelabel=[[UILabel alloc] initWithFrame:CGRectMake(100, 10, 160, 60)];
    [upView addSubview:namelabel];
    namelabel.textColor=[UIColor blackColor];
    namelabel.textAlignment=0;
    namelabel.text=[[NSString alloc] initWithFormat:@"%@·%@",_detailModel.designer.designerName,_detailModel.designer.brandName];
    
    guanzhu=[UIButton buttonWithType:UIButtonTypeCustom];
    [upView addSubview:guanzhu];
    guanzhu.frame=CGRectMake(270, 15, 80, 50);
    guanzhu.backgroundColor=[UIColor blackColor];
    [guanzhu setTitle:@"关注" forState:UIControlStateNormal];
    [guanzhu setTitle:@"已关注" forState:UIControlStateSelected];
    [guanzhu setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [guanzhu setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [guanzhu addTarget:self action:@selector(followAction:) forControlEvents:UIControlEventTouchUpInside];
    [self UpdateFollowBtnState];
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
-(void)CreateDownView
{
    downView=[UIButton buttonWithType:UIButtonTypeCustom];
    downView.frame=CGRectMake(0, 90, ScreenWidth, 150);
    [self addSubview:downView];
    downView.backgroundColor=[UIColor whiteColor];
    [downView addTarget:self action:@selector(serviesAction) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *_series_label=[[UILabel alloc] initWithFrame:CGRectMake(10, 10, ScreenWidth-20, 40)];
    [downView addSubview:_series_label];
    _series_label.textAlignment=0;
    _series_label.textColor=[UIColor blackColor];
    _series_label.text=_detailModel.item.series.name;
    
    UIScrollView *_scrollview=[[UIScrollView alloc] initWithFrame:CGRectMake(10, 60, ScreenWidth-20, 80)];
    [downView addSubview:_scrollview];
    NSInteger _item_count=_detailModel.item.otherItems.count;
    _scrollview.contentSize=CGSizeMake(70*_item_count+10*(_item_count-1), 80);
    for (int i=0; i<_item_count; i++) {
        DD_OtherItemModel *_OtherItem=[_detailModel.item.otherItems objectAtIndex:i];
        UIButton *imageview_btn=[UIButton buttonWithType:UIButtonTypeCustom];
        imageview_btn.frame=CGRectMake(80*i, 0,70, 80);
        [_scrollview addSubview:imageview_btn];
        
        [imageview_btn sd_setImageWithURL:[NSURL URLWithString:[regular getImgUrl:_OtherItem.itemPic WithSize:200]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"headImg_login1"]];
        imageview_btn.tag=100+i;
        [imageview_btn addTarget:self action:@selector(ItemAction:) forControlEvents:UIControlEventTouchUpInside];
    }
}
-(void)ItemAction:(UIButton *)btn
{
    NSInteger _index=btn.tag-100;
    _block(@"item",_index);
}
@end
