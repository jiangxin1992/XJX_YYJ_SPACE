//
//  DD_BenefitHeadView.m
//  YCO SPACE
//
//  Created by yyj on 2016/11/4.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_BenefitHeadView.h"

@implementation DD_BenefitHeadView

-(instancetype)initWithBlock:(void (^)(NSString *type))block
{
    self=[super initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
    if(self){
        _block=block;
        UIButton *rule_btn=[UIButton getCustomBtn];
//        rule_btn.backgroundColor=[UIColor redColor];
        [self addSubview:rule_btn];
        [rule_btn addTarget:self action:@selector(ruleAction) forControlEvents:UIControlEventTouchUpInside];
        [rule_btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.right.mas_equalTo(0);
            make.width.mas_equalTo(100);
        }];
        
        UILabel *rule_label=[UILabel getLabelWithAlignment:2 WithTitle:@"使用规则" WithFont:13.0f WithTextColor:nil WithSpacing:0];
//        rule_label.backgroundColor=[UIColor blueColor];
        [rule_btn addSubview:rule_label];
        [rule_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(rule_btn);
            make.right.mas_equalTo(-kEdge);
        }];
    }
    return self;
}

-(void)ruleAction
{
    _block(@"rule");
}

@end
