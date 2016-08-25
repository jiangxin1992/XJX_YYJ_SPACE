//
//  DD_CalendarTool.h
//  YCO SPACE
//
//  Created by yyj on 16/8/25.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DD_DDAYModel.h"

@interface DD_CalendarTool : NSObject
-(NSArray *)getPointArrWithType:(NSInteger )type WithColorOne:(NSString *)colorCode1 WithColorTwo:(NSString *)colorCode2;
@end
