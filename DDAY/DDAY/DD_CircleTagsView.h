//
//  DD_CircleTagsView.h
//  DDAY
//
//  Created by yyj on 16/6/15.
//  Copyright © 2016年 YYJ. All rights reserved.
//
#import "DD_CircleModel.h"

#import <UIKit/UIKit.h>

@interface DD_CircleTagsView : UIView
/**
 * 初始化
 */
-(instancetype)initWithCircleModel:(DD_CircleModel *)CircleModel WithBlock:(void (^)(NSString *type,long tag))block;
/**
 * 重新设置当前视图
 */
-(void)setState;
/**
 * 选择标签
 */
@property (nonatomic,strong) DD_CircleModel *circleModel;
/**
 * 回调block
 */
@property(nonatomic,copy) void (^block)(NSString *type,long tag);
@end
