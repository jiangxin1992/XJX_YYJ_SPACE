//
//  DD_ChooseBenefitListViewController.h
//  YCO SPACE
//
//  Created by yyj on 2016/11/7.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_BaseViewController.h"

#import "DD_ClearingModel.h"

@interface DD_ChooseBenefitListViewController : DD_BaseViewController

/**
 * 初始化方法
 */
-(instancetype)initWithClearingModel:(DD_ClearingModel *)clearingModel WithBlock:(void (^)(NSString *type))block;

__block_type(block, type);

@property (nonatomic,strong)DD_ClearingModel *clearingModel;

@end
