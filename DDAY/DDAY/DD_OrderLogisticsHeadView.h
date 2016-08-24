//
//  DD_OrderLogisticsHeadView.h
//  YCO SPACE
//
//  Created by yyj on 16/8/24.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DD_OrderLogisticsManageModel.h"

@interface DD_OrderLogisticsHeadView : UIView

/**
 * 初始化
 */
-(instancetype)initWithCircleListModel:(DD_OrderLogisticsManageModel *)model WithBlock:(void (^)(NSString *type))block;

+ (CGFloat)heightWithModel:(DD_OrderLogisticsManageModel *)model;
/**
 * 搭配model
 */
@property (nonatomic,strong) DD_OrderLogisticsManageModel *LogisticsManageModel;
/**
 * 回调block
 */
@property(nonatomic,copy) void (^block)(NSString *type);
/**
 * 更新
 */
-(void)setState;

@property (nonatomic,strong)UIImageView *head;

@end
