//
//  DD_GoodsItemModel.h
//  DDAY
//
//  Created by yyj on 16/5/22.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DD_baseModel.h"

@class DD_GoodsItemModel;
@class DD_SizeModel;
@class DD_GoodSeriesModel;

@interface DD_GoodsItemModel : DD_baseModel

+(DD_GoodsItemModel *)getGoodsItemModel:(NSDictionary *)dict;

+(NSArray *)getGoodsItemModelArr:(NSArray *)arr;

-(NSString *)getSizeNameWithID:(NSString *)sizeID;

-(DD_SizeModel *)getSizeModelWithID:(NSString *)sizeID;

-(NSArray *)getPicsArr;

/**
 * public static Integer ITEM_STATUS_WSJ = 0; //未上架
 * public static Integer ITEM_STATUS_YSJ = 1; //已上架
 * public static Integer ITEM_STATUS_YXJ = 2; //已下架
 * public static Integer ITEM_STATUS_YSC = 3; //已删除
 * public static Integer ITEM_STATUS_YSC = -1; //已售罄
 */
__int(status);

/** 商品ID*/
__string(itemId);

/** 商品名*/
__string(itemName);

/** 商品对应的颜色ID*/
__string(colorId);

/** 商品所有颜色colors*/
__array(colors);

/** 商品所属的类型*/
__string(categoryName);

/** 折扣*/
__string(discount);

/** 是否有打折*/
__bool(discountEnable);

/** 用户是否收藏*/
__bool(isCollect);

/** 商品原价*/
__string(originalPrice);

/** 商品现价*/
__string(price);

/** 商品说明*/
__string(itemBrief);

/** 商品设计师的其他精选单品*/
__array(otherItems);

/** 商品（发布会报名开始时间）*/
__long(signStartTime);

/** 商品（发布会报名结束时间）*/
__long(signEndTime);

/** 商品（发布会开始时间）*/
__long(saleStartTime);

/** 商品（发布会结束时间）*/
__long(saleEndTime);

/** 寄送与退换*/
__string(deliverDeclaration);

/** 材质*/
__string(material);

/** 护理说明*/
__string(washCare);

/** 商品对应的系列信息*/
@property (nonatomic,strong)DD_GoodSeriesModel *series;

@end
