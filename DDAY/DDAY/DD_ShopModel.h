//
//  DD_ShopModel.h
//  DDAY
//
//  Created by yyj on 16/5/27.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DD_ShopModel : NSObject
/**
 * 获取解析model
 */
+(DD_ShopModel *)getShopModel:(NSDictionary *)dict;
/**
 * 获取未失效系列数组
 */
__array(seriesNormal);

/**
 * 失效系列数组
 */
__array(seriesInvalid);
@end
