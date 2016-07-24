//
//  DD_CityModel.h
//  DDAY
//
//  Created by yyj on 16/5/17.
//  Copyright © 2016年 mike_xie. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface DD_CityModel : NSObject
+(NSArray *)getCityModelArray:(NSArray *)arrdata;
+(DD_CityModel *)getCityModel:(NSDictionary *)dict;
__string(name);
__string(en_name);
__string(code);
__string(c_id);
@end
