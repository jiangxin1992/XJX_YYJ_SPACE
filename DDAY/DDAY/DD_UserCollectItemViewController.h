//
//  DD_UserCollectItemViewController.h
//  DDAY
//
//  Created by yyj on 16/6/13.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_BaseViewController.h"

@class DD_ItemsModel;

@interface DD_UserCollectItemViewController : DD_BaseViewController

-(instancetype)initWithBlock:(void(^)(NSString *type,DD_ItemsModel *model))block;

@property(nonatomic,copy) void (^block)(NSString *type,DD_ItemsModel *model);

@end
