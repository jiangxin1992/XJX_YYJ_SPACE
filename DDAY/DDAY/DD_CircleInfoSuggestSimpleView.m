//
//  DD_CircleInfoSuggestView.m
//  DDAY
//
//  Created by yyj on 16/6/15.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_CircleInfoSuggestSimpleView.h"

#import "DD_CircleInfoSuggestSignBoard.h"

@implementation DD_CircleInfoSuggestSimpleView
{
    DD_CircleInfoSuggestSignBoard *_SignBoard;
//    UITextView *_textView;
    UITextField *_textfield;
//    UILabel *_numlabel;//字数
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
    _SignBoard.commentField.text=_textfield.text;
    [_SignBoard.commentField becomeFirstResponder];
    
}

#pragma mark - UIConfig
-(void)UIConfig
{
    
    _SignBoard=[[DD_CircleInfoSuggestSignBoard alloc] initWithHoldStr:_holdStr WithBlock:^(NSString *type, NSString *content) {
        if([type isEqualToString:@"cancel"]||[type isEqualToString:@"resign"])
        {
            [_textfield resignFirstResponder];
        }else if([type isEqualToString:@"save"])
        {
            _content=content;
            if([_content isEqualToString:_holdStr])
            {
                _textfield.textColor=_define_light_gray_color1;
                 _block(@"save",@"");
            }else
            {
                _textfield.textColor=_define_black_color;
                 _block(@"save",_content);
            }
            _textfield.text=_content;
            [_textfield resignFirstResponder];
           
        }else
        {
            _block(type,_content);
        }
    }];
    _SignBoard.frame=CGRectMake(0, 0, ScreenWidth, ScreenHeight+400);
    
    _textfield=[[UITextField alloc] init];
    [self addSubview:_textfield];
    _textfield.placeholder=_holdStr;
    _textfield.returnKeyType=UIReturnKeyDone;
    _textfield.inputAccessoryView = _SignBoard;
    _textfield.returnKeyType=UIReturnKeyDefault;
    _textfield.font=[regular getFont:13.0f];
    
    [_textfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kEdge);
        make.right.mas_equalTo(-kEdge);
        make.top.bottom.mas_equalTo(0);
        make.height.mas_equalTo(35);
    }];
    
    UIView *downLine=[UIView getCustomViewWithColor:_define_black_color];
    [_textfield addSubview:downLine];
    [downLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.bottom.right.left.mas_equalTo(0);
    }];
}
#pragma mark - SomeAction
//-(NSString *)getlength
//{
//    return [[NSString alloc] initWithFormat:@"%ld/%ld",_content.length,_limitNum];
//}
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

//-(void)UIConfig
//{
//    UIView *backView=[UIView getCustomViewWithColor:nil];
//    [self addSubview:backView];
//    [regular setBorder:backView];
//    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(kEdge);
//        make.right.mas_equalTo(-kEdge);
//        make.top.mas_equalTo(0);
//        make.height.mas_equalTo(85);
//        make.bottom.mas_equalTo(self.mas_bottom).with.offset(0);
//    }];
//    
//    _numlabel=[UILabel getLabelWithAlignment:2 WithTitle:[self getlength] WithFont:12.0f WithTextColor:_define_light_gray_color1 WithSpacing:0];
//    [backView addSubview:_numlabel];
//    [_numlabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.right.mas_equalTo(-11);
//    }];
//    [_numlabel sizeToFit];
//    
//    
//    _SignBoard=[[DD_CircleInfoSuggestSignBoard alloc] initWithBlock:^(NSString *type, NSString *content) {
//        if([type isEqualToString:@"cancel"])
//        {
//            [regular dismissKeyborad];
//        }else if([type isEqualToString:@"save"])
//        {
//            _content=content;
//            _textView.text=_content;
//            _numlabel.text=[self getlength];
//            [regular dismissKeyborad];
//            _block(@"save",_content);
//        }else
//        {
//            _block(type,_content);
//        }
//    }];
//    _SignBoard.frame=CGRectMake(0, 0, ScreenWidth, ScreenHeight+400);
//    
//    _textView=[[UITextView alloc] init];
//    _textView.inputAccessoryView = _SignBoard;
//    _textView.returnKeyType=UIReturnKeyDefault;
//    _textView.font=[regular getFont:10.5f];
//    [backView addSubview:_textView];
//    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.top.mas_equalTo(11);
//        make.right.mas_equalTo(-11);
//        make.bottom.mas_equalTo(_numlabel.mas_top).with.offset(0);
//    }];
//    
//}
@end






