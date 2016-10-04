//
//  Tools.m
//  爱限免
//
//  Created by huangdl on 14-10-10.
//  Copyright (c) 2014年 1000phone. All rights reserved.
//

#import "Tools.h"

@implementation Tools
//做ios版本之间的适配
//不同的ios版本,调用不同的方法,实现相同的功能
+(CGSize)sizeOfStr:(NSString *)str andFont:(UIFont *)font andMaxSize:(CGSize)size andLineBreakMode:(NSLineBreakMode)mode
{
    CGSize s;
    NSMutableDictionary  *mdic=[NSMutableDictionary dictionary];
    [mdic setObject:[UIColor redColor] forKey:NSForegroundColorAttributeName];
    [mdic setObject:font forKey:NSFontAttributeName];
    s = [str boundingRectWithSize:size options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                       attributes:mdic context:nil].size;
    return s;
}

+(NSString *)getShowDateByFormatAndTimeInterval:(NSString *)format timeInterval:(NSString *)timeInterval
{
    float millisecond = [timeInterval doubleValue];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:millisecond];
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [dateFormatter setTimeZone:timeZone];
    
    [dateFormatter setDateFormat:format];
    
    NSString *string = [dateFormatter stringFromDate:date];
    return string;
}


@end
