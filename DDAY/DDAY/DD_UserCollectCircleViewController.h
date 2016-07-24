//
//  DD_UserCollectCircleViewController.h
//  DDAY
//
//  Created by yyj on 16/6/13.
//  Copyright © 2016年 YYJ. All rights reserved.
//
#import "DD_CircleListModel.h"
#import "DD_BaseViewController.h"

@interface DD_UserCollectCircleViewController : DD_BaseViewController
-(instancetype)initWithBlock:(void(^)(NSString *type,DD_CircleListModel *model))block;
-(void)reloadData;
@property(nonatomic,copy) void (^block)(NSString *type,DD_CircleListModel *model);
@end
