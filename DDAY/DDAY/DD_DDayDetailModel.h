//
//  DD_DDayDetailModel.h
//  DDAY
//
//  Created by yyj on 16/6/2.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DD_ImageModel;
@class DD_ShowRoomModel;

@interface DD_DDayDetailModel : NSObject

/** 获取解析model*/
+(DD_DDayDetailModel *)getDDayDetailModel:(NSDictionary *)dict;

/** 获取解析数组*/
+(NSArray *)getDDayDetailModelArr:(NSArray *)arr;

/** 0表示线上 1表示线下*/
__long(stype);

/** 品牌简介*/
__string(brandBrief);

/** 系列封面照片*/
@property (nonatomic,strong) DD_ImageModel *seriesFrontPic;

/** 系列提示*/
__string(seriesTips);

/** 折扣*/
__string(discount);

/** 分享网页*/
__string(appUrl);

/** 后台编辑器网页*/
__string(seriesBriefUrl);

/** App Store下载地址*/
__string(downLoadUrl);

/** 发布会结束时间*/
__long(saleEndTime);

/** 发布会开始时间*/
__long(saleStartTime);

/** 报名结束时间*/
__long(signEndTime);

/** 报名开始时间*/
__long(signStartTime);

/** 该系列是否有名额限制*/
__bool(isQuotaLimt);

/** 当前用户是否参加该系列*/
__bool(isJoin);

/** 系列简介*/
__string(seriesBrief);

/** 系列名*/
__string(name);

/** 系列颜色*/
__string(seriesColor);

/** 系列ID*/
__string(s_id);

/** 系列baner封面*/
@property (nonatomic,strong) DD_ImageModel *seriesBannerPic;

/** 体验店*/
@property (nonatomic,strong) DD_ShowRoomModel *physicalStore;

/** 系列剩余名额*/
__long(leftQuota);

/** 品牌图片*/
@property (nonatomic,strong) DD_ImageModel *brandPic;

/** 品牌名*/
__string(brandName);

/** 设计师头像*/
__string(designerHead);

/** 设计师ID*/
__string(designerId);

/** 设计师名*/
__string(designerName);

/** 报名开始时间str*/
__string(signStartTimeStr);

@end
