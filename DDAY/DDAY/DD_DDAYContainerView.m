//
//  DD_DDAYContainerView.m
//  YCO SPACE
//
//  Created by yyj on 16/8/8.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_DDAYContainerView.h"

#import "DD_ImageModel.h"
#import "DD_DDayDetailModel.h"

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

    UILabel *seriesBriefLabel=[UILabel getLabelWithAlignment:0 WithTitle:_detailModel.seriesBrief WithFont:13.0f WithTextColor:nil WithSpacing:0];
    [self addSubview:seriesBriefLabel];
    seriesBriefLabel.numberOfLines=0;
    [seriesBriefLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kEdge);
        make.right.mas_offset(-kEdge);
        make.top.mas_equalTo(seriesBannerPicImg.mas_bottom).with.offset(30);
        make.width.mas_equalTo(250);
        make.bottom.mas_equalTo(-28);
    }];
    [seriesBriefLabel sizeToFit];
    
}
-(void)designerAction
{
    _block(@"enter_designer_homepage");
}
@end
