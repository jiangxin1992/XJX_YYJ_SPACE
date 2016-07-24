//
//  DD_DesignerViewController.h
//  DDAY
//
//  Created by yyj on 16/5/20.
//  Copyright © 2016年 YYJ. All rights reserved.
//
#import "DD_DesignerModel.h"
#import "DD_BaseViewController.h"

@interface DD_DesignerViewController : DD_BaseViewController
-(instancetype)initWithBlock:(void(^)(DD_DesignerModel *model))block;
@property(nonatomic,copy) void (^block)(DD_DesignerModel *model);
@end
