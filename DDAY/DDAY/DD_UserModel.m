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

+(BOOL)isReadWithBenefitID:(NSString *)benefitID
{
    NSUserDefaults*_default=[NSUserDefaults standardUserDefaults];
    
    NSMutableArray *_localBenefitArr = [_default objectForKey:@"localReadBenefit"];
    
    if(_localBenefitArr)
    {
        for (int i=0; i<_localBenefitArr.count; i++) {
            NSString *obj=[_localBenefitArr objectAtIndex:i];
            DD_BenefitInfoModel *_model = [DD_BenefitInfoModel mj_objectWithKeyValues:obj];
            if([_model.benefitId isEqualToString:benefitID])
            {
                JXLOG(@"localReadBenefit=%@",[_default objectForKey:@"localReadBenefit"]);
                return _model.localRead;
            }
        }
        JXLOG(@"localReadBenefit=%@",[_default objectForKey:@"localReadBenefit"]);
        return NO;
        
    }else
    {
        JXLOG(@"localReadBenefit=%@",[_default objectForKey:@"localReadBenefit"]);
        return NO;
    }
//    NSString *jsonstr_user=[[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
//    return [DD_UserModel mj_objectWithKeyValues:jsonstr_user];
}

+(void)setReadBenefit:(BOOL)read WithBenefitInfoModel:(DD_BenefitInfoModel *)benefitInfoModel
{
    
    NSUserDefaults*_default=[NSUserDefaults standardUserDefaults];
    
    NSMutableArray *_localBenefitArr = [_default objectForKey:@"localReadBenefit"];
    if(_localBenefitArr)
    {
        BOOL _have_model=NO;
        BOOL _model_index=0;
        for (int i=0; i<_localBenefitArr.count; i++) {
            NSString *obj=[_localBenefitArr objectAtIndex:i];
            DD_BenefitInfoModel *_model = [DD_BenefitInfoModel mj_objectWithKeyValues:obj];
            if([_model.benefitId isEqualToString:benefitInfoModel.benefitId])
            {
                
                _have_model=YES;
                _model_index=i;
                break;
            }
        }
        if(_have_model)
        {
            [_localBenefitArr removeObjectAtIndex:_model_index];
        }
        
        benefitInfoModel.localRead=read;
        [_localBenefitArr addObject:[benefitInfoModel mj_JSONString]];
        [_default setObject:_localBenefitArr forKey:@"localReadBenefit"];
        JXLOG(@"localReadBenefit=%@",[_default objectForKey:@"localReadBenefit"]);
    }else
    {
        NSMutableArray *_new_localBenefitArr = [[NSMutableArray alloc] init];
        benefitInfoModel.localRead=read;
        [_new_localBenefitArr addObject:[benefitInfoModel mj_JSONString]];
        [_default setObject:_new_localBenefitArr forKey:@"localReadBenefit"];
        JXLOG(@"localReadBenefit=%@",[_default objectForKey:@"localReadBenefit"]);
    }
    //    NSString *jsonstr_user=[_User mj_JSONString];
    //    [_default setObject:jsonstr_user forKey:@"user"];
}
+(void)setDailyIntegral
{
    NSUserDefaults*_default=[NSUserDefaults standardUserDefaults];
    NSDictionary *dict=[_default objectForKey:@"dailyIntegral"];
    long nowFirstTime=[[[NSDate nowDate] getFirstTime] getTime];
    if(dict)
    {
        if(nowFirstTime==[[dict objectForKey:@"time"] longValue])
        {
            
        }else
        {
            [_default setObject:@{@"isread":[NSNumber numberWithBool:NO],@"time":[NSNumber numberWithLong:nowFirstTime]} forKey:@"dailyIntegral"];
        }
    }else
    {
        [_default setObject:@{@"isread":[NSNumber numberWithBool:NO],@"time":[NSNumber numberWithLong:nowFirstTime]} forKey:@"dailyIntegral"];
    }

    [[DD_CustomViewController sharedManager] startSignInAnimationWithTitle:@"每日登录积分 +1" WithType:@"integral"];
}

+(BOOL)haveDailyIntegral
{
    NSUserDefaults*_default=[NSUserDefaults standardUserDefaults];
    NSDictionary *dict=[_default objectForKey:@"dailyIntegral"];
    long nowFirstTime=[[[NSDate nowDate] getFirstTime] getTime];
    if(dict)
    {
        if(nowFirstTime==[[dict objectForKey:@"time"] longValue])
        {
            return [[dict objectForKey:@"isread"] boolValue];
        }else
        {
            return YES;
        }
    }else
    {
        return YES;
    }
}
+(void)regisnDailyIntegral
{
    NSUserDefaults*_default=[NSUserDefaults standardUserDefaults];
    NSDictionary *dict=[_default objectForKey:@"dailyIntegral"];
    long nowFirstTime=[[[NSDate nowDate] getFirstTime] getTime];
    if(dict)
    {
        if(nowFirstTime==[[dict objectForKey:@"time"] longValue])
        {
            [_default setObject:@{@"isread":[NSNumber numberWithBool:YES],@"time":[dict objectForKey:@"time"]} forKey:@"dailyIntegral"];
        }else
        {
            [_default setObject:nil forKey:@"dailyIntegral"];
        }
    }else
    {
        [_default setObject:nil forKey:@"dailyIntegral"];
    }
}
@end
