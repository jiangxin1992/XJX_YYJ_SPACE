//
//  DD_ClearingModel.m
//  DDAY
//
//  Created by yyj on 16/5/18.
//  Copyright © 2016年 mike_xie. All rights reserved.
//

#import "DD_ClearingModel.h"

@implementation DD_ClearingModel
+(DD_ClearingModel *)getClearingModel:(NSDictionary *)dict
{
    DD_ClearingModel *_Clearing=[DD_ClearingModel objectWithKeyValues:dict];
    _Clearing.address=[DD_AddressModel getAddressModel:[dict objectForKey:@"address"]];
    
    _Clearing.orders=[DD_ClearingOrderModel getClearingOrderModelArray:[dict objectForKey:@"orders"]];
    return _Clearing;
}
#pragma mark - getItemsArr
-(NSArray *)getItemsArr
{
    NSMutableArray *ItemsArr=[[NSMutableArray alloc] init];
    for (DD_ClearingOrderModel *_orderModel in self.orders) {
        [ItemsArr addObject:@{
                              @"itemId":_orderModel.itemId
                              ,@"colorId":_orderModel.colorId
                              ,@"sizeId":_orderModel.sizeId
                              ,@"number":_orderModel.numbers
                              ,@"price":[_orderModel getPrice]
                              }];
    }
    return ItemsArr;
}
#pragma mark - getOrderInfo
-(NSDictionary *)getOrderInfo
{
    NSDictionary *ordersDict=[self getEndDict:[self CategoryData]];
    CGFloat _countPrice=[DD_ClearingTool getAllCountPriceWithDict:ordersDict];
    if(self.address)
    {
        return @{@"address":[self getAddressDict],@"orders":ordersDict,@"subTotal":[[NSString alloc] initWithFormat:@"%.1lf",_countPrice]};
    }else
    {
        return @{@"orders":ordersDict,@"subTotal":[[NSString alloc] initWithFormat:@"%.1lf",_countPrice]};
    }
}
-(NSDictionary *)CategoryData
{
    NSDictionary *_dataDict=[[NSMutableDictionary alloc] init];
    long nowtime=[regular date];
    NSArray *__orders=self.orders;
    //    过滤发布会结束的
    NSMutableArray *saleingArr=[[NSMutableArray alloc] init];
    NSMutableArray *saleingRemainArr=[[NSMutableArray alloc] init];
    for (int i=0; i<__orders.count; i++) {
        DD_ClearingOrderModel *ordermodel=[__orders objectAtIndex:i];
        if(nowtime<ordermodel.saleEndTime&&nowtime>=ordermodel.saleStartTime)
        {
            [saleingArr addObject:ordermodel];
        }else if(nowtime>=ordermodel.saleEndTime)
        {
            [saleingRemainArr addObject:ordermodel];
        }
    }
    [_dataDict setValue:saleingRemainArr forKey:@"remain"];
    
    //   过滤发布会中的
    NSMutableArray *_sid_arr=[[NSMutableArray alloc] init];
    if(saleingArr.count)
    {
        for (int i=0; i<saleingArr.count; i++) {
            DD_ClearingOrderModel *ordermodel=[saleingArr objectAtIndex:i];
            BOOL _isequal=NO;
            for (NSString *sid in _sid_arr) {
                if([sid isEqualToString:ordermodel.seriesId])
                {
                    _isequal=YES;
                    break;
                }
            }
            if(!_isequal)
            {
                [_sid_arr addObject:ordermodel.seriesId];
            }
            
        }
    }
    NSMutableArray *_saleingClassArr=[[NSMutableArray alloc] init];
    for (int i=0; i<_sid_arr.count; i++) {
        NSMutableArray *arr=[[NSMutableArray alloc] init];
        for (int j=0; j<saleingArr.count; j++) {
            DD_ClearingOrderModel *ordermodel=[saleingArr objectAtIndex:j];
            if([ordermodel.seriesId isEqualToString:[_sid_arr objectAtIndex:i]])
            {
                [arr addObject:ordermodel];
            }
        }
        if(arr.count)
        {
            [_saleingClassArr addObject:arr];
        }
    }
    [_dataDict setValue:_saleingClassArr forKey:@"saleing"];
    return _dataDict;
}
-(NSDictionary *)getAddressDict
{
    DD_AddressModel *__address=self.address;
    return  @{@"addressId":__address.udaId,@"deliverName":__address.deliverName,@"deliverPhone":__address.deliverPhone,@"detailAddress":__address.detailAddress};
}
-(NSDictionary *)getEndDict:(NSDictionary *)dataDict
{
    return @{
             @"remain":[self GetCategoryRemain:[dataDict objectForKey:@"remain"]]
             ,@"saleing":[self GetCategorySaleing:[dataDict objectForKey:@"saleing"]]
             };
}
-(NSArray *)GetCategorySaleing:(NSArray *)saleingArr
{
    NSMutableArray *_endSaleingArr=[[NSMutableArray alloc] init];
    for (int i=0; i<saleingArr.count; i++) {
        DD_ClearingSeriesModel *_Series=[[DD_ClearingSeriesModel alloc] init];
        NSArray *itemArr=[saleingArr objectAtIndex:i];
        CGFloat _totalMoney=0;
        NSInteger _num=0;
        for (int j=0; j<itemArr.count; j++) {
            DD_ClearingOrderModel *ordermodel=[itemArr objectAtIndex:j];
            if(!_Series.seriesId)
            {
                _Series.seriesId=ordermodel.seriesId;
            }
            if(!_Series.seriesName)
            {
                _Series.seriesName=ordermodel.seriesName;
            }
            if(!_Series.status)
            {
                long _nowtime=[regular date];
                if(ordermodel.saleEndTime<_nowtime)
                {
                    _Series.status=1;
                }else if(_nowtime<=ordermodel.saleEndTime&&_nowtime>ordermodel.saleStartTime)
                {
                    _Series.status=0;
                }else
                {
                    _Series.status=-1;
                }
            }
            _num+=[ordermodel.numbers integerValue];
            _totalMoney+=[ordermodel.price floatValue]*[ordermodel.numbers integerValue];
        }
        _Series.items=itemArr;
        _Series.numbers=[[NSString alloc] initWithFormat:@"%ld",(long)_num];
        _Series.totalMoney=[[NSString alloc] initWithFormat:@"%.1lf",_totalMoney];
        [_endSaleingArr addObject:_Series];
    }
    return _endSaleingArr;
}
-(NSArray *)GetCategoryRemain:(NSArray *)remainArr
{
    //  最后存放数据的数组
    NSMutableArray *_endRemainArr=[[NSMutableArray alloc] init];
    //    获取当前的所有系列id
    NSMutableArray *allkeyArr=[[NSMutableArray alloc] init];
    for (int i=0; i<remainArr.count; i++) {
        DD_ClearingOrderModel *ordermodel=[remainArr objectAtIndex:i];
        if(allkeyArr.count)
        {
            BOOL _is_exist=NO;
            for (int j=0; j<allkeyArr.count; j++) {
                NSString *_key=[allkeyArr objectAtIndex:j];
                if([_key isEqualToString:ordermodel.seriesId])
                {
                    _is_exist=YES;
                    break;
                }
            }
            if(!_is_exist)
            {
                [allkeyArr addObject:ordermodel.seriesId];
            }
        }else
        {
            [allkeyArr addObject:ordermodel.seriesId];
        }
        
    }
    //    整理当前的单品
    for (int i=0; i<allkeyArr.count; i++) {
        NSString *_key=[allkeyArr objectAtIndex:i];
        DD_ClearingSeriesModel *_Series=[[DD_ClearingSeriesModel alloc] init];
        NSMutableArray *items=[[NSMutableArray alloc] init];
        for (int j=0; j<remainArr.count; j++) {
            DD_ClearingOrderModel *ordermodel=[remainArr objectAtIndex:j];
            if([_key isEqualToString:ordermodel.seriesId])
            {
                [items addObject:ordermodel];
                if(!_Series.seriesId)
                {
                    _Series.seriesId=ordermodel.seriesId;
                }
                if(!_Series.seriesName)
                {
                    _Series.seriesName=ordermodel.seriesName;
                }
                if(!_Series.status)
                {
                    long _nowtime=[regular date];
                    if(ordermodel.saleEndTime<_nowtime)
                    {
                        _Series.status=1;
                    }else if(_nowtime<=ordermodel.saleEndTime&&_nowtime>ordermodel.saleStartTime)
                    {
                        _Series.status=0;
                    }else
                    {
                        _Series.status=-1;
                    }
                }
            }
        }
        //        item
        _Series.items=items;
        CGFloat _totalMoney=0;
        NSInteger _num=0;
        //        数量
        for (int i=0; i<items.count; i++) {
            DD_ClearingOrderModel *ordermodel=[remainArr objectAtIndex:i];
            _num+=[ordermodel.numbers integerValue];
            _totalMoney+=[ordermodel.price floatValue]*[ordermodel.numbers integerValue];
        }
        _Series.numbers=[[NSString alloc] initWithFormat:@"%ld",(long)_num];
        _Series.totalMoney=[[NSString alloc] initWithFormat:@"%.1lf",_totalMoney];
        [_endRemainArr addObject:_Series];
    }
    return _endRemainArr;
}
@end
