//
//  DD_ProvinceModel.h
//  DDAY
//
//  Created by yyj on 16/5/17.
//  Copyright © 2016年 mike_xie. All rights reserved.
//
#import "DD_ProvinceModel.h"
#import "DD_CityModel.h"
#import <Foundation/Foundation.h>
@interface DD_ProvinceModel : NSObject
+(NSArray *)getProvinceModelArray:(NSArray *)arrdata;
+(DD_ProvinceModel *)getProvinceModel:(NSDictionary *)dict;
__string(name);
__string(en_name);
__string(code);
__string(p_id);
__array(City);
@end
