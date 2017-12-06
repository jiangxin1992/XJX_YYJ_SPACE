//
//  DD_CityModel.h
//  DDAY
//
//  Created by yyj on 16/5/17.
//  Copyright © 2016年 mike_xie. All rights reserved.
//
#import <Foundation/Foundation.h>

#import "DD_baseModel.h"

@interface DD_CityModel : DD_baseModel

+(NSArray *)getCityModelArray:(NSArray *)arrdata;

+(DD_CityModel *)getCityModel:(NSDictionary *)dict;

/** 城市名称*/
__string(name);

/** 城市英文名*/
__string(en_name);

/** 城市code*/
__string(code);

/** 城市ID*/
__string(c_id);

@end
