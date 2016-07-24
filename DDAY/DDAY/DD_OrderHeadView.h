//
//  DD_OrderHeadView.h
//  DDAY
//
//  Created by yyj on 16/6/6.
//  Copyright © 2016年 YYJ. All rights reserved.
//
#import "DD_OrderModel.h"
#import <UIKit/UIKit.h>

@interface DD_OrderHeadView : UIView
-(instancetype)initWithFrame:(CGRect)frame WithOrderModel:(DD_OrderModel *)orderModel;
@property (nonatomic,strong)DD_OrderModel *orderModel;
@end
