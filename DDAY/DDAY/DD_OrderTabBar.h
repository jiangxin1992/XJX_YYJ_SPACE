//
//  DD_OrderTabBar.h
//  DDAY
//
//  Created by yyj on 16/6/8.
//  Copyright © 2016年 YYJ. All rights reserved.
//
#import "DD_OrderDetailInfoModel.h"
#import <UIKit/UIKit.h>

@interface DD_OrderTabBar : UIView
/**
 * 初始化方法
 */
-(instancetype)initWithFrame:(CGRect)frame WithOrderDetailInfoModel:(DD_OrderDetailInfoModel *)orderInfo WithBlock:(void (^)(NSString *type))block;
/**
 * 更新状态
 */
-(void)UIConfig;
/**
 * 回调方法
 */
__block_type(Block, type);
/**
 * model
 */
@property (nonatomic,strong)DD_OrderDetailInfoModel *orderInfo;
@end
