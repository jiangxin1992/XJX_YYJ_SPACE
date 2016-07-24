//
//  DD_DDAYDetailViewController.h
//  DDAY
//
//  Created by yyj on 16/6/2.
//  Copyright © 2016年 YYJ. All rights reserved.
//
#import "DD_DDAYModel.h"
#import "DD_BaseViewController.h"

@interface DD_DDAYDetailViewController : DD_BaseViewController
-(instancetype)initWithModel:(DD_DDAYModel *)model WithBlock:(void (^)(NSString *type))block;
@property (nonatomic,copy) void (^block)(NSString *type);
@property (nonatomic,strong) DD_DDAYModel *model;
@end
