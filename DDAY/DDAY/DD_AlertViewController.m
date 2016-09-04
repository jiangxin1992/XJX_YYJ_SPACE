
//
//  DD_AlertViewController.m
//  DDAY
//
//  Created by yyj on 16/5/22.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_AlertViewController.h"

@interface DD_AlertViewController ()<UITextFieldDelegate>

@end

@implementation DD_AlertViewController
{
    UITextField *_inputTextfield;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}
#pragma mark - 初始化
-(instancetype)initWithModel:(DD_UserModel *)usermodel WithKey:(NSString *)key WithContent:(NSString *)content WithBlock:(void (^)(DD_UserModel *model))block
{
    self=[super init];
    if(self)
    {
        _block=block;
        _key=key;
        _content=content;
        _usermodel=usermodel;
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
    DD_NavBtn *confirmBtn=[DD_NavBtn getNavBtnIsLeft:NO WithSize:CGSizeMake(24, 24) WithImgeStr:@"System_Confirm"];
    [confirmBtn addTarget:self action:@selector(DoneAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:confirmBtn];
}
#pragma mark - UIConfig
-(void)UIConfig
{
    _inputTextfield=[[UITextField alloc] init];
    [self.view addSubview:_inputTextfield];
    _inputTextfield.textColor=_define_black_color;

    if([_key isEqualToString:@"nickname"])
    {
        _inputTextfield.placeholder=@"快来填写昵称吧";
    }else if([_key isEqualToString:@"career"])
    {
        _inputTextfield.placeholder=@"快来填写职业吧";
    }
    _inputTextfield.font=[regular getFont:13.0f];
    _inputTextfield.textAlignment=0;
    _inputTextfield.delegate=self;
    _inputTextfield.returnKeyType=UIReturnKeyDone;
    _inputTextfield.clearButtonMode=UITextFieldViewModeAlways;
    [regular setBorder:_inputTextfield];
    _inputTextfield.text=_content;
    
    _inputTextfield.leftViewMode=UITextFieldViewModeAlways;
    _inputTextfield.leftView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 11, 32)];
    [_inputTextfield becomeFirstResponder];
    
    [_inputTextfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kEdge);
        make.right.mas_equalTo(-kEdge);
        make.top.mas_equalTo(kNavHeight+15);
        make.height.mas_equalTo(32);
    }];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self DoneAction];
    return YES;
}
#pragma mark - SomeAction
-(void)setTitle:(NSString *)title
{
    self.navigationItem.titleView=[regular returnNavView:title withmaxwidth:180];
}

/**
 * 保存
 */
-(void)DoneAction
{
    if([NSString isNilOrEmpty:_inputTextfield.text])
    {
        [self presentViewController:[regular alertTitle_Simple:NSLocalizedString(@"content_empty", @"")] animated:YES completion:nil];
    }else
    {
        NSString *_keystr=nil;
        if([_key isEqualToString:@"gender"])
        {
            if([_inputTextfield.text isEqualToString:@"男"])
            {
                _keystr=@"0";
            }else if([_inputTextfield.text isEqualToString:@"女"])
            {
                _keystr=@"1";
            }else
            {
                _keystr=@"";
            }
        }else
        {
            _keystr=_inputTextfield.text;
        }
        NSDictionary *_parameters=@{_key:_keystr,@"token":[DD_UserModel getToken]};
        [[JX_AFNetworking alloc] GET:@"user/editUserInfo.do" parameters:_parameters success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
            if(success)
            {
                DD_UserModel *usermodel=[DD_UserModel getUserModel:[data objectForKey:@"user"]];
                _block(usermodel);
                [self.navigationController popViewControllerAnimated:YES];
            }else
            {
                [self presentViewController:successAlert animated:YES completion:nil];
            }
        } failure:^(NSError *error, UIAlertController *failureAlert) {
            [self presentViewController:failureAlert animated:YES completion:nil];
        }];
    }
}

#pragma mark - Other
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [regular dismissKeyborad];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"DD_AlertViewController"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"DD_AlertViewController"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
