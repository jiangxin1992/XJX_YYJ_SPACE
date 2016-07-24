//
//  DD_CricleCategoryModel.h
//  DDAY
//
//  Created by yyj on 16/6/20.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DD_CricleCategoryModel : NSObject
/**
 * 获取分类标签model 数组
 */
+(NSArray *)getCricleCategoryModelArr:(NSArray *)arr;
/**
 * 获取分类标签model
 */
+(DD_CricleCategoryModel *)getInitModel;

/**
 * 分类标签code
 */
__string(code);
/**
 * 分类标签的分级
 */
__string(level);
/**
 * 分裂标签名
 */
__string(name);
@end
