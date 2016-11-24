//
//  DD_OrderLogisticsHeadView.h
//  YCO SPACE
//
//  Created by yyj on 16/8/24.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_BaseView.h"

@class DD_OrderLogisticsManageModel;

@interface DD_OrderLogisticsHeadView : DD_BaseView

/**
 * 初始化
 */
-(instancetype)initWithCircleListModel:(DD_OrderLogisticsManageModel *)model WithBlock:(void (^)(NSString *type))block;

/**
 * 更新
 */
-(void)setState;

+ (CGFloat)heightWithModel:(DD_OrderLogisticsManageModel *)model;

/** 搭配model*/
@property (nonatomic,strong) DD_OrderLogisticsManageModel *LogisticsManageModel;

/** 回调block*/
@property(nonatomic,copy) void (^block)(NSString *type);

@property (nonatomic,strong)UIImageView *head;

@end
