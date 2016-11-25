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

-(NSString *)getUrl:(NSString *)url
{
//    JXLOG(@"%@",[[NSString alloc] initWithFormat:@"%@%@",[regular getDNS],url]);
    return [[NSString alloc] initWithFormat:@"%@%@",[regular getDNS],url];
}
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
-(void)GET:(NSString *)url parameters:(NSDictionary *)parameters success:(void (^)(BOOL success,NSDictionary *data,UIAlertController *successAlert))successBlock failure:(void (^)(NSError *error,UIAlertController *failureAlert))failureBlock
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
//    如果你还想进一步保障的话 在你封装的地方加上这个代码    //新增IPv6
    manager.responseSerializer.acceptableContentTypes = nil;//[NSSet setWithObject:@"text/ plain"];
    
    manager.securityPolicy = [AFSecurityPolicy defaultPolicy];
    
    manager.securityPolicy.allowInvalidCertificates = YES;//忽略https证书
    
    manager.securityPolicy.validatesDomainName = NO;//是否验证域名
    NSString *urlstr=[self getUrl:url];
    [manager GET:urlstr parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self NETWorkingData:responseObject WithBlock:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
            successBlock(success,data,successAlert);
        }];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failureBlock(error,[regular alert_NONETWORKING]);
    }];

//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    [manager GET:[self getUrl:url] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        [self NETWorkingData:operation WithBlock:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
//            successBlock(success,data,successAlert);
//        }];
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        failureBlock(error,[regular alert_NONETWORKING]);
//    }];
}
-(void)DELETE:(NSString *)url parameters:(NSDictionary *)parameters success:(void (^)(BOOL success,NSDictionary *data,UIAlertController *successAlert))successBlock failure:(void (^)(NSError *error,UIAlertController *failureAlert))failureBlock
{

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //    如果你还想进一步保障的话 在你封装的地方加上这个代码    //新增IPv6
    manager.responseSerializer.acceptableContentTypes = nil;//[NSSet setWithObject:@"text/ plain"];
    
    manager.securityPolicy = [AFSecurityPolicy defaultPolicy];
    
    manager.securityPolicy.allowInvalidCertificates = YES;//忽略https证书
    
    manager.securityPolicy.validatesDomainName = NO;//是否验证域名
    
    [manager DELETE:[self getUrl:url] parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self NETWorkingData:responseObject WithBlock:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
            successBlock(success,data,successAlert);
        }];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failureBlock(error,[regular alert_NONETWORKING]);
    }];
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    [manager DELETE:[self getUrl:url] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        [self NETWorkingData:operation WithBlock:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
//            successBlock(success,data,successAlert);
//        }];
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        failureBlock(error,[regular alert_NONETWORKING]);
//    }];
}
-(void)POST:(NSString *)url parameters:(NSDictionary *)parameters success:(void (^)(BOOL success,NSDictionary *data,UIAlertController *successAlert))successBlock failure:(void (^)(NSError *error,UIAlertController *failureAlert))failureBlock
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //    如果你还想进一步保障的话 在你封装的地方加上这个代码    //新增IPv6
    manager.responseSerializer.acceptableContentTypes = nil;//[NSSet setWithObject:@"text/ plain"];
    
    manager.securityPolicy = [AFSecurityPolicy defaultPolicy];
    
    manager.securityPolicy.allowInvalidCertificates = YES;//忽略https证书
    
    manager.securityPolicy.validatesDomainName = NO;//是否验证域名
    
    [manager POST:[self getUrl:url] parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self NETWorkingData:responseObject WithBlock:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
            successBlock(success,data,successAlert);
        }];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failureBlock(error,[regular alert_NONETWORKING]);
    }];
//
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    [manager POST:[self getUrl:url] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        [self NETWorkingData:operation WithBlock:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
//            successBlock(success,data,successAlert);
//        }];
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        failureBlock(error,[regular alert_NONETWORKING]);
//    }];
}
-(void)PUT:(NSString *)url parameters:(NSDictionary *)parameters success:(void (^)(BOOL success,NSDictionary *data,UIAlertController *successAlert))successBlock failure:(void (^)(NSError *error,UIAlertController *failureAlert))failureBlock
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //    如果你还想进一步保障的话 在你封装的地方加上这个代码    //新增IPv6
    manager.responseSerializer.acceptableContentTypes = nil;//[NSSet setWithObject:@"text/ plain"];
    
    manager.securityPolicy = [AFSecurityPolicy defaultPolicy];
    
    manager.securityPolicy.allowInvalidCertificates = YES;//忽略https证书
    
    manager.securityPolicy.validatesDomainName = NO;//是否验证域名
    
    [manager PUT:[self getUrl:url] parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self NETWorkingData:responseObject WithBlock:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
            successBlock(success,data,successAlert);
        }];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failureBlock(error,[regular alert_NONETWORKING]);
    }];

//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    [manager PUT:[self getUrl:url] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        [self NETWorkingData:operation WithBlock:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
//            successBlock(success,data,successAlert);
//        }];
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        failureBlock(error,[regular alert_NONETWORKING]);
//    }];
}
@end
