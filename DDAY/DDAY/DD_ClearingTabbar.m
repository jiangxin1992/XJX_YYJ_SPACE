//
//  DD_ClearingTabbar.m
//  YCO SPACE
//
//  Created by yyj on 16/8/4.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_ClearingTabbar.h"

@implementation DD_ClearingTabbar
-(instancetype)initWithNumStr:(NSString *)numStr WithCountStr:(NSString *)countStr WithBlock:(void (^)(NSString *type))block
{
    self=[super init];
    if(self)
    {
        _numStr=numStr;
        _countStr=countStr;
        _block=block;
        [self UIConfig];
    }
    return self;
}
-(void)UIConfig
{
    self.backgroundColor=_define_white_color;
    
    UIView *upline=[UIView getCustomViewWithColor:_define_black_color];
    [self addSubview:upline];
    [upline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.top.left.right.mas_equalTo(0);
    }];
    
    UIButton *ConfirmBtn=[UIButton getCustomTitleBtnWithAlignment:0 WithFont:18.0f WithSpacing:0 WithNormalTitle:@"确认订单" WithNormalColor:_define_white_color WithSelectedTitle:nil WithSelectedColor:nil];
    [self addSubview:ConfirmBtn];
    [ConfirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(upline.mas_bottom).with.offset(0);
        make.width.mas_equalTo(130);
        make.bottom.mas_equalTo(0);
    }];
    [ConfirmBtn addTarget:self action:@selector(ConfirmAction) forControlEvents:UIControlEventTouchUpInside];
    ConfirmBtn.backgroundColor=_define_black_color;
    
    
    UILabel *numlabel=[UILabel getLabelWithAlignment:0 WithTitle:_numStr WithFont:15.0f WithTextColor:nil WithSpacing:0];
    [self addSubview:numlabel];
    [numlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kEdge);
        make.centerY.mas_equalTo(self);
    }];
    [numlabel sizeToFit];
    
    UILabel *countlabel=[UILabel getLabelWithAlignment:2 WithTitle:_countStr WithFont:15.0f WithTextColor:nil WithSpacing:0];
    [self addSubview:countlabel];
    countlabel.font=[regular getSemiboldFont:15.0f];
    [countlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(ConfirmBtn.mas_left).with.offset(-16);
        make.left.mas_equalTo(numlabel.mas_right).with.offset(10);
        make.top.bottom.mas_equalTo(0);
    }];
    
    
}

-(void)ConfirmAction
{
    _block(@"confirm");
}
@end
