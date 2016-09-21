//
//  DD_GoodsDetailModel.m
//  DDAY
//
//  Created by yyj on 16/5/22.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_GoodsDetailModel.h"

#import "DD_OrderItemModel.h"
#import "DD_ShowRoomModel.h"

@implementation DD_GoodsDetailModel
+(DD_GoodsDetailModel *)getGoodsDetailModel:(NSDictionary *)dict
{
    DD_GoodsDetailModel *_GoodsDetailModel=[DD_GoodsDetailModel mj_objectWithKeyValues:dict];
    _GoodsDetailModel.item=[DD_GoodsItemModel getGoodsItemModel:[dict objectForKey:@"item"]];
    _GoodsDetailModel.designer=[DD_GoodsDesignerModel getGoodsDesignerModel:[dict objectForKey:@"designer"]];
    _GoodsDetailModel.similarItems=[DD_OrderItemModel getOrderItemModelArr:[dict objectForKey:@"similarItems"]];
    _GoodsDetailModel.circle=[DD_CircleListModel getCircleListImgModel:[dict objectForKey:@"combination"]];
    _GoodsDetailModel.physicalStore=[DD_ShowRoomModel getShowRoomModelArr:[dict objectForKey:@"physicalStore"]];
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
    long _nowTime=[NSDate nowTime];
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

-(DD_ColorsModel *)getColorModelNameWithID:(NSString *)colorID
{
    for (DD_ColorsModel *color in self.item.colors) {
        if([color.colorId isEqualToString:colorID])
        {
            return color;
        }
    }
    return nil;
}

-(NSString *)getPriceStr
{
    NSString *_timestr=nil;
    long _nowTime=[NSDate nowTime];
    if(_nowTime>=self.item.saleEndTime)
    {
        //        已经结束
        if(self.item.discountEnable)
        {
            
            _timestr=[[NSString alloc] initWithFormat:@"￥%.1f  %@折 原价￥%.1f",[self.item.price floatValue],self.item.discount,[self.item.originalPrice floatValue]];
        }else
        {
            _timestr=[[NSString alloc] initWithFormat:@"￥%.1f",[self.item.originalPrice floatValue]];
        }
        
    }else
    {
        //        发布中
        if([self.item.discount integerValue])
        {
            _timestr=[[NSString alloc] initWithFormat:@"￥%.1f  %@折 原价￥%.1f",[self.item.price floatValue],self.item.discount,[self.item.originalPrice floatValue]];
            
        }else
        {
            _timestr=[[NSString alloc] initWithFormat:@"￥%.1f",[self.item.originalPrice floatValue]];
        }
        
    }
    return _timestr;
}
@end
