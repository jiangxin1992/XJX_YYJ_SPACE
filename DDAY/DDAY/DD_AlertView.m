//
//  DD_AlertView.m
//  YCOSPACE
//
//  Created by yyj on 2018/3/19.
//  Copyright © 2018年 YYJ. All rights reserved.
//

#import "DD_AlertView.h"

@interface DD_BaseAlertView ()<UIAlertViewDelegate>

@end

@implementation DD_AlertView

-(instancetype)initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION{
    self = [super initWithTitle:title message:title delegate:nil cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles, nil];
    if(self){
        self.delegate = self;
    }
    return self;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(_clickBlock){
        _clickBlock(buttonIndex);
    }
}

@end
