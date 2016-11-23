//
//  DD_CircleChooseDetailView.h
//  DDAY
//
//  Created by yyj on 16/6/20.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_BaseViewController.h"

@class DD_CircleModel;

@interface DD_CircleChooseDetailView : DD_BaseViewController

/**
 * 初始化
 */
-(instancetype)initWithCircleModel:(DD_CircleModel *)CircleModel WithLimitNum:(NSInteger )num WithBlock:(void (^)(NSString *type,NSInteger index))block;

/** 选择的款式*/
@property (nonatomic,strong) DD_CircleModel *circleModel;

/** 可选款式限制数量*/
__int(num);

/** 回调block*/
@property(nonatomic,copy) void (^block)(NSString *type,NSInteger index);

@end
