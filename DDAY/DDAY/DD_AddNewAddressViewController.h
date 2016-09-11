//
//  DD_AddNewAddressViewController.h
//  YCO SPACE
//
//  Created by yyj on 16/8/3.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_BaseViewController.h"

#import "DD_AddressModel.h"

@interface DD_AddNewAddressViewController : DD_BaseViewController<UITextFieldDelegate>
@property (nonatomic,strong)DD_AddressModel *AddressModel;
-(instancetype)initWithModel:(DD_AddressModel *)AddressModel isDefault:(BOOL )isDefault WithBlock:(void(^)(NSString *type,DD_AddressModel *model,NSString *defaultID))saveblock;
@property (nonatomic,copy) void (^saveblock)(NSString *type,DD_AddressModel *model,NSString *defaultID);
__bool(is_default);
@end
