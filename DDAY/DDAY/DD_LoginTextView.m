//
//  DD_LoginTextView.m
//  DDAY
//
//  Created by yyj on 16/7/14.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_LoginTextView.h"

@implementation DD_LoginTextView
-(instancetype)initWithFrame:(CGRect )_frame WithImgStr:(NSString *)_imgStr WithSize:(CGSize )_size isLeft:(BOOL)_isLeft WithBlock:(void (^)(NSString *type))block
{
    self=[super initWithFrame:_frame];
    if(self)
    {
        _block=block;
        UIButton *btn=[UIButton getCustomBackImgBtnWithImageStr:_imgStr WithSelectedImageStr:nil];
        [self addSubview:btn];
        [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self);

            make.width.mas_equalTo(_size.width);
            make.height.mas_equalTo(_size.height);
            if(_isLeft)
            {
                make.left.mas_equalTo(0);
            }else
            {
                make.right.mas_equalTo(0);
            }
        }];
        
    }
    return self;
}
-(instancetype)initWithTimingFrame:(CGRect )_frame WithSize:(CGSize )_size isLeft:(BOOL)_isLeft WithBlock:(void (^)(NSString *type))block
{
    self=[super initWithFrame:_frame];
    if(self)
    {
        _block=block;
        UIButton *btn=[UIButton getCustomTitleBtnWithAlignment:0 WithFont:13.0f WithSpacing:0 WithNormalTitle:@"验证" WithNormalColor:nil WithSelectedTitle:nil WithSelectedColor:nil];
        [self addSubview:btn];
        [btn addTarget:self action:@selector(sendCodeAction) forControlEvents:UIControlEventTouchUpInside];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self);
            make.width.mas_equalTo(_size.width);
            make.height.mas_equalTo(_size.height);
            if(_isLeft)
            {
                make.left.mas_equalTo(0);
            }else
            {
                make.right.mas_equalTo(0);
            }
        }];
    }
    return self;
}
-(void)sendCodeAction
{
    _block(@"send_code");
}
-(void)btnAction
{
    _block(@"click");
}
@end
