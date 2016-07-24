//
//  DD_CircleCustomTagViewController.h
//  DDAY
//
//  Created by yyj on 16/6/16.
//  Copyright © 2016年 YYJ. All rights reserved.
//
#import "DD_CircleModel.h"
#import "DD_CricleTagItemModel.h"
#import "DD_BaseViewController.h"

@interface DD_CircleCustomTagViewController : DD_BaseViewController
/**
 * 初始化
 */
-(instancetype)initWithCircleModel:(DD_CircleModel *)CircleModel WithBlock:(void (^)(NSString *type,DD_CricleTagItemModel *tagModel))block;
@property (weak, nonatomic) IBOutlet UITextField *tagTextField;
/**
 * 发布视图model
 */
@property (nonatomic,strong) DD_CircleModel *CircleModel;
/**
 * 回调block
 */
@property(nonatomic,copy) void (^block)(NSString *type,DD_CricleTagItemModel *tagModel);
@end
