//
//  DD_DDAYContainerView.m
//  YCO SPACE
//
//  Created by yyj on 16/8/8.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_DDAYContainerView.h"

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
//    UIImageView
    UIView *imgBackView=[UIView getCustomViewWithColor:nil];
    [self addSubview:imgBackView];
    [regular setBorder:imgBackView];
    [imgBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kEdge);
        make.right.mas_equalTo(-kEdge);
        make.top.mas_equalTo(7);
        make.height.width.mas_equalTo(imgBackView.mas_width);
        
    }];
    
    UIImageView *seriesImg=[UIImageView getCustomImg];
    [imgBackView addSubview:seriesImg];
    seriesImg.contentMode=2;
    [regular setZeroBorder:seriesImg];
    [seriesImg JX_ScaleAspectFill_loadImageUrlStr:_detailModel.seriesFrontPic.pic WithSize:800 placeHolderImageName:nil radius:0];
    [seriesImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(imgBackView).with.insets(UIEdgeInsetsMake(15, 15, 15, 15));
    }];
    
    UIView *timeBackView=[UIView getCustomViewWithColor:nil];
    [self addSubview:timeBackView];
    [regular setBorder:timeBackView];
    [timeBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kEdge);
        make.right.mas_equalTo(-kEdge);
        make.top.mas_equalTo(imgBackView.mas_bottom).with.offset(36);
        make.height.mas_equalTo(30);
    }];
    
    for (int i=0; i<2; i++) {
        UILabel *timelabel=[UILabel getLabelWithAlignment:i==0?0:2 WithTitle:i==0?[regular getTimeStr:_detailModel.saleStartTime WithFormatter:@"YYYY-MM-dd HH:mm"]:[regular getTimeStr:_detailModel.saleEndTime WithFormatter:@"YYYY-MM-dd HH:mm"] WithFont:14.0f WithTextColor:nil WithSpacing:0];
        [timeBackView addSubview:timelabel];
        [timelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            if(i==0)
            {
                make.right.mas_equalTo(timeBackView.mas_centerX).with.offset(-22);
                make.top.bottom.mas_equalTo(0);
                make.left.mas_equalTo(10);
            }else
            {
                make.left.mas_equalTo(timeBackView.mas_centerX).with.offset(22);
                make.top.bottom.mas_equalTo(0);
                make.right.mas_equalTo(-10);
            }
        }];
    }
    
    UIView *timeMiddleLine=[UIView getCustomViewWithColor:_define_black_color];
    [timeBackView addSubview:timeMiddleLine];
    [timeMiddleLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(timeBackView);
        make.height.mas_equalTo(5);
        make.width.mas_equalTo(16);
    }];
//
    UILabel *seriesTipsLabel=[UILabel getLabelWithAlignment:1 WithTitle:_detailModel.seriesTips WithFont:12.0f WithTextColor:nil WithSpacing:0];
    [self addSubview:seriesTipsLabel];
    [seriesTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kEdge);
        make.right.mas_equalTo(-kEdge);
        make.top.mas_equalTo(timeBackView.mas_bottom).with.offset(19);
    }];
    [seriesTipsLabel sizeToFit];
    
    UIView *upline=[UIView getCustomViewWithColor:_define_black_color];
    [self addSubview:upline];
    [upline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(seriesTipsLabel.mas_bottom).with.offset(27);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(1);

    }];
    
    UIImageView *brandPicImg=[UIImageView getCustomImg];
    [self addSubview:brandPicImg];
    brandPicImg.contentMode=0;
    [brandPicImg JX_ScaleToFill_loadImageUrlStr:_detailModel.brandPic.pic WithSize:800 placeHolderImageName:nil radius:0];
    [brandPicImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(upline.mas_bottom).with.offset(30);
        make.left.mas_equalTo(50);
        make.right.mas_equalTo(-50);
        make.height.mas_equalTo(([_detailModel.brandPic.height floatValue]/[_detailModel.brandPic.width floatValue])*(ScreenWidth-100));
    }];
    
//    60 90
    UIView *lastView=nil;
    for (int i=0; i<2; i++) {
        UILabel *label=[UILabel getLabelWithAlignment:0 WithTitle:i==0?@"ABOUT":@"关于品牌/设计师" WithFont:15.0f WithTextColor:nil WithSpacing:0];
        [self addSubview:label];
        [label sizeToFit];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(kEdge);
            if(lastView)
            {
                make.top.mas_equalTo(lastView.mas_bottom).with.offset(0);
            }else
            {
                make.top.mas_equalTo(brandPicImg.mas_bottom).with.offset(30);
            }
            
        }];
        [label sizeToFit];
        lastView=label;
    }
    
    UILabel *brandBriefLabel=[UILabel getLabelWithAlignment:0 WithTitle:_detailModel.brandBrief WithFont:12.0f WithTextColor:nil WithSpacing:0];
    [self addSubview:brandBriefLabel];
    brandBriefLabel.numberOfLines=0;
    [brandBriefLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-kEdge);
        make.top.mas_equalTo(lastView.mas_bottom).with.offset(30);
        make.width.mas_equalTo(250);
    }];
    [brandBriefLabel sizeToFit];
    
    UIView *downLine=[UIView getCustomViewWithColor:_define_black_color];
    [self addSubview:downLine];
    [downLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(brandBriefLabel.mas_bottom).with.offset(27);
        make.height.mas_equalTo(1);
    }];
    
    
    UIImageView *seriesBannerPicImg=[UIImageView getCustomImg];
    [self addSubview:seriesBannerPicImg];
    seriesBannerPicImg.contentMode=0;
    [seriesBannerPicImg JX_ScaleToFill_loadImageUrlStr:_detailModel.seriesBannerPic.pic WithSize:800 placeHolderImageName:nil radius:0];
    [seriesBannerPicImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kEdge);
        make.top.mas_equalTo(downLine.mas_bottom).with.offset(kEdge);
        make.width.mas_equalTo(205);
        make.height.mas_equalTo(([_detailModel.seriesBannerPic.height floatValue]/[_detailModel.seriesBannerPic.width floatValue])*(205));
    }];
    UIView *lastViewSeries=nil;
    for (int i=0; i<2; i++) {
        UILabel *label=[UILabel getLabelWithAlignment:0 WithTitle:i==0?@"ABOUT":@"关于发布系列" WithFont:15.0f WithTextColor:nil WithSpacing:0];
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(kEdge);
            if(lastViewSeries)
            {
                make.top.mas_equalTo(lastViewSeries.mas_bottom).with.offset(0);
            }else
            {
                make.top.mas_equalTo(seriesBannerPicImg.mas_bottom).with.offset(30);
            }
        }];
        [label sizeToFit];
        lastViewSeries=label;
    }

    UILabel *seriesBriefLabel=[UILabel getLabelWithAlignment:0 WithTitle:_detailModel.seriesBrief WithFont:12.0f WithTextColor:nil WithSpacing:0];
    [self addSubview:seriesBriefLabel];
    seriesBriefLabel.numberOfLines=0;
    [seriesBriefLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-kEdge);
        make.top.mas_equalTo(lastViewSeries.mas_bottom).with.offset(30);
        make.width.mas_equalTo(250);
        make.bottom.mas_equalTo(-15);
    }];
    [seriesBriefLabel sizeToFit];
    
}

@end
