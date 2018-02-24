//
//  DD_ClearingTabbar.m
//  YCO SPACE
//
//  Created by yyj on 16/8/4.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_ClearingTabbar.h"

#import "DD_BenefitInfoModel.h"
#import "DD_ClearingModel.h"

@implementation DD_ClearingTabbar
{
    UILabel *countlabel;
}

-(instancetype)initWithClearingModel:(DD_ClearingModel *)clearingModel WithCountPrice:(CGFloat )countPrice WithCount:(CGFloat )count WithBlock:(void (^)(NSString *type))block
{
    self=[super init];
    if(self)
    {
        _clearingModel=clearingModel;
        _countPrice=countPrice;
        _count=count;
        _block=block;
        [self UIConfig];
        [self SetState];
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
        make.bottom.mas_equalTo(-kSafetyZoneHeight);
    }];
    [ConfirmBtn addTarget:self action:@selector(ConfirmAction) forControlEvents:UIControlEventTouchUpInside];
    ConfirmBtn.backgroundColor=_define_black_color;

    countlabel=[UILabel getLabelWithAlignment:0 WithTitle:@"" WithFont:15.0f WithTextColor:nil WithSpacing:0];
    [self addSubview:countlabel];
    countlabel.font=[regular getSemiboldFont:15.0f];
    [countlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(ConfirmBtn.mas_left).with.offset(-16);
        make.left.mas_equalTo(kEdge);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(-kSafetyZoneHeight);
    }];

    if(kIPhoneX){
        UIView *safetyLine = [UIView getCustomViewWithColor:_define_light_gray_color3];
        [self addSubview:safetyLine];
        [safetyLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(ConfirmBtn.mas_bottom).with.offset(0);
            make.height.mas_equalTo(1);
        }];
    }
}

-(void)SetState
{
    DD_BenefitInfoModel *_benefitModel=[_clearingModel getChoosedBenefitInfo];
    CGFloat _price=_countPrice;
    if(_clearingModel.benefitInfo)
    {
        if(_benefitModel.amount>_price)
        {
            _price=0;
        }else
        {
            _price=_price-_benefitModel.amount;
        }
    }
    
    if(_price&&_clearingModel.rewardPoints&&_clearingModel.use_rewardPoints)
    {
        if(_price>_clearingModel.employ_rewardPoints)
        {
            _price=_price-_clearingModel.employ_rewardPoints;
        }else
        {
            _price=0;
        }
    }
    
    countlabel.text=[[NSString alloc] initWithFormat:@"实付 ￥%@",[regular getRoundNum:_price]];
}
-(void)ConfirmAction
{
    _block(@"confirm");
}
@end
