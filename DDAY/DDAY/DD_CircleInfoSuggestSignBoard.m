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
    view_qufen.backgroundColor=[UIColor colorWithRed:190.0f/255.0f green:190.0f/255.0f blue:190.0f/255.0f alpha:1];
    [view_qufen mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.and.right.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    
    UIButton *cancel=[UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:cancel];
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    cancel.titleLabel.font=[regular getFont:13.0f];
    [cancel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
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
    [send setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
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
    _commentField.textColor=[UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1];
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
    return YES;
}
//键盘return的时候发送 发送评论的请求
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    [self sendAction];
    return YES;
}
@end
