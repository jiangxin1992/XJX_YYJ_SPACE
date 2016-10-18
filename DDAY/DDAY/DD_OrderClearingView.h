//
//  DD_OrderClearingView.h
//  DDAY
//
//  Created by yyj on 16/6/7.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DD_OrderDetailInfoModel.h"

@interface DD_OrderClearingView : UIView
/**
 * 初始化方法
 */
-(instancetype)initWithOrderDetailInfoModel:(DD_OrderDetailInfoModel *)orderInfo Withfreight:(CGFloat )freight WithCountPrice:(NSString *)subTotal WithBlock:(void (^)(NSString *type,CGFloat height))block;
//-(void)setRemarksWithWebView:(NSString *)content;
/**
 * 小计，不包括运费
 */
__string(subTotal);
/**
 * 单个包裹运费
 */
__float(freight);
/**
 * 订单 model
 */
@property (nonatomic,strong)DD_OrderDetailInfoModel *orderInfo;

@property (nonatomic,copy) void (^block)(NSString *type,CGFloat height);
@end
