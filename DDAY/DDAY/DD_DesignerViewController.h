//
//  DD_DesignerViewController.h
//  DDAY
//
//  Created by yyj on 16/5/20.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_BaseViewController.h"

#import "DD_DesignerModel.h"

@interface DD_DesignerViewController : UIViewController
-(instancetype)initWithBlock:(void(^)(NSString *type , DD_DesignerModel *model))block;
@property(nonatomic,copy) void (^block)(NSString *type ,DD_DesignerModel *model);
@end
