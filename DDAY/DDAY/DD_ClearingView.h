//
//  DD_ClearingView.h
//  DDAY
//
//  Created by yyj on 16/5/24.
//  Copyright © 2016年 YYJ. All rights reserved.
//
/*********** 总结视图为确认订单页面中的结算视图 ***********/
#import <UIKit/UIKit.h>

@interface DD_ClearingView : UIView<UIWebViewDelegate>
/**
 * 初始化方法
 */
-(instancetype)initWithFrame:(CGRect)frame WithDataArr:(NSArray *)dataArr Withfreight:(NSString *)freight WithCountPrice:(NSString *)subTotal WithBlock:(void (^)(NSString *type,CGFloat height))block;
-(void)setRemarksWithWebView:(NSString *)content;
/**
 * 小计，不包括运费
 */
__string(subTotal);
/**
 * 单个包裹运费
 */
__string(freight);
/**
 * 数据数组
 */
__array(dataArr);
@property (nonatomic,copy) void (^block)(NSString *type,CGFloat height);
@end
