//
//  DD_CircleDailyDetailHeadView.h
//  YCO SPACE
//
//  Created by yyj on 16/9/13.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DD_OrderItemModel.h"
#import "DD_CircleListModel.h"

@interface DD_CircleDailyDetailHeadView : UIView

/**
 * 初始化
 */
-(instancetype)initWithCircleListModel:(DD_CircleListModel *)model IsHomePage:(BOOL )isHomePage WithBlock:(void (^)(NSString *type,NSInteger index,DD_OrderItemModel *item))block;

+ (CGFloat)heightWithModel:(DD_CircleListModel *)model;

/**
 * 更新
 */
-(void)setState;

/**
 * 更新
 */
//-(void)update;

/** 搭配model*/
@property (nonatomic,strong) DD_CircleListModel *listModel;

/** 回调block*/
@property(nonatomic,copy) void (^block)(NSString *type,NSInteger index,DD_OrderItemModel *item);

__view(contentView);

__bool(isHomePage);

@end
