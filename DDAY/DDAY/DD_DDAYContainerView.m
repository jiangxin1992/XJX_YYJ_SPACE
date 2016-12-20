//
//  DD_DDAYContainerView.m
//  YCO SPACE
//
//  Created by yyj on 16/8/8.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_DDAYContainerView.h"

#import <WebKit/WebKit.h>

#import "DD_ImageModel.h"
#import "DD_DDayDetailModel.h"

@interface DD_DDAYContainerView()<WKNavigationDelegate>

@end

@implementation DD_DDAYContainerView

-(instancetype)initWithGoodsDetailModel:(DD_DDayDetailModel *)model WithBlock:(void (^)(NSString *type))block
{
    self=[super init];
    if(self)
    {
        _detailModel=model;
        _block=block;
        [self UIConfig];
    }
    return self;
}
-(void)UIConfig
{
    
    UIImageView *seriesImg=[UIImageView getCustomImg];
    [self addSubview:seriesImg];
    seriesImg.contentMode=2;
    [regular setZeroBorder:seriesImg];
    
    [seriesImg JX_ScaleAspectFill_loadImageUrlStr:_detailModel.seriesFrontPic.pic WithSize:800 placeHolderImageName:nil radius:0];
    CGFloat _height_s_img=([_detailModel.seriesFrontPic.height floatValue]/[_detailModel.seriesFrontPic.width floatValue])*ScreenWidth;
    [seriesImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(7);
        make.height.mas_equalTo(_height_s_img);
    }];
    
    UILabel *brandLabel=[UILabel getLabelWithAlignment:0 WithTitle:_detailModel.name WithFont:15.0f WithTextColor:_define_black_color WithSpacing:0];
    [self addSubview:brandLabel];
    [brandLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kEdge);
        make.right.mas_equalTo(-kEdge);
        make.top.mas_equalTo(seriesImg.mas_bottom).with.offset(18);
    }];
    
    UILabel *ddayTitleLabel=[UILabel getLabelWithAlignment:0 WithTitle:_detailModel.seriesTips WithFont:13.0f WithTextColor:_define_black_color WithSpacing:0];
    [self addSubview:ddayTitleLabel];
    [ddayTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kEdge);
        make.right.mas_equalTo(-kEdge);
        make.top.mas_equalTo(brandLabel.mas_bottom).with.offset(9);
    }];
    
    UILabel *activeLabel=[UILabel getLabelWithAlignment:1 WithTitle:@"线上发布会" WithFont:13.0f WithTextColor:_define_white_color WithSpacing:0];
    [self addSubview:activeLabel];
    activeLabel.backgroundColor=[UIColor colorWithHexString:_detailModel.seriesColor];
    [activeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kEdge);
        make.top.mas_equalTo(ddayTitleLabel.mas_bottom).with.offset(18);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(21);
    }];
    
