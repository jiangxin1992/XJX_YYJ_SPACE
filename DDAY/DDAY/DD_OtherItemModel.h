//
//  DD_OtherItemModel.h
//  DDAY
//
//  Created by yyj on 16/5/23.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DD_OtherItemModel : NSObject

+(NSArray *)getOtherItemModelArr:(NSArray *)arr;

/** 单品pic*/
__string(itemPic);

/** 单品名*/
__string(itemName);

/** 单品ID*/
__string(itemId);

/** 单品对应colorId*/
__string(colorId);

/** 单品对应colorCode*/
__string(colorCode);

@end
