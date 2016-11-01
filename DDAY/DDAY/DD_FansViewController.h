//
//  DD_FansViewController.h
//  DDAY
//
//  Created by yyj on 16/6/27.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_BaseViewController.h"

@interface DD_FansViewController : DD_BaseViewController

-(instancetype)initWithBlock:(void (^)(NSString *type))block;

__block_type(block, type);

@end
