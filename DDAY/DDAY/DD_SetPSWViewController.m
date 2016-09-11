//
//  DD_SetPSWViewController.m
//  DDAY
//
//  Created by yyj on 16/5/21.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_SetPSWViewController.h"

#import "DD_LoginTextView.h"
#import "DD_LoginViewController.h"

@interface DD_SetPSWViewController ()<UITextFieldDelegate>

@end

@implementation DD_SetPSWViewController
{
    UITextField *_PSWTextfield;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self UIConfig];
    
}
-(instancetype)initWithBlock:(void (^)(NSString *type))successblock
{
    self=[super init];
    if(self)
    {
        _successblock=successblock;
    }
    return self;
}
#pragma mark - UIConfig
-(void)UIConfig
{
    DD_NavBtn *backBtn=[DD_NavBtn getBackBtn];
    [self.view addSubview:backBtn];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame=CGRectMake(10, kStatusBarHeight, CGRectGetWidth(backBtn.frame), CGRectGetHeight(backBtn.frame));
    [backBtn setEnlargeEdge:20];
    
    UILabel *title=[UILabel getLabelWithAlignment:1 WithTitle:@"注册账号" WithFont:IsPhone6_gt?18.0f:15.0f WithTextColor:nil WithSpacing:0];
    title.font=[regular getSemiboldFont:17.0f];
    [self.view addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(19+kStatusBarHeight);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(19);
        make.centerX.mas_equalTo(self.view);
    }];
    
    _PSWTextfield=[UITextField getTextFieldWithPlaceHolder:@"设置登录密码" WithAlignment:0 WithFont:15.0f WithTextColor:nil WithLeftView:[[DD_LoginTextView alloc] initWithFrame:CGRectMake(0, 0, 35, 50) WithImgStr:@"Login_PWD" WithSize:CGSizeMake(17, 27) isLeft:YES WithBlock:^(NSString *type) {
        
    }] WithRightView:nil WithSecureTextEntry:YES];
    [self.view addSubview:_PSWTextfield];
    _PSWTextfield.returnKeyType=UIReturnKeyDone;
    _PSWTextfield.delegate=self;
    [_PSWTextfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(50);
        make.right.mas_equalTo(-50);
        make.height.mas_equalTo(50);
        make.top.mas_equalTo(self.view).with.offset((IsPhone6_gt?250:kIPhone5s?196:165)+kStatusBarHeight);
    }];
    
    UIButton *registerBtn=[UIButton getCustomTitleBtnWithAlignment:0 WithFont:18.0f WithSpacing:20.0f WithNormalTitle:@"注    册" WithNormalColor:_define_white_color WithSelectedTitle:nil WithSelectedColor:nil];
    registerBtn.backgroundColor=_define_black_color;
    [self.view addSubview:registerBtn];
    [registerBtn addTarget:self action:@selector(registerAction) forControlEvents:UIControlEventTouchUpInside];
    [registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(50);
        make.right.mas_equalTo(-50);
        make.height.mas_equalTo(40);
        make.top.mas_equalTo(_PSWTextfield.mas_bottom).with.offset(IsPhone5_gt?45:28);
    }];
}
#pragma mark - SomeAction
/**
 * 返回
 */
-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
/**
 * 注册验证
 */
-(void)registerAction
{
    if([NSString isNilOrEmpty:_PSWTextfield.text])
    {
        [self presentViewController:[regular alertTitle_Simple:NSLocalizedString(@"content_empty", @"")] animated:YES completion:nil];
    }else
    {
        if([regular checkPassword:_PSWTextfield.text])
        {
            [self enterRegisterAction];
        }else
        {
            [self presentViewController:[regular alertTitle_Simple:NSLocalizedString(@"login_psw_form", @"")] animated:YES completion:nil];
        }
    }
}

/**
 * 注册
 */
-(void)enterRegisterAction
{
    NSDictionary *_parameters=@{@"phone":_phone,@"password":[regular md5:_PSWTextfield.text]};
    [[JX_AFNetworking alloc] GET:@"user/regist.do" parameters:_parameters success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
        if(success)
        {
            // 本地化数据
            [DD_UserModel setLocalUserInfo:data];
            // 更新当前权限状态
//            [regular UpdateRoot];
            // 更新友盟用户统计和渠道
            [regular updateProfileSignInWithPUID];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"rootChange" object:@"login"];
            _successblock(@"success");
            //            回到登录发起页面
            NSArray *controllers=self.navigationController.viewControllers;
            for (int i=0; i<controllers.count; i++) {
                id obj=controllers[i];
                if([obj isKindOfClass:[DD_LoginViewController class]])
                {
                    if(i>0)
                    {
                        [self.navigationController popToViewController:controllers[i-1] animated:YES];
                    }
                }
            }
            
        }else
        {
            [self presentViewController:successAlert animated:YES completion:nil];
        }
    } failure:^(NSError *error, UIAlertController *failureAlert) {
        [self presentViewController:failureAlert animated:YES completion:nil];
    }];
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if(textField == _PSWTextfield)
    {
        
        [self registerAction];
    }
    return YES;
}
#pragma mark - Other
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [regular dismissKeyborad];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"DD_SetPSWViewController"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"DD_SetPSWViewController"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
