//
//  DD_ItemsModel.h
//  DDAY
//
//  Created by yyj on 16/5/22.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DD_ItemsModel : NSObject

/**
 * 获取单品model
 */
+(DD_ItemsModel *)getItemsModel:(NSDictionary *)dict;

/**
 * 获取单品model数组
 */
+(NSArray *)getItemsModelArr:(NSArray *)arr;

/**
 * public static Integer ITEM_STATUS_WSJ = 0; //未上架
 * public static Integer ITEM_STATUS_YSJ = 1; //已上架
 * public static Integer ITEM_STATUS_YXJ = 2; //已下架
 * public static Integer ITEM_STATUS_YSC = 3; //已删除
 * public static Integer ITEM_STATUS_YSC = -1; //已售罄
 */
__int(status);

/**
 * public static Integer ITEM_STATUS_WSJ = 0; //非合作款
 * public static Integer ITEM_STATUS_YSJ = 1; //合作款
 */
__int(cooperateTag);

/** 单品ID*/
__string(g_id);

/** 单品名*/
__string(name);

/** 单品原价*/
__string(originalPrice);

/** 单品现价*/
__string(price);

/** 单品对应系列名*/
__string(seriesName);

/** 单品图片数组*/
__array(pics);

/** 单品颜色ID*/
__string(colorId);

/** 单品颜色Code*/
__string(colorCode);

@end
