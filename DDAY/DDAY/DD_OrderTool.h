//
//  DD_OrderTool.h
//  DDAY
//
//  Created by yyj on 16/6/6.
//  Copyright © 2016年 YYJ. All rights reserved.
//
#import "DD_ClearingOrderModel.h"
#import "DD_OrderItemModel.h"
#import <Foundation/Foundation.h>

@interface DD_OrderTool : NSObject
/**
 * 模型转化
 */
+(DD_ClearingOrderModel *)getClearingOrderModel:(DD_OrderItemModel *)_item;
@end
