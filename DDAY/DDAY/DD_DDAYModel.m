//
//  DD_DDAYModel.m
//  DDAY
//
//  Created by yyj on 16/6/1.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_DDAYModel.h"

@implementation DD_DDAYModel


/**
 * 获取解析model
 */
+(DD_DDAYModel *)getDDAYModel:(NSDictionary *)dict
{
    DD_DDAYModel *_DDAYModel=[DD_DDAYModel objectWithKeyValues:dict];
    _DDAYModel.s_id=[dict objectForKey:@"id"];
    _DDAYModel.signStartTime=_DDAYModel.signStartTime/1000;
    _DDAYModel.signEndTime=_DDAYModel.signEndTime/1000;
    _DDAYModel.saleStartTime=_DDAYModel.saleStartTime/1000;
    _DDAYModel.saleEndTime=_DDAYModel.saleEndTime/1000;
//    _DDAYModel.leftQuota=12;
//    _DDAYModel.isJoin=NO;
//    [self testData:_DDAYModel WithType:0];
//    [self testData1:_DDAYModel WithType:4];
    return _DDAYModel;
}
+(void)testData:(DD_DDAYModel *)_DDAYModel WithType:(NSInteger )type
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
+(void)testData1:(DD_DDAYModel *)_DDAYModel WithType:(NSInteger )type
{
    long nowTime=[regular date];
    if(type==0)
    {
        //        报名开始之前
        _DDAYModel.signStartTime=nowTime+300;
        _DDAYModel.signEndTime=nowTime+600;
        _DDAYModel.saleStartTime=nowTime+900;
        _DDAYModel.saleEndTime=nowTime+1200;
    }else if(type==1)
    {
        //        报名结束之前
        _DDAYModel.signStartTime=nowTime;
        _DDAYModel.signEndTime=nowTime+300;
        _DDAYModel.saleStartTime=nowTime+600;
        _DDAYModel.saleEndTime=nowTime+900;
    }else if(type==2)
    {
        //        发布会开始之前
        _DDAYModel.signStartTime=nowTime-300;
        _DDAYModel.signEndTime=nowTime;
        _DDAYModel.saleStartTime=nowTime+300;
        _DDAYModel.saleEndTime=nowTime+600;
    }else if(type==3)
    {
        //         发布中
        _DDAYModel.signStartTime=nowTime-600;
        _DDAYModel.signEndTime=nowTime-300;
        _DDAYModel.saleStartTime=nowTime;
        _DDAYModel.saleEndTime=nowTime+300;
    }else if(type==4)
    {
        //        发布会结束
        _DDAYModel.signStartTime=nowTime-900;
        _DDAYModel.signEndTime=nowTime-600;
        _DDAYModel.saleStartTime=nowTime-300;
        _DDAYModel.saleEndTime=nowTime;
    }
    
}

/**
 * 获取解析数组
 */
+(NSArray *)getDDAYModelArr:(NSArray *)arr
{
    NSMutableArray *itemsArr=[[NSMutableArray alloc] init];
    for (NSDictionary *dict in arr) {
        [itemsArr addObject:[self getDDAYModel:dict]];
    }
    return itemsArr;
}


@end
