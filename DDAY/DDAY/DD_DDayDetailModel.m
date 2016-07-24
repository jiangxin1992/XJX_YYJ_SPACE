//
//  DD_DDayDetailModel.m
//  DDAY
//
//  Created by yyj on 16/6/2.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_DDayDetailModel.h"

@implementation DD_DDayDetailModel
/**
 * 获取解析model
 */
+(DD_DDayDetailModel *)getDDayDetailModel:(NSDictionary *)dict{
    DD_DDayDetailModel *_DDAYModel=[DD_DDayDetailModel objectWithKeyValues:dict];
    _DDAYModel.s_id=[dict objectForKey:@"id"];
    _DDAYModel.signStartTime=_DDAYModel.signStartTime/1000;
    _DDAYModel.signEndTime=_DDAYModel.signEndTime/1000;
    _DDAYModel.saleStartTime=_DDAYModel.saleStartTime/1000;
    _DDAYModel.saleEndTime=_DDAYModel.saleEndTime/1000;
//    [self testData:_DDAYModel WithType:0];
    return _DDAYModel;
}
+(void)testData:(DD_DDayDetailModel *)_DDAYModel WithType:(NSInteger )type
{
    long nowTime=[regular date];
    if(type==0)
    {
        //        报名开始之前
        _DDAYModel.signStartTime=nowTime+3;
        _DDAYModel.signEndTime=nowTime+6;
        _DDAYModel.saleStartTime=nowTime+9;
        _DDAYModel.saleEndTime=nowTime+12;
    }else if(type==1)
    {
        //        报名结束之前
        _DDAYModel.signStartTime=nowTime;
        _DDAYModel.signEndTime=nowTime+3;
        _DDAYModel.saleStartTime=nowTime+6;
        _DDAYModel.saleEndTime=nowTime+9;
    }else if(type==2)
    {
        //        发布会开始之前
        _DDAYModel.signStartTime=nowTime-3;
        _DDAYModel.signEndTime=nowTime;
        _DDAYModel.saleStartTime=nowTime+3;
        _DDAYModel.saleEndTime=nowTime+6;
    }else if(type==3)
    {
        //         发布中
        _DDAYModel.signStartTime=nowTime-6;
        _DDAYModel.signEndTime=nowTime-3;
        _DDAYModel.saleStartTime=nowTime;
        _DDAYModel.saleEndTime=nowTime+3;
    }else if(type==4)
    {
        //        发布会结束
        _DDAYModel.signStartTime=nowTime-9;
        _DDAYModel.signEndTime=nowTime-6;
        _DDAYModel.saleStartTime=nowTime-3;
        _DDAYModel.saleEndTime=nowTime;
    }
    
}
/**
 * 获取解析数组
 */
+(NSArray *)getDDayDetailModelArr:(NSArray *)arr
{
    NSMutableArray *itemsArr=[[NSMutableArray alloc] init];
    for (NSDictionary *dict in arr) {
        [itemsArr addObject:[self getDDayDetailModel:dict]];
    }
    return itemsArr;
}
@end
