//
//  DD_ProvinceModel.h
//  DDAY
//
//  Created by yyj on 16/5/17.
//  Copyright © 2016年 mike_xie. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DD_ProvinceModel;

@interface DD_ProvinceModel : NSObject

+(NSArray *)getProvinceModelArray:(NSArray *)arrdata;

+(DD_ProvinceModel *)getProvinceModel:(NSDictionary *)dict;

/** 省ID*/
__string(p_id);

/** 省名称*/
__string(name);

/** 省英文名称*/
__string(en_name);

/** 省code*/
__string(code);

/** 省下对应的城市数组*/
__array(City);

@end
