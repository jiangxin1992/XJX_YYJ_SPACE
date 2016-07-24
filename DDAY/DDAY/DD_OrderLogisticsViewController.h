//
//  DD_OrderLogisticsViewController.h
//  DDAY
//
//  Created by yyj on 16/6/7.
//  Copyright © 2016年 YYJ. All rights reserved.
//
#import "DD_OrderModel.h"
#import <UIKit/UIKit.h>

@interface DD_OrderLogisticsViewController : UIViewController
-(instancetype)initWithModel:(DD_OrderModel *)model WithBlock:(void (^)(NSString *type))block;
__block_type(block, type);
@property (nonatomic,strong)DD_OrderModel *OrderModel;
@end