//    UIButton *discountButton=[UIButton getCustomTitleBtnWithAlignment:0 WithFont:13.0f WithSpacing:0 WithNormalTitle:_detailModel.discount WithNormalColor:[UIColor colorWithHexString:_detailModel.seriesColor] WithSelectedTitle:nil WithSelectedColor:nil];
//    [self addSubview:discountButton];
//    discountButton.backgroundColor=[UIColor colorWithHexString:_detailModel.seriesColor];
//    [discountButton setBackgroundImage:[UIImage imageNamed:@"DDAY_Discountframe"] forState:UIControlStateNormal];
////    discountButton
//    [discountButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(activeLabel.mas_right).with.offset(11);
//        make.centerY.mas_equalTo(activeLabel);
//        make.height.mas_equalTo(21);
//        make.width.mas_equalTo(45);
//    }];
    
    UIImageView *timeImg=[UIImageView getImgWithImageStr:@"DDAY_Black_Clock"];
    [self addSubview:timeImg];
    [timeImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kEdge);
        make.height.width.mas_equalTo(15);
        make.top.mas_equalTo(activeLabel.mas_bottom).with.offset(20);
    }];
    
    UILabel *timeLabel=[UILabel getLabelWithAlignment:0 WithTitle:[[NSString alloc] initWithFormat:@"%@ - %@",[regular getTimeStr:_detailModel.saleStartTime WithFormatter:@"YYYY.MM.dd"],[regular getTimeStr:_detailModel.saleEndTime WithFormatter:@"YYYY.MM.dd"]] WithFont:13.0f WithTextColor:_define_black_color WithSpacing:0];
    [self addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(timeImg.mas_right).with.offset(15);
        make.right.mas_equalTo(-kEdge);
        make.centerY.mas_equalTo(timeImg);
    }];

    
    UIView *upline=[UIView getCustomViewWithColor:[UIColor colorWithHexString:_detailModel.seriesColor]];
    [self addSubview:upline];
    [upline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(timeLabel.mas_bottom).with.offset(20);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(4);

    }];
    
    UIView *view1=[UIView getCustomViewWithColor:_define_black_color];
    [self addSubview:view1];
    [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kEdge);
        make.top.mas_equalTo(upline.mas_bottom).with.offset(25);
        make.width.mas_equalTo(4);
        make.height.mas_equalTo(17);
    }];
    
    UILabel *designerLabel=[UILabel getLabelWithAlignment:0 WithTitle:@"关于设计师" WithFont:15.0f WithTextColor:nil WithSpacing:0];
    [self addSubview:designerLabel];
    [designerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(view1.mas_right).with.offset(6);
        make.centerY.mas_equalTo(view1);
    }];
    
    UIButton *desigerBtn=[UIButton getCustomBtn];
    [self addSubview:desigerBtn];
    [desigerBtn addTarget:self action:@selector(designerAction) forControlEvents:UIControlEventTouchUpInside];
    [desigerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(view1.mas_bottom).with.offset(0);
    }];
    
    UIImageView *brandImg=[UIImageView getCustomImg];
    [desigerBtn addSubview:brandImg];
    brandImg.contentMode=2;
    [regular setZeroBorder:brandImg];
    [brandImg JX_ScaleAspectFill_loadImageUrlStr:_detailModel.brandPic.pic WithSize:400 placeHolderImageName:nil radius:0];
    [brandImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kEdge);
        make.top.mas_equalTo(view1.mas_bottom).with.offset(25);
        make.width.height.mas_equalTo(IsPhone5_gt?60:70);
    }];
    
    UIImageView *designerImg=[UIImageView getCustomImg];
    [desigerBtn addSubview:designerImg];
    designerImg.contentMode=2;
    [regular setZeroBorder:designerImg];
    [designerImg JX_ScaleAspectFill_loadImageUrlStr:_detailModel.designerHead WithSize:400 placeHolderImageName:nil radius:0];
    [designerImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(brandImg.mas_right).with.offset(20);
        make.top.mas_equalTo(brandImg);
        make.width.height.mas_equalTo(IsPhone5_gt?60:70);
        make.bottom.mas_equalTo(desigerBtn.mas_bottom).with.offset(-25);
    }];
    
    UILabel *designerName=[UILabel getLabelWithAlignment:0 WithTitle:_detailModel.designerName WithFont:13.0f WithTextColor:nil WithSpacing:0];
    [desigerBtn addSubview:designerName];
    [designerName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(designerImg.mas_right).with.offset(20);
        make.bottom.mas_equalTo(designerImg.mas_centerY).with.offset(0);
        make.right.mas_equalTo(-kEdge);
    }];
    
    UILabel *brandName=[UILabel getLabelWithAlignment:0 WithTitle:_detailModel.brandName WithFont:13.0f WithTextColor:nil WithSpacing:0];
    [desigerBtn addSubview:brandName];
    [brandName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(designerImg.mas_right).with.offset(20);
        make.top.mas_equalTo(designerImg.mas_centerY).with.offset(0);
        make.right.mas_equalTo(-kEdge);
    }];
    
    UIView *view2=[UIView getCustomViewWithColor:_define_black_color];
    [self addSubview:view2];
    [view2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kEdge);
        make.top.mas_equalTo(desigerBtn.mas_bottom).with.offset(0);
        make.width.mas_equalTo(4);
        make.height.mas_equalTo(17);
    }];
    
    UILabel *seriesLabel=[UILabel getLabelWithAlignment:0 WithTitle:@"关于系列" WithFont:15.0f WithTextColor:nil WithSpacing:0];
    [self addSubview:seriesLabel];
    [seriesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(view2.mas_right).with.offset(6);
        make.centerY.mas_equalTo(view2);
    }];
    
    UIImageView *seriesBannerPicImg=[UIImageView getCustomImg];
    [self addSubview:seriesBannerPicImg];
    seriesBannerPicImg.contentMode=2;
    [regular setZeroBorder:seriesBannerPicImg];
    [seriesBannerPicImg JX_ScaleAspectFill_loadImageUrlStr:_detailModel.seriesBannerPic.pic WithSize:800 placeHolderImageName:nil radius:0];
    [seriesBannerPicImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kEdge);
        make.top.mas_equalTo(view2.mas_bottom).with.offset(25);
        make.right.mas_offset(-kEdge);
        make.height.mas_equalTo(([_detailModel.seriesBannerPic.height floatValue]/[_detailModel.seriesBannerPic.width floatValue])*(ScreenWidth-2*kEdge));
    }];

//    UILabel *seriesBriefLabel=[UILabel getLabelWithAlignment:0 WithTitle:_detailModel.seriesBrief WithFont:13.0f WithTextColor:nil WithSpacing:0];
//    [self addSubview:seriesBriefLabel];
//    seriesBriefLabel.numberOfLines=0;
//    seriesBriefLabel.lineBreakMode=NSLineBreakByCharWrapping;
//    [seriesBriefLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(kEdge);
//        make.right.mas_offset(-kEdge);
//        make.top.mas_equalTo(seriesBannerPicImg.mas_bottom).with.offset(30);
//        make.width.mas_equalTo(250);
//        make.bottom.mas_equalTo(-28);
//    }];

    WKWebView *seriesBriefWebView=[[WKWebView alloc] init];
    [self addSubview:seriesBriefWebView];
    seriesBriefWebView.userInteractionEnabled=NO;
    seriesBriefWebView.navigationDelegate = self;
    [seriesBriefWebView loadHTMLString:[regular getHTMLStringWithContent:_detailModel.seriesBrief WithFont:@"13px/16px" WithColorCode:@"#000000"] baseURL:nil];
    [seriesBriefWebView sizeToFit];
    [seriesBriefWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kEdge);
        make.right.mas_offset(-kEdge);
        make.top.mas_equalTo(seriesBannerPicImg.mas_bottom).with.offset(30);
        make.height.mas_equalTo(0);
        make.bottom.mas_equalTo(-28);
    }];
}
#pragma mark - WKNavigationDelegate

//加载完成时调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [webView evaluateJavaScript:@"document.body.offsetHeight" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        CGFloat height = floor([result doubleValue])+2;
        [webView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(height);
        }];
    }];
}

-(void)designerAction
{
    _block(@"enter_designer_homepage");
}
@end
