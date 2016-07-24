//
//  DD_SetAddressBtn.h
//  DDAY
//
//  Created by yyj on 16/5/24.
//  Copyright © 2016年 YYJ. All rights reserved.
//
#import "DD_AddressModel.h"
#import <UIKit/UIKit.h>

@interface DD_SetAddressBtn : UIButton
/**
 * 初始化方法
 * AddressModel为当前的地址
 */
+(instancetype)buttonWithType:(UIButtonType)buttonType WithFrame:(CGRect )frame WithAddressModel:(DD_AddressModel *)AddressModel WithBlock:(void(^)(NSString *type))block ;
/**
 * 当前地址model
 */
@property (nonatomic,strong) DD_AddressModel *AddressModel;
/**
 * 回调方法
 */
@property (nonatomic,copy) void(^touchBlock)(NSString *type);
/**
 * 设置btn状态/更新btn状态
 * model空和非空时候的处理
 */
-(void)SetState;
@end
