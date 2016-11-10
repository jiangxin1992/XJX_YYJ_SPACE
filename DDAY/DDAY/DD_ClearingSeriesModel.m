//
//  DD_ClearingSeriesModel.m
//  DDAY
//
//  Created by yyj on 16/5/25.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_ClearingSeriesModel.h"

#import "DD_ClearingOrderModel.h"

@implementation DD_ClearingSeriesModel

/**
 * 获取SectionFooterView
 */
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
       
        _label.text=i==0?[[NSString alloc] initWithFormat:@"%ld 件商品",self.items.count]:[[NSString alloc] initWithFormat:@"共计 ￥ %@", [regular getRoundNum:[self getSeriesPrice]]];
    }
    return view;
}
-(CGFloat )getSeriesPrice
{
    CGFloat _price=0;
    for (DD_ClearingOrderModel *_order in self.items) {
        _price+=[_order.price floatValue]*[_order.numbers integerValue];
    }
    return _price;
}
/**
 * 获取SectionHeaderView
 */
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
    
    label.text=[[NSString alloc] initWithFormat:@"系列：%@",self.seriesName];
    
    
    return view;
}

@end
