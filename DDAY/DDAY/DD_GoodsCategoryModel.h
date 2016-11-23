//
//  DD_GoodsCategoryModel.h
//  YCO SPACE
//
//  Created by yyj on 16/8/1.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DD_GoodsCategorySubModel;

@interface DD_GoodsCategoryModel : NSObject

+(DD_GoodsCategoryModel *)getGoodsCategoryModel:(NSDictionary *)dict;

+(NSArray *)getGoodsCategoryModelArr:(NSArray *)arr;

/** 一级目录名*/
__string(catOneName);

/** 二级目录列表*/
__array(catTwoList);

/** 是否是（全部）目录类型*/
__bool(isAll);

@end
