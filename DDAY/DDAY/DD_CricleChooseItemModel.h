//
//  DD_CricleChooseItemModel.h
//  DDAY
//
//  Created by yyj on 16/6/20.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DD_ImageModel;

@interface DD_CricleChooseItemModel : NSObject

/**
 * 获取款式model 数组 
 * 并遍历查询chooseItem中是否有_ItemsModel
 */
+(NSArray *)getItemsModelArr:(NSArray *)arr WithDetail:(NSArray *)chooseItem;

/**
 * 获取款式model 数组
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

/** 款式名*/
__string(name);

/** 款式价格*/
__string(price);

/** 原价**/
__string(originalPrice);

/** 款式照片*/
@property (nonatomic,strong)DD_ImageModel *pic;

/** 款式item ID*/
__string(g_id);

/** 款式对应的颜色 ID*/
__string(colorId);

/** 款式对应的颜色 Code*/
__string(colorCode);

/** 当前款式是否处于被选中状态*/
__bool(isSelect);

@end
