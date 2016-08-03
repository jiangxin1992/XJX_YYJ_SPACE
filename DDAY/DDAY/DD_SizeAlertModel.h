//
//  DD_SizeAlertModel.h
//  YCO SPACE
//
//  Created by yyj on 16/8/3.
//  Copyright © 2016年 YYJ. All rights reserved.
//
#import "DD_SizeModel.h"
#import <Foundation/Foundation.h>

@interface DD_SizeAlertModel : NSObject
/**
 * 获取解析model
 */
+(DD_SizeAlertModel *)getSizeAlertModel:(NSDictionary *)dict;
/**
 * 获取解析数组
 */
+(NSArray *)getSizeAlertModelArr:(NSArray *)arr;
__array(size);
__string(sizeBriefPic);
__long(sizeBriefPicHeight);
__long(sizeBriefPicWidth);
@end
