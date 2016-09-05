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
    UITextView *_commentField;
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
    UIView *upline=[UIView getCustomViewWithColor:_define_black_color];
    [self addSubview:upline];
    [upline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    
    UIButton *sendBtn=[UIButton getCustomTitleBtnWithAlignment:0 WithFont:18.0f WithSpacing:0 WithNormalTitle:@"发 送" WithNormalColor:_define_white_color WithSelectedTitle:nil WithSelectedColor:nil];
    [self addSubview:sendBtn];
    sendBtn.backgroundColor=_define_black_color;
    [sendBtn addTarget:self action:@selector(sendAction:) forControlEvents:UIControlEventTouchUpInside];
    [sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.mas_equalTo(0);
        make.width.mas_equalTo(IsPhone6_gt?95:75);
        
    }];
    
    _commentField=[[UITextView alloc] init];
    [self addSubview:_commentField];
    
    _SignBoard=[[DD_CircleCommentSignBoard alloc] initWithBlock:^(NSString *type, NSString *content,CGFloat height) {
        if([type isEqualToString:@"cancel"]||[type isEqualToString:@"resign"])
        {
            
            [self return_KeyBoard];
        }else if([type isEqualToString:@"send"])
        {
            [regular dismissKeyborad];
            _commentField.text=_SignBoard.commentField.text;
            _block(type,content);
        }
        
    }];
    _SignBoard.frame=CGRectMake(0, 0, ScreenWidth, ScreenHeight+400);
    
    _commentField.font = [regular getFont:13.0f];//设置字体名字和字体大小
    
    _commentField.delegate = self;//设置它的委托方法
    _commentField.textAlignment=0;
    _commentField.backgroundColor =  _define_clear_color;//设置它的背景颜色
    
    _commentField.returnKeyType = UIReturnKeyDefault;//返回键的类型
    
    _commentField.keyboardType = UIKeyboardTypeDefault;//键盘类型
    _commentField.textColor=_define_light_gray_color1;
    _commentField.text = @"发表评论";
    _commentField.inputAccessoryView = _SignBoard;

    
    [_commentField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(0);
        make.height.mas_equalTo(ktabbarHeight);
        make.right.mas_equalTo(sendBtn.mas_left).with.offset(0);
    }];
    
    
}
#pragma mark - SomeAction


//在开始编辑的代理方法中进行如下操作
- (void)textViewDidBeginEditing:(UITextView *)textView {
    textView.textColor=_define_black_color;
    if ([textView.text isEqualToString:@"发表评论"]) {
        
        textView.text = @"";
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"发表评论"]||[textView.text isEqualToString:@""]) {
        textView.text = @"发表评论";
        textView.textColor=_define_light_gray_color1;
    }else
    {
        textView.textColor=_define_black_color;
    }
}
-(void)textViewDidChange:(UITextView *)textView{
    //博客园-FlyElephant
    [self reloadHeight:textView];
    
}
-(void)sendAction:(UIButton *)btn
{
    _block(@"send",_commentField.text);
}
-(void)reloadHeight:(UITextView *)textView
{
    static CGFloat maxHeight =100.0f;
    CGRect frame = textView.frame;
    CGSize constraintSize = CGSizeMake(frame.size.width, MAXFLOAT);
    CGSize size = [textView sizeThatFits:constraintSize];
    //    if (size.height<=frame.size.height) {
    if (size.height<=ktabbarHeight) {
        //        size.height=frame.size.height;
        size.height=ktabbarHeight;
    }else{
        if (size.height >= maxHeight)
        {
            size.height = maxHeight;
            textView.scrollEnabled = YES;   // 允许滚动
        }
        else
        {
            textView.scrollEnabled = NO;    // 不允许滚动
        }
    }
    [_commentField mas_updateConstraints:^(MASConstraintMaker *make) {
        if(size.height<ktabbarHeight)
        {
            make.height.mas_equalTo(ktabbarHeight);
        }else
        {
            make.height.mas_equalTo(size.height);
        }
    }];
}
/**
 * 键盘消失
 */
-(void)return_KeyBoard
{
    [regular dismissKeyborad];
    _commentField.text=_SignBoard.commentField.text;
    if([_SignBoard.commentField.text isEqualToString:@"发表评论"]||[_SignBoard.commentField.text isEqualToString:@""])
    {
        _commentField.text = @"发表评论";
        _commentField.textColor=_define_light_gray_color1;
    }else
    {
        _commentField.text=_SignBoard.commentField.text;
        _commentField.textColor=_define_black_color;
    }
    
    [self reloadHeight:_commentField];
    
}
/**
 * 初始化输入框内容
 */
-(void)initTextView
{
    _commentField.text=@"";
    _SignBoard.commentField.text=@"";
    if ([_commentField.text isEqualToString:@"发表评论"]||[_commentField.text isEqualToString:@""]) {
        _commentField.text = @"发表评论";
        _commentField.textColor=_define_light_gray_color1;
    }else
    {
        _commentField.textColor=_define_black_color;
    }
    [self reloadHeight:_commentField];
}
/**
 * 成为第一响应
 */
-(void)becomeFirstResponder
{
    [_commentField becomeFirstResponder];
}

@end
