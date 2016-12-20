//
//  DD_GoodsTabBar.m
//  YCO SPACE
//
//  Created by yyj on 16/7/30.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_GoodsTabBar.h"

#import "DD_ColorsModel.h"

@implementation DD_GoodsTabBar
{
    UIButton *buyBtn;
}

-(instancetype)initWithColorModel:(DD_ColorsModel *)colorModel WithBlock:(void (^)(NSString *type))block
{
    self=[super init];
    if(self)
    {
        _block=block;
        _colorModel=colorModel;
        self.backgroundColor=_define_white_color;
        [self UIConfig];
        [self setState];
    }
    return self;
}
#pragma mark - UIConfig
-(void)UIConfig
{
    
    buyBtn=[UIButton getCustomTitleBtnWithAlignment:0 WithFont:18.0f WithSpacing:0 WithNormalTitle:nil WithNormalColor:nil WithSelectedTitle:nil WithSelectedColor:nil];
    [self addSubview:buyBtn];
    [buyBtn addTarget:self action:@selector(clickAction) forControlEvents:UIControlEventTouchUpInside];
    [buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
        make.height.mas_equalTo(ktabbarHeight);
    }];
    
}
-(void)setState
{
    NSString *title=nil;
    if(_colorModel.status==1)
    {
        title=@"购   买";
        buyBtn.userInteractionEnabled=YES;
        buyBtn.backgroundColor=_define_black_color;
        [buyBtn setTitleColor:_define_white_color forState:UIControlStateNormal];
    }else
    {
        title=_colorModel.status==0?@"未 上 架":_colorModel.status==2?@"已 下 架":_colorModel.status==3?@"已 删 除":_colorModel.status==-1?@"已 售 罄":@"";
        buyBtn.userInteractionEnabled=NO;
        buyBtn.backgroundColor=_define_light_gray_color1;
        [buyBtn setTitleColor:_define_light_gray_color forState:UIControlStateNormal];
    }
    [buyBtn setTitle:title forState:UIControlStateNormal];
    
}
#pragma mark - SomeAction
-(void)clickAction
{
    if(_colorModel.status==1)
    {
        _block(@"buy");
    }else
    {
        _block(@"cannot_buy");
    }
}
@end
