//
//  DD_CirclePushlishPreViewController.h
//  YCO SPACE
//
//  Created by yyj on 16/8/15.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_BaseViewController.h"

#import "DD_CircleModel.h"

@interface DD_CirclePushlishPreViewController : DD_BaseViewController
-(instancetype)initWithCircleModel:(DD_CircleModel *)circleModel;
__block_type(block, type);
@property (nonatomic,strong)DD_CircleModel *circleModel;
@end
