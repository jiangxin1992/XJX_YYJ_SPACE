//
//  DD_CirclePushlishPreViewController.h
//  YCO SPACE
//
//  Created by yyj on 16/8/15.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_BaseViewController.h"

@class DD_CircleModel;

@interface DD_CirclePushlishPreViewController : DD_BaseViewController

-(instancetype)initWithCircleModel:(DD_CircleModel *)circleModel WithType:(NSString *)type WithBlock:(void (^)(NSString *type))block;

__block_type(block, type);

__string(type);

@property (nonatomic,strong)DD_CircleModel *circleModel;

@end
