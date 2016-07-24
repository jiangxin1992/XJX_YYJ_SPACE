//
//  DD_CircleApplyViewController.h
//  DDAY
//
//  Created by yyj on 16/6/23.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_BaseViewController.h"
/**
 * 申请成为达人
 * 普通用户权限才能申请
 * 测试环境所有权限下皆开放入口
 * 申请为四个状态：还未申请（填写申请表）、提交申请（审核中）、通过审核（成功变身达人）、未通过（申请被拒）
 */
@interface DD_CircleApplyViewController : DD_BaseViewController
/**
 *  初始化
 */
-(instancetype)initWithBlock:(void (^)(NSString *type))block;
/**
 * 回调block
 */
__block_type(block, type);
@end
