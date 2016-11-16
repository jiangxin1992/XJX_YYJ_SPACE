//
//  DD_UserModel.h
//  DDAY
//
//  Created by yyj on 16/5/20.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DD_BenefitInfoModel.h"

#define __string(__k__) @property(nonatomic,strong) NSString *__k__
#define __long(__k__) @property(nonatomic,assign) long __k__

@interface DD_UserModel : NSObject

/*********************************用户信息*********************************/
/**
 * 获取model
 */
+(DD_UserModel *)getUserModel:(NSDictionary *)dict;

/**
 * 登出
 */
+(void)logout;

/**
 * 获取性别（0 男/1 女 /2 未知）
 */
-(NSString *)getSexStr;

/**
 * 获取当前登录用户权限
 * 1 管理员 2 设计师 3 普通用户 4 达人
 */
+(NSInteger )getUserType;

/**
 * 获取用户的登陆渠道 (1:手机号码登陆/ 2:微信登录/ 3:qq登陆/ 4:sina登陆)
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
 * 更新本地用户权限
 */
+(void)UpdateUserType:(NSInteger )userType;

/*********************************一些存取*********************************/

/**
 * 用户信息本地存取
 */
+(void)setLocalUserInfo:(NSDictionary *)data;

+(DD_UserModel *)getLocalUserInfo;

/**
 * DeviceToken存取
 */
+(void)setDeviceToken:(NSString *)token;

+(NSString *)getDeviceToken;

/**
 * 订单号存取
 */
+(void)setTradeOrderCode:(NSString *)tradeOrderCode;

+(void)removeTradeOrderCode;

+(NSString *)getTradeOrderCode;

/**
 * 每日登录积分状态存取
 */
+(void)setDailyIntegral;

+(BOOL)getDailyIntegral;

+(void)regisnDailyIntegral;

/**
 * 首单立减红包未登录状态下的存取
 */
+(BOOL)isReadWithBenefitID:(NSString *)benefitID;

+(void)setReadBenefit:(BOOL)read WithBenefitInfoModel:(DD_BenefitInfoModel *)benefitInfoModel;

/*********************************参数*********************************/

/** 职业*/
__string(career);

/** 头像*/
__string(head);

/** 身高*/
__string(height);

/** 用户ID*/
__string(u_id);

/** 用户积分*/
__long(rewardPoints);

/** 优惠券数量*/
__int(benefitNumber);

/** 用户昵称*/
__string(nickName);

/** 手机号*/
__string(phone);

/** 性别 0男1女2未知*/
__string(sex);

/** 用户token*/
__string(token);

/** 用户类型 2设计师 3普通用户 4达人*/
__string(userType);

/** 体重*/
__string(weight);

@end
