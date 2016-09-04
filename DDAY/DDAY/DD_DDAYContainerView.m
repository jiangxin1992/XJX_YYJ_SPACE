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
//[NSDate ise]
//    UIView *imgBackView=[UIView getCustomViewWithColor:nil];
//    [self addSubview:imgBackView];
//    [regular setBorder:imgBackView WithColor:[UIColor colorWithHexString:_detailModel.seriesColor] WithWidth:2];
//    [imgBackView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(kEdge);
//        make.right.mas_equalTo(-kEdge);
//        make.top.mas_equalTo(7);
//        make.height.width.mas_equalTo(imgBackView.mas_width);
//        
//    }];
    
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
    
    UIView *timeBackView=[UIView getCustomViewWithColor:nil];
    [self addSubview:timeBackView];
    [timeBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kEdge);
        make.right.mas_equalTo(-kEdge);
        make.top.mas_equalTo(seriesImg.mas_bottom).with.offset(0);
    }];
    
//            _detailModel.saleStartTime=[regular getTimeWithTimeStr:@"2015-2-1 10:00"];
//            _detailModel.saleEndTime=[regular getTimeWithTimeStr:@"2015-10-1 10:00"];
    //
//    _detailModel.saleStartTime=[regular getTimeWithTimeStr:@"2015-2-1 10:00"];
//    _detailModel.saleEndTime=[regular getTimeWithTimeStr:@"2016-4-1 10:00"];
//    NSInteger _now_year=[[regular getTimeStr:[NSDate nowTime] WithFormatter:@"YYYY"] integerValue];
    NSString *_s_year=[regular getTimeStr:_detailModel.saleStartTime WithFormatter:@"YYYY"];
    NSString *_e_year=[regular getTimeStr:_detailModel.saleEndTime WithFormatter:@"YYYY"];
//    NSInteger _s_start_year=[_s_year integerValue];
//    NSInteger _e_start_year=[_e_year integerValue];
    for (int i=0; i<2; i++) {
//        YYYY
        UILabel *timelabel=[UILabel getLabelWithAlignment:i==0?2:0 WithTitle:i==0?[regular getTimeStr:_detailModel.saleStartTime WithFormatter:@"HH : mm"]:[regular getTimeStr:_detailModel.saleEndTime WithFormatter:@"MM . dd"] WithFont:i==0?15:18 WithTextColor:nil WithSpacing:0];
        [timeBackView addSubview:timelabel];
        timelabel.font=[regular get_en_Font:i==0?15:18];
        CGFloat _width=[regular getWidthWithHeight:34 WithContent:i==0?[regular getTimeStr:_detailModel.saleStartTime WithFormatter:@"HH : mm"]:[regular getTimeStr:_detailModel.saleEndTime WithFormatter:@"MM . dd"] WithFont:[regular get_en_Font:18.0f]];
        [timelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(60);
            if(i==0)
            {
                make.right.mas_equalTo(timeBackView.mas_centerX).with.offset(-28);
                make.bottom.mas_equalTo(0);
                
            }else
            {
                make.left.mas_equalTo(timeBackView.mas_centerX).with.offset(28);
                make.bottom.mas_equalTo(0);
            }
            make.width.mas_equalTo(_width);
            
        }];
        [timelabel sizeToFit];
        
        
        UILabel *daylabel=[UILabel getLabelWithAlignment:i==0?2:0 WithTitle:i==0?[regular getTimeStr:_detailModel.saleStartTime WithFormatter:@"MM . dd"]:[regular getTimeStr:_detailModel.saleEndTime WithFormatter:@"HH : mm"] WithFont:i==0?18:15 WithTextColor:nil WithSpacing:0];
        [timeBackView addSubview:daylabel];
        daylabel.font=[regular get_en_Font:i==0?18:15];
        [daylabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(60);
            if(i==0)
            {
                make.right.mas_equalTo(timelabel.mas_left).with.offset(-10);
                make.bottom.mas_equalTo(0);
            }else
            {
                make.left.mas_equalTo(timelabel.mas_right).with.offset(10);
                make.bottom.mas_equalTo(0);
            }
        }];
        [daylabel sizeToFit];
        
        //        今年
        //        横跨两个年
        //        没横跨 但是不是今年
//        if(_s_start_year!=_e_start_year)
//        {
            //            横跨
            NSString *_year=i==0?_s_year:_e_year;
            UILabel *yearLabel=[UILabel getLabelWithAlignment:1 WithTitle:_year WithFont:18.0f WithTextColor:nil WithSpacing:0];
            [timeBackView addSubview:yearLabel];
            yearLabel.font=[regular get_en_Font:14.0f];
            [yearLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                if(i==0)
                {
                    make.right.mas_equalTo(timeBackView.mas_centerX).with.offset(-28);
                }else
                {
                    make.left.mas_equalTo(timeBackView.mas_centerX).with.offset(28);
                }
                make.top.mas_equalTo(2);
                make.height.mas_equalTo(58);
            }];
            
