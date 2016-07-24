//
//  DD_CircleDetailHeadView.h
//  DDAY
//
//  Created by yyj on 16/6/23.
//  Copyright © 2016年 YYJ. All rights reserved.
//
#import "DD_CircleListModel.h"
#import <UIKit/UIKit.h>

@interface DD_CircleDetailHeadView : UIView
/**
 * 初始化
 */
-(instancetype)initWithCircleListModel:(DD_CircleListModel *)model WithBlock:(void (^)(NSString *type,NSInteger index))block;

/**
 * 更新
 */
-(void)update;
/**
 * 搭配model
 */
@property (nonatomic,strong) DD_CircleListModel *listModel;
/**
 * 回调block
 */
@property(nonatomic,copy) void (^block)(NSString *type,NSInteger index);


/**
 * 更新
 */
-(void)setState;
@end
