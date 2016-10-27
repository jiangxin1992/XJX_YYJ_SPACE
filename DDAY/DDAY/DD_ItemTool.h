//
//  DD_ItemTool.h
//  YCO SPACE
//
//  Created by yyj on 16/7/21.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WaterflowCell.h"

#import "DD_ItemsModel.h"

@interface DD_ItemTool : NSObject

+(WaterflowCell *)getCustomWaterflowCell:(Waterflow *)waterflow cellAtIndex:(NSInteger)index WithItemsModel:(DD_ItemsModel *)item WithHeight:(CGFloat )_height;
+(WaterflowCell *)getColCustomWaterflowCell:(Waterflow *)waterflow cellAtIndex:(NSUInteger)index WithItemsModel:(DD_ItemsModel *)item WithHeight:(CGFloat )_height;
+(WaterflowCell *)getHomePageCustomWaterflowCell:(Waterflow *)waterflow cellAtIndex:(NSUInteger)index WithItemsModel:(DD_ItemsModel *)item WithHeight:(CGFloat )_height;

@end
