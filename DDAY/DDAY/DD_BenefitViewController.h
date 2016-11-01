//
//  DD_BenefitViewController.h
//  YCO SPACE
//
//  Created by yyj on 2016/10/28.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_BaseViewController.h"

#import "DD_BenefitInfoModel.h"

@interface DD_BenefitViewController : DD_BaseViewController

/**
 * 初始化 根据shareId
 */
-(instancetype)initWithBenefitInfoModel:(DD_BenefitInfoModel *)benefitInfoModel WithBlock:(void (^)(NSString *type))block;

/** 搭配list model*/
@property (nonatomic,strong)DD_BenefitInfoModel *benefitInfoModel;

/** 回调block*/
__block_type(block, type);

@end
