//
//  DD_ShowRoomModel.h
//  YCO SPACE
//
//  Created by yyj on 16/8/19.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DD_ShowRoomModel : NSObject
/**
 * 获取体验店model
 */
+(DD_ShowRoomModel *)getShowRoomModel:(NSDictionary *)dict;
/**
 * 获取体验店model数组
 */
+(NSArray *)getShowRoomModelArr:(NSArray *)arr;

/**
 * 店面展示图片数组
 */
__array(pics);

/** 店名*/
__string(storeName);

/** 维度*/
__string(latitude);

/** 经度*/
__string(longitude);

/** 店铺ID*/
__string(s_id);

/** 店铺描述*/
__string(brief);

/** 店铺地址*/
__string(address);

/** 营业时间*/
__string(businessHours);

/** 联系方式*/
__string(contactPhone);

@end
