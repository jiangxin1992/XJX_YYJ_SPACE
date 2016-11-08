//
//  DD_ClearingTableViewCell.h
//  DDAY
//
//  Created by yyj on 16/5/18.
//  Copyright © 2016年 mike_xie. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DD_ClearingOrderModel.h"

@interface DD_ClearingTableViewCell : UITableViewCell

/**
 * 初始化方法
 */
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier IsOrderDetail:(BOOL )isOrderDetail WithBlock:(void(^)(NSString *type))block;

@property (nonatomic,strong)DD_ClearingOrderModel *ClearingModel;

@property (nonatomic,copy) void (^clickblock)(NSString *type);

/** 是否是订单详情页中用到*/
__bool(isOrderDetail);

@end
