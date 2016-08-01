//
//  DD_ClearingViewController.h
//  DDAY
//
//  Created by yyj on 16/5/18.
//  Copyright © 2016年 mike_xie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DD_ClearingModel.h"
@interface DD_ClearingViewController : UIViewController
/**
 * 结算页面初始化
 * _model:结算界面数据
 */
-(instancetype)initWithModel:(DD_ClearingModel *)_model WithBlock:(void (^)(NSString *type))block;
/**
 * 结算界面数据
 */
@property (nonatomic,strong)DD_ClearingModel *Clearingmodel;
/**
 * 结算回调
 */
@property (nonatomic,copy)void(^successblock)(NSString *type);
@end

