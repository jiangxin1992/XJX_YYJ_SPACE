//
//  DD_OrderTool.m
//  DDAY
//
//  Created by yyj on 16/6/6.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_OrderTool.h"

@implementation DD_OrderTool
+(DD_ClearingOrderModel *)getClearingOrderModel:(DD_OrderItemModel *)_item
{
    DD_ClearingOrderModel *_ClearingOrderModel=[[DD_ClearingOrderModel alloc] init];
    _ClearingOrderModel.colorId=_item.colorId;
    _ClearingOrderModel.colorName=_item.colorName;
    _ClearingOrderModel.itemId=_item.itemId;
    _ClearingOrderModel.itemName=_item.itemName;
    _ClearingOrderModel.numbers=[[NSString alloc] initWithFormat:@"%ld",_item.itemCount];
    _ClearingOrderModel.originalPrice=_item.originalPrice;
    _ClearingOrderModel.pic=_item.pic;
    _ClearingOrderModel.price=_item.price;
    _ClearingOrderModel.sizeId=_item.sizeId;
    _ClearingOrderModel.sizeName=_item.sizeName;
    _ClearingOrderModel.brandName=_item.brand;
    return _ClearingOrderModel;
}
@end
