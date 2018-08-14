//
//  DD_GoodsFabricView.m
//  YCO SPACE
//
//  Created by yyj on 16/7/30.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_GoodsFabricView.h"

#import "DD_GoodsItemModel.h"

@implementation DD_GoodsFabricView
{
    UIButton *backBtn;
    NSMutableArray *viewArr;
    
    UILabel *label;
    UILabel *washing_content;
    
    MASConstraint *_hide;
    MASConstraint *_show;
}
#pragma mark - 初始化
-(instancetype)initWithGoodsItem:(DD_GoodsItemModel *)item WithBlock:(void (^)(NSString *type))block
{
    self=[super init];
    if(self)
    {
        _item=item;
        _block=block;
        viewArr=[[NSMutableArray alloc] init];
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
        make.edges.mas_equalTo(self).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    UIView *view=[UIView getCustomViewWithColor:_define_black_color];
    [backBtn addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.left.and.right.mas_equalTo(view.superview).with.offset(0);
        make.bottom.mas_equalTo(view.superview).with.offset(0);
    }];
    
    label=[UILabel getLabelWithAlignment:0 WithTitle:NSLocalizedString(@"goods_detail_fabric", nil) WithFont:15.0f WithTextColor:_define_black_color WithSpacing:0];
    [backBtn addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kEdge);
        make.right.mas_equalTo(-kEdge);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(48);
    }];
    
    
    UILabel *fabric_title=[UILabel getLabelWithAlignment:0 WithTitle:@"材质" WithFont:15.0f WithTextColor:nil WithSpacing:0];
    [backBtn addSubview:fabric_title];
    [viewArr addObject:fabric_title];
    [fabric_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kEdge);
        make.top.mas_equalTo(label.mas_bottom).with.offset(5);
    }];
//    [fabric_title sizeToFit];
    
    
    UILabel *fabric_content=[UILabel getLabelWithAlignment:0 WithTitle:_item.material WithFont:13.0f WithTextColor:nil WithSpacing:0];
    [backBtn addSubview:fabric_content];
    fabric_content.numberOfLines=0;
    [viewArr addObject:fabric_content];
    [fabric_content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(fabric_title.mas_bottom).with.offset(6);
        make.left.mas_equalTo(kEdge);
        make.right.mas_equalTo(-kEdge);
    }];
//    [fabric_content sizeToFit];
    

    
    UILabel *washing_title=[UILabel getLabelWithAlignment:0 WithTitle:@"护理说明" WithFont:15.0f WithTextColor:nil WithSpacing:0];
    [backBtn addSubview:washing_title];
    [viewArr addObject:washing_title];
    [washing_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kEdge);
        make.top.mas_equalTo(fabric_content.mas_bottom).with.offset(6+20);
    }];
//    [washing_title sizeToFit];
    
    washing_content=[UILabel getLabelWithAlignment:0 WithTitle:_item.washCare WithFont:13.0f WithTextColor:nil WithSpacing:0];
    [backBtn addSubview:washing_content];
    washing_content.numberOfLines=0;
    [viewArr addObject:washing_content];
    [washing_content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(washing_title.mas_bottom).with.offset(6);
        make.left.mas_equalTo(kEdge);
        make.right.mas_equalTo(-kEdge);
    }];
//    [washing_content sizeToFit];
    
}
-(void)setIs_show:(BOOL)is_show
{
    _is_show=is_show;
    
    [viewArr enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL * _Nonnull stop) {
        view.hidden=!_is_show;
    }];
    
    if(_is_show)
    {
        [_hide uninstall];
        [washing_content mas_updateConstraints:^(MASConstraintMaker *make) {
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
