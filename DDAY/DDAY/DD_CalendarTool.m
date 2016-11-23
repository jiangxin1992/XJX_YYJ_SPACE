//
//  DD_CalendarTool.m
//  YCO SPACE
//
//  Created by yyj on 16/8/25.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_CalendarTool.h"
#import "Tools.h"
#import "DD_MonthModel.h"
#import "DD_RGBModel.h"
#import "DD_DDAYModel.h"

#define cellW floor(([UIScreen mainScreen].bounds.size.width-40-12)/7)
#define cellH floor((([UIScreen mainScreen].bounds.size.width-40-12)/7)-6)

@implementation DD_CalendarTool


+(NSArray *)getCurrentSeriesWithMonthModel:(DD_MonthModel *)monthModel WithData:(NSArray *)seriesArr
{
    NSMutableArray *arr=[[NSMutableArray alloc] init];
    NSDate *time=[monthModel.dateValue getFirstTime];
    long time_inv=[time getTime];
    
    for (DD_DDAYModel *seriesModel in seriesArr) {
        
        if([[[regular zoneChange:seriesModel.signStartTime] getFirstTime] getTime]<=time_inv&&[[[regular zoneChange:seriesModel.saleEndTime] getFirstTime] getTime]>=time_inv)
        {
            seriesModel.is_select=YES;
            [arr addObject:seriesModel];
        }else
        {
            seriesModel.is_select=NO;
        }
    }
    
    [self sortWithArr:arr];
//    NSInteger count = [arr count];
//    for (int i = 0; i < count; i++) {
//        for (int j = 0; j < count - i - 1; j++) {
//            if([[[NSString alloc] initWithFormat:@"%ld",((DD_DDAYModel *)[arr objectAtIndex:j]).signStartTime] compare:[[NSString alloc] initWithFormat:@"%ld",((DD_DDAYModel *)[arr objectAtIndex:j+1]).signStartTime] options:NSNumericSearch] == 1){  //同上potions  NSNumericSearch = 64,
//                [arr exchangeObjectAtIndex:j withObjectAtIndex:(j + 1)];  //这里可以用exchangeObjectAtIndex:方法来交换两个位置的数组元素。
//            }
//        }
//    }
    JXLOG(@"%@",arr);
    return arr;
}
+(NSInteger)getTypeWithArr:(NSArray *)getArr WithMonthModel:(DD_MonthModel *)monthModel
{
    NSInteger type=0;
    if(getArr.count)
    {
        JXLOG(@"%@",getArr);
        JXLOG(@"111");
        if(getArr.count==1)
        {
            if([monthModel.week integerValue]%7==0)
            {
                type=2;
            }else if([monthModel.week integerValue]%6==0)
            {
                type=4;
            }else
            {
                type=3;
            }
        }else
        {
            DD_DDAYModel *ddayModel_right=[getArr objectAtIndex:1];
            long _now_time=[[monthModel.dateValue getFirstTime] getTime];
            long _right_start_time=[[[regular zoneChange:ddayModel_right.signStartTime] getFirstTime] getTime];
            long _right_end_time=[[[regular zoneChange:ddayModel_right.saleEndTime] getFirstTime] getTime];
            if([monthModel.week integerValue]%7==0)
            {
                //                左边
                if(_now_time==_right_start_time)
                {
                    type=5;
                }else if(_now_time==_right_end_time)
                {
                    type=7;
                }else if(_right_start_time<_now_time&&_right_end_time>_now_time)
                {
                    type=6;
                }else
                {
                    type=1;
                }
            }else if([monthModel.week integerValue]%6==0)
            {
                //                中间
                if(_now_time==_right_start_time)
                {
                    type=11;
                }else if(_now_time==_right_end_time)
                {
                    type=13;
                }else if(_right_start_time<_now_time&&_right_end_time>_now_time)
                {
                    type=12;
                }else
                {
                    type=1;
                }
                
            }else
            {
                //                右边
                if(_now_time==_right_start_time)
                {
                    type=8;
                }else if(_now_time==_right_end_time)
                {
                    type=10;
                }else if(_right_start_time<_now_time&&_right_end_time>_now_time)
                {
                    JXLOG(@"%@",ddayModel_right);
                    JXLOG(@"%@",monthModel);
                    type=9;
                }else
                {
                    type=1;
                }
            }
        }
    }else
    {
         type=1;
    }
    return type;
}
+(NSInteger )getWeekCountWithDayModel:(NSDate *)date
{
    NSUInteger days = [date numberOfDaysInMonth];
    NSInteger week = [date startDayOfWeek];
    NSInteger _num = week+days;
    NSInteger _count=_num/7;
    if(_num%7)
    {
        _count=_count+1;
    }
    return _count;
}

