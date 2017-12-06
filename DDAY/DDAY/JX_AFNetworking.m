//
//  JX_AFNetworking.m
//  DDAY
//
//  Created by yyj on 16/5/20.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "JX_AFNetworking.h"

#import "AFNetworking.h"

#include<netdb.h>

@implementation JX_AFNetworking
#pragma mark - 网络请求
-(void)GET:(NSString *)url parameters:(NSDictionary *)parameters success:(void (^)(BOOL success,NSDictionary *data,UIAlertController *successAlert))successBlock failure:(void (^)(NSError *error,UIAlertController *failureAlert))failureBlock
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
//    如果你还想进一步保障的话 在你封装的地方加上这个代码    //新增IPv6
    manager.responseSerializer.acceptableContentTypes = nil;//[NSSet setWithObject:@"text/ plain"];
    
    manager.securityPolicy = [AFSecurityPolicy defaultPolicy];
    
    manager.securityPolicy.allowInvalidCertificates = YES;//忽略https证书
    
    manager.securityPolicy.validatesDomainName = NO;//是否验证域名

    NSString *urlstr=[self getUrl:url];

    [manager GET:urlstr parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;

        NSDictionary *responseHeaders = response.allHeaderFields;

        JXLOG(@"----------Http请求----------\n");

        JXLOG(@"----------Http请求Headers：%@\n", responseHeaders);

        JXLOG(@"----------Http请求Body：%@\n", parameters);

        JXLOG(@"----------Http请求Url：%@\n", urlstr);

        JXLOG(@"----------Http响应----------\n");

        JXLOG(@"----------Http响应Body：%@\n", (NSDictionary *)responseObject);

        [self NETWorkingData:responseObject WithBlock:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
            successBlock(success,data,successAlert);
        }];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;

        NSDictionary *responseHeaders = response.allHeaderFields;

        JXLOG(@"----------Http请求----------\n");

        JXLOG(@"----------Http请求Headers：%@\n", responseHeaders);

        JXLOG(@"----------Http请求Body：%@\n", parameters);

        JXLOG(@"----------Http请求Url：%@\n", urlstr);

        JXLOG(@"----------Http响应----------\n");

        JXLOG(@"----------Http响应error：%@\n",error);

        failureBlock(error,[regular alert_NONETWORKING]);
    }];
}
-(void)DELETE:(NSString *)url parameters:(NSDictionary *)parameters success:(void (^)(BOOL success,NSDictionary *data,UIAlertController *successAlert))successBlock failure:(void (^)(NSError *error,UIAlertController *failureAlert))failureBlock
{

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //    如果你还想进一步保障的话 在你封装的地方加上这个代码    //新增IPv6
    manager.responseSerializer.acceptableContentTypes = nil;//[NSSet setWithObject:@"text/ plain"];
    
    manager.securityPolicy = [AFSecurityPolicy defaultPolicy];
    
    manager.securityPolicy.allowInvalidCertificates = YES;//忽略https证书
    
    manager.securityPolicy.validatesDomainName = NO;//是否验证域名

    NSString *urlstr=[self getUrl:url];
    
    [manager DELETE:urlstr parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;

        NSDictionary *responseHeaders = response.allHeaderFields;

        JXLOG(@"----------Http请求----------\n");

        JXLOG(@"----------Http请求Headers：%@\n", responseHeaders);

        JXLOG(@"----------Http请求Body：%@\n", parameters);

        JXLOG(@"----------Http请求Url：%@\n", urlstr);

        JXLOG(@"----------Http响应----------\n");

        JXLOG(@"----------Http响应Body：%@\n", (NSDictionary *)responseObject);

        [self NETWorkingData:responseObject WithBlock:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
            successBlock(success,data,successAlert);
        }];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;

        NSDictionary *responseHeaders = response.allHeaderFields;

        JXLOG(@"----------Http请求----------\n");

        JXLOG(@"----------Http请求Headers：%@\n", responseHeaders);

        JXLOG(@"----------Http请求Body：%@\n", parameters);

        JXLOG(@"----------Http请求Url：%@\n", urlstr);

        JXLOG(@"----------Http响应----------\n");

        JXLOG(@"----------Http响应error：%@\n",error);

        failureBlock(error,[regular alert_NONETWORKING]);
    }];
}
-(void)POST:(NSString *)url parameters:(NSDictionary *)parameters success:(void (^)(BOOL success,NSDictionary *data,UIAlertController *successAlert))successBlock failure:(void (^)(NSError *error,UIAlertController *failureAlert))failureBlock
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //    如果你还想进一步保障的话 在你封装的地方加上这个代码    //新增IPv6
    manager.responseSerializer.acceptableContentTypes = nil;//[NSSet setWithObject:@"text/ plain"];
    
    manager.securityPolicy = [AFSecurityPolicy defaultPolicy];
    
    manager.securityPolicy.allowInvalidCertificates = YES;//忽略https证书
    
    manager.securityPolicy.validatesDomainName = NO;//是否验证域名

    NSString *urlstr=[self getUrl:url];

    [manager POST:urlstr parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;

        NSDictionary *responseHeaders = response.allHeaderFields;

        JXLOG(@"----------Http请求----------\n");

        JXLOG(@"----------Http请求Headers：%@\n", responseHeaders);

        JXLOG(@"----------Http请求Body：%@\n", parameters);

        JXLOG(@"----------Http请求Url：%@\n", urlstr);

        JXLOG(@"----------Http响应----------\n");

        JXLOG(@"----------Http响应Body：%@\n", (NSDictionary *)responseObject);

        [self NETWorkingData:responseObject WithBlock:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
            successBlock(success,data,successAlert);
        }];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;

        NSDictionary *responseHeaders = response.allHeaderFields;

        JXLOG(@"----------Http请求----------\n");

        JXLOG(@"----------Http请求Headers：%@\n", responseHeaders);

        JXLOG(@"----------Http请求Body：%@\n", parameters);

        JXLOG(@"----------Http请求Url：%@\n", urlstr);

        JXLOG(@"----------Http响应----------\n");

        JXLOG(@"----------Http响应error：%@\n",error);

        failureBlock(error,[regular alert_NONETWORKING]);
    }];
}
-(void)PUT:(NSString *)url parameters:(NSDictionary *)parameters success:(void (^)(BOOL success,NSDictionary *data,UIAlertController *successAlert))successBlock failure:(void (^)(NSError *error,UIAlertController *failureAlert))failureBlock
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //    如果你还想进一步保障的话 在你封装的地方加上这个代码    //新增IPv6
    manager.responseSerializer.acceptableContentTypes = nil;//[NSSet setWithObject:@"text/ plain"];
    
    manager.securityPolicy = [AFSecurityPolicy defaultPolicy];
    
    manager.securityPolicy.allowInvalidCertificates = YES;//忽略https证书
    
    manager.securityPolicy.validatesDomainName = NO;//是否验证域名

    NSString *urlstr=[self getUrl:url];

    [manager PUT:urlstr parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;

        NSDictionary *responseHeaders = response.allHeaderFields;

        JXLOG(@"----------Http请求----------\n");

        JXLOG(@"----------Http请求Headers：%@\n", responseHeaders);

        JXLOG(@"----------Http请求Body：%@\n", parameters);

        JXLOG(@"----------Http请求Url：%@\n", urlstr);

        JXLOG(@"----------Http响应----------\n");

        JXLOG(@"----------Http响应Body：%@\n", (NSDictionary *)responseObject);

        [self NETWorkingData:responseObject WithBlock:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
            successBlock(success,data,successAlert);
        }];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;

        NSDictionary *responseHeaders = response.allHeaderFields;

        JXLOG(@"----------Http请求----------\n");

        JXLOG(@"----------Http请求Headers：%@\n", responseHeaders);

        JXLOG(@"----------Http请求Body：%@\n", parameters);

        JXLOG(@"----------Http请求Url：%@\n", urlstr);

        JXLOG(@"----------Http响应----------\n");

        JXLOG(@"----------Http响应error：%@\n",error);

        failureBlock(error,[regular alert_NONETWORKING]);
    }];
}
#pragma mark - SomeAction
-(void)NETWorkingData:(id )responseObject WithBlock:(void (^)(BOOL success,NSDictionary *data,UIAlertController *successAlert))successBlock
{
    NSDictionary *dict=responseObject;
    NSDictionary *_data=[dict objectForKey:@"data"];
    if([[dict objectForKey:@"status"] integerValue]==100)
    {
        successBlock(YES,_data,nil);
    }else
    {
        successBlock(NO,_data,[regular alertTitle_Simple:[dict objectForKey:@"message"]]);
    }
}
-(NSString *)getUrl:(NSString *)url
{
    return [[NSString alloc] initWithFormat:@"%@%@",[regular getDNS],url];
}
@end
