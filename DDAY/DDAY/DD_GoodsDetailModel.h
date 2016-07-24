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
__bool(shoucang);
__bool(guanzhu);
@property (nonatomic,strong)DD_GoodsDesignerModel *designer;
@property (nonatomic,strong)DD_GoodsItemModel *item;
@end