+(NSArray *)getWeekSeriesWithDayModel:(NSDate *)date WithWeekNum:(NSInteger )week WithSeriesArr:(NSArray *)seriesArr WithDataArr:(NSArray *)dataArr
{
    JXLOG(@"date%@",[Tools getShowDateByFormatAndTimeInterval:@"YYYY/MM/dd HH:mm" timeInterval:[[[NSNumber alloc] initWithLong:[date getTime]] stringValue]]);

    NSUInteger days = [date numberOfDaysInMonth];
    NSInteger _week = [date startDayOfWeek];
    if(week==5)
    {
        JXLOG(@"111");
    }
    NSMutableArray *weekArr=[[NSMutableArray alloc] init];
    
    
    NSInteger _count=7;//[self getWeekCountWithDayModel:date];
    for (int j=0; j<_count; j++) {
        NSInteger _num=(week-1)*7+j;
        if(_num<(days+_week-1))
        {
            id mon = [dataArr objectAtIndex:_num];
            if ([mon isKindOfClass:[DD_MonthModel class]]) {
                DD_MonthModel *m_mon=(DD_MonthModel *)mon;
                NSInteger nowTime=[[m_mon.dateValue getFirstTime] getTime];
                for (DD_DDAYModel *ddayModel in seriesArr) {
                    long firstTime=[[[regular zoneChange:ddayModel.signStartTime] getFirstTime] getTime];
                    long lastTime=[[[regular zoneChange:ddayModel.saleEndTime] getFirstTime] getTime];
                    JXLOG(@"firstTime%@ lastTime%@",[Tools getShowDateByFormatAndTimeInterval:@"YYYY/MM/dd HH:mm" timeInterval:[[[NSNumber alloc] initWithLong:firstTime] stringValue]],[Tools getShowDateByFormatAndTimeInterval:@"YYYY/MM/dd HH:mm" timeInterval:[[[NSNumber alloc] initWithLong:lastTime] stringValue]]);

                    if(firstTime<=nowTime&&lastTime>=nowTime)
                    {
                        BOOL _have=NO;
                        for (DD_DDAYModel *_ddayModel in weekArr) {
                            if([_ddayModel.s_id isEqualToString:ddayModel.s_id])
                            {
                                _have=YES;
                                break;
                            }
                        }
                        if(!_have)
                        {
                            [weekArr addObject:ddayModel];
                        }
                    }
                }
            }
        }
    }

    [self sortWithArr:weekArr];
//    NSInteger count = [weekArr count];
//    for (int i = 0; i < count; i++) {
//        for (int j = 0; j < count - i - 1; j++) {
//            if([[[NSString alloc] initWithFormat:@"%ld",((DD_DDAYModel *)[weekArr objectAtIndex:j]).signStartTime] compare:[[NSString alloc] initWithFormat:@"%ld",((DD_DDAYModel *)[weekArr objectAtIndex:j+1]).signStartTime] options:NSNumericSearch] == 1){  //同上potions  NSNumericSearch = 64,
//                [weekArr exchangeObjectAtIndex:j withObjectAtIndex:(j + 1)];  //这里可以用exchangeObjectAtIndex:方法来交换两个位置的数组元素。
//            }
//        }
//    }
    
    return weekArr;
}
+(NSArray *)getWeekViewWithDayModel:(NSDate *)date WithWeekArr:(NSArray *)weekArr WithWeekNum:(NSInteger )week WithDataArr:(NSArray *)dataArr
{
    NSMutableArray *viewArr=[[NSMutableArray alloc] init];
    NSUInteger days = [date numberOfDaysInMonth];
    NSInteger _week = [date startDayOfWeek];
    //    获取每周开始到结束
/*    long _week_start_time=0;
    long _week_end_time=0;
    NSInteger _left_index=0;
    NSInteger _right_index=0;
    
    for (int j=0; j<7; j++) {
        NSInteger _num=(week-1)*7+j;
        if(_num<(days+_week-1))
        {
            id mon = [dataArr objectAtIndex:_num];
            if ([mon isKindOfClass:[DD_MonthModel class]]) {
                DD_MonthModel *m_mon=(DD_MonthModel *)mon;
                if(!_week_start_time)
                {
                    _week_start_time=[[m_mon.dateValue getFirstTime] getTime];
                    _left_index=j;
                }
                _week_end_time=[[m_mon.dateValue getFirstTime] getTime];
                _right_index=j;
            }
        }
    }*/
   // JXLOG(@"_left_index=%ld,_right_index=%ld",_left_index,_right_index);
   // JXLOG(@"_week_start_time=%ld,_week_end_time=%ld",_week_start_time,_week_end_time);
    
    
    //[[[NSNumber alloc] initWithLong:_week_end_time] stringValue];
   // JXLOG(@"week%@ %@",[Tools getShowDateByFormatAndTimeInterval:@"YYYY/MM/dd HH:mm" timeInterval:[[[NSNumber alloc] initWithLong:_week_start_time] stringValue]],[Tools getShowDateByFormatAndTimeInterval:@"YYYY/MM/dd HH:mm" timeInterval:[[[NSNumber alloc] initWithLong:_week_end_time] stringValue]]);
    
    //    计算宽度 和 起始点
    for (int i=0; i<weekArr.count; i++) {
        NSInteger _left_s_index=-1;
        NSInteger _right_s_index=-1;
        //        NSInteger
        DD_DDAYModel *seriesModel=[weekArr objectAtIndex:i];
        for (int j=0; j<7; j++) {
            NSInteger _num=(week-1)*7+j;
            if(_num<(days+_week-1))
            {
                id mon = [dataArr objectAtIndex:_num];
                if ([mon isKindOfClass:[DD_MonthModel class]]) {
                    DD_MonthModel *m_mon=(DD_MonthModel *)mon;
                    long _series_start_time=[[[regular zoneChange:seriesModel.signStartTime] getFirstTime] getTime];
                    long _series_end_time=[[[regular zoneChange:seriesModel.saleEndTime] getFirstTime] getTime];
                    long m_time=[[m_mon.dateValue getFirstTime] getTime];
                    JXLOG(@"series%@ %@",[Tools getShowDateByFormatAndTimeInterval:@"YYYY/MM/dd HH:mm" timeInterval:[[[NSNumber alloc] initWithLong:_series_start_time] stringValue]],[Tools getShowDateByFormatAndTimeInterval:@"YYYY/MM/dd HH:mm" timeInterval:[[[NSNumber alloc] initWithLong:_series_end_time] stringValue]]);
                    JXLOG(@"m_time%@",[Tools getShowDateByFormatAndTimeInterval:@"YYYY/MM/dd HH:mm" timeInterval:[[[NSNumber alloc] initWithLong:m_time] stringValue]]);
                    if(_series_start_time > _series_end_time){
                        break;
                    }
                    if(_series_start_time <= m_time && _left_s_index == -1){
                        _left_s_index = j;
                    }
                    if(_series_end_time <= m_time){
                        _right_s_index = j;
                        break;
                    }else{
                        _right_s_index = j;
                    }
                    
 /*                   if(_series_start_time<_week_start_time && _series_end_time>=_week_start_time && _series_end_time<=_week_end_time)
                    {
                        if(m_time<=_series_end_time)
                        {
                            _right_s_index=j;
                        }
                        
                        if(_left_s_index==-1)
                        {
                            _left_s_index=_left_index;
                        }
                    }
                    
                    if(_series_start_time>=_week_start_time && _series_start_time<=_week_end_time && _series_end_time>=_week_start_time && _series_end_time<=_week_end_time)
                    {
                        if(m_time<=_series_end_time)
                        {
                            _right_s_index=j;
                        }
                        
                        if(_series_start_time<=m_time)
                        {
                            _left_s_index=j;
                        }
                    }
                    
                    if(_series_start_time<=_week_end_time && _series_start_time>=_week_start_time && _series_end_time>_week_end_time)
                    {
                        
                        if(_right_s_index==-1)
                        {
                            
                            _right_s_index=_right_index;
                        }
                        
                        if(m_time<=_series_start_time)
                        {
                            _left_s_index=j;
                        }
                    }
                    
                    if(_series_start_time<_week_start_time && _week_end_time<_series_end_time)
                    {
                        if(_right_s_index==-1)
                        {
                            
                            _right_s_index=_right_index;
                        }
                        if(_left_s_index==-1)
                        {
                            
                            _left_s_index=_left_index;
                        }
                    }
  */
                }
            }
        }
        if(_left_s_index!=-1&&_right_s_index!=-1)
        {
            if(weekArr.count==1)
            {

                UIView *view=[[UIView alloc] initWithFrame:CGRectMake(6+_left_s_index*cellW, 40+(week-1)*cellH+0.1*cellH+6 , (_right_s_index-_left_s_index+1)*cellW, cellH-0.2*cellH)];
                view.layer.masksToBounds=YES;
                view.layer.borderWidth=2;
                view.backgroundColor=_define_white_color;
                DD_RGBModel *RGBModel=[DD_RGBModel initWithColorCode:seriesModel.seriesColor];
                view.layer.borderColor=[[UIColor colorWithRed:RGBModel.R/255.0 green:RGBModel.G/255.0 blue:RGBModel.B/255.0 alpha:1] CGColor];
                [viewArr addObject:view];
                
            }else if(weekArr.count>1)
            {
                UIView *view=[[UIView alloc] init];
                view.backgroundColor=_define_white_color;
                view.layer.masksToBounds=YES;
                view.layer.borderWidth=2;
                DD_RGBModel *RGBModel=[DD_RGBModel initWithColorCode:seriesModel.seriesColor];
                view.layer.borderColor=[[UIColor colorWithRed:RGBModel.R/255.0 green:RGBModel.G/255.0 blue:RGBModel.B/255.0 alpha:1] CGColor];
                if(i==0)
                {
                    view.frame=CGRectMake(6+_left_s_index*cellW, 40+(week-1)*cellH+0.1*cellH+6 , (_right_s_index-_left_s_index+1)*cellW, cellH-0.2*cellH-6);
                    [viewArr addObject:view];
                }else
                {
                    view.frame=CGRectMake(6+_left_s_index*cellW, 40+(week-1)*cellH+0.1*cellH+6+6 , (_right_s_index-_left_s_index+1)*cellW, cellH-0.2*cellH-6);
                    [viewArr insertObject:view atIndex:0];
                }
            }
        }
        
    }
    JXLOG(@"111____________________");

    return viewArr;
}

