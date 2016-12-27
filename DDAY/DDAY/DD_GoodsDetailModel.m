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
#import "DD_GoodsItemModel.h"
#import "DD_GoodsDesignerModel.h"
#import "DD_CircleListModel.h"
#import "DD_ColorsModel.h"

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
    __block DD_ColorsModel *getColor=nil;
    NSString *_colorId=self.item.colorId;
    [self.item.colors enumerateObjectsUsingBlock:^(DD_ColorsModel *_color, NSUInteger idx, BOOL * _Nonnull stop) {
        if([_color.colorId isEqualToString:_colorId])
        {
            getColor=_color;
            *stop=YES;
        }
    }];
    return getColor;
}

-(NSString *)getAppUrl
{
    __block NSString *appurl=nil;
    NSString *_colorId=self.item.colorId;
    [self.item.colors enumerateObjectsUsingBlock:^(DD_ColorsModel *_color, NSUInteger idx, BOOL * _Nonnull stop) {
        if([_color.colorId isEqualToString:_colorId])
        {
//            appurl=_color.appUrl;
            appurl=_color.appUrlFull;
            *stop=YES;
        }
    }];
    return appurl;
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
    __block DD_ColorsModel *getColorModel=nil;
    [self.item.colors enumerateObjectsUsingBlock:^(DD_ColorsModel *color, NSUInteger idx, BOOL * _Nonnull stop) {
        if([color.colorId isEqualToString:colorID])
        {
            getColorModel=color;
            *stop=YES;
        }
    }];
    return getColorModel;
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
            
            _timestr=[[NSString alloc] initWithFormat:@"￥%@  %@折 原价￥%@",[regular getRoundNum:[self.item.price floatValue]],[regular getRoundNum:[self.item.discount floatValue]],[regular getRoundNum:[self.item.originalPrice floatValue]]];
        }else
        {
            
            _timestr=[[NSString alloc] initWithFormat:@"￥%@",[regular getRoundNum:[self.item.originalPrice floatValue]]];
        }
        
    }else
    {
        //        发布中
        if([self.item.discount integerValue])
        {
            
            _timestr=[[NSString alloc] initWithFormat:@"￥%@  %@折 原价￥%@",[regular getRoundNum:[self.item.price floatValue]],[regular getRoundNum:[self.item.discount floatValue]],[regular getRoundNum:[self.item.originalPrice floatValue]]];
            
        }else
        {
            _timestr=[[NSString alloc] initWithFormat:@"￥%@",[regular getRoundNum:[self.item.originalPrice floatValue]]];
        }
        
    }
    return _timestr;
}
-(NSString *)getDiscountPriceStr
{
    NSString *_timestr=nil;
    long _nowTime=[NSDate nowTime];
    if(_nowTime>=self.item.saleEndTime)
    {
        //        已经结束
        if(self.item.discountEnable)
        {
            
            _timestr=[[NSString alloc] initWithFormat:@"￥%@",[regular getRoundNum:[self.item.price floatValue]]];
        }else
        {
            
            _timestr=[[NSString alloc] initWithFormat:@"￥%@",[regular getRoundNum:[self.item.originalPrice floatValue]]];
        }
        
    }else
    {
        //        发布中
        if([self.item.discount integerValue])
        {
            
            _timestr=[[NSString alloc] initWithFormat:@"￥%@",[regular getRoundNum:[self.item.price floatValue]]];
            
        }else
        {
            _timestr=[[NSString alloc] initWithFormat:@"￥%@",[regular getRoundNum:[self.item.originalPrice floatValue]]];
        }
        
    }
    return _timestr;
}
-(NSString *)getOriginalPriceStr
{
    return [[NSString alloc] initWithFormat:@"￥%@",[regular getRoundNum:[self.item.originalPrice floatValue]]];;
}
@end
