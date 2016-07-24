//
//  DD_GoodsDetailModel.m
//  DDAY
//
//  Created by yyj on 16/5/22.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_GoodsDetailModel.h"

@implementation DD_GoodsDetailModel
+(DD_GoodsDetailModel *)getGoodsDetailModel:(NSDictionary *)dict
{
    DD_GoodsDetailModel *_GoodsDetailModel=[DD_GoodsDetailModel objectWithKeyValues:dict];
    _GoodsDetailModel.item=[DD_GoodsItemModel getGoodsItemModel:[dict objectForKey:@"item"]];
    _GoodsDetailModel.designer=[DD_GoodsDesignerModel getGoodsDesignerModel:[dict objectForKey:@"designer"]];
    return _GoodsDetailModel;
}
@end
