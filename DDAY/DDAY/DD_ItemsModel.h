//
//  DD_ItemsModel.h
//  DDAY
//
//  Created by yyj on 16/5/22.
//  Copyright © 2016年 YYJ. All rights reserved.
//
#import "DD_ImageModel.h"
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
 * 单品id
 */
__string(g_id);
/**
 * 单品名
 */
__string(name);
/**
 * 单品原价
 */
__string(originalPrice);
/**
 * 单品现价
 */
__string(price);
/**
 * 单品对应系列名
 */
__string(seriesName);
/**
 * 单品图片数组
 */
__array(pics);
/**
 * 单品颜色id
 */
__string(colorId);
@end
