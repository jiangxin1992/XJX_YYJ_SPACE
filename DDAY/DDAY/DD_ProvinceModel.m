//
//  DD_ProvinceModel.m
//  DDAY
//
//  Created by yyj on 16/5/17.
//  Copyright © 2016年 mike_xie. All rights reserved.
//

#import "DD_ProvinceModel.h"

@implementation DD_ProvinceModel
+(DD_ProvinceModel *)getProvinceModel:(NSDictionary *)dict
{

    DD_ProvinceModel *_Province=[DD_ProvinceModel objectWithKeyValues:dict];
    _Province.p_id=[[NSString alloc] initWithFormat:@"%ld",[[dict objectForKey:@"id"] integerValue]];
    _Province.City=[DD_CityModel getCityModelArray:[dict objectForKey:@"City"]];
    return _Province;
}
+(NSArray *)getProvinceModelArray:(NSArray *)arrdata
{
    NSMutableArray *arr=[[NSMutableArray alloc] init];
    for (NSDictionary *_dict in arrdata) {
        
         [arr addObject:[DD_ProvinceModel getProvinceModel:_dict]];
    }
    return arr;
}

@end