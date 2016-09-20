//
//  DD_ShareTool.h
//  YCO SPACE
//
//  Created by yyj on 16/8/23.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DD_ShareTool : NSObject
/**
 * 全部分享平台的图片map
 */
+(NSDictionary *)getShareListMap;
/**
 * 获取当前状态下支持的分享平台列表
 */
+(NSArray *)getShareListArr;
/**
 * 获取当前设备对应视图的高度
 */
+(CGFloat)getHeight;
@end
