//
//  JX_AFNetworking.h
//  DDAY
//
//  Created by yyj on 16/5/20.
//  Copyright © 2016年 YYJ. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface JX_AFNetworking : NSObject
/**
 * GET
 */
-(void)GET:(NSString *)url parameters:(NSDictionary *)parameters success:(void (^)(BOOL success,NSDictionary *data,UIAlertController *successAlert))successBlock failure:(void (^)(NSError *error,UIAlertController *failureAlert))failureBlock;
/**
 * DELETE
 */
-(void)DELETE:(NSString *)url parameters:(NSDictionary *)parameters success:(void (^)(BOOL success,NSDictionary *data,UIAlertController *successAlert))successBlock failure:(void (^)(NSError *error,UIAlertController *failureAlert))failureBlock;
/**
 * POST
 */
-(void)POST:(NSString *)url parameters:(NSDictionary *)parameters success:(void (^)(BOOL success,NSDictionary *data,UIAlertController *successAlert))successBlock failure:(void (^)(NSError *error,UIAlertController *failureAlert))failureBlock;
/**
 * PUT
 */
-(void)PUT:(NSString *)url parameters:(NSDictionary *)parameters success:(void (^)(BOOL success,NSDictionary *data,UIAlertController *successAlert))successBlock failure:(void (^)(NSError *error,UIAlertController *failureAlert))failureBlock;

@end
