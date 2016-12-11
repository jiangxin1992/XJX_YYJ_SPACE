//
//  DD_UserModel.m
//  DDAY
//
//  Created by yyj on 16/5/20.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_UserModel.h"

#import "DD_CustomViewController.h"

#import "DD_BenefitInfoModel.h"
#import "DD_VersionModel.h"

@implementation DD_UserModel

#pragma mark *********************************用户信息*********************************
+(DD_UserModel *)getUserModel:(NSDictionary *)dict
{
    DD_UserModel *_User=[DD_UserModel mj_objectWithKeyValues:dict];
    _User.u_id=[dict objectForKey:@"id"];
    return _User;
}
+(void)logout
{
    NSUserDefaults*_default=[NSUserDefaults standardUserDefaults];
    [_default setObject:nil forKey:@"user"];
    [_default setObject:nil forKey:@"thirdPartLogin"];
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
+(BOOL )isLogin
{
    NSUserDefaults *_UserDefaults=[NSUserDefaults standardUserDefaults];
    if([_UserDefaults objectForKey:@"user"])
    {
        return YES;
    }
    return NO;
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
+(void)UpdateUserType:(NSInteger )userType
{
    NSUserDefaults*_default=[NSUserDefaults standardUserDefaults];
    DD_UserModel *_User=[self getLocalUserInfo];
    _User.userType=[[NSString alloc] initWithFormat:@"%ld",userType];
    NSString *jsonstr_user=[_User mj_JSONString];
    [_default setObject:jsonstr_user forKey:@"user"];
}
#pragma mark *********************************一些存取*********************************
/**
 * 用户信息本地存取
 */
+(void)setLocalUserInfo:(NSDictionary *)data
{
    NSUserDefaults*_default=[NSUserDefaults standardUserDefaults];
    DD_UserModel *_User=[DD_UserModel getUserModel:[data objectForKey:@"user"]];
    NSString *jsonstr_user=[_User mj_JSONString];
    [_default setObject:jsonstr_user forKey:@"user"];
    [_default setObject:[data objectForKey:@"thirdPartLogin"] forKey:@"thirdPartLogin"];
}
+(DD_UserModel *)getLocalUserInfo
{
    NSString *jsonstr_user=[[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    return [DD_UserModel mj_objectWithKeyValues:jsonstr_user];
}

/**
 * DeviceToken存取
 */
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

/**
 * 订单号存取
 */
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
/**
 * 每日登录积分状态存取
 */
+(void)SigninAction
{
    
    if([DD_UserModel isLogin])
    {
        [[JX_AFNetworking alloc] GET:@"user/signUpWithRewardsPoints.do" parameters:@{@"token":[DD_UserModel getToken]} success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
            if(success)
            {
                [DD_UserModel setDailyIntegral];
            }else
            {
                [DD_UserModel regisnDailyIntegral];
            }
        } failure:^(NSError *error, UIAlertController *failureAlert) {
            
        }];
    }
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
/**
 * 首单立减红包未登录状态下的存取
 */
+(BOOL)isReadWithBenefitID:(NSString *)benefitID
{
    
    
    NSUserDefaults*_default=[NSUserDefaults standardUserDefaults];
    
    NSMutableArray *_localBenefitArr = [_default objectForKey:@"localReadBenefit"];
    
    if(_localBenefitArr)
    {
        __block BOOL isRead=NO;
        [_localBenefitArr enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            DD_BenefitInfoModel *_model = [DD_BenefitInfoModel mj_objectWithKeyValues:obj];
            if([_model.benefitId isEqualToString:benefitID])
            {
                JXLOG(@"localReadBenefit=%@",[_default objectForKey:@"localReadBenefit"]);
                isRead=_model.localRead;
                *stop=YES;
            }
        }];
//        for (int i=0; i<_localBenefitArr.count; i++) {
//            NSString *obj=_localBenefitArr[i];
//            DD_BenefitInfoModel *_model = [DD_BenefitInfoModel mj_objectWithKeyValues:obj];
//            if([_model.benefitId isEqualToString:benefitID])
//            {
//                JXLOG(@"localReadBenefit=%@",[_default objectForKey:@"localReadBenefit"]);
//                return _model.localRead;
//            }
//        }
        JXLOG(@"localReadBenefit=%@",[_default objectForKey:@"localReadBenefit"]);
        return isRead;
        
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
        __block BOOL _have_model=NO;
        __block BOOL _model_index=0;
        [_localBenefitArr enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            DD_BenefitInfoModel *_model = [DD_BenefitInfoModel mj_objectWithKeyValues:obj];
            if([_model.benefitId isEqualToString:benefitInfoModel.benefitId])
            {
                _have_model=YES;
                _model_index=idx;
                *stop=YES;
            }
        }];
//        for (int i=0; i<_localBenefitArr.count; i++) {
//            NSString *obj=_localBenefitArr[i];
//            DD_BenefitInfoModel *_model = [DD_BenefitInfoModel mj_objectWithKeyValues:obj];
//            if([_model.benefitId isEqualToString:benefitInfoModel.benefitId])
//            {
//                
//                _have_model=YES;
//                _model_index=i;
//                break;
//            }
//        }
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
/**
 * 版本更新状态的存取
 * 获取到的版本与本地的版本做比较
 * 关闭弹窗，当前版本不在提示，直到下个版本上新的时候再做提示
 */
+(NSString *)GetVersion
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}
+(NSString *)GetBundleVersion
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
}
+(void)CheckVersion
{
    [[JX_AFNetworking alloc] GET:@"user/getAppVersionInfo.do" parameters:@{@"token":[DD_UserModel getToken]} success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
        if(success)
        {
            DD_VersionModel *_version=[DD_VersionModel getVersionModel:[data objectForKey:@"appVersionInfo"]];
            [DD_UserModel setCheckVersionWithVersionModel:_version];
        }else
        {
            
        }
    } failure:^(NSError *error, UIAlertController *failureAlert) {
        
    }];
}
+(void)setCheckVersionWithVersionModel:(DD_VersionModel *)versionModel
{
    NSUserDefaults*_default=[NSUserDefaults standardUserDefaults];
    NSDictionary *_versionKVLoc=[_default objectForKey:@"versionKV"];
    NSString *nowVersion=[DD_UserModel GetBundleVersion];
// versionKV appVersion isRead
    if([nowVersion longValue]<[versionModel.appBundleVersion longValue])
    {
        //当前版本小于App Store版本时候
        //本地是否有数据
        if(_versionKVLoc)
        {
            //本地有数据时
            if([[_versionKVLoc objectForKey:@"appBundleVersion"] longValue]<[versionModel.appBundleVersion longValue])
            {
                //显示版本更新视图
                [_default setObject:@{@"appVersion":versionModel.appVersion,@"isRead":[NSNumber numberWithBool:YES],@"appBundleVersion":versionModel.appBundleVersion} forKey:@"versionKV"];
                [[DD_CustomViewController sharedManager] showVersionViewWithVersonModel:versionModel];
            }else
            {
                if([[_versionKVLoc objectForKey:@"appBundleVersion"] longValue]==[versionModel.appBundleVersion longValue])
                {
                    if(![[_versionKVLoc objectForKey:@"isRead"] boolValue])
                    {
                        //显示版本更新视图
                        [_default setObject:@{@"appVersion":versionModel.appVersion,@"isRead":[NSNumber numberWithBool:YES],@"appBundleVersion":versionModel.appBundleVersion} forKey:@"versionKV"];
                        [[DD_CustomViewController sharedManager] showVersionViewWithVersonModel:versionModel];
                    }
                }
            }
        }else
        {
            //本地无数据时
            [_default setObject:@{@"appVersion":versionModel.appVersion,@"isRead":[NSNumber numberWithBool:YES],@"appBundleVersion":versionModel.appBundleVersion} forKey:@"versionKV"];
            //显示版本更新视图
            [[DD_CustomViewController sharedManager] showVersionViewWithVersonModel:versionModel];
        }
    }else
    {
//        当前版本大于等于App Store版本时候(不需要更新时候)
        JXLOG(@"111");
    }
}

@end
