//
//  DD_GoodsItemModel.h
//  DDAY
//
//  Created by yyj on 16/5/22.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DD_GoodsItemModel.h"
#import "DD_SizeModel.h"
#import "DD_GoodSeriesModel.h"

@interface DD_GoodsItemModel : NSObject
+(DD_GoodsItemModel *)getGoodsItemModel:(NSDictionary *)dict;
+(NSArray *)getGoodsItemModelArr:(NSArray *)arr;
-(NSString *)getSizeNameWithID:(NSString *)sizeID;
-(DD_SizeModel *)getSizeModelWithID:(NSString *)sizeID;
-(NSArray *)getPicsArr;

__string(colorId);
__array(colors);
__string(categoryName);//类别
__string(discount);
__bool(discountEnable);
/**
 * 用户是否收藏
 */
__bool(isCollect);
__string(originalPrice);
__string(price);
__string(itemBrief);
__string(itemId);
__string(itemName);
__array(otherItems);
__long(saleEndTime);
__long(saleStartTime);
__long(signEndTime);
__long(signStartTime);
__int(status);
/**
 * 寄送与退换
 */
__string(deliverDeclaration);
/**
 * 面料
 */
__string(material);
/**
 * 洗涤说明
 */
__string(washCare);
@property (nonatomic,strong)DD_GoodSeriesModel *series;
@end
