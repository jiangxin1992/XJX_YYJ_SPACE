//
//  DD_GoodSeriesModel.h
//  DDAY
//
//  Created by yyj on 16/5/23.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DD_GoodSeriesModel : NSObject

+(DD_GoodSeriesModel *)getGoodSeriesModel:(NSDictionary *)dict;

/** 系列ID*/
__string(s_id);

/** 系列名称*/
__string(name);

/** 系列颜色*/
__string(seriesColor);

@end
