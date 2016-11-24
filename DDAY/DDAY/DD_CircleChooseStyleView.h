//
//  DD_CircleChooseStyleView.h
//  DDAY
//
//  Created by yyj on 16/6/15.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_BaseView.h"

@class DD_CircleModel;

@interface DD_CircleChooseStyleView : DD_BaseView

/**
 * 初始化
 */
-(instancetype)initWithCircleModel:(DD_CircleModel *)CircleModel WithBlock:(void (^)(NSString *type,NSInteger index))block;

/**
 * 更新款式界面
 */
-(void)updateImageView;

/** 选择的款式*/
@property (nonatomic,strong) DD_CircleModel *circleModel;

/** 回调block*/
@property(nonatomic,copy) void (^block)(NSString *type,NSInteger index);

@end
