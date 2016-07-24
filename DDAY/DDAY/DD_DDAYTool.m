//
//  DD_DDAYTool.m
//  DDAY
//
//  Created by yyj on 16/6/1.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_DDAYTool.h"

@implementation DD_DDAYTool
+(NSString *)getTimeStrWithTime:(long)time
{
//    NSTimeInterval time=DDAYModel.saleEndTime+28800;//因为时差问题要加8小时 == 28800 sec
    
    NSDate*detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    
    //实例化一个NSDateFormatter对象
    
    NSDateFormatter*dateFormatter = [[NSDateFormatter alloc]init];
    
    //设定时间格式,这里可以设置成自己需要的格式
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSString*currentDateStr = [dateFormatter stringFromDate:detaildate];
    return currentDateStr;
}
@end
