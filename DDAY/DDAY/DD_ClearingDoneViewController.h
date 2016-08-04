//
//  DD_ClearingDoneViewController.h
//  DDAY
//
//  Created by yyj on 16/5/26.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_BaseViewController.h"

@interface DD_ClearingDoneViewController : DD_BaseViewController
/**
 * 初始化方法
 * 传入code（支付回调code）9000表成功 反之不成功
 */
-(instancetype)initWithReturnCode:(NSString *)code WithTradeOrderCode:(NSString *)tradeOrderCode WithType:(NSString *)type WithBlock:(void (^)(NSString *type))block;
/**
 * 类型
 */
__string(type);
__string(tradeOrderCode);
/**
 * 回调
 */
__block_type(block, type);
/**
 * 支付code
 */
__string(code);
@end
