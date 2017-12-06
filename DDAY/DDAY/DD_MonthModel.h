//
//  DD_MonthModel.h
//  YCO SPACE
//
//  Created by yyj on 16/8/25.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DD_baseModel.h"

@interface DD_MonthModel : DD_baseModel

/** 几号*/
@property (assign, nonatomic) NSInteger dayValue;

/** 时间*/
@property (strong, nonatomic) NSDate *dateValue;

/** 星期几*/
__string(week);

/** 是否被锁定*/
__bool(isSelectedDay);

@end
