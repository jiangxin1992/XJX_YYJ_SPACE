//
//  DD_BenefitHeadView.h
//  YCO SPACE
//
//  Created by yyj on 2016/11/4.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_BaseView.h"

@interface DD_BenefitHeadView : DD_BaseView

-(instancetype)initWithBlock:(void (^)(NSString *type))block;

__block_type(block, type);

@end
