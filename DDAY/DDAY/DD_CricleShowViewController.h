//
//  DD_CricleShowViewController.h
//  DDAY
//
//  Created by yyj on 16/6/16.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_BaseViewController.h"

#import "DD_CircleModel.h"

@interface DD_CricleShowViewController : DD_BaseViewController

/**
 * 初始化
 */
-(instancetype)initWithCircleModel:(DD_CircleModel *)CircleModel WithIndex:(NSInteger )index WithBlock:(void (^)(NSString *type))block;

/** 搭配图*/
@property (nonatomic,strong) DD_CircleModel *circleModel;

/** 当前选择搭配图index*/
__int(index);

/** 回调block*/
@property(nonatomic,copy) void (^block)(NSString *type);

@end
