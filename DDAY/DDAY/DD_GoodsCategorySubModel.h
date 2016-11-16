//
//  DD_GoodsCategorySubModel.h
//  YCO SPACE
//
//  Created by yyj on 16/8/1.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DD_GoodsCategorySubModel : NSObject

+(NSArray *)getGoodsCategorySubModelArr:(NSArray *)arr;

/** 二级目录名*/
__string(catTwoName);

/** 二级目录ID*/
__string(catTwoId);

@end
