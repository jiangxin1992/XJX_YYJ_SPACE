//
//  DD_ShareTool.m
//  YCO SPACE
//
//  Created by yyj on 16/8/23.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_ShareTool.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/ShareSDK+Extension.h>

@implementation DD_ShareTool

+(NSDictionary *)getShareListMap
{
    return @{
             @"wechat":@"System_Weixin"
             ,@"wechat_friend":@"System_Friendcircle"
             ,@"sina":@"System_Weibo"
             ,@"qq":@"System_QQ"
             ,@"copy":@"System_Copylink"
             };
}
+(NSArray *)getShareListArr
{
    BOOL _isInstallQQ=[self isInstallQQ];
    BOOL _isInstallWeChat=[self isInstallWeChat];
    NSLog(@"%d %d",_isInstallQQ,_isInstallWeChat);
    if(_isInstallQQ&&_isInstallWeChat)
    {
        return @[@"wechat",@"wechat_friend",@"sina",@"qq",@"copy"];
    }else
    {
        if(_isInstallQQ)
        {
            return @[@"sina",@"qq",@"copy"];
        }else if(_isInstallWeChat)
        {
            return @[@"wechat",@"wechat_friend",@"sina",@"copy"];
        }else
        {
            return @[@"sina",@"copy"];
        }
    }
}


+(BOOL)isInstallQQ
{
    return [ShareSDK isClientInstalled:SSDKPlatformSubTypeQQFriend];
}

+(BOOL)isInstallWeChat
{
    return [ShareSDK isClientInstalled:SSDKPlatformSubTypeWechatSession];
}
+(CGFloat)getHeight
{
    NSArray *arr=[self getShareListArr];
    if(arr.count>4)
    {
        return 250;
    }else
    {
        return 180;
    }
}
@end
