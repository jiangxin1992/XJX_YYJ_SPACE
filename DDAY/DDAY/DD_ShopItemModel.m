//
//  DD_ShopItemModel.m
//  DDAY
//
//  Created by yyj on 16/5/27.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_ShopItemModel.h"

@implementation DD_ShopItemModel
+(DD_ShopItemModel *)getShopItemModel:(NSDictionary *)dict
{
    
    DD_ShopItemModel *_ShopItemModel=[DD_ShopItemModel objectWithKeyValues:dict];
//    java时间戳转换
    ;
    _ShopItemModel.signStartTime=[[dict objectForKey:@"signStartTime"] longLongValue]/1000;
    _ShopItemModel.signEndTime=[[dict objectForKey:@"signEndTime"] longLongValue]/1000;
    _ShopItemModel.saleStartTime=[[dict objectForKey:@"saleStartTime"] longLongValue]/1000;
    _ShopItemModel.saleEndTime=[[dict objectForKey:@"saleEndTime"] longLongValue]/1000;

//    _ShopItemModel.signStartTime=_ShopItemModel.signStartTime/1000;
//    _ShopItemModel.signEndTime=_ShopItemModel.signEndTime/1000;
//    _ShopItemModel.saleStartTime=_ShopItemModel.saleStartTime/1000;
//    _ShopItemModel.saleEndTime=_ShopItemModel.saleEndTime/1000;
//    初始化编辑状态
    _ShopItemModel.is_select=NO;
//    [self testDate:_ShopItemModel];
    return _ShopItemModel;
}
+(NSArray *)getShopItemModelArr:(NSArray *)arr
{
    NSMutableArray *itemsArr=[[NSMutableArray alloc] init];
    for (NSDictionary *dict in arr) {
        [itemsArr addObject:[self getShopItemModel:dict]];
    }
    return itemsArr;
}

/**
 * 测试数据
 */
+(void)testDate:(DD_ShopItemModel *)_ShopItemModel
{
    _ShopItemModel.signStartTime=[NSDate nowTime]-10;
    _ShopItemModel.signEndTime=[NSDate nowTime]-5;
    _ShopItemModel.saleStartTime=[NSDate nowTime];
    _ShopItemModel.saleEndTime=[NSDate nowTime]+5;
}
-(CGFloat )getPrice
{
    if(self)
    {
        if(self.saleEndTime>[NSDate nowTime])
        {
            return [self.price floatValue];
        }else
        {
            if(self.discountEnable)
            {
                return [self.price floatValue];
                
            }else
            {
                return [self.originalPrice floatValue];
            }
            
        }
    }
    return 0;
}

@end
