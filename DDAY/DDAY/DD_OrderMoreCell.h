//
//  DD_OrderMoreCell.h
//  DDAY
//
//  Created by yyj on 16/6/6.
//  Copyright © 2016年 YYJ. All rights reserved.
//
#import "DD_OrderItemModel.h"
#import "DD_OrderModel.h"
#import <UIKit/UIKit.h>

@interface DD_OrderMoreCell : UITableViewCell
/**
 * cell 回调
 */
@property(nonatomic,copy) void (^cellblock)(NSString *type,NSInteger section);

/**
 * model index
 */
@property (nonatomic,assign)NSInteger index;
/**
 * cell model
 */
@property (nonatomic,strong)DD_OrderModel *OrderModel;

/**
 * 商品图片展示
 */
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
/**
 * 当前订单item数量label
 */
@property (weak, nonatomic) IBOutlet UILabel *itemCountLabel;
/**
 * 小计label
 */
@property (weak, nonatomic) IBOutlet UILabel *totalAmountLabel;
/**
 * 两个btn
 */
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@end
