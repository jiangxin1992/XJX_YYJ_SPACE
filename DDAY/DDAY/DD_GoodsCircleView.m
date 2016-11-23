//
//  DD_GoodCircleView.m
//  YCO SPACE
//
//  Created by yyj on 16/7/30.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_GoodsCircleView.h"

#import "DD_ImageModel.h"
#import "DD_CircleListModel.h"
#import "DD_OrderItemModel.h"

@implementation DD_GoodsCircleView
{
    NSMutableArray *goodsImgArr;
    
    UIImageView *userHeadImg;
    UILabel *userNameLabel;
    UILabel *userCareerLabel;
    UIImageView *goodImgView;
    UILabel *conentLabel;
    UILabel *timeLabel;
    
    UIScrollView *_scrollview;
    
}
#pragma mark - 初始化
-(instancetype)initWithGoodsItem:(DD_CircleListModel *)circle WithBlock:(void (^)(NSString *type,DD_OrderItemModel *item))block
{
    self=[super init];
    if(self)
    {
        _block=block;
        _circle=circle;
        [self SomePrepare];
        [self UIConfig];
        [self setAction];
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
    goodsImgArr=[[NSMutableArray alloc] init];
}
-(void)PrepareUI{}
#pragma mark - UIConfig
-(void)UIConfig
{
    UIButton *backBtn=[UIButton getCustomBtn];
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
    
    UILabel *label=[UILabel getLabelWithAlignment:0 WithTitle:NSLocalizedString(@"goods_detail_circle", nil) WithFont:15.0f WithTextColor:_define_black_color WithSpacing:0];
    [backBtn addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kEdge);
        make.right.mas_equalTo(-kEdge);
        make.top.mas_equalTo(16);
    }];
    
    UIButton *moreCircle=[UIButton getCustomTitleBtnWithAlignment:2 WithFont:15.0f WithSpacing:0 WithNormalTitle:@"更多搭配" WithNormalColor:nil WithSelectedTitle:nil WithSelectedColor:nil];
    [backBtn addSubview:moreCircle];
    [moreCircle addTarget:self action:@selector(moreAction) forControlEvents:UIControlEventTouchUpInside];
    [moreCircle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-kEdge);
        make.centerY.mas_equalTo(label);
        make.height.mas_equalTo(25);
        make.width.mas_equalTo(80);
    }];
    
    UIView *downLine=[UIView getCustomViewWithColor:_define_black_color];
    [moreCircle addSubview:downLine];
    [downLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(2);
        make.width.mas_equalTo([regular getWidthWithHeight:25 WithContent:@"更多搭配" WithFont:[regular getFont:15.0f]]);
    }];

    
    
    
    userHeadImg=[UIImageView getCornerRadiusImg];
    [backBtn addSubview:userHeadImg];
    userHeadImg.contentMode=2;
    [regular setZeroBorder:userHeadImg];
    userHeadImg.userInteractionEnabled=YES;
    [userHeadImg addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headClick)]];
    [userHeadImg mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(IsPhone6_gt?34:15);
        make.left.mas_equalTo(kEdge);
        make.top.mas_equalTo(label.mas_bottom).with.offset(10);
        make.width.height.mas_equalTo(44);
    }];
    
    userNameLabel=[UILabel getLabelWithAlignment:0 WithTitle:@"" WithFont:IsPhone6_gt?15.0f:14.0f WithTextColor:nil WithSpacing:0];
    [backBtn addSubview:userNameLabel];
    [userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(userHeadImg);
        make.height.mas_equalTo(44/2.0f);
        make.left.mas_equalTo(userHeadImg.mas_right).with.offset(6);

    }];
    [userNameLabel sizeToFit];
    
    
    userCareerLabel=[UILabel getLabelWithAlignment:0 WithTitle:@"" WithFont:13.0f WithTextColor:_define_light_gray_color1 WithSpacing:0];
    [backBtn addSubview:userCareerLabel];
    [userCareerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(userNameLabel.mas_bottom).with.offset(0);
        make.height.mas_equalTo(44/2.0f);
        make.left.mas_equalTo(userHeadImg.mas_right).with.offset(6);
    }];
    [userCareerLabel sizeToFit];
    
    goodImgView=[UIImageView getCustomImg];
    [backBtn addSubview:goodImgView];
    goodImgView.contentMode=2;
    [regular setZeroBorder:goodImgView];
    [goodImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(userHeadImg);
        make.top.mas_equalTo(userHeadImg.mas_bottom).with.offset(19);
        if(IsPhone6_gt)
        {
            make.width.mas_equalTo(IsPhone6_gt?234:190);
        }else
        {
            make.right.mas_equalTo(-kEdge);
        }
        make.height.mas_equalTo(300);
    }];
    if(IsPhone6_gt)
    {
        UIView *lastView=nil;
        for (int i=0; i<3; i++) {
            UIImageView *goods=[UIImageView getCustomImg];
            [backBtn addSubview:goods];
            goods.contentMode=2;
            [regular setZeroBorder:goods];
            goods.userInteractionEnabled=YES;
            goods.tag=100+i;
            [goods addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemAction:)]];
            [goods mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(-kEdge);
                make.width.height.mas_equalTo(66);
                if(lastView)
                {
                    make.bottom.mas_equalTo(lastView.mas_top).with.offset(-24);
                }else
                {
                    make.bottom.mas_equalTo(goodImgView.mas_bottom).with.offset(0);
                }
            }];
            lastView=goods;
            [goodsImgArr addObject:goods];
            
            UIButton *pricebtn=[UIButton getCustomTitleBtnWithAlignment:0 WithFont:12.0f WithSpacing:0 WithNormalTitle:@"" WithNormalColor:_define_white_color WithSelectedTitle:@"" WithSelectedColor:nil];
            [goods addSubview:pricebtn];
            pricebtn.titleLabel.font=[regular getSemiboldFont:12.0f];
            pricebtn.userInteractionEnabled=NO;
            pricebtn.tag=150+i;
            [pricebtn setBackgroundImage:[UIImage imageNamed:@"Item_PriceFrame"] forState:UIControlStateNormal];
            [pricebtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.mas_equalTo(0);
                make.height.mas_equalTo(18);
            }];
        }
    }else
    {
        _scrollview=[[UIScrollView alloc] init];
        [backBtn addSubview:_scrollview];
        [_scrollview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(kEdge);
            make.right.mas_equalTo(-kEdge);
            make.height.mas_equalTo(66);
            make.top.mas_equalTo(goodImgView.mas_bottom).with.offset(20);
        }];
        _scrollview.contentSize=CGSizeMake(66*_circle.items.count+20*(_circle.items.count-1), 66);
        CGFloat _x_p=0;
        for (int i=0; i<_circle.items.count; i++) {
            UIImageView *goods=[UIImageView getCustomImg];;
            [_scrollview addSubview:goods];
            goods.frame=CGRectMake(_x_p, 0, 66, 66);
            goods.contentMode=2;
            [regular setZeroBorder:goods];
            goods.userInteractionEnabled=YES;
            [goods addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemAction:)]];
            goods.tag=100+i;
            DD_OrderItemModel *_order=_circle.items[i];
            [goods JX_ScaleAspectFill_loadImageUrlStr:_order.pic WithSize:400 placeHolderImageName:nil radius:0];
            
            
            UIButton *pricebtn=[UIButton getCustomTitleBtnWithAlignment:0 WithFont:12.0f WithSpacing:0 WithNormalTitle:@"" WithNormalColor:_define_white_color WithSelectedTitle:@"" WithSelectedColor:nil];;
            [goods addSubview:pricebtn];
            pricebtn.titleLabel.font=[regular getSemiboldFont:12.0f];
            pricebtn.userInteractionEnabled=NO;
            [pricebtn setBackgroundImage:[UIImage imageNamed:@"Item_PriceFrame"] forState:UIControlStateNormal];
            [pricebtn setTitle:[[NSString alloc] initWithFormat:@"￥%@",_order.price] forState:UIControlStateNormal];
            [pricebtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.mas_equalTo(0);
                make.height.mas_equalTo(18);
            }];
            _x_p+=CGRectGetWidth(goods.frame)+20;
        }
    }
    
    
    conentLabel=[UILabel getLabelWithAlignment:0 WithTitle:@"" WithFont:13.0f WithTextColor:nil WithSpacing:0];
    [backBtn addSubview:conentLabel];
    conentLabel.numberOfLines=0;
    [conentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        if(IsPhone6_gt)
        {
            make.top.mas_equalTo(goodImgView.mas_bottom).with.offset(19);
        }else
        {
            make.top.mas_equalTo(_scrollview.mas_bottom).with.offset(20);
        }
        make.left.mas_equalTo(kEdge);
        make.right.mas_equalTo(-kEdge);
        make.bottom.mas_equalTo(backBtn.mas_bottom).with.offset(-16);
    }];
}
#pragma mark - SomeAction
/**
 * 更新
 */
