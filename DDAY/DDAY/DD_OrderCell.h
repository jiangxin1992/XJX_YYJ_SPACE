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

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier WithBlock:(void(^)(NSString *type,NSIndexPath *indexPath))block;

@property (nonatomic,strong)NSIndexPath *indexPath;

/** cell 回调*/
@property (nonatomic,copy) void (^cellblock)(NSString *type,NSIndexPath *indexPath);

/** cell model*/
@property (nonatomic,strong)DD_OrderModel *OrderModel;

@end
