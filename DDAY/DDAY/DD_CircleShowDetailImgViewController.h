//
//  DD_CircleShowDetailImgViewController.h
//  DDAY
//
//  Created by yyj on 16/6/23.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_BaseViewController.h"

@interface DD_CircleShowDetailImgViewController : DD_BaseViewController

/**
 * 初始化
 */
-(instancetype)initWithCircleArr:(NSArray *)picArrs WithType:(NSString *)type WithIndex:(NSInteger )index WithBlock:(void (^)(NSString *type))block;

__string(type);

/** 搭配图数组*/
__array(picArrs);

/** 当前选择搭配图index*/
__int(index);

/** 回调block*/
@property(nonatomic,copy) void (^block)(NSString *type);

@end
