//
//  DD_UserInfoViewController.h
//  DDAY
//
//  Created by yyj on 16/5/22.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_BaseViewController.h"

@interface DD_UserInfoViewController : DD_BaseViewController
-(instancetype)initWithModel:(DD_UserModel *)usermodel WithBlock:(void (^)(DD_UserModel *model))block;
-(instancetype)initWithBlock:(void (^)(DD_UserModel *model))block;
@property (nonatomic,strong) DD_UserModel*usermodel;
@property (nonatomic,copy) void (^block)(DD_UserModel *usermodel);
@end