+(NSArray *)getMonthSeriesWithDayModel:(NSDate *)date WithSeriesArr:(NSArray *)seriesArr WithDataArr:(NSArray *)dataArr
{
   
    NSMutableArray *monthArr=[[NSMutableArray alloc] init];
    
    for (int i=0; i<dataArr.count; i++) {
        id mon = [dataArr objectAtIndex:i];
        if ([mon isKindOfClass:[DD_MonthModel class]])
        {
            DD_MonthModel *m_mon=(DD_MonthModel *)mon;
            NSInteger nowTime=[[m_mon.dateValue getFirstTime] getTime];
            for (DD_DDAYModel *ddayModel in seriesArr) {
                long firstTime=[[[regular zoneChange:ddayModel.signStartTime] getFirstTime] getTime];
                long lastTime=[[[regular zoneChange:ddayModel.saleEndTime] getFirstTime] getTime];
                if(firstTime<=nowTime&&lastTime>=nowTime)
                {
                    BOOL _have=NO;
                    for (DD_DDAYModel *_ddayModel in monthArr) {
                        if([_ddayModel.s_id isEqualToString:ddayModel.s_id])
                        {
                            _have=YES;
                            break;
                        }
                    }
                    if(!_have)
                    {
                        [monthArr addObject:ddayModel];
                    }
                }
            }
        }
        
    }
    
    [self sortWithArr:monthArr];
//    NSInteger count = [monthArr count];
//    for (int i = 0; i < count; i++) {
//        for (int j = 0; j < count - i - 1; j++) {
//            if([[[NSString alloc] initWithFormat:@"%ld",((DD_DDAYModel *)[monthArr objectAtIndex:j]).signStartTime] compare:[[NSString alloc] initWithFormat:@"%ld",((DD_DDAYModel *)[monthArr objectAtIndex:j+1]).signStartTime] options:NSNumericSearch] == 1){  //同上potions  NSNumericSearch = 64,
//                [monthArr exchangeObjectAtIndex:j withObjectAtIndex:(j + 1)];  //这里可以用exchangeObjectAtIndex:方法来交换两个位置的数组元素。
//            }
//        }
//    }
    
    return monthArr;
}

