//
//  DD_CircleItemListViewController.h
//  DDAY
//
//  Created by yyj on 16/6/21.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_BaseViewController.h"

@interface DD_CircleItemListViewController : DD_BaseViewController
/**
 * 初始化
 */
-(instancetype)initWithShareID:(NSString *)shareID WithBlock:(void (^)(NSString *type))block;
/**
 * 搭配id
 */
__string(shareID);
/**
 * 回调block
 */
@property(nonatomic,copy) void (^block)(NSString *type);
@end
