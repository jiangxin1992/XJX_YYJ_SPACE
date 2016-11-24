//
//  DD_CircleComentInputView.h
//  DDAY
//
//  Created by yyj on 16/6/23.
//  Copyright © 2016年 YYJ. All rights reserved.
//


#import "DD_BaseView.h"

@interface DD_CircleComentInputView : DD_BaseView

/**
 * 初始化
 */
-(instancetype)initWithBlock:(void (^)(NSString *type,NSString *content))block;

/**
 * 键盘消失
 */
-(void)return_KeyBoard;

/**
 * 初始化输入框内容
 */
-(void)initTextView;

/**
 * 成为第一响应
 */
-(void)becomeFirstResponder;

/** 回调block*/
@property(nonatomic,copy) void (^block)(NSString *type,NSString *content);

@end
