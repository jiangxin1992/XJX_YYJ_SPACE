//
//  DD_OrderRefundViewController.h
//  DDAY
//
//  Created by yyj on 16/6/8.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_BaseViewController.h"

#import "DD_OrderDetailModel.h"

@interface DD_OrderRefundViewController : DD_BaseViewController

-(instancetype)initWithModel:(DD_OrderDetailModel *)model WithBlock:(void (^)(NSString *type))block;

@property(nonatomic,copy) void (^block)(NSString *type);

@property (nonatomic,strong)DD_OrderDetailModel *OrderModel;

@end
