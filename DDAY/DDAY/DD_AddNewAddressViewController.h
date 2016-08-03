//
//  DD_AddNewAddressViewController.h
//  YCO SPACE
//
//  Created by yyj on 16/8/3.
//  Copyright © 2016年 YYJ. All rights reserved.
//
#import "DD_AddressModel.h"
#import "DD_BaseViewController.h"

@interface DD_AddNewAddressViewController : DD_BaseViewController
@property (nonatomic,strong)DD_AddressModel *AddressModel;
-(instancetype)initWithModel:(DD_AddressModel *)AddressModel WithBlock:(void(^)(NSString *type,DD_AddressModel *model,NSString *defaultID))saveblock;
@property (nonatomic,copy) void (^saveblock)(NSString *type,DD_AddressModel *model,NSString *defaultID);
@end
