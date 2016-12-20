//
//  DD_DDAYOfflineContainerView.m
//  YCOSPACE
//
//  Created by yyj on 2016/12/12.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_DDAYOfflineContainerView.h"

#import <WebKit/WebKit.h>

#import "DD_ImageModel.h"
#import "DD_DDayDetailModel.h"
#import "DD_ShowRoomModel.h"

@interface DD_DDAYOfflineContainerView()<WKNavigationDelegate>

@end

@implementation DD_DDAYOfflineContainerView

-(instancetype)initWithGoodsDetailModel:(DD_DDayDetailModel *)model WithBlock:(void (^)(NSString *type))block
{
    self=[super init];
    if(self)
    {
        _detailModel=model;
        _block=block;
        self.backgroundColor=_define_white_color;
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
    
    UILabel *activeLabel=[UILabel getLabelWithAlignment:1 WithTitle:@"活动详情" WithFont:13.0f WithTextColor:_define_white_color WithSpacing:0];
    [self addSubview:activeLabel];
    activeLabel.backgroundColor=[UIColor colorWithHexString:_detailModel.seriesColor];
    [activeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kEdge);
        make.top.mas_equalTo(ddayTitleLabel.mas_bottom).with.offset(18);
        make.width.mas_equalTo(62);
        make.height.mas_equalTo(21);
    }];
    
    UIImageView *timeImg=[UIImageView getImgWithImageStr:@"DDAY_Black_Clock"];
    [self addSubview:timeImg];
    [timeImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kEdge);
        make.height.width.mas_equalTo(18);
        make.top.mas_equalTo(activeLabel.mas_bottom).with.offset(26);
    }];
    
    UILabel *timeLabel=[UILabel getLabelWithAlignment:0 WithTitle:[[NSString alloc] initWithFormat:@"%@ - %@",[regular getTimeStr:_detailModel.saleStartTime WithFormatter:@"YYYY.MM.dd"],[regular getTimeStr:_detailModel.saleEndTime WithFormatter:@"YYYY.MM.dd"]] WithFont:13.0f WithTextColor:_define_black_color WithSpacing:0];
    [self addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(timeImg.mas_right).with.offset(15);
        make.right.mas_equalTo(-kEdge);
        make.centerY.mas_equalTo(timeImg);
    }];
    
    UIButton *addressBtn=[UIButton getCustomBtn];
    [self addSubview:addressBtn];
    [addressBtn addTarget:self action:@selector(addressAction) forControlEvents:UIControlEventTouchUpInside];
    [addressBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(timeImg.mas_bottom).with.offset(10);
        make.height.mas_equalTo(45);
        make.left.right.mas_equalTo(0);
    }];
    
//    System_Triangle_Right
    UIImageView *rightImg=[UIImageView getImgWithImageStr:@"System_Triangle_Right"];
    [addressBtn addSubview:rightImg];
    [rightImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-kEdge);
        make.centerY.mas_equalTo(addressBtn);
        make.width.mas_equalTo(10);
        make.height.mas_equalTo(12);
    }];
    
    UIView *upview=[UIView getCustomViewWithColor:_define_light_gray_color1];
    [addressBtn addSubview:upview];
    [upview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(kEdge);
        make.right.mas_equalTo(-kEdge);
        make.height.mas_equalTo(1);
    }];
    
    UIView *downview=[UIView getCustomViewWithColor:_define_light_gray_color1];
    [addressBtn addSubview:downview];
    [downview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(kEdge);
        make.right.mas_equalTo(-kEdge);
        make.height.mas_equalTo(1);
    }];
    
    UIImageView *addressImg=[UIImageView getImgWithImageStr:@"DDAY_Address"];
    [addressBtn addSubview:addressImg];
    [addressImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kEdge);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(26);
        make.centerY.mas_equalTo(addressBtn);
    }];
    
    UILabel *addressLabel=[UILabel getLabelWithAlignment:0 WithTitle:_detailModel.physicalStore.address WithFont:13.0f WithTextColor:_define_black_color WithSpacing:0];
    [addressBtn addSubview:addressLabel];
    [addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(addressImg.mas_right).with.offset(15);
        make.right.mas_equalTo(-kEdge);
        make.centerY.mas_equalTo(addressImg);
    }];
    
//    UIView *upline=[UIView getCustomViewWithColor:[UIColor colorWithHexString:_detailModel.seriesColor]];
//    [self addSubview:upline];
//    [upline mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(addressBtn.mas_bottom).with.offset(10);
//        make.left.right.mas_equalTo(0);
//        make.height.mas_equalTo(4);
//    }];
    
    WKWebView *seriesBriefWebView=[[WKWebView alloc] init];
    [self addSubview:seriesBriefWebView];
    seriesBriefWebView.userInteractionEnabled=NO;
    seriesBriefWebView.navigationDelegate = self;
    [seriesBriefWebView loadRequest:[[NSURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:_detailModel.seriesBriefUrl]]];
    [seriesBriefWebView sizeToFit];
    [seriesBriefWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(addressBtn.mas_bottom).with.offset(0);
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
-(void)addressAction
{
    _block(@"address_detail");
}
@end
