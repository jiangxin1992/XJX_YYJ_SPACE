//
//  DD_AddressViewController.h
//  DDAY
//
//  Created by yyj on 16/5/17.
//  Copyright © 2016年 mike_xie. All rights reserved.
//
#import "DD_AddressModel.h"
#import <UIKit/UIKit.h>

@interface DD_AddressViewController : UIViewController
-(instancetype)initWithType:(NSString *)type WithBlock:(void(^)(NSString *type,DD_AddressModel *addressModel))touchBlock;
__string(type);
@property (nonatomic,copy)void (^touchBlock)(NSString *type,DD_AddressModel *addressModel);
@end
