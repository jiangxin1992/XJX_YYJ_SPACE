//
//  DD_ClearingTool.m
//  DDAY
//
//  Created by yyj on 16/5/19.
//  Copyright © 2016年 mike_xie. All rights reserved.
//

#import "DD_ClearingTool.h"

#import "DD_ClearingSeriesModel.h"

@implementation DD_ClearingTool

+(NSDictionary *)getPayOrderInfoWithDataDict:(NSDictionary *)dataDict WithDataArr:(NSArray *)dataArr WithRemarks:(NSString *)remarks WithFreight:(NSString *)_freight
{
    CGFloat _Freight=dataArr.count*[_freight floatValue];
    CGFloat _subTotal=[[dataDict objectForKey:@"subTotal"] floatValue];
    
    //NSString *total=[[regular getDNS] rangeOfString:@"app.ycospace.com"].location !=NSNotFound?[regular getRoundNum:(_subTotal+_Freight)]:@"0.03";
    NSString *total=[regular getRoundNum:(_subTotal+_Freight)];
    NSDictionary *_dict=@{@"address":[dataDict objectForKey:@"address"]
                          ,@"orders":[self getPayOrderWithDataArr:dataArr]
                          ,@"payApproach":@"1"
                          ,@"memo":remarks
                          ,@"freight":[regular getRoundNum:_Freight]
                          ,@"total":total
                          ,@"subTotal":[regular getRoundNum:_subTotal]
                          };
    return _dict;
}
+(NSArray *)getPayOrderWithDataArr:(NSArray *)dataArr
{
    NSMutableArray *orderArr=[[NSMutableArray alloc] init];
    
    [dataArr enumerateObjectsUsingBlock:^(DD_ClearingSeriesModel *_Series, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableArray *items=[[NSMutableArray alloc] init];
        
        [_Series.items enumerateObjectsUsingBlock:^(DD_ClearingOrderModel *order, NSUInteger idx2, BOOL * _Nonnull stop2) {
            [items addObject:@{
                               @"pic":order.pic
                               ,@"brandName":order.brandName
                               ,@"itemId":order.itemId
                               ,@"itemName":order.itemName
                               ,@"colorId":order.colorId
                               ,@"colorCode":order.colorCode
                               ,@"colorName":order.colorName
                               ,@"sizeId":order.sizeId
                               ,@"sizeName":order.sizeName
                               ,@"num":order.numbers
                               ,@"price":order.price
                               ,@"originalPrice":order.originalPrice
                               }];
        }];
        [orderArr addObject: @{
                               @"seriesId":_Series.seriesId
                               ,@"seriesName":_Series.seriesName
                               ,@"status":[NSNumber numberWithInteger:_Series.status]
                               ,@"numbers":_Series.numbers
                               ,@"totalMoney":_Series.totalMoney
                               ,@"items":items
                               }];
    }];
//    for (DD_ClearingSeriesModel *_Series in dataArr) {
//        NSMutableArray *items=[[NSMutableArray alloc] init];
//        for (DD_ClearingOrderModel *order in _Series.items) {
//            [items addObject:@{
//                               @"pic":order.pic
//                               ,@"brandName":order.brandName
//                               ,@"itemId":order.itemId
//                               ,@"itemName":order.itemName
//                               ,@"colorId":order.colorId
//                               ,@"colorCode":order.colorCode
//                               ,@"colorName":order.colorName
//                               ,@"sizeId":order.sizeId
//                               ,@"sizeName":order.sizeName
//                               ,@"num":order.numbers
//                               ,@"price":order.price
//                               ,@"originalPrice":order.originalPrice
//                               }];
//        }
//        [orderArr addObject: @{
//                               @"seriesId":_Series.seriesId
//                               ,@"seriesName":_Series.seriesName
//                               ,@"status":[NSNumber numberWithInteger:_Series.status]
//                               ,@"numbers":_Series.numbers
//                               ,@"totalMoney":_Series.totalMoney
//                               ,@"items":items
//                               }];
//    }
    
    return orderArr;
}





+(CGFloat )getAllCountPriceWithDict:(NSDictionary *)_dataDict
{
    __block CGFloat _price=0;
    NSArray *remainArr=[_dataDict objectForKey:@"remain"];
    [remainArr enumerateObjectsUsingBlock:^(DD_ClearingSeriesModel *Series, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [Series.items enumerateObjectsUsingBlock:^(DD_ClearingOrderModel *order, NSUInteger idx2, BOOL * _Nonnull stop2) {
            _price+=[order.price floatValue]*[order.numbers integerValue];
        }];
    }];
//    for (DD_ClearingSeriesModel *Series in remainArr) {
//        for (DD_ClearingOrderModel *order in Series.items) {
//            _price+=[order.price floatValue]*[order.numbers integerValue];
//        }
//    }
    NSArray *saleArr=[_dataDict objectForKey:@"saleing"];
    [saleArr enumerateObjectsUsingBlock:^(DD_ClearingSeriesModel *Series, NSUInteger idx, BOOL * _Nonnull stop) {
        [Series.items enumerateObjectsUsingBlock:^(DD_ClearingOrderModel *order, NSUInteger idx2, BOOL * _Nonnull stop2) {
            CGFloat _danjia=[order.price floatValue];
            NSInteger _num=[order.numbers integerValue];
            _price+=_danjia*_num;
        }];
    }];
//    for (DD_ClearingSeriesModel *Series in saleArr) {
//        for (DD_ClearingOrderModel *order in Series.items) {
//            CGFloat _danjia=[order.price floatValue];
//            NSInteger _num=[order.numbers integerValue];
//            _price+=_danjia*_num;
//        }
//    }
    return _price;
}

