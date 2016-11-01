//
//  DD_OrderLogisticsModel.h
//  YCO SPACE
//
//  Created by yyj on 16/8/24.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DD_OrderLogisticsModel : NSObject

/**
 * 获取解析model
 */
+(DD_OrderLogisticsModel *)getLogisticsModel:(NSDictionary *)dict;
/**
 * 获取解析数组
 */
+(NSArray *)getLogisticsModelArr:(NSArray *)arr;

/** 物流信息*/
__string(AcceptStation);

/** 该物流信息的更新时间*/
__long(AcceptTime);

/** 该物流信息的备注*/
__string(mark);

@end
