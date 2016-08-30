//
//  DD_GoodCircleView.m
//  YCO SPACE
//
//  Created by yyj on 16/7/30.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_GoodsCircleView.h"

#import "DD_ImageModel.h"

@implementation DD_GoodsCircleView
{
    NSMutableArray *goodsImgArr;
    
    UIImageView *userHeadImg;
    UILabel *userNameLabel;
    UILabel *userCareerLabel;
    UIImageView *goodImgView;
    UILabel *conentLabel;
    UILabel *timeLabel;
    
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
        make.bottom.mas_equalTo(view.superview).with.offset(-1);
    }];
    
    UILabel *label=[UILabel getLabelWithAlignment:0 WithTitle:NSLocalizedString(@"goods_detail_circle", nil) WithFont:15.0f WithTextColor:_define_black_color WithSpacing:0];
    [backBtn addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kEdge);
        make.right.mas_equalTo(-kEdge);
        make.top.mas_equalTo(13);
    }];
    
    UIButton *moreCircle=[UIButton getCustomTitleBtnWithAlignment:0 WithFont:15.0f WithSpacing:0 WithNormalTitle:@"更多搭配" WithNormalColor:_define_white_color WithSelectedTitle:nil WithSelectedColor:nil];
    [backBtn addSubview:moreCircle];
    moreCircle.backgroundColor=_define_black_color;
    [moreCircle addTarget:self action:@selector(moreAction) forControlEvents:UIControlEventTouchUpInside];
    [moreCircle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-kEdge);
        make.centerY.mas_equalTo(label);
        make.height.mas_equalTo(25);
        make.width.mas_equalTo(80);
    }];
    
    userHeadImg=[UIImageView getCustomImg];
    [backBtn addSubview:userHeadImg];
    userHeadImg.userInteractionEnabled=YES;
    [userHeadImg addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headClick)]];
    [userHeadImg mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(IsPhone6_gt?34:15);
        make.left.mas_equalTo(kEdge);
        make.top.mas_equalTo(label.mas_bottom).with.offset(10);
        make.width.height.mas_equalTo(43);
    }];
    
    userNameLabel=[UILabel getLabelWithAlignment:0 WithTitle:@"" WithFont:15.0f WithTextColor:nil WithSpacing:0];
    [backBtn addSubview:userNameLabel];
    [userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(userHeadImg);
        make.height.mas_equalTo(43/2.0f);
        make.left.mas_equalTo(userHeadImg.mas_right).with.offset(6);

    }];
    [userNameLabel sizeToFit];
    
    
    userCareerLabel=[UILabel getLabelWithAlignment:0 WithTitle:@"" WithFont:13.0f WithTextColor:_define_light_gray_color1 WithSpacing:0];
    [backBtn addSubview:userCareerLabel];
    [userCareerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(userNameLabel.mas_bottom).with.offset(0);
        make.height.mas_equalTo(43/2.0f);
        make.left.mas_equalTo(userHeadImg.mas_right).with.offset(6);
    }];
    [userCareerLabel sizeToFit];
    
    goodImgView=[UIImageView getCustomImg];
    [backBtn addSubview:goodImgView];
    [regular setZeroBorder:goodImgView];
    goodImgView.contentMode=UIViewContentModeScaleAspectFill;
    [goodImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(userHeadImg);
        make.top.mas_equalTo(userHeadImg.mas_bottom).with.offset(19);
        make.width.mas_equalTo(IsPhone6_gt?234:190);
        make.height.mas_equalTo(300);
    }];
    
    UIView *lastView=nil;
    for (int i=0; i<3; i++) {
        UIImageView *goods=[UIImageView getCustomImg];
        [backBtn addSubview:goods];
        [regular setZeroBorder:goods];
        goods.contentMode=UIViewContentModeScaleAspectFill;
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
        pricebtn.titleLabel.font=[regular getFont:12.0f];
        pricebtn.userInteractionEnabled=NO;
        pricebtn.tag=150+i;
        [pricebtn setBackgroundImage:[UIImage imageNamed:@"Circle_PriceFrame"] forState:UIControlStateNormal];
        [pricebtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.height.mas_equalTo(18);
        }];
    }
    
    conentLabel=[UILabel getLabelWithAlignment:0 WithTitle:@"" WithFont:13.0f WithTextColor:nil WithSpacing:0];
    [backBtn addSubview:conentLabel];
    conentLabel.numberOfLines=0;
    [conentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(goodImgView.mas_bottom).with.offset(19);
        make.left.mas_equalTo(kEdge);
        make.bottom.mas_equalTo(backBtn.mas_bottom).with.offset(-10);
    }];
}
#pragma mark - SomeAction
/**
 * 更新
 */
-(void)setAction
{
    [userHeadImg JX_loadImageUrlStr:_circle.userHead WithSize:400 placeHolderImageName:nil radius:43/2.0f];
    userNameLabel.text=_circle.userName;
    userCareerLabel.text=_circle.career;
    if(_circle.pics.count)
    {
        DD_ImageModel *imgModel=[_circle.pics objectAtIndex:0];
        [goodImgView JX_loadImageUrlStr:imgModel.pic WithSize:800 placeHolderImageName:nil radius:0];
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
        UIImageView *goods=[goodsImgArr objectAtIndex:i];
        UIButton *goodsPrice=(UIButton *)[self viewWithTag:150+i];
        if(i<count_index)
        {
            DD_OrderItemModel *_order=[_circle.items objectAtIndex:i];
            [goods JX_loadImageUrlStr:_order.pic WithSize:400 placeHolderImageName:nil radius:0];
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
    
    DD_OrderItemModel *_item=[_circle.items objectAtIndex:ges.view.tag-100];
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