-(void)setAction
{
    [userHeadImg JX_ScaleAspectFill_loadImageUrlStr:_circle.userHead WithSize:400 placeHolderImageName:nil radius:44/2.0f];
    userNameLabel.text=_circle.userName;
    if([NSString isNilOrEmpty:_circle.career])
    {
        userCareerLabel.text=@"貌似来自火星";
    }else
    {
        userCareerLabel.text=_circle.career;
    }
    if(_circle.pics.count)
    {
        DD_ImageModel *imgModel=_circle.pics[0];
        [goodImgView JX_ScaleAspectFill_loadImageUrlStr:imgModel.pic WithSize:800 placeHolderImageName:nil radius:0];
    }
    
    NSInteger count_index=0;
    if(_circle.items.count>3)
    {
        count_index=3;
    }else
    {
        count_index=_circle.items.count;
    }
    for (int i=0; i<goodsImgArr.count; i++) {
        UIImageView *goods=goodsImgArr[i];
        UIButton *goodsPrice=(UIButton *)[self viewWithTag:150+i];
        if(i<count_index)
        {
            DD_OrderItemModel *_order=_circle.items[i];
            [goods JX_ScaleAspectFill_loadImageUrlStr:_order.pic WithSize:400 placeHolderImageName:nil radius:0];
            goods.hidden=NO;
            [goodsPrice setTitle:[[NSString alloc] initWithFormat:@"￥%@",_order.price] forState:UIControlStateNormal];
        }else
        {
            goods.hidden=YES;
        }
    }
    conentLabel.text=_circle.shareAdvise;

}

/**
 * 头像点击
 */
-(void)headClick
{
    _block(@"head_click",nil);
}
-(void)itemAction:(UIGestureRecognizer *)ges
{
    
    DD_OrderItemModel *_item=_circle.items[ges.view.tag-100];
    _block(@"item_click",_item);
}
-(void)clickAction
{
    _block(@"enter_detail",nil);
}
-(void)moreAction
{
    _block(@"more_circle",nil);
}
@end
