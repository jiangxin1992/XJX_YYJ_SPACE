//
//  DD_OrderModel.h
//  DDAY
//
//  Created by yyj on 16/6/6.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DD_OrderItemModel.h"

@interface DD_OrderModel : NSObject
/**
 * 获取解析数组
 */
+(NSArray *)getOrderModelArr:(NSArray *)arr;

/**
 * 获取解析model
 */
+(DD_OrderModel *)getOrderModel:(NSDictionary *)dict;

/**
 * 获取SectionHeaderView
 */
-(UIView *)getViewHeader;
/**
 * 获取SectionFooterView
 */
-(UIView *)getViewFooter;

/**
 * 当前订单中的item数量
 */
-(BOOL )isSingle;
/**
 * 获取购买验证参数BuyItems
 */
-(NSArray *)getBuyItems;

/**
 * item list
 */
__array(itemList);


/**
 * public static Integer ORDER_STATUS_DFK = 0; //待付款
 * public static Integer ORDER_STATUS_DFH = 1; //待发货
 * public static Integer ORDER_STATUS_DSH = 2; //待收货
 * public static Integer ORDER_STATUS_JYCG = 3; //交易成功
 * public static Integer ORDER_STATUS_SQTK = 4; //申请退款
 * public static Integer ORDER_STATUS_TKCLZ = 5; //退款处理中
 * public static Integer ORDER_STATUS_YTK = 6; //已退款
 * public static Integer ORDER_STATUS_JJTK = 7; //拒绝退款
 */
__long(orderStatus);

/**
 * 数量
 */
__long(itemCount);
/**
 * 订单创建时间
 */
__long(createTime);

/**
 * 是否支付
 */
__bool(isPay);

/**
 * 系列id
 */
__string(seriesId);
/**
 * 系列名称
 */
__string(seriesName);
/**
 * 小计 不算运费
 */
__string(totalAmount);
/**
 * 订单号
 */
__string(tradeOrderCode);
/**
 * 子订单号
 */
__string(subOrderCode);


@end
