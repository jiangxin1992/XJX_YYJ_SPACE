//
//  DD_SizeModel.h
//  DDAY
//
//  Created by yyj on 16/5/23.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DD_SizeModel : NSObject
+(NSArray *)getSizeModelArr:(NSArray *)arr;
//http://dday.yunejian.com/dday/20160802/877fc284f702445f907eb4f684ec9c04-z100.jpg
//260
//790
/**
 * 尺寸说明
 */
__string(sizeBrief);
/**
 * 尺寸说明高度
 */
__long(sizeBriefPicHeight);
/**
 * 尺寸说明宽度
 */
__long(sizeBriefPicWidth);

/**
 * 尺寸ID
 */
__string(sizeId);
/**
 * 尺寸名
 */
__string(sizeName);
/**
 * 剩余数量
 */
__long(stock);

@end
