//
//  JX_AFNetworking.m
//  DDAY
//
//  Created by yyj on 16/5/20.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "JX_AFNetworking.h"

#import "AFNetworking.h"

@implementation JX_AFNetworking

-(NSString *)getUrl:(NSString *)url
{
    return [[NSString alloc] initWithFormat:@"%@%@",DNS,url];
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
    
    [manager GET:[self getUrl:url] parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
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
