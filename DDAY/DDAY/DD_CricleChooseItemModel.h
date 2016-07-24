//
//  DD_CricleChooseItemModel.h
//  DDAY
//
//  Created by yyj on 16/6/20.
//  Copyright © 2016年 YYJ. All rights reserved.
//
#import <Foundation/Foundation.h>

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
 * 款式名
 */
__string(name);
/**
 * 款式价格
 */
__string(price);
/**
 * 款式照片
 */
__string(pic);
/**
 * 款式item id
 */
__string(g_id);
/**
 * 款式对应的颜色 id
 */
__string(colorId);
/**
 * 当前款式是否处于被选中状态
 */
__bool(isSelect);
@end
