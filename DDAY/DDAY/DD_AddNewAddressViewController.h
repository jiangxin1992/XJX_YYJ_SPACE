//
//  DD_AddNewAddressViewController.h
//  DDAY
//
//  Created by yyj on 16/5/17.
//  Copyright © 2016年 mike_xie. All rights reserved.
//
#import "DD_AddressModel.h"
#import <UIKit/UIKit.h>

@interface DD_AddNewAddressViewController : UIViewController
@property (nonatomic,strong)DD_AddressModel *AddressModel;
-(instancetype)initWithModel:(DD_AddressModel *)AddressModel WithBlock:(void(^)(NSString *type,DD_AddressModel *model,NSString *defaultID))saveblock;
@property (nonatomic,copy) void (^saveblock)(NSString *type,DD_AddressModel *model,NSString *defaultID);
@end
