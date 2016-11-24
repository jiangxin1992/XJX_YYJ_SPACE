//
//  DD_OrderMoreCell.h
//  DDAY
//
//  Created by yyj on 16/6/6.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_BaseCell.h"

@class DD_OrderModel;
@class DD_OrderItemModel;

@interface DD_OrderMoreCell : DD_BaseCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier WithBlock:(void(^)(NSString *type,NSIndexPath *indexPath))block;

@property (nonatomic,strong)NSIndexPath *indexPath;

/** cell 回调*/
@property (nonatomic,copy) void (^cellblock)(NSString *type,NSIndexPath *indexPath);

/** cell model*/
@property (nonatomic,strong)DD_OrderModel *OrderModel;

@end
