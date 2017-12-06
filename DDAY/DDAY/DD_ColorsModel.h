//
//  DD_ColorsModel.h
//  DDAY
//
//  Created by yyj on 16/5/23.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DD_baseModel.h"

@interface DD_ColorsModel : DD_baseModel

+(DD_ColorsModel *)getColorsModel:(NSDictionary *)dict;

+(NSArray *)getColorsModelArr:(NSArray *)arr;

/**
 * public static Integer ITEM_STATUS_WSJ = 0; //未上架
 * public static Integer ITEM_STATUS_YSJ = 1; //已上架
 * public static Integer ITEM_STATUS_YXJ = 2; //已下架
 * public static Integer ITEM_STATUS_YSC = 3; //已删除
 * public static Integer ITEM_STATUS_YSC = -1; //已售罄
 */
__int(status);

/** 颜色code*/
__string(colorCode);

/** 颜色ID*/
__string(colorId);

/** 颜色名*/
__string(colorName);

/** 颜色图片*/
__string(colorPic);

/** 对应的itemId*/
__string(itemId);

/** 图片数组*/
__array(pics);

/** 颜色对应的size数组*/
__array(size);

/** 尺寸图*/
__string(sizeBriefPic);

/** 尺寸图高度*/
__string(sizeBriefPicHeight);

/** 尺寸图宽度*/
__string(sizeBriefPicWidth);

/** 分享链接*/
__string(appUrl);
__string(appUrlFull);

@end
