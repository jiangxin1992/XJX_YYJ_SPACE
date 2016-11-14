//
//  DD_IntegralHeadView.m
//  YCO SPACE
//
//  Created by yyj on 2016/10/31.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_IntegralHeadView.h"

@implementation DD_IntegralHeadView
{
    UILabel *_integralCountLabel;
    UILabel *_deductionCountLabel;
    UIButton *_integralRuleBtn;
}

-(instancetype)initWithIntegralCount:(NSInteger )integralCount WithDeductionCount:(NSInteger )deductionCount WithBlock:(void(^)(NSString *type))block
{
    self=[super init];
    if(self)
    {
        _block=block;
        _integralCount=integralCount;
        _deductionCount=deductionCount;
        self.frame=CGRectMake(0, 0, ScreenWidth, 175);
        
        UIView *_circle_view=[UIView getCustomViewWithColor:nil];
        [self addSubview:_circle_view];
        _circle_view.layer.masksToBounds=YES;
        _circle_view.layer.cornerRadius=49;
        _circle_view.layer.borderColor=[_define_black_color CGColor];
        _circle_view.layer.borderWidth=2;
        [_circle_view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(21);
            make.centerX.mas_equalTo(self);
            make.width.height.mas_equalTo(98);
        }];
        
        _integralCountLabel=[UILabel getLabelWithAlignment:0 WithTitle:@"" WithFont:18.0f WithTextColor:nil WithSpacing:0];
        [_circle_view addSubview:_integralCountLabel];
        _integralCountLabel.font=[regular getSemiboldFont:18.0f];
        _integralCountLabel.text=[[NSString alloc] initWithFormat:@"%ld积分",_integralCount];
        [_integralCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(_circle_view.mas_centerY).with.offset(-2);
            make.centerX.mas_equalTo(self);
        }];
        
        _deductionCountLabel=[UILabel getLabelWithAlignment:0 WithTitle:@"" WithFont:12.0f WithTextColor:_define_light_gray_color1 WithSpacing:0];
        [_circle_view addSubview:_deductionCountLabel];
        _deductionCountLabel.text=[[NSString alloc] initWithFormat:@"可抵扣%ld元",_deductionCount];
        [_deductionCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_circle_view.mas_centerY).with.offset(3);
            make.centerX.mas_equalTo(self);
        }];
        
        _integralRuleBtn=[UIButton getCustomBtn];
        [self addSubview:_integralRuleBtn];
        [_integralRuleBtn addTarget:self action:@selector(ruleAction) forControlEvents:UIControlEventTouchUpInside];
        [_integralRuleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.mas_equalTo(0);
            make.width.mas_equalTo(110);
            make.height.mas_equalTo(55);
        }];
        
        UILabel *_integralRuleLabel=[UILabel getLabelWithAlignment:2 WithTitle:@"积分规则" WithFont:12.0f WithTextColor:nil WithSpacing:0];
        [_integralRuleBtn addSubview:_integralRuleLabel];
        [_integralRuleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(21);
            make.right.mas_equalTo(-kEdge);
        }];
        
        UILabel *_integralTitleLabel=[UILabel getLabelWithAlignment:1 WithTitle:@"积分明细" WithFont:13.0f WithTextColor:_define_light_gray_color1 WithSpacing:0];
        [self addSubview:_integralTitleLabel];
        [_integralTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_circle_view.mas_bottom).with.offset(0);
            make.bottom.left.right.mas_equalTo(0);
        }];
        
        UIView *line=[UIView getCustomViewWithColor:_define_black_color];
        [self addSubview:line];
        line.backgroundColor=_define_light_gray_color1;
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(kEdge);
            make.right.mas_equalTo(-kEdge);
            make.height.mas_equalTo(1);
            make.bottom.mas_equalTo(self.bottom).with.offset(0);
            
        }];
    }
    return self;
}
-(void)ruleAction
{
    _block(@"rule");
}
-(void)update
{
    _integralCountLabel.text=[[NSString alloc] initWithFormat:@"%ld积分",_integralCount];
    _deductionCountLabel.text=[[NSString alloc] initWithFormat:@"可抵扣%ld元",_deductionCount];
}
@end