+(NSInteger)getAllGoodsNumWithDict:(NSDictionary *)_dataDict
{
    NSArray *remainArr=[_dataDict objectForKey:@"remain"];
    NSArray *saleArr=[_dataDict objectForKey:@"saleing"];
    __block NSInteger _count=0;
    [saleArr enumerateObjectsUsingBlock:^(NSArray *_arr, NSUInteger idx, BOOL * _Nonnull stop) {
        _count+=_arr.count;
    }];
//    for (NSArray *_arr in saleArr) {
//        _count+=_arr.count;
//    }
    return _count+remainArr.count;
}
+(BOOL)have_saleingWithDict:(NSDictionary *)_dataDict
{
    if(((NSArray *)[_dataDict objectForKey:@"saleing"]).count)
    {
        return YES;
    }else
    {
        return NO;
    }
}
+(BOOL)have_remainWithDict:(NSDictionary *)_dataDict
{
    if(((NSArray *)[_dataDict objectForKey:@"remain"]).count)
    {
        return YES;
    }else
    {
        return NO;
    }
}

+(CGFloat )getSectionPrice:(NSInteger )_section WithDict:(NSDictionary *)_dataDict{
    __block CGFloat _price=0;
    NSArray *_saleingArr=[_dataDict objectForKey:@"saleing"];
    NSArray *arr=nil;
    if([self have_remainWithDict:_dataDict])
    {
        if([self have_saleingWithDict:_dataDict])
        {
            //        有完成的商品
            if(_section==0)
            {
                arr=[_dataDict objectForKey:@"remain"];
                
            }else
            {
                arr=_saleingArr[_section-1];
                
            }
        }else
        {
            //        有完成的商品
            if(_section==0)
            {
                arr=[_dataDict objectForKey:@"remain"];
                
            }
        }
        
    }else
    {
        if([self have_saleingWithDict:_dataDict])
        {
            arr=_saleingArr[_section];
        }else
        {
            return 0;
        }
    }
    [arr enumerateObjectsUsingBlock:^(DD_ClearingOrderModel *ordermodel, NSUInteger idx, BOOL * _Nonnull stop) {
        _price+=[ordermodel.price floatValue];
    }];
//    for (DD_ClearingOrderModel *ordermodel in arr) {
//        _price+=[ordermodel.price floatValue];
//    }
    return _price;
}
+(DD_ClearingOrderModel *)getModelForCellRow:(NSIndexPath *)indexPath WithDict:(NSDictionary *)_dataDict
{
    if(![self have_remainWithDict:_dataDict])
    {
        if([self have_saleingWithDict:_dataDict])
        {
            return [self getSaleingModelWithRow:indexPath WithDict:_dataDict];
        }else
        {
            return nil;
        }
        
    }else
    {
        if([self have_saleingWithDict:_dataDict])
        {
            if(indexPath.section==0)
            {
                return [self getRemainModelWithSection:indexPath WithDict:_dataDict];
            }else
            {
                return [self getSaleingModelWithRow:indexPath WithDict:_dataDict];
            }
        }else
        {
            return [self getRemainModelWithSection:indexPath WithDict:_dataDict];
        }
    }
}
+(DD_ClearingOrderModel *)getRemainModelWithSection:(NSIndexPath *)indexPath WithDict:(NSDictionary *)_dataDict
{
    NSArray *remainArr=[_dataDict objectForKey:@"remain"];
    return remainArr[indexPath.row];
}
+(DD_ClearingOrderModel *)getSaleingModelWithRow:(NSIndexPath *)indexPath WithDict:(NSDictionary *)_dataDict
{
    NSInteger _section=0;
    if(indexPath.section)
    {
        _section=indexPath.section-1;
    }else
    {
        _section=indexPath.section;
    }
    
    NSArray *saleingArr=[_dataDict objectForKey:@"saleing"];
    DD_ClearingOrderModel *model=saleingArr[_section][indexPath.row];
    return model;
}
+(NSInteger )getAllSectionNumWithDict:(NSDictionary *)_dataDict
{
    NSInteger _sectionNum=0;
    
    NSArray *_saleingArr=[_dataDict objectForKey:@"saleing"];
    NSArray *_remainArr=[_dataDict objectForKey:@"remain"];
    _sectionNum=_saleingArr.count+_remainArr.count;
    return _sectionNum;
}
+(NSInteger )getRowNumWithSection:(NSInteger )_section WithDict:(NSDictionary *)_dataDict
{
    
    NSArray *_data_arr=[_dataDict objectForKey:@"saleing"];
    if([self have_remainWithDict:_dataDict])
    {
        if([self have_saleingWithDict:_dataDict])
        {
            if(_section==0)
            {
                return ((NSArray *)[_dataDict objectForKey:@"remain"]).count;
            }else
            {
                return ((NSArray *)_data_arr[_section-1]).count;
            }
        }else
        {
            return ((NSArray *)[_dataDict objectForKey:@"remain"]).count;
        }
        
    }else
    {
        if([self have_saleingWithDict:_dataDict])
        {
            return ((NSArray *)_data_arr[_section]).count;
        }else
        {
            return 0;
        }
        
    }
}

+(CGFloat )getAllPrice:(NSInteger )_section WithDict:(NSDictionary *)_dataDict Withfreight:(NSString *)freight
{
    CGFloat _Freight=[DD_ClearingTool getAllSectionNumWithDict:_dataDict]*[freight floatValue];
    CGFloat _countPrice=[DD_ClearingTool getAllCountPriceWithDict:_dataDict];
    return _Freight+_countPrice;
}
@end
