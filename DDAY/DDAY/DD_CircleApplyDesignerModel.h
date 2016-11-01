//
//  DD_CircleApplyDesignerModel.h
//  DDAY
//
//  Created by yyj on 16/6/24.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DD_CircleApplyDesignerModel : NSObject

/**
 * 获取单品model数组
 */
+(NSArray *)getApplyDesignerModelArr:(NSArray *)arr;

/** 设计师ID*/
__string(designerId);

/** 设计师名*/
__string(designerName);
@end
