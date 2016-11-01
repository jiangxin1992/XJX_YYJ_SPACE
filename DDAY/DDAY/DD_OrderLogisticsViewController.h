//
//  DD_OrderLogisticsViewController.h
//  DDAY
//
//  Created by yyj on 16/6/7.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DD_BaseViewController.h"
#import "DD_OrderModel.h"

@interface DD_OrderLogisticsViewController : DD_BaseViewController

-(instancetype)initWithModel:(DD_OrderModel *)model WithBlock:(void (^)(NSString *type))block;

__block_type(block, type);

@property (nonatomic,strong)DD_OrderModel *OrderModel;

@end
