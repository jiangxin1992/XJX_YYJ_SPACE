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
        CGFloat _pic_height=floor(([benefitInfoModel.picInfo.height floatValue]/[benefitInfoModel.picInfo.width floatValue])*ScreenWidth);
        self.frame=CGRectMake(0, 0, ScreenWidth, _pic_height);
        self.userInteractionEnabled=YES;
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(enterAction)]];
        
        UIImageView *benefitImg=[UIImageView getCustomImg];
        [self addSubview:benefitImg];
        benefitImg.frame=CGRectMake(0, 0, ScreenWidth, _pic_height);
        benefitImg.contentMode=0;
        [benefitImg JX_ScaleToFill_loadImageUrlStr:benefitInfoModel.picInfo.pic WithSize:800 placeHolderImageName:nil radius:0];
        
        UIButton *btn=[UIButton getCustomTitleBtnWithAlignment:0 WithFont:14.0f WithSpacing:0 WithNormalTitle:@"" WithNormalColor:nil WithSelectedTitle:nil WithSelectedColor:nil];
//        btn.backgroundColor=[UIColor redColor];
//        btn.alpha=0.5;
        btn.frame=CGRectMake(ScreenWidth-_pic_height*4.0f/6.0f, _pic_height/4.0f, _pic_height/2.0f, _pic_height/2.0f);
        [self addSubview:btn];
        [btn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    return self;
}
-(void)closeAction
{
    _block(@"close");
}
-(void)enterAction
{
    _block(@"enter");
}
@end
