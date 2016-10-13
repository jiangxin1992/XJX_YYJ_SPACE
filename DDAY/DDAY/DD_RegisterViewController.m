//
//  DD_RegisterViewController.m
//  DDAY
//
//  Created by yyj on 16/5/21.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_RegisterViewController.h"

#import "DD_SetPSWViewController.h"
#import "DD_ProtocolViewController.h"

#import "DD_LoginTextView.h"

@interface DD_RegisterViewController ()<UITextFieldDelegate>

@end

@implementation DD_RegisterViewController
{
    dispatch_source_t _timer;
    UITextField *_phoneTextfield;
    UITextField *_codeTextfield;
    UIButton *_yanzhengBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self UIConfig];
}
#pragma mark - 初始化
-(instancetype)initWithParameters:(NSDictionary *)parameters WithThirdPartLogin:(NSInteger )thirdPartLogin WithBlock:(void (^)(NSString *type))successblock
{
    self=[super init];
    if(self)
    {
        _successblock=successblock;
        _parameters=parameters;
        _thirdPartLogin=thirdPartLogin;
    }
    return self;
}
-(void)UIConfig
{
    DD_NavBtn *backBtn=[DD_NavBtn getBackBtn];
    [self.view addSubview:backBtn];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame=CGRectMake(10, kStatusBarHeight, CGRectGetWidth(backBtn.frame), CGRectGetHeight(backBtn.frame));
    [backBtn setEnlargeEdge:20];
    
    UILabel *title=[UILabel getLabelWithAlignment:1 WithTitle:@"注册账号" WithFont:IsPhone6_gt?18.0f:15.0f WithTextColor:nil WithSpacing:0];
    title.font=[regular getSemiboldFont:IsPhone6_gt?18.0f:15.0f];
    [self.view addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(19+kStatusBarHeight);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(19);
        make.centerX.mas_equalTo(self.view);
    }];
    
    _phoneTextfield=[UITextField getTextFieldWithPlaceHolder:@"输入手机号" WithAlignment:0 WithFont:15.0f WithTextColor:nil WithLeftView:[[DD_LoginTextView alloc] initWithFrame:CGRectMake(0, 0, 35, 50) WithImgStr:@"Login_Phone" WithSize:CGSizeMake(17, 27) isLeft:YES WithBlock:^(NSString *type) {
        
    }] WithRightView:nil WithSecureTextEntry:NO];
    [self.view addSubview:_phoneTextfield];
    _phoneTextfield.keyboardType=UIKeyboardTypeNumberPad;
    _phoneTextfield.returnKeyType=UIReturnKeyDone;
    _phoneTextfield.delegate=self;
    [_phoneTextfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(50);
        make.right.mas_equalTo(-50);
        make.height.mas_equalTo(50);
        make.top.mas_equalTo(self.view).with.offset((IsPhone6_gt?204:kIPhone5s?150:126)+kStatusBarHeight);
    }];

    
    UIView *_yanzheng=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 55, 50)];
    _yanzhengBtn=[UIButton getCustomTitleBtnWithAlignment:0 WithFont:13.0f WithSpacing:0 WithNormalTitle:@"验证" WithNormalColor:_define_light_gray_color WithSelectedTitle:nil WithSelectedColor:nil];
    [_yanzheng addSubview:_yanzhengBtn];
    _yanzhengBtn.layer.masksToBounds=YES;
    _yanzhengBtn.layer.borderColor=[_define_black_color CGColor];
    _yanzhengBtn.layer.borderWidth=1;
    [_yanzhengBtn addTarget:self action:@selector(getCodeAction) forControlEvents:UIControlEventTouchUpInside];
    [_yanzhengBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_yanzheng);
        make.height.mas_equalTo(23);
        make.right.and.left.mas_equalTo(0);
    }];
    
    
    _codeTextfield=[UITextField getTextFieldWithPlaceHolder:@"输入验证码" WithAlignment:0 WithFont:15.0f WithTextColor:nil WithLeftView:[[DD_LoginTextView alloc] initWithFrame:CGRectMake(0, 0, 35, 50) WithImgStr:@"Login_CAPTCHA" WithSize:CGSizeMake(17, 27) isLeft:YES WithBlock:^(NSString *type) {
        
    }] WithRightView:_yanzheng WithSecureTextEntry:NO];
    [self.view addSubview:_codeTextfield];
    _codeTextfield.returnKeyType=UIReturnKeyNext;
    _codeTextfield.delegate=self;
    [_codeTextfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(50);
        make.right.mas_equalTo(-50);
        make.height.mas_equalTo(_phoneTextfield);
        make.top.mas_equalTo(_phoneTextfield.mas_bottom).with.offset(IsPhone5_gt?18:11);
    }];

    UIButton *registerBtn=[UIButton getCustomTitleBtnWithAlignment:0 WithFont:18.0f WithSpacing:20.0f WithNormalTitle:@"验    证" WithNormalColor:_define_white_color WithSelectedTitle:nil WithSelectedColor:nil];
    registerBtn.backgroundColor=_define_black_color;
    [self.view addSubview:registerBtn];
    [registerBtn addTarget:self action:@selector(verifyAction) forControlEvents:UIControlEventTouchUpInside];
    [registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(50);
        make.right.mas_equalTo(-50);
        make.height.mas_equalTo(40);
        make.top.mas_equalTo(_codeTextfield.mas_bottom).with.offset(IsPhone5_gt?65:47);
    }];
    
    UIButton *ProtocolBtn=[UIButton getCustomTitleBtnWithAlignment:0 WithFont:13.0f WithSpacing:0 WithNormalTitle:@"" WithNormalColor:_define_light_gray_color WithSelectedTitle:nil WithSelectedColor:nil];
    [self.view addSubview:ProtocolBtn];
    [ProtocolBtn addTarget:self action:@selector(ProtocolAction) forControlEvents:UIControlEventTouchUpInside];
    [ProtocolBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kEdge);
        make.right.mas_equalTo(-kEdge);
        make.bottom.mas_equalTo(-25);
        make.height.mas_equalTo(40);
    }];
    //下划线
    NSString *protocolBtnStr = @"注册表示您已经同意\"YCO SPACE服务协议\"";
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:protocolBtnStr];
    NSRange range = [protocolBtnStr rangeOfString:@"\"YCO SPACE服务协议\""];
    if(range.location != NSNotFound){
        NSDictionary *linkAttributes = @{NSForegroundColorAttributeName: [UIColor colorWithHexString:@"47a3dc"],
                                        
                                         NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};
        [attributedString addAttributes:linkAttributes range:range];
    }
    [ProtocolBtn setAttributedTitle:attributedString forState:UIControlStateNormal];
}
#pragma mark - SomeAction
-(void)ProtocolAction
{
    [self.navigationController pushViewController:[[DD_ProtocolViewController alloc] init] animated:YES];
}
/**
 * 计时
 */
