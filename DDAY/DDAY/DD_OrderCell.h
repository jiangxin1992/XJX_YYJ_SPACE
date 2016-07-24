//
//  DD_OrderCell.h
//  DDAY
//
//  Created by yyj on 16/6/6.
//  Copyright © 2016年 YYJ. All rights reserved.
//
#import "DD_OrderModel.h"
#import "DD_OrderItemModel.h"
#import <UIKit/UIKit.h>

@interface DD_OrderCell : UITableViewCell
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
 * 单品图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *itemImg;
/**
 * 品牌名label
 */
@property (weak, nonatomic) IBOutlet UILabel *brandName;
/**
 * item名label
 */
@property (weak, nonatomic) IBOutlet UILabel *itemName;
/**
 * 尺寸label
 */
@property (weak, nonatomic) IBOutlet UILabel *sizeName;
/**
 * 单价label
 */
@property (weak, nonatomic) IBOutlet UILabel *pricelabel;
/**
 * 当前订单item数量label
 */
@property (weak, nonatomic) IBOutlet UILabel *itemCountLabel;
/**
 * 单品购买数量label
 */
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
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
