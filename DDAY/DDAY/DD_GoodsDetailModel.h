//
//  DD_GoodsDetailModel.h
//  DDAY
//
//  Created by yyj on 16/5/22.
//  Copyright © 2016年 YYJ. All rights reserved.
//
#import "DD_GoodsDesignerModel.h"
#import "DD_GoodsItemModel.h"
#import <Foundation/Foundation.h>

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

__bool(shoucang);
__bool(guanzhu);
@property (nonatomic,strong)DD_GoodsDesignerModel *designer;
@property (nonatomic,strong)DD_GoodsItemModel *item;

@end
