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
    self.backgroundColor=[UIColor clearColor];
}
#pragma mark - UIConfig
-(void)UIConfig
{
    UIImageView *backimg=[UIImageView getMaskImageView];
    [self addSubview:backimg];
    [backimg addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickAction)]];
    [backimg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    UIButton *sendBtn=[UIButton getCustomTitleBtnWithAlignment:0 WithFont:18.0f WithSpacing:0 WithNormalTitle:@"完 成" WithNormalColor:_define_white_color WithSelectedTitle:nil WithSelectedColor:nil];
    [backimg addSubview:sendBtn];
    sendBtn.backgroundColor=_define_black_color;
    [sendBtn addTarget:self action:@selector(sendAction) forControlEvents:UIControlEventTouchUpInside];
    [sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.mas_equalTo(0);
        make.width.mas_equalTo(IsPhone6_gt?95:75);
    }];
    
    _commentField=[[UITextView alloc] init];
    [backimg addSubview:_commentField];
    _commentField.returnKeyType=UIReturnKeyDone;
    _commentField.backgroundColor=_define_white_color;
    _commentField.font = [regular getFont:13.0f];//设置字体名字和字体大小
    
    _commentField.delegate = self;//设置它的委托方法
    _commentField.textAlignment=0;
    
    _commentField.keyboardType = UIKeyboardTypeDefault;//键盘类型
    _commentField.textColor=_define_light_gray_color1;
    _commentField.text = _holdStr;
    
    [_commentField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.mas_equalTo(0);
        make.height.mas_equalTo(ktabbarHeight);
        make.right.mas_equalTo(sendBtn.mas_left).with.offset(0);
        make.height.mas_equalTo(sendBtn);
    }];
    
    UIView *upline=[UIView getCustomViewWithColor:_define_black_color];
    [backimg addSubview:upline];
    [upline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_commentField.mas_top).with.offset(0);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
}
#pragma mark - OtherAction
-(void)clickAction
{
    if ([_commentField.text isEqualToString:_holdStr]||[_commentField.text isEqualToString:@""]) {
        _commentField.text = _holdStr;
        _commentField.textColor=_define_light_gray_color1;
    }else
    {
        _commentField.textColor=_define_black_color;
    }
    _block(@"resign",_commentField.text);
    [_commentField resignFirstResponder];
}
/**
 * 取消
 */
-(void)cancelAction
{
    if ([_commentField.text isEqualToString:_holdStr]||[_commentField.text isEqualToString:@""]) {
        _commentField.text = _holdStr;
        _commentField.textColor=_define_light_gray_color1;
    }else
    {
        _commentField.textColor=_define_black_color;
    }
    _block(@"cancel",_commentField.text);
    [_commentField resignFirstResponder];
}
/**
 * 发送
 */
-(void)sendAction
{
    if ([_commentField.text isEqualToString:_holdStr]||[_commentField.text isEqualToString:@""]) {
        _commentField.text = _holdStr;
        _commentField.textColor=_define_light_gray_color1;
    }else
    {
        _commentField.textColor=_define_black_color;
    }
    JXLOG(@"_commentField111=%@",_commentField.text);
    _block(@"save",_commentField.text);
    [_commentField resignFirstResponder];
}
//在开始编辑的代理方法中进行如下操作
- (void)textViewDidBeginEditing:(UITextView *)textView {
    textView.textColor=_define_black_color;
    if ([textView.text isEqualToString:_holdStr]) {
        
        textView.text = @"";
    }
    
    [self reloadHeight:textView];
}

-(void)textViewDidChange:(UITextView *)textView{
    [self reloadHeight:textView];
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
#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        [self sendAction];
        //在这里做你响应return键的代码
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    return YES;
}

@end
