//
//  DD_CityModel.m
//  DDAY
//
//  Created by yyj on 16/5/17.
//  Copyright © 2016年 mike_xie. All rights reserved.
//

#import "DD_CityModel.h"

@implementation DD_CityModel
+(NSArray *)getCityModelArray:(NSArray *)arrdata
{
    NSMutableArray *arr=[[NSMutableArray alloc] init];
    for (NSDictionary *_dict in arrdata) {
        
        [arr addObject:[DD_CityModel getCityModel:_dict]];
    }
    return arr;
}
+(DD_CityModel *)getCityModel:(NSDictionary *)dict
{
    DD_CityModel *_City=[DD_CityModel objectWithKeyValues:dict];
    _City.c_id=[[NSString alloc] initWithFormat:@"%ld",[[dict objectForKey:@"id"] integerValue]];
    return _City;
}

@end