//        }else
//        {
//            if(_s_start_year==_now_year)
//            {
//                //                今年
//                
//            }else
//            {
//                if(i==0)
//                {
//                    //                没横跨 但是不是今年
//                    UILabel *yearLabel=[UILabel getLabelWithAlignment:1 WithTitle:_s_year WithFont:18.0f WithTextColor:nil WithSpacing:0];
//                    [timeBackView addSubview:yearLabel];
//                    yearLabel.font=[regular get_en_Font:18.0f];
//                    [yearLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//                        make.centerX.mas_equalTo(timeBackView);
//                        make.top.mas_equalTo(0);
//                        make.height.mas_equalTo(34);
//                    }];
//                }
//                
//            }
//        }
        
    }
    
    
    UIView *timeMiddleLine=[UIView getCustomViewWithColor:_define_black_color];
    [timeBackView addSubview:timeMiddleLine];
    [timeMiddleLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(timeBackView.mas_centerY).with.offset(30);
        make.centerX.mas_equalTo(timeBackView);
        make.height.mas_equalTo(5);
        make.width.mas_equalTo(16);
    }];
//
    UILabel *seriesTipsLabel=[UILabel getLabelWithAlignment:1 WithTitle:_detailModel.seriesTips WithFont:12.0f WithTextColor:nil WithSpacing:0];
    [self addSubview:seriesTipsLabel];
    [seriesTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kEdge);
        make.right.mas_equalTo(-kEdge);
        if([NSString isNilOrEmpty:_detailModel.seriesTips])
        {
            make.top.mas_equalTo(timeBackView.mas_bottom).with.offset(0);
        }else
        {
            make.top.mas_equalTo(timeBackView.mas_bottom).with.offset(19);
        }
        
    }];
    [seriesTipsLabel sizeToFit];
    
    UIView *upline=[UIView getCustomViewWithColor:[UIColor colorWithHexString:_detailModel.seriesColor]];
    [self addSubview:upline];
    [upline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(seriesTipsLabel.mas_bottom).with.offset(28);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(1);

    }];
    
    UIImageView *brandPicImg=[UIImageView getCustomImg];
    [self addSubview:brandPicImg];
    brandPicImg.contentMode=0;
    [brandPicImg JX_ScaleToFill_loadImageUrlStr:_detailModel.brandPic.pic WithSize:800 placeHolderImageName:nil radius:0];
    [brandPicImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(upline.mas_bottom).with.offset(30);
        make.left.mas_equalTo(kEdge);
        make.right.mas_equalTo(-kEdge);
        make.height.mas_equalTo(([_detailModel.brandPic.height floatValue]/[_detailModel.brandPic.width floatValue])*(ScreenWidth-kEdge*2));
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
                make.top.mas_equalTo(brandPicImg.mas_bottom).with.offset(28);
            }
            
        }];
        [label sizeToFit];
        lastView=label;
    }
    
    UILabel *brandBriefLabel=[UILabel getLabelWithAlignment:0 WithTitle:_detailModel.brandBrief WithFont:13.0f WithTextColor:nil WithSpacing:0];
    [self addSubview:brandBriefLabel];
    brandBriefLabel.numberOfLines=0;
    [brandBriefLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-kEdge);
        make.left.mas_offset(kEdge);
        make.top.mas_equalTo(lastView.mas_bottom).with.offset(27);
    }];
    [brandBriefLabel sizeToFit];
    
    UIView *downLine=[UIView getCustomViewWithColor:[UIColor colorWithHexString:_detailModel.seriesColor]];
    [self addSubview:downLine];
    [downLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        if([NSString isNilOrEmpty:_detailModel.brandBrief])
        {
            make.top.mas_equalTo(brandBriefLabel.mas_bottom).with.offset(0);
        }else
        {
            make.top.mas_equalTo(brandBriefLabel.mas_bottom).with.offset(27);
        }
        
        make.height.mas_equalTo(1);
    }];
    
    
    UIImageView *seriesBannerPicImg=[UIImageView getCustomImg];
    [self addSubview:seriesBannerPicImg];
    seriesBannerPicImg.contentMode=0;
    [seriesBannerPicImg JX_ScaleToFill_loadImageUrlStr:_detailModel.seriesBannerPic.pic WithSize:800 placeHolderImageName:nil radius:0];
    [seriesBannerPicImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kEdge);
        make.top.mas_equalTo(downLine.mas_bottom).with.offset(30);
        make.right.mas_offset(-kEdge);
        make.height.mas_equalTo(([_detailModel.seriesBannerPic.height floatValue]/[_detailModel.seriesBannerPic.width floatValue])*(ScreenWidth-2*kEdge));
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

    UILabel *seriesBriefLabel=[UILabel getLabelWithAlignment:0 WithTitle:_detailModel.seriesBrief WithFont:13.0f WithTextColor:nil WithSpacing:0];
    [self addSubview:seriesBriefLabel];
    seriesBriefLabel.numberOfLines=0;
    [seriesBriefLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kEdge);
        make.right.mas_offset(-kEdge);
        if([NSString isNilOrEmpty:_detailModel.seriesBrief])
        {
            make.top.mas_equalTo(lastViewSeries.mas_bottom).with.offset(0);
        }else
        {
            make.top.mas_equalTo(lastViewSeries.mas_bottom).with.offset(28);
        }
        make.width.mas_equalTo(250);
        make.bottom.mas_equalTo(-28);
    }];
    [seriesBriefLabel sizeToFit];
    
}

@end
