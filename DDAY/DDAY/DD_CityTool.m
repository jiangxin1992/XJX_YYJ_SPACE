//
//  DD_CityTool.m
//  DDAY
//
//  Created by yyj on 16/5/17.
//  Copyright © 2016年 mike_xie. All rights reserved.
//

#import "DD_CityTool.h"

#import "DD_ProvinceModel.h"

@implementation DD_CityTool
+(NSArray *)getCityModelArr
{
    NSString* path = [[NSBundle mainBundle] pathForResource:@"area" ofType:@"json"];
    
    NSData *theData = [NSData dataWithContentsOfFile:path];
    
    NSArray *cityarr = [NSJSONSerialization JSONObjectWithData:theData options:NSJSONReadingMutableContainers error:nil] ;
    return [DD_ProvinceModel getProvinceModelArray:cityarr];
}
@end
