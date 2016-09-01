//
//  DD_SexViewController.h
//  YCO SPACE
//
//  Created by yyj on 16/9/1.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_BaseViewController.h"

@interface DD_SexViewController : DD_BaseViewController

-(instancetype)initWithModel:(DD_UserModel *)usermodel WithSex:(NSString *)sex WithBlock:(void (^)(DD_UserModel *model))block;
__string(sex);
@property (nonatomic,strong) DD_UserModel*usermodel;
@property (nonatomic,copy) void (^block)(DD_UserModel *usermodel);
@end

