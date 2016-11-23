//
//  DD_GoodsTabBar.m
//  YCO SPACE
//
//  Created by yyj on 16/7/30.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_GoodsTabBar.h"

#import "DD_GoodsItemModel.h"

@implementation DD_GoodsTabBar
-(instancetype)initWithItem:(DD_GoodsItemModel *)item WithBlock:(void (^)(NSString *type))block
{
    self=[super init];
    if(self)
    {
        _block=block;
        _item=item;
        self.backgroundColor=_define_white_color;
        [self UIConfig];
    }
    return self;
}
#pragma mark - UIConfig
-(void)UIConfig
{
    NSString *title=nil;
    if(_item.status==1)
    {
        title=@"购   买";
    }else
    {
        title=@"已  下  架";
    }
    UIButton *buyBtn=[UIButton getCustomTitleBtnWithAlignment:0 WithFont:18.0f WithSpacing:0 WithNormalTitle:title WithNormalColor:_define_white_color WithSelectedTitle:nil WithSelectedColor:nil];
    [self addSubview:buyBtn];
    buyBtn.backgroundColor=_define_black_color;
    [buyBtn addTarget:self action:@selector(clickAction) forControlEvents:UIControlEventTouchUpInside];
    [buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
        make.height.mas_equalTo(ktabbarHeight);
    }];
    
}
#pragma mark - SomeAction
-(void)clickAction
{
    if(_item.status==1)
    {
        _block(@"buy");
    }else
    {
        _block(@"sold_out");
    }
    
}
@end
