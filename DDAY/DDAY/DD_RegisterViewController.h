//
//  DD_RegisterViewController.h
//  DDAY
//
//  Created by yyj on 16/5/21.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DD_RegisterViewController :UIViewController
-(instancetype)initWithBlock:(void (^)(NSString *type))successblock;
__block_type(successblock, type);

@end