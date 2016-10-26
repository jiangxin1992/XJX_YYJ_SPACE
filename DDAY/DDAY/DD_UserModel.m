//
//  DD_UserModel.m
//  DDAY
//
//  Created by yyj on 16/5/20.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_UserModel.h"

@implementation DD_UserModel
+(void)setLocalUserInfo:(NSDictionary *)data
{
    NSUserDefaults*_default=[NSUserDefaults standardUserDefaults];
    DD_UserModel *_User=[DD_UserModel getUserModel:[data objectForKey:@"user"]];
    NSString *jsonstr_user=[_User mj_JSONString];
    [_default setObject:jsonstr_user forKey:@"user"];
    [_default setObject:[data objectForKey:@"thirdPartLogin"] forKey:@"thirdPartLogin"];
}
+(void)UpdateUserType:(NSInteger )userType
{
    NSUserDefaults*_default=[NSUserDefaults standardUserDefaults];
    DD_UserModel *_User=[self getLocalUserInfo];
    _User.userType=[[NSString alloc] initWithFormat:@"%ld",userType];
    NSString *jsonstr_user=[_User mj_JSONString];
    [_default setObject:jsonstr_user forKey:@"user"];
}
+(void)setTradeOrderCode:(NSString *)tradeOrderCode
{
    NSUserDefaults*_default=[NSUserDefaults standardUserDefaults];
    [_default setObject:tradeOrderCode forKey:@"tradeOrderCode"];
}
+(void)removeTradeOrderCode
{
    NSUserDefaults*_default=[NSUserDefaults standardUserDefaults];
    [_default setObject:nil forKey:@"tradeOrderCode"];
}
+(NSString *)getTradeOrderCode
{
     NSUserDefaults*_default=[NSUserDefaults standardUserDefaults];
    return [_default objectForKey:@"tradeOrderCode"];
}
+(void)logout
{
    NSUserDefaults*_default=[NSUserDefaults standardUserDefaults];
    [_default setObject:nil forKey:@"user"];
    [_default setObject:nil forKey:@"thirdPartLogin"];
}
+(DD_UserModel *)getLocalUserInfo
{
   NSString *jsonstr_user=[[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    return [DD_UserModel mj_objectWithKeyValues:jsonstr_user];
}
+(DD_UserModel *)getUserModel:(NSDictionary *)dict
{
    DD_UserModel *_User=[DD_UserModel mj_objectWithKeyValues:dict];
    _User.u_id=[dict objectForKey:@"id"];
    return _User;
}
+(NSInteger )getUserType
{
    DD_UserModel *_usermodel=[self getLocalUserInfo];
    return [_usermodel.userType integerValue];
}
+(NSInteger )getThirdPartLogin
{
    NSUserDefaults *_UserDefaults=[NSUserDefaults standardUserDefaults];
    if([_UserDefaults objectForKey:@"thirdPartLogin"])
    {
        return [[_UserDefaults objectForKey:@"thirdPartLogin"] integerValue];
    }
    return 0;
}
+(NSString *)getToken
{
    if([self isLogin])
    {
        DD_UserModel *_usermodel=[self getLocalUserInfo];
        return _usermodel.token;
    }
    return @"";
}
+(BOOL )isLogin
{
    NSUserDefaults *_UserDefaults=[NSUserDefaults standardUserDefaults];
    if([_UserDefaults objectForKey:@"user"])
    {
        return YES;
    }
    return NO;
}
-(NSString *)getSexStr
{
    if([NSString isNilOrEmpty:self.sex])
    {
        return @"";
    }else
    {
        if([self.sex integerValue]==0)
        {
            return @"男";
        }else if([self.sex integerValue]==1)
        {
            return @"女";
        }else
        {
            return @"";
        }
    }
}
+(void)setDeviceToken:(NSString *)token
{
    NSUserDefaults*_default=[NSUserDefaults standardUserDefaults];
    [_default setObject:token forKey:@"deviceToken"];
}
+(NSString *)getDeviceToken
{
    NSUserDefaults*_default=[NSUserDefaults standardUserDefaults];
    if([_default objectForKey:@"deviceToken"])
    {
        return [_default objectForKey:@"deviceToken"];
    }
    return @"";
}
@end
