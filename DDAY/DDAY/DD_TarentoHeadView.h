//
//  DD_TarentoHeadView.h
//  DDAY
//
//  Created by yyj on 16/6/27.
//  Copyright © 2016年 YYJ. All rights reserved.
//
#import "DD_BaseView.h"

@interface DD_TarentoHeadView : DD_BaseView
/**
 * 初始化
 */
-(instancetype)initWithUserModel:(DD_UserModel *)usermodel WithBlock:(void (^)(NSString *type))block;
//+ (CGFloat)heightWithModel:(DD_UserModel *)model;
/**
 * 用户信息
 */
@property (nonatomic,strong) DD_UserModel *usermodel;
/**
 * 回调block
 */
@property(nonatomic,copy) void (^block)(NSString *type);
__label(des);
@end
