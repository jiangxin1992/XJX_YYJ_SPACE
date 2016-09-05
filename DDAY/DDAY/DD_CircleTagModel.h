//
//  DD_CircleTagModel.h
//  DDAY
//
//  Created by yyj on 16/6/16.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DD_CricleTagItemModel.h"

@interface DD_CircleTagModel : NSObject
/**
 * 获取标签组model
 */
+(DD_CircleTagModel *)getCircleTagModel:(NSDictionary *)dict;
//+(DD_CircleTagModel *)getCircleTagModel_no:(NSDictionary *)dict;
/**
 * 获取标签组model数组
 */
+(NSMutableArray *)getCircleTagModelArr:(NSArray *)arr;
//+(NSMutableArray *)getCircleTagModelArr_no:(NSArray *)arr;
/**
 * 更新当前状态下的lastItem
 */
-(void )updateLastSelect;

/**
 * tags组对应的title
 */
__string(CategoryName);
/**
 * tags组对应的参数
 */
__string(parameterName);
/**
 * 标签 model数组
 */
__mu_array(tags);
/**
 * 最后点击的lastItem
 */
@property (nonatomic,strong)DD_CricleTagItemModel *lastItem;
@end
