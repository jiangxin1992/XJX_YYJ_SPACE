//
//  DD_ClearingTool.h
//  DDAY
//
//  Created by yyj on 16/5/19.
//  Copyright © 2016年 mike_xie. All rights reserved.
//
#import "DD_ClearingSeriesModel.h"
#import "DD_ClearingOrderModel.h"
#import "DD_ClearingModel.h"

@interface DD_ClearingTool : NSObject

/**
 * 获取创建订单请求参数 orderInfo
 */
+(NSDictionary *)getPayOrderInfoWithDataDict:(NSDictionary *)dataDict WithDataArr:(NSArray *)dataArr WithRemarks:(NSString *)remarks WithFreight:(NSString *)_freight;
/**
 * 是否有预售商品
 */
+(BOOL)have_saleingWithDict:(NSDictionary *)_dataDict;
/**
 * 是否有发布会结束商品
 */
+(BOOL)have_remainWithDict:(NSDictionary *)_dataDict;
/**
 * 获取所有商品的价格 除运费
 */
+(CGFloat )getAllCountPriceWithDict:(NSDictionary *)_dataDict;
/**
 * 获取所有商品的数量
 */
+(NSInteger)getAllGoodsNumWithDict:(NSDictionary *)_dataDict;
/**
 * 获取相应section下对应的rownum
 */
+(NSInteger )getRowNumWithSection:(NSInteger )_section WithDict:(NSDictionary *)_dataDict;
/**
 * 获取所有section的数量（订单数量）
 */
+(NSInteger )getAllSectionNumWithDict:(NSDictionary *)_dataDict;
/**
 * 获取订单对应的商品价格之和
 */
+(CGFloat )getSectionPrice:(NSInteger )_section WithDict:(NSDictionary *)_dataDict;
/**
 * 获取总价之和
 */
+(CGFloat )getAllPrice:(NSInteger )_section WithDict:(NSDictionary *)_dataDict Withfreight:(NSString *)freight;
/**
 * 获取cell对应的model
 */
+(DD_ClearingOrderModel *)getModelForCellRow:(NSIndexPath *)indexPath WithDict:(NSDictionary *)_dataDict;
/**
 * 如果当前section为发布会结束商品
 * 获取相应的model
 */
+(DD_ClearingOrderModel *)getRemainModelWithSection:(NSIndexPath *)indexPath WithDict:(NSDictionary *)_dataDict;
/**
 * 如果当前section为预售
 * 获取相应的model
 */
+(DD_ClearingOrderModel *)getSaleingModelWithRow:(NSIndexPath *)indexPath WithDict:(NSDictionary *)_dataDict;

@end
