//
//  DD_baseModel.m
//  DDAY
//
//  Created by yyj on 16/5/20.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_baseModel.h"

@implementation DD_baseModel

-(NSString *)description{
    return [NSString stringWithFormat:@"<%@: %p, %@>",[self class],self,[self mj_JSONObject]];
}

@end
