//
//  DD_DesignerFollowViewController.h
//  DDAY
//
//  Created by yyj on 16/6/12.
//  Copyright © 2016年 YYJ. All rights reserved.
//
#import "DD_DesignerModel.h"
#import "DD_BaseViewController.h"

@interface DD_DesignerFollowViewController : UIViewController
-(instancetype)initWithBlock:(void(^)(NSString *type ,DD_DesignerModel *model))block;
@property(nonatomic,copy) void (^block)(NSString *type ,DD_DesignerModel *model);
@end
