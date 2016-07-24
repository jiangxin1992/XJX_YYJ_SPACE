//
//  DD_CirclePublishViewController.h
//  DDAY
//
//  Created by yyj on 16/6/14.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_BaseViewController.h"

@interface DD_CirclePublishViewController : DD_BaseViewController
/**
 *  初始化
 */
-(instancetype)initWithBlock:(void (^)(NSString *type))block;
/**
 * 回调block
 */
__block_type(block, type);
@end
