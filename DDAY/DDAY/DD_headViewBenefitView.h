//
//  DD_headViewBenefitView.h
//  YCO SPACE
//
//  Created by yyj on 2016/10/27.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_BaseView.h"

@class DD_BenefitInfoModel;

@interface DD_headViewBenefitView : DD_BaseView

-(instancetype)initWithModel:(DD_BenefitInfoModel *)benefitInfoModel WithBlock:(void (^)(NSString *type))block;

@property (nonatomic,copy) void (^block)(NSString *type);

@property (nonatomic,strong) DD_BenefitInfoModel *benefitInfoModel;

@end
