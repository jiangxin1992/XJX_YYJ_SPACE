//
//  DD_ImageModel.h
//  YCO SPACE
//
//  Created by yyj on 16/7/21.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DD_ImageModel : NSObject
/**
 * 获取图片model
 */
+(DD_ImageModel *)getImageModel:(NSDictionary *)dict;
/**
 * 获取图片model数组
 */
+(NSArray *)getImageModelArr:(NSArray *)arr;

+(NSArray *)getRandomImageModelArr:(NSArray *)arr;
/**
 * 原图高
 */
__string(height);
/**
 * 原图宽
 */
__string(width);
/**
 * 图片url
 */
__string(pic);
@end
