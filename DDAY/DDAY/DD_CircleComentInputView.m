//
//  DD_CircleComentInputView.m
//  DDAY
//
//  Created by yyj on 16/6/23.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_CircleComentInputView.h"

#import "DD_CircleCommentSignBoard.h"

@implementation DD_CircleComentInputView
{
    UITextField *_commentField;
    DD_CircleCommentSignBoard *_SignBoard;
}

#pragma mark - 初始化
-(instancetype)initWithBlock:(void (^)(NSString *type,NSString *content))block
{
    self=[super init];
    if(self)
    {
        _block=block;
        [self SomePrepare];
        [self UIConfig];
    }
    return self;
}
#pragma mark - SomePrepare
-(void)SomePrepare
{
    [self PrepareData];
    [self PrepareUI];
    [self createNotification];
}
-(void)PrepareData{}
-(void)PrepareUI
{
    self.backgroundColor=_define_backview_color;
}
//给键盘加上监听，捕获他的隐藏和显示
- (void)createNotification
{
    //    UIKeyboardWillShowNotification这个通知在软键盘弹出时由系统发送
    //    UIKeyboardWillShowNotification 通知：键盘将要显示的通知
    //    在通知中心中添加监测对象，当该对象受到UIKeyboardWillShowNotification的通知时，会调用参数二所代表的方法
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
//键盘将要隐藏时调用的方法
//将底部的评论 view，根据键盘的变化而变化
- (void)keyboardWillHide:(NSNotification *)not
{
    [_SignBoard.commentField resignFirstResponder];
    
}
//键盘将要出现时调用的方法
//将底部的评论 view，根据键盘的变化而变化
- (void)keyboardWillShow:(NSNotification *)not
{
    [_SignBoard.commentField becomeFirstResponder];
}
#pragma mark - UIConfig
-(void)UIConfig
{
    _commentField=[[UITextField alloc] init];
    [self addSubview:_commentField];
    
    _SignBoard=[[DD_CircleCommentSignBoard alloc] initWithBlock:^(NSString *type, NSString *content) {
        if([type isEqualToString:@"cancel"])
        {
            [self return_KeyBoard];
        }else if([type isEqualToString:@"send"])
        {
            _commentField.text=_SignBoard.commentField.text;
            _block(type,content);
        }else
        {
            _block(type,content);
        }
    }];
    _SignBoard.frame=CGRectMake(0, 0, ScreenWidth, 140);
    
    _commentField.inputAccessoryView = _SignBoard;
    _commentField.clearButtonMode = UITextFieldViewModeAlways;
    _commentField.leftViewMode=UITextFieldViewModeAlways;
    _commentField.leftView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, CGRectGetHeight(_commentField.frame))];
    _commentField.returnKeyType=UIReturnKeyDefault;
    _commentField.borderStyle= UITextBorderStyleNone;
    _commentField.placeholder=@"撰 写 您 的 评 论 。";
    _commentField.background=[UIImage imageNamed:@"comment_搜索框搜索框"];
    _commentField.font=[regular getFont:10.5f];
    
    [_commentField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.right.mas_equalTo(-5);
        make.height.mas_equalTo(26);
        make.top.mas_equalTo(3);
        make.bottom.mas_equalTo(-3);
    }];
}
#pragma mark - SomeAction
/**
 * 键盘消失
 */
-(void)return_KeyBoard
{
    [regular dismissKeyborad];
    _commentField.text=_SignBoard.commentField.text;
}
/**
 * 初始化输入框内容
 */
-(void)initTextView
{
    _commentField.text=@"";
    _SignBoard.commentField.text=@"";
}
/**
 * 成为第一响应
 */
-(void)becomeFirstResponder
{
    [_commentField becomeFirstResponder];
}

@end
