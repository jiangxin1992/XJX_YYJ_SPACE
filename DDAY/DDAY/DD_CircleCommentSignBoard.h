//
//  DD_CircleCommentSignBoard.h
//  DDAY
//
//  Created by yyj on 16/6/23.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DD_CircleCommentSignBoard : UIView<UITextViewDelegate>
/**
 * 初始化
 */
-(instancetype)initWithBlock:(void (^)(NSString *type,NSString *content))block;

/**
 * 回调block
 */
@property(nonatomic,copy) void (^block)(NSString *type,NSString *content);
/**
 * 输入框 用于外部调用文本框内容
 */
@property (nonatomic,strong) UITextView *commentField;
@end
