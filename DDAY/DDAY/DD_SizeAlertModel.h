//
//  DD_SizeAlertModel.h
//  YCO SPACE
//
//  Created by yyj on 16/8/3.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DD_baseModel.h"

@interface DD_SizeAlertModel : DD_baseModel

/**
 * 获取解析model
 */
+(DD_SizeAlertModel *)getSizeAlertModel:(NSDictionary *)dict;

/**
 * 获取解析数组
 */
+(NSArray *)getSizeAlertModelArr:(NSArray *)arr;

/** 当前商品对应的尺寸数组*/
__array(size);

/** 尺寸说明图*/
__string(sizeBriefPic);

/** 尺寸说明图高度*/
__long(sizeBriefPicHeight);

/** 尺寸说明图宽度*/
__long(sizeBriefPicWidth);

@end
