//
//  DD_CircleInfoSuggestSignBoard.m
//  YCO SPACE
//
//  Created by yyj on 16/8/12.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_CircleInfoSuggestSignBoard.h"

@implementation DD_CircleInfoSuggestSignBoard

#pragma mark - 初始化
-(instancetype)initWithHoldStr:(NSString *)holdStr WithBlock:(void (^)(NSString *type,NSString *content))block
{
    self=[super init];
    if(self)
    {
        _holdStr=holdStr;
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
}
-(void)PrepareData{}
-(void)PrepareUI
{
    self.backgroundColor=_define_backview_color;
}
#pragma mark - UIConfig
-(void)UIConfig
{
    UIView *view_qufen=[[UIView alloc] init];
    [self addSubview:view_qufen];
    view_qufen.backgroundColor=_define_black_color;
    [view_qufen mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.and.right.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    
    UIButton *cancel=[UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:cancel];
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    cancel.titleLabel.font=[regular getFont:13.0f];
    [cancel setTitleColor:_define_black_color forState:UIControlStateNormal];
    [cancel addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [cancel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(view_qufen.mas_bottom).with.offset(0);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(33);
    }];
    
    
    UIButton *send=[UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:send];
    [send setTitle:@"保存" forState:UIControlStateNormal];
    send.titleLabel.font=[regular getFont:13.0f];
    [send setTitleColor:_define_black_color forState:UIControlStateNormal];
    [send addTarget:self action:@selector(sendAction) forControlEvents:UIControlEventTouchUpInside];
    [send mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(view_qufen.mas_bottom).with.offset(0);
        make.right.mas_equalTo(0);
        make.width.mas_equalTo(cancel);
        make.height.mas_equalTo(cancel);
    }];
    
    _commentField=[[UITextView alloc] init];
    [self addSubview:_commentField];
    _commentField.returnKeyType=UIReturnKeyDefault;
    _commentField.delegate=self;
    _commentField.font=[regular getFont:14.0f];
    _commentField.textColor=_define_black_color;
    [_commentField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(7);
        make.right.mas_equalTo(-7);
        make.top.mas_equalTo(cancel.mas_bottom).with.offset(0);
        make.height.mas_equalTo(100);
        make.bottom.mas_equalTo(-7);
    }];
}
#pragma mark - OtherAction
/**
 * 取消
 */
-(void)cancelAction
{
    _block(@"cancel",_commentField.text);
}
/**
 * 发送
 */
-(void)sendAction
{
    _block(@"save",_commentField.text);
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
//键盘return的时候发送 发送评论的请求
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    [self sendAction];
    return YES;
}
//在开始编辑的代理方法中进行如下操作
- (void)textViewDidBeginEditing:(UITextView *)textView {
    textView.textColor=_define_black_color;
    if ([textView.text isEqualToString:_holdStr]) {
        
        textView.text = @"";
    }
}

@end
