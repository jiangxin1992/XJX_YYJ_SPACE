//
//  DD_OrderAddressView.h
//  DDAY
//
//  Created by yyj on 16/6/8.
//  Copyright © 2016年 YYJ. All rights reserved.
//
//#import "DD_AddressModel.h"
#import "DD_OrderDetailModel.h"
#import <UIKit/UIKit.h>

@interface DD_OrderAddressView : UIView
/**
 * 初始化方法
 */
-(instancetype)initWithFrame:(CGRect)frame WithOrderDetailInfoModel:(DD_OrderDetailModel *)_OrderDetailModel WithBlock:(void (^)(NSString *type))block;
/**
 * 更新
 */
-(void)SetState;
/**
 * 回调
 */
__block_type(addressBlock, type);
/**
 * model
 */
@property (nonatomic,strong)DD_OrderDetailModel *DetailModel;
@end
