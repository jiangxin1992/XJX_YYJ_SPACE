//
//  DD_AddressModel.h
//  DDAY
//
//  Created by yyj on 16/5/17.
//  Copyright © 2016年 mike_xie. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface DD_AddressModel : NSObject
+(NSArray *)getAddressModelArray:(NSArray *)arrdata;
+(DD_AddressModel *)getAddressModel:(NSDictionary *)dict;
/**
 * 国家ID
 */
__string(countryId);
/**
 * 国家名
 */
__string(countryName);
/**
 * 省ID
 */
__string(provinceId);
/**
 * 省名
 */
__string(provinceName);
/**
 * 城市ID
 */
__string(cityId);
/**
 * 城市名
 */
__string(cityName);


/**
 * 收货人
 */
__string(deliverName);
/**
 * 收货人手机号码
 */
__string(deliverPhone);
/**
 * 详细地址
 */
__string(detailAddress);
/**
 * 是否是默认地址
 */
__bool(isDefault);
/**
 * 邮政编码
 */
__string(postCode);
/**
 * 地址ID
 */
__string(udaId);
@end
