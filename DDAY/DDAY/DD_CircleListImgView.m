//
//  DD_CircleListImgView.m
//  DDAY
//
//  Created by yyj on 16/6/21.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_CircleListImgView.h"

#import "DD_CircleListModel.h"

@implementation DD_CircleListImgView
{
    UIImageView *pic;//搭配图片
    UIButton *itemBtn;//单品按钮，点击进入该搭配的单品列表
}
#pragma mark - 初始化
-(instancetype)initWithCircleListModel:(DD_CircleListModel *)model WithBlock:(void (^)(NSString *))block
{
    self=[super init];
    if(self)
    {
        _block=block;
        _detailModel=model;
        [self UIConfig];

    }
    return self;
}
#pragma mark - UIConfig
-(void)UIConfig
{
    pic=[[UIImageView alloc] init];
    [self addSubview:pic];
    pic.contentMode=2;
    [regular setZeroBorder:pic];
    pic.userInteractionEnabled=YES;
    [pic mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.and.right.mas_equalTo(0);
        make.height.mas_equalTo(@300);
        make.bottom.mas_equalTo(pic.superview);
    }];
    
    
    itemBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [pic addSubview:itemBtn];
    itemBtn.alpha=0.7;
    [itemBtn setTitleColor:_define_black_color forState:UIControlStateNormal];
    itemBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
    itemBtn.titleLabel.font=[regular get_en_Font:20.0f];
    itemBtn.backgroundColor=_define_white_color;
    [itemBtn addTarget:self action:@selector(showItemListAction) forControlEvents:UIControlEventTouchUpInside];
    [itemBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.and.height.mas_equalTo(@80);
        make.right.and.bottom.mas_equalTo(-20);
    }];
}
-(void)setDetailModel:(DD_CircleListModel *)detailModel
{
    _detailModel=detailModel;
    [self setState];
}
#pragma mark - setState
-(void)setState
{
    if(_detailModel)
    {
        [pic JX_ScaleAspectFill_loadImageUrlStr:_detailModel.pics[0] WithSize:800 placeHolderImageName:nil radius:0];
        [itemBtn setTitle:[[NSString alloc] initWithFormat:@"%ld",_detailModel.items.count] forState:UIControlStateNormal];
    }   
}
#pragma mark - SomeAction
/**
 * 跳转当前搭配对应的单品列表
 */
-(void)showItemListAction
{
    _block(@"show_item_list");
}
@end
