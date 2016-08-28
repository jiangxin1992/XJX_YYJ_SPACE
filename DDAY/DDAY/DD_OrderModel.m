//
//  DD_OrderModel.m
//  DDAY
//
//  Created by yyj on 16/6/6.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_OrderModel.h"

#import "DD_OrderItemModel.h"

@implementation DD_OrderModel
+(DD_OrderModel *)getOrderModel:(NSDictionary *)dict
{
    DD_OrderModel *_OrderModel=[DD_OrderModel objectWithKeyValues:dict];
    _OrderModel.itemList=[DD_OrderItemModel getOrderItemModelArr:[dict objectForKey:@"itemList"]];
    _OrderModel.createTime=[[dict objectForKey:@"createTime"] longLongValue]/1000;
//    _OrderModel.createTime=_OrderModel.createTime/1000;
    return _OrderModel;
}
+(NSArray *)getOrderModelArr:(NSArray *)arr
{
    NSMutableArray *itemsArr=[[NSMutableArray alloc] init];
    for (NSDictionary *dict in arr) {
        [itemsArr addObject:[self getOrderModel:dict]];
    }
    return itemsArr;
}
-(NSArray *)getBuyItems
{
    NSMutableArray *mut_arr=[[NSMutableArray alloc] init];
    for (DD_OrderItemModel *_item in self.itemList) {
        [mut_arr addObject:@{
                             @"itemId":_item.itemId
                             ,@"colorId":_item.colorId
                             ,@"sizeId":_item.sizeId
                             ,@"number":[NSNumber numberWithLong:_item.itemCount]
                             ,@"price":_item.price}];
        
    }
    return mut_arr;
}
-(BOOL )isSingle
{
    NSInteger num=self.itemList.count;
    
    if(num>1)
    {
        return NO;
    }
    return YES;
}
-(UIView *)getViewHeader
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
    view.backgroundColor = [UIColor clearColor];
    UIView *backview=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 38)];
    [view addSubview:backview];
    backview.backgroundColor=[UIColor whiteColor];
    
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(20,0, ScreenWidth-40, 38)];
    [backview addSubview:label];
    label.textColor=[UIColor blackColor];
    label.textAlignment=0;
    
    label.text=[[NSString alloc] initWithFormat:@"系列名称：%@",self.seriesName];
    
    return view;
}
-(UIView *)getViewFooter
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
    view.backgroundColor = [UIColor clearColor];
    UIView *backview=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 38)];
    [view addSubview:backview];
    backview.backgroundColor=[UIColor whiteColor];
    
    
    for (int i=0; i<2; i++) {
        UILabel *_label=[[UILabel alloc] initWithFrame:CGRectMake(10+200*i, 0, i==0?150:150, 38)];
        [backview addSubview:_label];
        _label.textAlignment=i==0?2:0;
        _label.textColor=[UIColor blackColor];
        _label.text=i==0?[[NSString alloc] initWithFormat:@"%ld 件商品",self.itemCount]:[[NSString alloc] initWithFormat:@"共计 ￥ %.1f",[self.totalAmount floatValue]];
    }
    return view;
}

@end
