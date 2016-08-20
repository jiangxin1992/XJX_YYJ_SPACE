//
//  DD_UserModel.h
//  DDAY
//
//  Created by yyj on 16/5/20.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <Foundation/Foundation.h>

#define __string(__k__) @property(nonatomic,strong) NSString *__k__

@interface DD_UserModel : NSObject
/**
 * 职业
 */
__string(career);
/**
 * 头像
 */
__string(head);
/**
 * 身高
 */
__string(height);
/**
 * 用户id
 */
__string(u_id);
/**
 * 用户昵称
 */
__string(nickName);
/**
 * 手机号
 */
__string(phone);
/**
 * 性别 0男1女2未知
 */
__string(sex);
/**
 * 用户token
 */
__string(token);
/**
 * 用户类型 2设计师 3普通用户 4达人
 */
__string(userType);
/**
 * 体重
 */
__string(weight);
/**
 * 登出
 */
+(void)logout;
/**
 * 存入订单号
 */
+(void)setTradeOrderCode:(NSString *)tradeOrderCode;
/**
 * 移除订单号
 */
+(void)removeTradeOrderCode;
/**
 * 获取订单号
 */
+(NSString *)getTradeOrderCode;
/**
 * 获取model
 */
+(DD_UserModel *)getUserModel:(NSDictionary *)dict;
/**
 * 设置本地用户信息
 */
+(void)setLocalUserInfo:(NSDictionary *)data;
/**
 * 获取本地用户信息
 */
+(DD_UserModel *)getLocalUserInfo;
/**
 * 获取当前登录用户权限
 * 1 管理员 2 设计师 3 普通用户 4 达人
 */
+(NSInteger )getUserType;
/**
 * 获取用户的登陆渠道
 * public static final int USER_LOGIN_PHONE = 1;//手机号码登陆
 * public static final int USER_LOGIN_WEIXIN = 2;//微信登录
 * public static final int USER_LOGIN_QQ = 3;//qq登陆
 * public static final int USER_LOGIN_SINA = 4;//sina登陆
 */
+(NSInteger )getThirdPartLogin;
/**
 * 用户是否登录
 */
+(BOOL )isLogin;
/**
 * 获取用户token
 */
+(NSString *)getToken;
/**
 * 获取性别
 */
-(NSString *)getSexStr;
/**
 * 更新本地用户权限
 */
+(void)UpdateUserType:(NSInteger )userType;
@end
