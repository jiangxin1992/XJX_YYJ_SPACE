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

__string(s_id);

__string(name);

@end
