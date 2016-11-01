//
//  DD_LoginViewController.h
//  DDAY
//
//  Created by yyj on 16/5/21.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DD_BaseViewController.h"

@interface DD_LoginViewController : DD_BaseViewController
    
-(instancetype)initWithBlock:(void (^)(NSString *type))successblock;

__block_type(successblock, type);

@end
