//
//  DD_ShareTool.h
//  YCO SPACE
//
//  Created by yyj on 16/8/23.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/ShareSDK+Extension.h>

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

/**
 * 获取分享参数
 */
+(NSMutableDictionary *)getShareParamsWithType:(NSString *)type WithShare_type:(SSDKPlatformType )platformType WithShareParams:(NSDictionary *)params;

/**
 * 获取分享成功后  请求是否有分享红包的参数（分享信息）
 */
+(NSDictionary *)getShareParamsWithType:(NSString *)type WithShareParams:(NSDictionary *)params;
@end
