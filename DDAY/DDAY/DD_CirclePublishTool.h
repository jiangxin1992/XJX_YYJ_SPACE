//
//  DD_CirclePublishTool.h
//  DDAY
//
//  Created by yyj on 16/6/24.
//  Copyright © 2016年 YYJ. All rights reserved.
//
#import "WaterflowCell.h"
#import "DD_CircleModel.h"
#import "DD_CricleTagItemModel.h"
#import "DD_CircleTagModel.h"
#import "DD_CricleChooseItemModel.h"
#import <Foundation/Foundation.h>

@interface DD_CirclePublishTool : NSObject
-(WaterflowCell *)getCustomWaterflowCell:(Waterflow *)waterflow cellAtIndex:(NSUInteger)index WithItemsModel:(DD_CricleChooseItemModel *)item WithHeight:(CGFloat )_height WithBlock:(void(^)(NSString *type,NSInteger index))block;
@property(nonatomic,copy) void (^block)(NSString *type,NSInteger index);
__int(index);
/**
 * 设置标签
 * 标签网络获取成功之后，setter值
 */
+(void)SetWithDict:(NSDictionary *)dict WithCircleModel:(DD_CircleModel *)CircleModel;
/**
 * 管理tagMap
 * 删除
 */
+(void)TagDelete:(long )index WithType:(NSInteger )type WithCircleModel:(DD_CircleModel *)CircleModel;
/**
 * 管理tagMap
 * 添加
 */
+(void)TagAdd:(long )index WithType:(NSInteger )type WithCircleModel:(DD_CircleModel *)CircleModel;
/**
 * 添加自定义标签
 * 将刚创建的 标签model存入管理对象中
 */
+(void)addCustomModel:(DD_CricleTagItemModel *)tagModel WithCircleModel:(DD_CircleModel *)CircleModel;
/**
 * 遍历当前customtags数组
 * 判断tagName对应的model是否存在
 */
+(BOOL)isExistCustomModelWithTagName:(NSString *)tagName WithCircleModel:(DD_CircleModel *)CircleModel;
/**
 * 更新chooseItem
 */
+(void)delChooseItemModel:(DD_CricleChooseItemModel *)model WithCircleModel:(DD_CircleModel *)CircleModel;
/**
 * 获取self chooseItem的参数数组
 */
+(NSArray *)getParameterItemArrWithCircleModel:(DD_CircleModel *)CircleModel;
/**
 * 获取tag的数量
 */
+(NSInteger)getParameterTagsNumWithCircleModel:(DD_CircleModel *)CircleModel;
/**
 * 获取picArr对应的key数组
 */
+(NSArray *)getPicArrWithCircleModel:(DD_CircleModel *)CircleModel;
+(NSArray *)getPicDataArrWithCircleModel:(DD_CircleModel *)CircleModel;
@end
