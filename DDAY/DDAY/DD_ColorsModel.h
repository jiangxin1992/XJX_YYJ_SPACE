//
//  DD_ColorsModel.h
//  DDAY
//
//  Created by yyj on 16/5/23.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DD_ColorsModel : NSObject

+(DD_ColorsModel *)getColorsModel:(NSDictionary *)dict;
+(NSArray *)getColorsModelArr:(NSArray *)arr;

__string(colorCode);
__string(colorId);
__string(colorPic);
__string(itemId);
__array(pics);
__array(size);
__string(colorName);
__string(sizeBriefPic);
__string(sizeBriefPicHeight);
__string(sizeBriefPicWidth);



@end
