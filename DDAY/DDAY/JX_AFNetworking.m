//
//  JX_AFNetworking.m
//  DDAY
//
//  Created by yyj on 16/5/20.
//  Copyright © 2016年 YYJ. All rights reserved.
//
#import "AFNetworking.h"
#import "JX_AFNetworking.h"

@implementation JX_AFNetworking

-(NSString *)getUrl:(NSString *)url
{
    return [[NSString alloc] initWithFormat:@"%@%@",DNS,url];
}
-(void)NETWorkingData:(AFHTTPRequestOperation *)operation WithBlock:(void (^)(BOOL success,NSDictionary *data,UIAlertController *successAlert))successBlock
{
    NSString *html = operation.responseString;
    NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
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
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[self getUrl:url] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self NETWorkingData:operation WithBlock:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
            successBlock(success,data,successAlert);
        }];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failureBlock(error,[regular alert_NONETWORKING]);
    }];
}
-(void)DELETE:(NSString *)url parameters:(NSDictionary *)parameters success:(void (^)(BOOL success,NSDictionary *data,UIAlertController *successAlert))successBlock failure:(void (^)(NSError *error,UIAlertController *failureAlert))failureBlock
{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager DELETE:[self getUrl:url] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self NETWorkingData:operation WithBlock:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
            successBlock(success,data,successAlert);
        }];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failureBlock(error,[regular alert_NONETWORKING]);
    }];
}
-(void)POST:(NSString *)url parameters:(NSDictionary *)parameters success:(void (^)(BOOL success,NSDictionary *data,UIAlertController *successAlert))successBlock failure:(void (^)(NSError *error,UIAlertController *failureAlert))failureBlock
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:[self getUrl:url] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self NETWorkingData:operation WithBlock:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
            successBlock(success,data,successAlert);
        }];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failureBlock(error,[regular alert_NONETWORKING]);
    }];
}
-(void)PUT:(NSString *)url parameters:(NSDictionary *)parameters success:(void (^)(BOOL success,NSDictionary *data,UIAlertController *successAlert))successBlock failure:(void (^)(NSError *error,UIAlertController *failureAlert))failureBlock
{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager PUT:[self getUrl:url] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self NETWorkingData:operation WithBlock:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
            successBlock(success,data,successAlert);
        }];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failureBlock(error,[regular alert_NONETWORKING]);
    }];
}
@end
