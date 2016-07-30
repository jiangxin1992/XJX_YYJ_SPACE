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
-(DD_ColorsModel *)getColorsModel
{
    NSString *_colorId=self.item.colorId;
    for (DD_ColorsModel *_color in self.item.colors) {
        if([_color.colorId isEqualToString:_colorId])
        {
            return _color;
        }
    }
    return nil;
}

-(NSString *)getPrice
{
    long _nowTime=[regular date];
    if(_nowTime>=self.item.saleEndTime)
    {
        //        已经结束
        if(self.item.discountEnable)
        {
            return self.item.price;
        }else
        {
            return  self.item.originalPrice;
        }
        
    }else
    {
        //        发布中
        return self.item.price;
    }
}
-(NSString *)getColorNameWithID:(NSString *)colorID
{
    for (DD_ColorsModel *color in self.item.colors) {
        if([color.colorId isEqualToString:colorID])
        {
            if(color.colorName)
            {
                return color.colorName;
                
            }else
            {
                return @"";
            }
            break;
        }
    }
    return @"";
}
-(NSString *)getPriceStr
{
    NSString *_timestr=nil;
    long _nowTime=[regular date];
    if(_nowTime>=self.item.saleEndTime)
    {
        //        已经结束
        if(self.item.discountEnable)
        {
            
            _timestr=[[NSString alloc] initWithFormat:@"￥%.1f 折 %@原价￥%.1f",[self.item.price floatValue],self.item.discount,[self.item.originalPrice floatValue]];
        }else
        {
            _timestr=[[NSString alloc] initWithFormat:@"￥%.1f",[self.item.originalPrice floatValue]];
        }
        
    }else
    {
        //        发布中
        _timestr=[[NSString alloc] initWithFormat:@"￥%.1f 折 %@原价￥%.1f",[self.item.price floatValue],self.item.discount,[self.item.originalPrice floatValue]];
    }
    return _timestr;
}
@end
