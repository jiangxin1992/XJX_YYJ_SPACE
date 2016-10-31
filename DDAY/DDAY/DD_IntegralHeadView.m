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
        self.frame=CGRectMake(0, 0, ScreenWidth, 100);
        
        _integralCountLabel=[UILabel getLabelWithAlignment:0 WithTitle:@"" WithFont:18.0f WithTextColor:nil WithSpacing:0];
        [self addSubview:_integralCountLabel];
        _integralCountLabel.text=[[NSString alloc] initWithFormat:@"%ld积分",_integralCount];
        [_integralCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.mas_centerY).with.offset(-5);
            make.centerX.mas_equalTo(self);
        }];
        
        
        _deductionCountLabel=[UILabel getLabelWithAlignment:0 WithTitle:@"" WithFont:16.0f WithTextColor:_define_light_gray_color WithSpacing:0];
        [self addSubview:_deductionCountLabel];
        _deductionCountLabel.text=[[NSString alloc] initWithFormat:@"可抵扣%ld元",_deductionCount];
        [_deductionCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_centerY).with.offset(5);
            make.centerX.mas_equalTo(self);
        }];
        
        _integralRuleBtn=[UIButton getCustomTitleBtnWithAlignment:0 WithFont:16.0f WithSpacing:0 WithNormalTitle:@"积分规则" WithNormalColor:nil WithSelectedTitle:nil WithSelectedColor:nil];
        [self addSubview:_integralRuleBtn];
        [_integralRuleBtn addTarget:self action:@selector(ruleAction) forControlEvents:UIControlEventTouchUpInside];
        [_integralRuleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(5);
            make.right.mas_equalTo(-5);
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
