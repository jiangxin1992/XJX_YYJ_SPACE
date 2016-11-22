//
//  DD_BenefitView.m
//  YCO SPACE
//
//  Created by yyj on 2016/11/22.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_BenefitView.h"

@implementation DD_BenefitView
{
    UIImageView *_benefitImg;
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
        
        _benefitImg=[UIImageView getCustomImg];
        [self addSubview:_benefitImg];
        _benefitImg.contentMode=0;
        CGFloat _height = floor(([_benefitModel.picInfo.height floatValue]/[_benefitModel.picInfo.width floatValue])*200);
        [_benefitImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self);
            make.height.mas_equalTo(_height);
            make.width.mas_equalTo(200);
        }];
        [_benefitImg JX_ScaleToFill_loadImageUrlStr:_benefitModel.picInfo.pic WithSize:800 placeHolderImageName:nil radius:0];
        
        
        UIButton *_checkBtn=[UIButton getCustomTitleBtnWithAlignment:0 WithFont:15.0f WithSpacing:0 WithNormalTitle:@"点击查看红包" WithNormalColor:nil WithSelectedTitle:nil  WithSelectedColor:nil];
        [_benefitImg addSubview:_checkBtn];
        CGFloat _width=[regular getWidthWithHeight:9999 WithContent:@"点击查看红包" WithFont:[regular getFont:15.0f]]+10;
        [_checkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(30);
            make.centerX.mas_equalTo(_benefitImg);
            make.width.mas_equalTo(_width);
        }];
        _checkBtn.backgroundColor=_define_white_color;
        [_checkBtn addTarget:self action:@selector(checkAction) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *closeBtn=[UIButton getCustomTitleBtnWithAlignment:0 WithFont:15.0f WithSpacing:0 WithNormalTitle:@"关闭" WithNormalColor:nil WithSelectedTitle:nil WithSelectedColor:nil];
        [self addSubview:closeBtn];
        [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_benefitImg.mas_top).with.offset(0);
            make.centerX.mas_equalTo(_benefitImg.mas_right).with.offset(0);
            make.height.width.mas_equalTo(50);
        }];
        closeBtn.backgroundColor=_define_white_color;
        [closeBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}
-(void)setState
{
    CGFloat _height = floor(([_benefitModel.picInfo.height floatValue]/[_benefitModel.picInfo.width floatValue])*200);
    [_benefitImg mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.height.mas_equalTo(_height);
        make.width.mas_equalTo(200);
    }];
    [_benefitImg JX_ScaleToFill_loadImageUrlStr:_benefitModel.picInfo.pic WithSize:800 placeHolderImageName:nil radius:0];
}
-(void)checkAction
{
    _block(@"enter");
}
-(void)closeAction
{
    _block(@"close");
}
@end
