//
//  DD_ShopItemModel.h
//  DDAY
//
//  Created by yyj on 16/5/27.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DD_ShopItemModel : NSObject
/**
 * 获取解析model
 */
+(DD_ShopItemModel *)getShopItemModel:(NSDictionary *)dict;
/**
 * 获取解析数组
 */
+(NSArray *)getShopItemModelArr:(NSArray *)arr;
/**
 * 获取单品当前时间的价格
 */
-(CGFloat )getPrice;


/**
 * item对应的图片
 */
__array(pics);

/**
 * 商品是否失效
 */
__bool(invalid);
/**
 * 发布会之后商品是否恢复原价
 */
__bool(discountEnable);
/**
 * 用户是否选中
 */
__bool(is_select);

/**
 * 品牌名
 */
__string(brandName);
/**
 * 颜色ID
 */
__string(colorId);
/**
 * 颜色code
 */
__string(colorCode);
/**
 * 颜色name
 */
__string(colorName);
/**
 * 类别
 */
__string(categoryName);
/**
 * 设计师ID
 */
__string(designerId);
/**
 * 单品ID
 */
__string(itemId);
/**
 * 单品名称
 */
__string(itemName);
/**
 * 所选单品数量
 */
__string(number);
/**
 * 原价
 */
__string(originalPrice);
/**
 * 现价
 */
__string(price);
/**
 * 系列ID
 */
__string(seriesId);
/**
 * 系列名称
 */
__string(seriesName);
/**
 * 尺寸ID
 */
__string(sizeId);
/**
 * 尺寸名称
 */
__string(sizeName);




/**
 * 报名开始时间
 */
__long(signStartTime);
/**
 * 报名结束时间
 */
__long(signEndTime);
/**
 * 发布会开始时间
 */
__long(saleStartTime);

/**
 * 发布会结束时间
 */
__long(saleEndTime);




@end
