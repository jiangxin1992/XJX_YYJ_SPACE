//
//  DD_headViewBenefitView.h
//  YCO SPACE
//
//  Created by yyj on 2016/10/27.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DD_BenefitInfoModel.h"

@interface DD_headViewBenefitView : UIView

-(instancetype)initWithModel:(DD_BenefitInfoModel *)benefitInfoModel WithBlock:(void (^)(NSString *type))block;
@property (nonatomic,copy) void (^block)(NSString *type);

@end
