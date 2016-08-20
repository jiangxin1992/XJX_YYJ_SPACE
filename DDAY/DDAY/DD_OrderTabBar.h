//
//  DD_OrderTabBar.h
//  DDAY
//
//  Created by yyj on 16/6/8.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DD_OrderDetailInfoModel.h"

@interface DD_OrderTabBar : UIView

/**
 * 查看物流 logistics
 * 取消订单 cancel
 * 去支付 pay
 * 确认收货 confirm
 * 删除订单 delect
 * 退款申请中 applying_refund
 * 退款处理中 dealing_refund
 * 退款 refund
 * 联系客服 contact
 */

/**
 * 初始化方法
 */
-(instancetype)initWithFrame:(CGRect)frame WithOrderDetailInfoModel:(DD_OrderDetailInfoModel *)orderInfo WithBlock:(void (^)(NSString *type))block;
/**
 * 更新状态
 */
-(void)UIConfig;

/**
 * 回调方法
 */
__block_type(Block, type);
/**
 * model
 */
@property (nonatomic,strong)DD_OrderDetailInfoModel *orderInfo;
@end
