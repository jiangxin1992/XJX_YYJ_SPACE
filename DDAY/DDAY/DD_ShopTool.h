//
//  DD_ShopTool.h
//  DDAY
//
//  Created by yyj on 16/5/27.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_ShopModel.h"
#import "DD_ShopItemModel.h"
#import <Foundation/Foundation.h>

@interface DD_ShopTool : NSObject
/**
 * 判断当前section对应的系列是否为失效系列
 */
+(BOOL)isInvalidWithSection:(NSInteger )section WithModel:(DD_ShopModel *)ShopModel;
/**
 * 该section是否处于全选状态
 */
+(BOOL)selectAllWithModel:(DD_ShopModel *)ShopModel WithSection:(NSInteger)section;
/**
 * 是否为全选状态
 */
+(BOOL)selectAllWithModel:(DD_ShopModel *)ShopModel;

/**
 * 获取结算的商品arr
 * 用于结算请求
 */
+(NSArray *)getConfirmArrWithModel:(DD_ShopModel *)shopModel;
/**
 * 获取以选商品的总计
 * 不包括邮费
 */
+(NSString *)getAllPriceWithModel:(DD_ShopModel *)ShopModel;
/**
 * 获取section num
 */
+(NSInteger )getSectionNumWithModel:(DD_ShopModel *)ShopModel;
/**
 * 获取section 对应的row num
 */
+(NSInteger )getNumberOfRowsInSection:(NSInteger )Section WithModel:(DD_ShopModel *)ShopModel;
/**
 * 获取indexPath对应的DD_ShopItemModel
 */
+(DD_ShopItemModel *)getNumberOfRowsIndexPath:(NSIndexPath *)indexPath WithModel:(DD_ShopModel *)ShopModel;
/**
 * 获取section对应的DD_ShopSeriesModel
 */
+(DD_ShopSeriesModel *)getNumberSection:(NSInteger )section WithModel:(DD_ShopModel *)ShopModel;
/**
 * 获取失效款式对应的num
 */
+(NSInteger )getInvalidSectionNum:(DD_ShopModel *)ShopModel;
/**
 * 获取SectionFooterView
 * 失效款式前一个section
 */
+(UIView *)getViewFooter;




/**
 * 根据indexPath删除ShopModel中对应的item
 * 当系列对应的item数量为0时，删除该系列
 */
+(void)removeItemModelWithIndexPath:(NSIndexPath *)indexPath WithModel:(DD_ShopModel *)ShopModel;

/**
 * 更新indexPath对用的ItemModel
 */
+(void)setItemModelWithIndexPath:(NSIndexPath *)indexPath WithModel:(DD_ShopModel *)ShopModel WithItemModel:(DD_ShopItemModel *)ItemModel;

/**
 * 底部tabbar的全选/取消全选
 * 设置所有商品为全选/取消全选
 * 不包括失效商品
 */
+(void)selectAllWithModel:(DD_ShopModel *)ShopModel WithSelect:(BOOL )is_select;
/**
 * section headerview处的全选
 * 设置当前section商品为全选/取消全选
 */
+(void)selectAllWithModel:(DD_ShopModel *)ShopModel WithSelect:(BOOL )is_select WithSection:(NSInteger)section;


@end
