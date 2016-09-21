//
//  DD_AddressModel.m
//  DDAY
//
//  Created by yyj on 16/5/17.
//  Copyright © 2016年 mike_xie. All rights reserved.
//

#import "DD_AddressModel.h"

@implementation DD_AddressModel
+(DD_AddressModel *)getAddressModel:(NSDictionary *)dict
{
    DD_AddressModel *_Address=[DD_AddressModel mj_objectWithKeyValues:dict];
    return _Address;
}
+(NSArray *)getAddressModelArray:(NSArray *)arrdata
{
    NSMutableArray *mutable_arr=[[NSMutableArray alloc] init];
    for (NSDictionary *dict in arrdata) {
        [mutable_arr addObject:[self getAddressModel:dict]];
    }
    return mutable_arr;
}

@end
