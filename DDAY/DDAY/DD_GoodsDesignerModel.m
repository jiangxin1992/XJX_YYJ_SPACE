//
//  DD_GoodsDesignerModel.m
//  DDAY
//
//  Created by yyj on 16/5/22.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_GoodsDesignerModel.h"

@implementation DD_GoodsDesignerModel
+(DD_GoodsDesignerModel *)getGoodsDesignerModel:(NSDictionary *)dict
{
    DD_GoodsDesignerModel *_DesignerModel=[DD_GoodsDesignerModel mj_objectWithKeyValues:dict];
    return _DesignerModel;
}
@end
