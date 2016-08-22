//
//  DD_UserCollectCircleViewController.h
//  DDAY
//
//  Created by yyj on 16/6/13.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_BaseViewController.h"

#import "DD_OrderItemModel.h"
#import "DD_CircleListModel.h"

@interface DD_UserCollectCircleViewController : DD_BaseViewController
-(instancetype)initWithBlock:(void(^)(NSString *type,DD_CircleListModel *model,DD_OrderItemModel *item))block;
@property(nonatomic,copy) void (^block)(NSString *type,DD_CircleListModel *model,DD_OrderItemModel *item);
//-(void)reloadData;
@end
