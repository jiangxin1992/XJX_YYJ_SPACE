//
//  DD_RGBModel.h
//  YCO SPACE
//
//  Created by yyj on 16/8/25.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DD_baseModel.h"

@interface DD_RGBModel : DD_baseModel

+(DD_RGBModel *)initWithColorCode:(NSString *)colorCode;

__float(R);

__float(G);

__float(B);

@end
