//
//  DD_headViewBenefitView.m
//  YCO SPACE
//
//  Created by yyj on 2016/10/27.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_headViewBenefitView.h"



@implementation DD_headViewBenefitView

-(instancetype)initWithModel:(DD_BenefitInfoModel *)benefitInfoModel WithBlock:(void (^)(NSString *type))block
{
    self=[super init];
    if(self)
    {
        _block=block;
        self.backgroundColor=[UIColor redColor];
        self.frame=CGRectMake(0, 0, ScreenWidth, 80);
        
        UIButton *btn=[UIButton getCustomTitleBtnWithAlignment:0 WithFont:14.0f WithSpacing:0 WithNormalTitle:@"关 闭" WithNormalColor:nil WithSelectedTitle:nil WithSelectedColor:nil];
        btn.frame=CGRectMake(ScreenWidth-60, 0, 60, 40);
        btn.backgroundColor=[UIColor yellowColor];
        [self addSubview:btn];
        [btn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    return self;
}
-(void)closeAction
{
    _block(@"close");
}

@end
