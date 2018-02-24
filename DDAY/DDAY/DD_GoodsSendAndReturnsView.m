//
//  DD_GoodSendAndReturnsView.m
//  YCO SPACE
//
//  Created by yyj on 16/7/30.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_GoodsSendAndReturnsView.h"

#import "DD_GoodsItemModel.h"

@implementation DD_GoodsSendAndReturnsView
{
    UILabel *label;
    UILabel *return_content;
    UIButton *backBtn;
    
    MASConstraint *_hide;
    MASConstraint *_show;
}
#pragma mark - 初始化
-(instancetype)initWithGoodsItem:(DD_GoodsItemModel *)item WithBlock:(void (^)(NSString *type))block
{
    self=[super init];
    if(self)
    {
        _block=block;
        _item=item;
        [self UIConfig];
    }
    return self;
}
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
    
    label=[UILabel getLabelWithAlignment:0 WithTitle:NSLocalizedString(@"goods_detail_send_return", nil) WithFont:15.0f WithTextColor:_define_black_color WithSpacing:0];
    [backBtn addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kEdge);
        make.right.mas_equalTo(-kEdge);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(48);
    }];
    JXLOG(@"%@",_item.deliverDeclaration);
    return_content=[UILabel getLabelWithAlignment:0 WithTitle:_item.deliverDeclaration  WithFont:13.0f WithTextColor:nil WithSpacing:0];
    [backBtn addSubview:return_content];
    return_content.numberOfLines=0;
    [return_content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(label.mas_bottom).with.offset(5);
        make.left.mas_equalTo(kEdge);
        make.right.mas_equalTo(-kEdge);
    }];
//    [return_content sizeToFit];
}
-(void)setIs_show:(BOOL)is_show
{
    _is_show=is_show;
    
    return_content.hidden=!_is_show;
    if(_is_show)
    {
        [_hide uninstall];
        [return_content mas_updateConstraints:^(MASConstraintMaker *make) {
            _show=make.bottom.mas_equalTo(backBtn.mas_bottom).with.offset(-20);
        }];
    }else
    {
        [_show uninstall];
        [label mas_updateConstraints:^(MASConstraintMaker *make) {
            _hide=make.bottom.mas_equalTo(backBtn.mas_bottom).with.offset(-1);
        }];
    }
}
#pragma mark - SomeAction
-(void)clickAction
{
    _block(@"click");
}
@end
