//
//  DD_GoodsDetailModel.h
//  DDAY
//
//  Created by yyj on 16/5/22.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DD_GoodsDesignerModel.h"
#import "DD_GoodsItemModel.h"
#import "DD_ColorsModel.h"
#import "DD_CircleListModel.h"

@interface DD_GoodsDetailModel : NSObject

+(DD_GoodsDetailModel *)getGoodsDetailModel:(NSDictionary *)dict;

/**
 * 根据当前_colorId 获取ColorsModel
 */
-(DD_ColorsModel *)getColorsModel;

/**
 * 获取当前单品价格
 */
-(NSString *)getPrice;

/**
 * 获取当前单品价格描述
 */
-(NSString *)getPriceStr;

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

/** 分享网页url*/
__string(appUrl);

/** app下载地址*/
__string(downLoadUrl);

/** 体验店数组*/
__array(physicalStore);

/** 相似单品*/
__array(similarItems);

@end
