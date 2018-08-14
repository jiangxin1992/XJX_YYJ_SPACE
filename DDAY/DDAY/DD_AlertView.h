//
//  DD_AlertView.h
//  YCOSPACE
//
//  Created by yyj on 2018/3/19.
//  Copyright © 2018年 YYJ. All rights reserved.
//

#import "DD_BaseAlertView.h"

@interface DD_AlertView : DD_BaseAlertView

-(instancetype)initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

@property (nonatomic, copy) void (^clickBlock)(NSInteger buttonIndex);

@end
