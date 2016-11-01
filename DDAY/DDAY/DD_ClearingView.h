//
//  DD_ClearingView.h
//  DDAY
//
//  Created by yyj on 16/5/24.
//  Copyright © 2016年 YYJ. All rights reserved.
//
/*********** 总结视图为确认订单页面中的结算视图 ***********/
#import <UIKit/UIKit.h>

@interface DD_ClearingView : UIView

/**
 * 初始化方法
 */
-(instancetype)initWithDataArr:(NSArray *)dataArr Withfreight:(NSString *)freight WithPayWay:(NSString *)payWay WithBlock:(void (^)(NSString *type,CGFloat height,NSString *payWay))block;

-(void)setRemarksWithWebView:(NSString *)content;

/** 小计，不包括运费*/
//__string(subTotal);

/** 单个包裹运费*/
__string(freight);

/** 支付方式*/
__string(payWay);

/** 数据数组*/
__array(dataArr);

@property (nonatomic,copy) void (^block)(NSString *type,CGFloat height,NSString *payWay);

@end
