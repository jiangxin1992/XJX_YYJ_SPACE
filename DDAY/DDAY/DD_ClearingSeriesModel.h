//
//  DD_ClearingSeriesModel.h
//  DDAY
//
//  Created by yyj on 16/5/25.
//  Copyright © 2016年 YYJ. All rights reserved.
//
#import "DD_ClearingOrderModel.h"
#import <Foundation/Foundation.h>

@interface DD_ClearingSeriesModel : NSObject
/**
 * 系列对应价格小计/不包括运费
 */
-(CGFloat )getSeriesPrice;
/**
 * 获取SectionFooterView
 */
-(UIView *)getViewFooter;
/**
 * 获取SectionHeaderView
 */
-(UIView *)getViewHeader;


/**
 * 该系列的商品
 */
__array(items);
/**
 * 所属系列的ID
 */
__string(seriesId);
/**
 * 所属系列名称
 */
__string(seriesName);
/**
 * status:1//所属系列的状态（0发布中，1发布结束，-1为非发布系列）
 */
__int(status);
/**
 * numbers:3//此订单单品数
 */
__string(numbers);
/**
 * totalMoney:999//此订单总计
 */
__string(totalMoney);
@end
