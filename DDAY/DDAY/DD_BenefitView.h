//
//  DD_BenefitView.h
//  YCO SPACE
//
//  Created by yyj on 2016/11/22.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DD_BenefitInfoModel;

@interface DD_BenefitView : UIView

/**
 * 创建单例
 */
+(id)sharedManagerWithModel:(DD_BenefitInfoModel *)benefitModel WithBlock:(void (^)(NSString *type))block;

/** block回调*/
__block_type(block, type);

/** 优惠券信息*/
@property(nonatomic,strong)DD_BenefitInfoModel *benefitModel;

@end
