//
//  DD_TarentoHomePageViewController.h
//  DDAY
//
//  Created by yyj on 16/6/27.
//  Copyright © 2016年 YYJ. All rights reserved.
//
#import "DD_UserModel.h"
#import "DD_BaseViewController.h"

@interface DD_TarentoHomePageViewController : DD_BaseViewController
-(instancetype)initWithUserModel:(DD_UserModel *)usermodel;
@property (nonatomic,strong)DD_UserModel *usermodel;
@end
