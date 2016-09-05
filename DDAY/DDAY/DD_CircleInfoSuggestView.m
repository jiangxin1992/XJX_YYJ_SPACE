//
//  DD_CircleInfoSuggestView.m
//  DDAY
//
//  Created by yyj on 16/6/15.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_CircleInfoSuggestView.h"

#import "DD_CircleInfoSuggestSignBoard.h"

@implementation DD_CircleInfoSuggestView
{
    DD_CircleInfoSuggestSignBoard *_SignBoard;
    UITextView *_textView;
    UILabel *_numlabel;//字数
    NSString *_content;
}

#pragma mark - 初始化
/**
 * 初始化
 */
-(instancetype)initWithPlaceHoldStr:(NSString *)holdStr WithBlockType:(NSString *)blockType WithLimitNum:(long)limitNum Block:(void (^)(NSString *type,NSString *content))block
{
    self=[super init];
    if(self)
    {
        _block=block;
        _holdStr=holdStr;
        _limitNum=limitNum;
        _blockType=blockType;
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
-(void)PrepareData
{
    _content=@"";
}
-(void)PrepareUI
{
    self.backgroundColor=_define_white_color;
    self.userInteractionEnabled=YES;
//    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(remarksAction)]];
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
    _SignBoard.commentField.text=_textView.text;
    [_SignBoard.commentField becomeFirstResponder];
    
}
#pragma mark - UIConfig
-(void)UIConfig
{
    UIView *backView=[UIView getCustomViewWithColor:nil];
    [self addSubview:backView];
    [regular setBorder:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kEdge);
        make.right.mas_equalTo(-kEdge);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(85);
        make.bottom.mas_equalTo(self.mas_bottom).with.offset(0);
    }];
    
    _numlabel=[UILabel getLabelWithAlignment:2 WithTitle:[self getlength] WithFont:13.0f WithTextColor:_define_light_gray_color1 WithSpacing:0];
    [backView addSubview:_numlabel];
    [_numlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.mas_equalTo(-11);
    }];
    [_numlabel sizeToFit];
    
    _SignBoard=[[DD_CircleInfoSuggestSignBoard alloc] initWithHoldStr:_holdStr WithBlock:^(NSString *type, NSString *content) {
        if([type isEqualToString:@"cancel"])
        {
            [regular dismissKeyborad];
        }else if([type isEqualToString:@"save"])
        {
            _content=content;
            _textView.text=_content;
            _numlabel.text=[self getlength];
            [regular dismissKeyborad];
            _block(@"save",_content);
        }else
        {
            _block(type,_content);
        }
    }];
    _SignBoard.frame=CGRectMake(0, 0, ScreenWidth, 140);
    
    _textView=[[UITextView alloc] init];
    _textView.inputAccessoryView = _SignBoard;
    _textView.returnKeyType=UIReturnKeyDefault;
    _textView.font=[regular getFont:13.0f];
    _textView.text=_holdStr;
    _textView.textColor=_define_light_gray_color1;
    _textView.delegate=self;
    [backView addSubview:_textView];
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(2);
        make.left.mas_equalTo(6);
        make.right.mas_equalTo(-6);
        make.bottom.mas_equalTo(_numlabel.mas_top).with.offset(0);
    }];
}
#pragma mark - UITextViewDelegate
-(BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    if (textView.text.length<1) {
        
        textView.text = _holdStr;
        textView.textColor=_define_light_gray_color1;
        
    }else
    {
        textView.textColor=_define_black_color;
    }
    return YES;
}
//在开始编辑的代理方法中进行如下操作
- (void)textViewDidBeginEditing:(UITextView *)textView {
    textView.textColor=_define_black_color;
    if ([textView.text isEqualToString:_holdStr]) {
        
        textView.text = @"";
    }
}

#pragma mark - SomeAction
-(NSString *)getlength
{
    return [[NSString alloc] initWithFormat:@"%ld/%ld",_content.length,_limitNum];
}
/**
 * 跳转填写备注界面
 */
//-(void)remarksAction
//{
//    _block(_blockType,_limitNum);
//}

/**
 * 键盘消失
 */
//-(void)return_KeyBoard
//{
//    [regular dismissKeyborad];
//    _textView.text=_SignBoard.commentField.text;
//}

@end






