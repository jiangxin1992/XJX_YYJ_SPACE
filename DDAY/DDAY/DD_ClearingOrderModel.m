//
//  DD_ClearingOrderModel.m
//  DDAY
//
//  Created by yyj on 16/5/18.
//  Copyright © 2016年 mike_xie. All rights reserved.
//

#import "DD_ClearingOrderModel.h"

@implementation DD_ClearingOrderModel
+(DD_ClearingOrderModel *)getClearingOrderModel:(NSDictionary *)dict
{
    DD_ClearingOrderModel *_ClearingOrder=[DD_ClearingOrderModel objectWithKeyValues:dict];
    _ClearingOrder.saleEndTime=[[dict objectForKey:@"saleEndTime"] longValue]/1000;
    _ClearingOrder.saleStartTime=[[dict objectForKey:@"saleStartTime"] longValue]/1000;
//    将商品价格设置成当前状态的价格
    long nowtime=[regular date];
    if(nowtime<_ClearingOrder.saleEndTime)
    {
        _ClearingOrder.price=_ClearingOrder.price;
    }else
    {
        if(_ClearingOrder.discountEnable)
        {
            _ClearingOrder.price=_ClearingOrder.originalPrice;
        }else
        {
            _ClearingOrder.price=_ClearingOrder.price;
        }
    }
    
    return _ClearingOrder;
}
+(NSArray *)getClearingOrderModelArray:(NSArray *)arrdata
{
    NSMutableArray *mutable_arr=[[NSMutableArray alloc] init];
    for (NSDictionary *dict in arrdata) {
        [mutable_arr addObject:[self getClearingOrderModel:dict]];
    }
    return mutable_arr;
}
-(NSString *)getPriceStr
{
    if(self.discountEnable)
    {
        return [[NSString alloc] initWithFormat:@"￥%@ 原价 ￥%@",self.price,self.originalPrice];
    }else
    {
        if([self.price isEqualToString:self.originalPrice])
        {
            return [[NSString alloc] initWithFormat:@"￥%@",self.originalPrice];
            
        }else
        {
            return [[NSString alloc] initWithFormat:@"￥%@ 原价 ￥%@",self.price,self.originalPrice];
        }
    }
    return @"";
}
-(NSString *)getPrice
{
    if(self.discountEnable)
    {
        return self.price;
    }else
    {
        if([self.price isEqualToString:self.originalPrice])
        {
            return self.originalPrice;
        }else
        {
            return self.price;
        }
    }
    return @"";
}
@end
