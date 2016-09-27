//
//  DD_SetPSWViewController.h
//  DDAY
//
//  Created by yyj on 16/5/21.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_BaseViewController.h"

@interface DD_SetPSWViewController : DD_BaseViewController
-(instancetype)initWithParameters:(NSDictionary *)parameters WithThirdPartLogin:(NSInteger )thirdPartLogin WithBlock:(void (^)(NSString *type))successblock;
__block_type(successblock, type);
__string(phone);
__dict(parameters);
/**
 * 获取用户的登陆渠道
 * public static final int USER_LOGIN_PHONE = 1;//手机号码登陆
 * public static final int USER_LOGIN_WEIXIN = 2;//微信登录
 * public static final int USER_LOGIN_QQ = 3;//qq登陆
 * public static final int USER_LOGIN_SINA = 4;//sina登陆
 */
__int(thirdPartLogin);
@end
