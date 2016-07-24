//
//  DD_OrderItemModel.h
//  DDAY
//
//  Created by yyj on 16/6/6.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DD_OrderItemModel : NSObject
/**
 * 获取解析数组
 */
+(NSArray *)getOrderItemModelArr:(NSArray *)arr;
/**
 * 品牌名
 */
__string(brand);
/**
 * 颜色id
 */
__string(colorId);
/**
 * 颜色名
 */
__string(colorName);
/**
 * 商品数量
 */
__long(itemCount);
/**
 * item id
 */
__string(itemId);
/**
 * item 名
 */
__string(itemName);
/**
 * item 对应图片
 */
__string(pic);
/**
 * 当前单品尺寸id
 */
__string(sizeId);
/**
 * 当前单品尺寸名
 */
__string(sizeName);
/**
 * 原价
 */
__string(originalPrice);
/**
 * 现价
 */
__string(price);
@end
