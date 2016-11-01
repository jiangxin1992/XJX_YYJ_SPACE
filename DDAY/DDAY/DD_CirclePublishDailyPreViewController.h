//
//  DD_CirclePublishDailyPreViewController.h
//  YCO SPACE
//
//  Created by yyj on 16/9/13.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_BaseViewController.h"

#import "DD_CircleModel.h"

@interface DD_CirclePublishDailyPreViewController : DD_BaseViewController

-(instancetype)initWithCircleModel:(DD_CircleModel *)circleModel WithType:(NSString *)type WithBlock:(void (^)(NSString *type))block;

__block_type(block, type);

__string(type);

@property (nonatomic,strong)DD_CircleModel *circleModel;

@end
