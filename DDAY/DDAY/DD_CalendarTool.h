//
//  DD_CalendarTool.h
//  YCO SPACE
//
//  Created by yyj on 16/8/25.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DD_DDAYModel.h"
#import "DD_MonthModel.h"

@interface DD_CalendarTool : NSObject

/**
 * 获取该星期的所有系列
 */
+(NSArray *)getWeekSeriesWithDayModel:(NSDate *)date WithWeekNum:(NSInteger )week WithSeriesArr:(NSArray *)seriesArr WithDataArr:(NSArray *)dataArr;
/**
 * 获取该星期的所有区域view
 */
+(NSArray *)getWeekViewWithDayModel:(NSDate *)date WithWeekArr:(NSArray *)weekArr WithWeekNum:(NSInteger )week WithDataArr:(NSArray *)dataArr;
/**
 * 获取该月的所有系列
 */
+(NSArray *)getMonthSeriesWithDayModel:(NSDate *)date WithSeriesArr:(NSArray *)seriesArr WithDataArr:(NSArray *)dataArr;

+(NSArray *)getCurrentSeriesWithMonthModel:(DD_MonthModel *)monthModel WithData:(NSArray *)seriesArr;

+(NSInteger)getTypeWithArr:(NSArray *)getArr WithMonthModel:(DD_MonthModel *)monthModel;

+(NSArray *)sortWithCurrentSeries:(NSArray *)currentArr WithMonthSeriesArr:(NSArray *)monthSArr;
/**
 * 获取该月有几周
 */
+(NSInteger )getWeekCountWithDayModel:(NSDate *)date;
+(void)SetUnSelectWithArr:(NSMutableArray *)monthArr;
@end
