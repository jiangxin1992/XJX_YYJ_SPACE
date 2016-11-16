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

/** 颜色code*/
__string(colorCode);

/** 颜色ID*/
__string(colorId);

/** 颜色名*/
__string(colorName);

/** 颜色图片*/
__string(colorPic);

/** 对应的itemId*/
__string(itemId);

/** 图片数组*/
__array(pics);

/** 颜色对应的size数组*/
__array(size);

/** 尺寸图*/
__string(sizeBriefPic);

/** 尺寸图高度*/
__string(sizeBriefPicHeight);

/** 尺寸图宽度*/
__string(sizeBriefPicWidth);

@end
