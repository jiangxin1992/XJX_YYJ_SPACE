//
//  DD_BenefitView.m
//  YCO SPACE
//
//  Created by yyj on 2016/11/22.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_BenefitView.h"

#import "DD_ImageModel.h"
#import "DD_BenefitInfoModel.h"

@implementation DD_BenefitView
{
    UIImageView *_benefitImg;
    UILabel *_titleLabel;
    UILabel *_amountLabel;
}

static DD_BenefitView *benefitView = nil;

#pragma mark - 创建单例
+(id)sharedManagerWithModel:(DD_BenefitInfoModel *)benefitModel WithBlock:(void (^)(NSString *type))block
{
    //    创建CustomTabbarController的单例，并通过此方法调用
    //    互斥锁，确保单例只能被创建一次
    @synchronized(self)
    {
        if (!benefitView) {
            benefitView = [[DD_BenefitView alloc]initWithModel:benefitModel WithBlock:block];
        }else
        {
            benefitView.benefitModel=benefitModel;
            [benefitView setState];
        }
    }
    return benefitView;
}

- (instancetype)initWithModel:(DD_BenefitInfoModel *)benefitModel WithBlock:(void (^)(NSString *))block
{
    self = [super initWithFrame:[[UIScreen mainScreen] bounds]];
    if (self) {
        _benefitModel=benefitModel;
        _block=block;
        
        UIImageView *backView=[UIImageView getImgWithImageStr:@"User_Benefit_Mask"];
        [self addSubview:backView];
        backView.contentMode=UIViewContentModeScaleToFill;
        backView.userInteractionEnabled=YES;
//        [backView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeAction)]];
        [backView bk_whenTapped:^{
//            关闭
            [self closeAction];
        }];
        [backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
        
        _benefitImg=[UIImageView getImgWithImageStr:@"User_Benefit_Back"];
        [backView addSubview:_benefitImg];
        _benefitImg.contentMode=UIViewContentModeScaleToFill;
        _benefitImg.userInteractionEnabled=YES;
        [_benefitImg addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(NULLACTION)]];
        CGFloat _height = floor((373.0f/272.0f)*(ScreenWidth-100));
        [_benefitImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self);
            make.height.mas_equalTo(_height);
            make.width.mas_equalTo(ScreenWidth-100);
        }];
        
        _titleLabel=[UILabel getLabelWithAlignment:1 WithTitle:_benefitModel.name WithFont:24.0f WithTextColor:_define_white_color WithSpacing:0];
        [_benefitImg addSubview:_titleLabel];
        _titleLabel.font=[regular getSemiboldFont:24.0f];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(64);
        }];
        
        _amountLabel=[UILabel getLabelWithAlignment:1 WithTitle:[[NSString alloc] initWithFormat:@"%ld",_benefitModel.amount] WithFont:150 WithTextColor:_define_white_color WithSpacing:0];
        [_benefitImg addSubview:_amountLabel];
        _amountLabel.font=[UIFont fontWithName:@"DIN-Medium" size:150.0f];
        [_amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(_benefitImg);
        }];
        
        UIButton *_checkBtn=[UIButton getCustomTitleBtnWithAlignment:0 WithFont:15.0f WithSpacing:0 WithNormalTitle:@"点击查看红包" WithNormalColor:nil WithSelectedTitle:nil  WithSelectedColor:nil];
        [_benefitImg addSubview:_checkBtn];
        [_checkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-38);
            make.centerX.mas_equalTo(_benefitImg);
            make.width.mas_equalTo(135);
            make.height.mas_equalTo(35);
        }];
        _checkBtn.backgroundColor=_define_white_color;
        [_checkBtn addTarget:self action:@selector(checkAction) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *closeBtn=[UIButton getCustomBackImgBtnWithImageStr:@"User_Benefit_Close" WithSelectedImageStr:nil];
        [_benefitImg addSubview:closeBtn];
        [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(32);
            make.right.mas_equalTo(-32);
            make.height.width.mas_equalTo(13);
        }];
        [closeBtn setEnlargeEdge:20];
        [closeBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}
-(void)setState
{
    _titleLabel.text=_benefitModel.name;
    _amountLabel.text=[[NSString alloc] initWithFormat:@"%ld",_benefitModel.amount];
}
-(void)checkAction
{
    _block(@"enter");
}
-(void)closeAction
{
    _block(@"close");
}
-(void)NULLACTION{}
@end
