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
    CGFloat _Freight=dataArr.count*[_freight floatValue]*dataArr.count;
    CGFloat _subTotal=[[dataDict objectForKey:@"subTotal"] floatValue];
    NSDictionary *_dict=@{@"address":[dataDict objectForKey:@"address"]
                          ,@"orders":[self getPayOrderWithDataArr:dataArr]
                          ,@"payApproach":@"1"
                          ,@"memo":remarks
                          ,@"freight":[[NSString alloc] initWithFormat:@"%.0lf",_Freight]
                          ,@"total":[[NSString alloc] initWithFormat:@"%.1lf",_subTotal+_Freight]
                          ,@"subTotal":[[NSString alloc] initWithFormat:@"%.1lf",_subTotal]
                          };
    
    return _dict;
}
+(NSArray *)getPayOrderWithDataArr:(NSArray *)dataArr
{
    NSMutableArray *orderArr=[[NSMutableArray alloc] init];
    for (DD_ClearingSeriesModel *_Series in dataArr) {
        NSMutableArray *items=[[NSMutableArray alloc] init];
        for (DD_ClearingOrderModel *order in _Series.items) {
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
        }
        [orderArr addObject: @{
                               @"seriesId":_Series.seriesId
                               ,@"seriesName":_Series.seriesName
                               ,@"status":[NSNumber numberWithInteger:_Series.status]
                               ,@"numbers":_Series.numbers
                               ,@"totalMoney":_Series.totalMoney
                               ,@"items":items
                               }];
    }
    
    return orderArr;
}





+(CGFloat )getAllCountPriceWithDict:(NSDictionary *)_dataDict
{
    CGFloat _price=0;
    NSArray *remainArr=[_dataDict objectForKey:@"remain"];
    for (DD_ClearingSeriesModel *Series in remainArr) {
        for (DD_ClearingOrderModel *order in Series.items) {
            _price+=[order.price floatValue]*[order.numbers integerValue];
        }
    }
    NSArray *saleArr=[_dataDict objectForKey:@"saleing"];
    for (DD_ClearingSeriesModel *Series in saleArr) {
        for (DD_ClearingOrderModel *order in Series.items) {
            CGFloat _danjia=[order.price floatValue];
            NSInteger _num=[order.numbers integerValue];
            _price+=_danjia*_num;
        }
    }
    return _price;
}

+(NSInteger)getAllGoodsNumWithDict:(NSDictionary *)_dataDict
{
    NSArray *remainArr=[_dataDict objectForKey:@"remain"];
    NSArray *saleArr=[_dataDict objectForKey:@"saleing"];
    NSInteger _count=0;
    for (NSArray *_arr in saleArr) {
        _count+=_arr.count;
    }
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
    CGFloat _price=0;
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
                arr=[_saleingArr objectAtIndex:_section-1];
                
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
            arr=[_saleingArr objectAtIndex:_section];
        }else
        {
            return 0;
        }
    }
    for (DD_ClearingOrderModel *ordermodel in arr) {
        _price+=[ordermodel.price floatValue];
    }
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
    return [remainArr objectAtIndex:indexPath.row];
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
    return [((NSArray *)[saleingArr objectAtIndex:_section]) objectAtIndex:indexPath.row];
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
                return ((NSArray *)[_data_arr objectAtIndex:_section-1]).count;
            }
        }else
        {
            return ((NSArray *)[_dataDict objectForKey:@"remain"]).count;
        }
        
    }else
    {
        if([self have_saleingWithDict:_dataDict])
        {
            return ((NSArray *)[_data_arr objectAtIndex:_section]).count;
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
