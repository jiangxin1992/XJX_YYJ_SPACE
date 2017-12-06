//
//  DD_GoodsDetailModel.h
//  DDAY
//
//  Created by yyj on 16/5/22.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DD_baseModel.h"

@class DD_GoodsDesignerModel;
@class DD_GoodsItemModel;
@class DD_ColorsModel;
@class DD_CircleListModel;

@interface DD_GoodsDetailModel : DD_baseModel

+(DD_GoodsDetailModel *)getGoodsDetailModel:(NSDictionary *)dict;

/**
 * 根据当前_colorId 获取ColorsModel
 */
-(DD_ColorsModel *)getColorsModel;

/**
 * public static Integer ITEM_STATUS_WSJ = 0; //未上架
 * public static Integer ITEM_STATUS_YSJ = 1; //已上架
 * public static Integer ITEM_STATUS_YXJ = 2; //已下架
 * public static Integer ITEM_STATUS_YSC = 3; //已删除
 * public static Integer ITEM_STATUS_YSC = -1; //已售罄
 */
__int(status);

/** 获取分享链接*/
-(NSString *)getAppUrl;

/**
 * 获取当前单品价格
 */
-(NSString *)getPrice;

/**
 * 获取当前单品价格描述
 */
-(NSString *)getPriceStr;

-(NSString *)getDiscountPriceStr;

-(NSString *)getOriginalPriceStr;

/**
 * 获取颜色ID对应的colorModel
 */
-(DD_ColorsModel *)getColorModelNameWithID:(NSString *)colorID;

/** 设计师model*/
@property (nonatomic,strong)DD_GoodsDesignerModel *designer;

/** 商品信息model*/
@property (nonatomic,strong)DD_GoodsItemModel *item;

/** 相关搭配model*/
@property (nonatomic,strong)DD_CircleListModel *circle;

/** 用户是否收藏*/
__bool(shoucang);

/** 用户是否关注*/
__bool(guanzhu);

/** app下载地址*/
__string(downLoadUrl);

/** 体验店数组*/
__array(physicalStore);

/** 相似单品*/
__array(similarItems);



@end
