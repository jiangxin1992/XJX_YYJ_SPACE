//
//  DD_OrderDetailFootView.h
//  YCO SPACE
//
//  Created by yyj on 2016/11/9.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DD_OrderDetailModel.h"

@interface DD_OrderDetailFootView : UIView

/**
 * 初始化方法
 * public static Integer ORDER_STATUS_DFK = 0; //待付款
 * public static Integer ORDER_STATUS_DFH = 1; //待发货
 * public static Integer ORDER_STATUS_DSH = 2; //待收货
 * public static Integer ORDER_STATUS_JYCG = 3; //交易成功
 * public static Integer ORDER_STATUS_SQTK = 4; //申请退款
 * public static Integer ORDER_STATUS_TKCLZ = 5; //退款处理中
 * public static Integer ORDER_STATUS_YTK = 6; //已退款
 * public static Integer ORDER_STATUS_JJTK = 7; //拒绝退款
 * public static Integer ORDER_STATUS_YQX = 8; //已取消
 * public static Integer ORDER_STATUS_YSC = 9; //已删除
 */
-(instancetype)initWithOrderDetailModel:(DD_OrderDetailModel *)orderDetailModel WithBlock:(void (^)(NSString *type,CGFloat height))block;

/**
 * 更新视图
 */
-(void)SetState;
/**
 * 1、倒计时结束
 * 2、倒计时被终止（订单被支付／取消／推出界面）
 * 3、状态变化
 * 4、高度变化
 */
@property (nonatomic,copy) void (^block)(NSString *type,CGFloat height);

/** 订单详情model*/
@property (nonatomic,strong) DD_OrderDetailModel *orderDetailModel;

@end
