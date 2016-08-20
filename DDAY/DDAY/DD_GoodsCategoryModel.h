//
//  DD_GoodsCategoryModel.h
//  YCO SPACE
//
//  Created by yyj on 16/8/1.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DD_GoodsCategorySubModel.h"

@interface DD_GoodsCategoryModel : NSObject
+(DD_GoodsCategoryModel *)getGoodsCategoryModel:(NSDictionary *)dict;
+(NSArray *)getGoodsCategoryModelArr:(NSArray *)arr;
__string(catOneName);
__array(catTwoList);
__bool(isAll);
@end