-(void)startTime{
    __block int timeout=59; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout==0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [_yanzhengBtn setTitle:@"验证" forState:UIControlStateNormal];
                _yanzhengBtn.userInteractionEnabled = YES;
                [_yanzhengBtn setTitleColor:_define_black_color forState:UIControlStateNormal];
            });
        }else{
            //            int minutes = timeout / 60;
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                JXLOG(@"____%@",strTime);
                [_yanzhengBtn setTitle:[NSString stringWithFormat:@"%@s",strTime] forState:UIControlStateNormal];
                _yanzhengBtn.userInteractionEnabled = NO;
                [_yanzhengBtn setTitleColor:_define_light_gray_color forState:UIControlStateNormal];
                timeout--;
            });
        }
    });
    dispatch_resume(_timer);
    
}
/**
 * 获取验证码
 */
-(void)getCodeAction
{
    if([NSString isNilOrEmpty:_phoneTextfield.text])
    {
        [self presentViewController:[regular alertTitle_Simple:NSLocalizedString(@"login_phone_null", @"")] animated:YES completion:nil];
    }else if(![regular phoneVerify:_phoneTextfield.text])
    {
        [self presentViewController:[regular alertTitle_Simple:NSLocalizedString(@"login_phone_flase", @"")] animated:YES completion:nil];
    }else
    {
        NSDictionary *__parameters=@{@"phone":_phoneTextfield.text,@"type":@"register"};
        [[JX_AFNetworking alloc] GET:@"user/sendVerifyCode.do" parameters:__parameters success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
            if(success)
            {
                [self startTime];
            }else
            {
                [self presentViewController:successAlert animated:YES completion:nil];
            }
        } failure:^(NSError *error, UIAlertController *failureAlert) {
            [self presentViewController:failureAlert animated:YES completion:nil];
        }];
    }
}

/**
 * 验证验证
 */
-(void)verifyAction
{
    if([NSString isNilOrEmpty:_phoneTextfield.text]||[NSString isNilOrEmpty:_codeTextfield.text])
    {
        [self presentViewController:[regular alertTitle_Simple:NSLocalizedString(@"content_empty", @"")] animated:YES completion:nil];
    }else
    {
        if([regular phoneVerify:_phoneTextfield.text])
        {
            if([regular codeVerify:_codeTextfield.text])
            {
                [self enterVerifyAction];
            }else
            {
                [self presentViewController:[regular alertTitle_Simple:NSLocalizedString(@"login_code_flase", @"")] animated:YES completion:nil];
            }
        }else
        {
            [self presentViewController:[regular alertTitle_Simple:NSLocalizedString(@"login_phone_flase", @"")] animated:YES completion:nil];
        }
    }
}

/**
 * 验证
 */
-(void)enterVerifyAction
{
        NSDictionary *parameters=@{@"phone":_phoneTextfield.text,@"type":@"register",@"verifyCode":_codeTextfield.text};
        [[JX_AFNetworking alloc] GET:@"user/validateVerifyCode.do" parameters:parameters success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
            if(success)
            {
                DD_SetPSWViewController *_SetPSW=[[DD_SetPSWViewController alloc] initWithParameters:_parameters WithThirdPartLogin:_thirdPartLogin WithBlock:^(NSString *type) {
                    _successblock(type);
                }];
                _SetPSW.phone=_phoneTextfield.text;
                [self.navigationController pushViewController:_SetPSW animated:YES];
            }else
            {
                [self presentViewController:successAlert animated:YES completion:nil];
            }
        } failure:^(NSError *error, UIAlertController *failureAlert) {
            [self presentViewController:failureAlert animated:YES completion:nil];
        }];
}
/**
 * 返回
 */
-(void)backAction
{
    [regular dispatch_cancel:_timer];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if(textField == _codeTextfield)
    {
        [self verifyAction];
    }
    return YES;
}

#pragma mark - Other
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [regular dismissKeyborad];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
