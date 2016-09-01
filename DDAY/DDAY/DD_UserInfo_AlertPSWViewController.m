
//
//  DD_UserInfo_AlertPSWViewController.m
//  DDAY
//
//  Created by yyj on 16/5/22.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_UserInfo_AlertPSWViewController.h"

#import "DD_LoginTextView.h"

@interface DD_UserInfo_AlertPSWViewController ()<UITextFieldDelegate>

@end

@implementation DD_UserInfo_AlertPSWViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self SomePrepare];
    [self UIConfig];
}
#pragma mark - SomePrepare
-(void)SomePrepare
{
    [self PrepareData];
    [self PrepareUI];
}
-(void)PrepareData{}
-(void)PrepareUI{}
#pragma mark - UIConfig

-(void)UIConfig
{
    UIView *lastView=nil;
    for (int i=0; i<3; i++) {
        UITextField *_textFiled=[UITextField getTextFieldWithPlaceHolder:i==0?@"输入当前密码":i==1?@"输入新密码":@"重新输入新密码" WithAlignment:0 WithFont:15.0f WithTextColor:nil WithLeftView:[[DD_LoginTextView alloc] initWithFrame:CGRectMake(0, 0, 35, 50) WithImgStr:@"Login_PWD" WithSize:CGSizeMake(17, 27) isLeft:YES WithBlock:nil] WithRightView:nil WithSecureTextEntry:YES];
        [self.view addSubview:_textFiled];
        _textFiled.tag=100+i;
        _textFiled.returnKeyType=UIReturnKeyDone;
        _textFiled.delegate=self;
        if(i==0)
        {
            [_textFiled becomeFirstResponder];
        }
        [_textFiled mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(50);
            make.right.mas_equalTo(-50);
            make.height.mas_equalTo(50);
            if(lastView)
            {
                make.top.mas_equalTo(lastView.mas_bottom).with.offset(IsPhone6_gt?18:11);
            }else
            {
                make.bottom.mas_equalTo(self.view.mas_centerY).with.offset(IsPhone6_gt?-68-kNavHeight:-61-kNavHeight);
            }
        }];
        lastView=_textFiled;
    }
    
    UIButton *submitBtn=[UIButton getCustomTitleBtnWithAlignment:0 WithFont:18 WithSpacing:0 WithNormalTitle:@"确认修改" WithNormalColor:_define_white_color WithSelectedTitle:nil WithSelectedColor:nil];
    [self.view addSubview:submitBtn];
    submitBtn.backgroundColor=_define_black_color;
    [submitBtn addTarget:self action:@selector(SaveAction) forControlEvents:UIControlEventTouchUpInside];
    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(50);
        make.right.mas_equalTo(-50);
        make.height.mas_equalTo(40);
        make.top.mas_equalTo(lastView.mas_bottom).with.offset(50);
    }];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
#pragma mark - SomeAction
-(void)setTitle:(NSString *)title
{
    self.navigationItem.titleView=[regular returnNavView:title withmaxwidth:180];
}
/**
 * 修改验证
 */
-(void)SaveAction
{
    UITextField *_oldPSWTextfield=(UITextField *)[self.view viewWithTag:100];
    UITextField *_newpsw=(UITextField *)[self.view viewWithTag:101];
    UITextField *_repeat_newpsw=(UITextField *)[self.view viewWithTag:102];

    if([NSString isNilOrEmpty:_oldPSWTextfield.text]||[NSString isNilOrEmpty:_newpsw.text]||[NSString isNilOrEmpty:_repeat_newpsw.text])
    {
        NSLog(@"%@ %@ %@",_oldPSWTextfield.text,_newpsw.text,_repeat_newpsw.text);
        [self presentViewController:[regular alertTitle_Simple:NSLocalizedString(@"content_empty", @"")] animated:YES completion:nil];
    }else
    {
        if([regular checkPassword:_oldPSWTextfield.text]&&[regular checkPassword:_newpsw.text]&&[regular checkPassword:_repeat_newpsw.text])
        {
            if([_newpsw.text isEqualToString:_repeat_newpsw.text])
            {
                [self enterSaveAction];
            }else
            {
                [self presentViewController:[regular alertTitle_Simple:NSLocalizedString(@"login_code_different", @"")] animated:YES completion:nil];
            }
        }else
        {
            [self presentViewController:[regular alertTitle_Simple:NSLocalizedString(@"login_psw_form", @"")] animated:YES completion:nil];
        }
    }
}

/**
 * 修改
 */
-(void)enterSaveAction
{
    UITextField *_oldPSWTextfield=(UITextField *)[self.view viewWithTag:100];
    UITextField *_newpsw=(UITextField *)[self.view viewWithTag:101];

    NSDictionary *_parameters=@{@"token":[DD_UserModel getToken],@"oldPwd":[regular md5:_oldPSWTextfield.text],@"newPwd":[regular md5:_newpsw.text]};
    [[JX_AFNetworking alloc] GET:@"user/editPassword.do" parameters:_parameters success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
        if(success)
        {
            [self.navigationController popViewControllerAnimated:YES];
        }else
        {
            [self presentViewController:successAlert animated:YES completion:nil];
        }
    } failure:^(NSError *error, UIAlertController *failureAlert) {
        [self presentViewController:failureAlert animated:YES completion:nil];
    }];
}
#pragma mark - Other
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [regular dismissKeyborad];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"DD_UserInfo_AlertPSWViewController"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"DD_UserInfo_AlertPSWViewController"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
