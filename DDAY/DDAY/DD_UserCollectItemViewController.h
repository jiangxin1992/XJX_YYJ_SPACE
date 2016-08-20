//
//  DD_UserCollectItemViewController.h
//  DDAY
//
//  Created by yyj on 16/6/13.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_BaseViewController.h"

#import "DD_ItemsModel.h"

@interface DD_UserCollectItemViewController : DD_BaseViewController
-(instancetype)initWithBlock:(void(^)(NSString *type,DD_ItemsModel *model))block;
@property(nonatomic,copy) void (^block)(NSString *type,DD_ItemsModel *model);
@end