+(NSArray *)sortWithCurrentSeries:(NSArray *)currentArr WithMonthSeriesArr:(NSArray *)monthSArr
{
    if(currentArr)
    {
     
        NSMutableArray *monthArr=[[NSMutableArray alloc] init];
        [monthArr addObjectsFromArray:currentArr];
        
        NSMutableArray *monthSArr1=[[NSMutableArray alloc] initWithArray:monthSArr];
        for (DD_DDAYModel *ddayModel in currentArr) {
            [monthSArr1 removeObject:ddayModel];
        }
        [self sortWithArr:monthSArr1];
        [monthArr addObjectsFromArray:monthSArr1];
        return monthArr;
    }else
    {
        NSMutableArray *monthArr=[[NSMutableArray alloc] initWithArray:monthSArr];
        [self sortWithArr:monthArr];
        [self SetUnSelectWithArr:monthArr];
        return monthArr;
    }
}
+(void)SetUnSelectWithArr:(NSMutableArray *)monthArr
{
    for (DD_DDAYModel *ddayModel in monthArr) {
        ddayModel.is_select=NO;
    }
}
+(void)sortWithArr:(NSMutableArray *)monthArr
{
    NSInteger count = [monthArr count];
    for (int i = 0; i < count; i++) {
        for (int j = 0; j < count - i - 1; j++) {
            if([[[NSString alloc] initWithFormat:@"%ld",((DD_DDAYModel *)[monthArr objectAtIndex:j]).signStartTime] compare:[[NSString alloc] initWithFormat:@"%ld",((DD_DDAYModel *)[monthArr objectAtIndex:j+1]).signStartTime] options:NSNumericSearch] == 1){  //同上potions  NSNumericSearch = 64,
                [monthArr exchangeObjectAtIndex:j withObjectAtIndex:(j + 1)];  //这里可以用exchangeObjectAtIndex:方法来交换两个位置的数组元素。
            }
        }
    }
}
@end
