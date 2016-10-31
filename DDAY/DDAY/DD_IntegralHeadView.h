//
//  DD_IntegralHeadView.h
//  YCO SPACE
//
//  Created by yyj on 2016/10/31.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DD_IntegralHeadView : UIView

-(instancetype)initWithIntegralCount:(NSInteger )integralCount WithDeductionCount:(NSInteger )deductionCount WithBlock:(void(^)(NSString *type))block;

__int(integralCount);

__int(deductionCount);

@property (nonatomic,copy)void (^block)(NSString *type);

-(void)update;

@end
