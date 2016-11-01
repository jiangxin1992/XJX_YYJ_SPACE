//
//  DD_CirclePublishDailyViewController.h
//  YCO SPACE
//
//  Created by yyj on 16/9/13.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_BaseViewController.h"

@interface DD_CirclePublishDailyViewController : DD_BaseViewController

/**
 *  初始化
 */
-(instancetype)initWithBlock:(void (^)(NSString *type))block;

/** 回调block*/
__block_type(block, type);

@end
