//
//  DD_LoginViewController.m
//  DDAY
//
//  Created by yyj on 16/5/21.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_LoginViewController.h"

#import <ShareSDK/ShareSDK.h>

#import "DD_RegisterViewController.h"
#import "DD_forgetViewController.h"
#import "DD_LoginTextView.h"

@interface DD_LoginViewController ()<UITextFieldDelegate>

@end

@implementation DD_LoginViewController
{
    UITextField *_phoneTextfiled;
    UITextField *_PSWTextfiled;
    UIButton *wechatBtn;
    UIButton *qqBtn;
    UIButton *sinaBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self SomePrepare];
    [self UIConfig];
}
#pragma mark - 初始化
-(instancetype)initWithBlock:(void (^)(NSString *type))successblock
{
    self=[super init];
    if(self)
    {
        _successblock=successblock;
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
-(void)PrepareUI{}
#pragma mark - UIConfig
-(void)UIConfig
{
    DD_NavBtn *backBtn=[DD_NavBtn getBackBtn];
    [self.view addSubview:backBtn];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame=CGRectMake(10, kStatusBarHeight, CGRectGetWidth(backBtn.frame), CGRectGetHeight(backBtn.frame));
    [backBtn setEnlargeEdge:20];
    
    UIImageView *Logo=[UIImageView getImgWithImageStr:@"Login_Space_Logo"];
    [self.view addSubview:Logo];
    [Logo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo((IsPhone6_gt?103:kIPhone5s?48:30)+kStatusBarHeight);
        make.centerX.mas_equalTo(self.view);
        make.width.and.height.mas_equalTo(72);
    }];
    _phoneTextfiled=[UITextField getTextFieldWithPlaceHolder:@"输入手机号" WithAlignment:0 WithFont:15.0f WithTextColor:nil WithLeftView:[[DD_LoginTextView alloc] initWithFrame:CGRectMake(0, 0, 35, 50) WithImgStr:@"Login_Phone" WithSize:CGSizeMake(17, 27) isLeft:YES WithBlock:^(NSString *type) {
        
    }] WithRightView:nil WithSecureTextEntry:NO];
    [self.view addSubview:_phoneTextfiled];
    _phoneTextfiled.returnKeyType=UIReturnKeyDone;
    _phoneTextfiled.keyboardType=UIKeyboardTypeNumberPad;
    _phoneTextfiled.delegate=self;
    [_phoneTextfiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(50);
        make.right.mas_equalTo(-50);
        make.height.mas_equalTo(50);
        make.top.mas_equalTo(Logo.mas_bottom).with.offset(IsPhone5_gt?28:22);
    }];
    _PSWTextfiled=[UITextField getTextFieldWithPlaceHolder:@"输入密码" WithAlignment:0 WithFont:15.0f WithTextColor:nil WithLeftView:[[DD_LoginTextView alloc] initWithFrame:CGRectMake(0, 0, 35, 50) WithImgStr:@"Login_PWD" WithSize:CGSizeMake(17, 27) isLeft:YES WithBlock:^(NSString *type) {
        
    }] WithRightView:[[DD_LoginTextView alloc] initWithFrame:CGRectMake(0, 0, 35, 50) WithImgStr:@"Login_Eye" WithSize:CGSizeMake(21, 14) isLeft:NO WithBlock:^(NSString *type) {
        if([type isEqualToString:@"click"])
        {
            _PSWTextfiled.secureTextEntry=!_PSWTextfiled.isSecureTextEntry;
        }
    }] WithSecureTextEntry:YES];
    [self.view addSubview:_PSWTextfiled];
    _PSWTextfiled.returnKeyType=UIReturnKeyGo;
    _PSWTextfiled.delegate=self;
    [_PSWTextfiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(50);
        make.right.mas_equalTo(-50);
        make.height.mas_equalTo(50);
        make.top.mas_equalTo(_phoneTextfiled.mas_bottom).with.offset(IsPhone5_gt?18:11);
    }];
    
    UIButton *retrieveBtn=[UIButton getCustomTitleBtnWithAlignment:1 WithFont:13.0f WithSpacing:0 WithNormalTitle:@"忘记密码" WithNormalColor:_define_light_gray_color WithSelectedTitle:nil WithSelectedColor:nil];
    [self.view addSubview:retrieveBtn];
    [retrieveBtn addTarget:self action:@selector(fogetPWD) forControlEvents:UIControlEventTouchUpInside];
    [retrieveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_PSWTextfiled.mas_bottom).with.offset(5);
        make.height.mas_equalTo(30);
        make.left.mas_equalTo(50);
        make.width.mas_equalTo(100);
    }];
    
    UIButton *registerBtn=[UIButton getCustomTitleBtnWithAlignment:2 WithFont:13.0f WithSpacing:0 WithNormalTitle:@"还没有账号" WithNormalColor:_define_light_gray_color WithSelectedTitle:nil WithSelectedColor:nil];
    [self.view addSubview:registerBtn];
    [registerBtn addTarget:self action:@selector(CreateCount) forControlEvents:UIControlEventTouchUpInside];
    [registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_PSWTextfiled.mas_bottom).with.offset(5);
        make.height.mas_equalTo(30);
        make.right.mas_equalTo(-50);
        make.width.mas_equalTo(100);
    }];
    
    UIButton *login=[UIButton getCustomTitleBtnWithAlignment:0 WithFont:18.0f WithSpacing:0 WithNormalTitle:@"登    录" WithNormalColor:_define_white_color WithSelectedTitle:nil WithSelectedColor:nil];
    
    login.backgroundColor=_define_black_color;
    [self.view addSubview:login];
    [login addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    [login mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(50);
        make.right.mas_equalTo(-50);
        make.top.mas_equalTo(_PSWTextfiled.mas_bottom).with.offset(IsPhone5_gt?65:47);
        make.height.mas_equalTo(40);
    }];
    
    UILabel *otherlabel=[UILabel getLabelWithAlignment:1 WithTitle:@"更多登录方式" WithFont:13.0f WithTextColor:nil WithSpacing:0];
    [self.view addSubview:otherlabel];
    [otherlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(login.mas_bottom).with.offset(IsPhone5_gt?39:19);
        make.centerX.mas_equalTo(self.view);
        make.height.mas_equalTo(28);
        make.width.mas_equalTo(100);
    }];

    
    qqBtn=[UIButton getCustomBackImgBtnWithImageStr:@"Login_QQ" WithSelectedImageStr:nil];
    [self.view addSubview:qqBtn];
    [qqBtn addTarget:self action:@selector(QQLogin) forControlEvents:UIControlEventTouchUpInside];
    [qqBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(28);
        make.height.mas_equalTo(23);
        make.top.mas_equalTo(otherlabel.mas_bottom).with.offset(20);
        make.centerX.mas_equalTo(self.view);
    }];
    [qqBtn setEnlargeEdge:10.0f];
    
    
    wechatBtn=[UIButton getCustomBackImgBtnWithImageStr:@"Login_Wechat" WithSelectedImageStr:nil];
    [self.view addSubview:wechatBtn];
    [wechatBtn addTarget:self action:@selector(WechatLogin) forControlEvents:UIControlEventTouchUpInside];
    [wechatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(qqBtn);
        make.height.mas_equalTo(qqBtn);
        make.top.mas_equalTo(otherlabel.mas_bottom).with.offset(20);
        make.right.mas_equalTo(qqBtn.mas_left).with.offset(IsPhone6_gt?-49:-21);
    }];
    [wechatBtn setEnlargeEdge:10.0f];
    
    
    
    sinaBtn=[UIButton getCustomBackImgBtnWithImageStr:@"Login_Sina" WithSelectedImageStr:nil];
    [self.view addSubview:sinaBtn];
    [sinaBtn addTarget:self action:@selector(SinaLogin) forControlEvents:UIControlEventTouchUpInside];
    [sinaBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(qqBtn);
        make.height.mas_equalTo(qqBtn);
        make.top.mas_equalTo(otherlabel.mas_bottom).with.offset(20);
        
        make.left.mas_equalTo(qqBtn.mas_right).with.offset(IsPhone6_gt?49:21);
    }];
    [sinaBtn setEnlargeEdge:10.0f];
    
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
 * 登录验证
 */
-(void)loginAction
{
    if([NSString isNilOrEmpty:_phoneTextfiled.text]||[NSString isNilOrEmpty:_PSWTextfiled.text])
    {
        [self presentViewController:[regular alertTitle_Simple:NSLocalizedString(@"content_empty", @"")] animated:YES completion:nil];
    }else
    {
        if([regular phoneVerify:_phoneTextfiled.text])
        {
            if([regular checkPassword:_PSWTextfiled.text])
            {
                [self enterloginAction];
            }else
            {

                [self presentViewController:[regular alertTitle_Simple:@"用户名或密码错误"] animated:YES completion:nil];
            }
            
        }else
        {
            [self presentViewController:[regular alertTitle_Simple:NSLocalizedString(@"login_phone_flase", @"")] animated:YES completion:nil];
        }
    }
}

/**
 * 登录
 */
-(void)enterloginAction
{
    NSDictionary *parameters=@{@"phone":_phoneTextfiled.text,@"password":[regular md5:_PSWTextfiled.text]};
    [[JX_AFNetworking alloc] GET:@"user/login.do" parameters:parameters success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
        if(success)
        {
            [DD_UserModel setLocalUserInfo:data];
            // 更新当前权限状态
//            [regular UpdateRoot];
            // 更新友盟用户统计和渠道
            [regular updateProfileSignInWithPUID];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"rootChange" object:@"login"];
            _successblock(@"success");
            [self.navigationController popViewControllerAnimated:YES];
        }else
        {
            [self presentViewController:successAlert animated:YES completion:nil];
        }
    } failure:^(NSError *error, UIAlertController *failureAlert) {
        [self presentViewController:failureAlert animated:YES completion:nil];
    }];
}
/**
 * 忘记密码
 */
-(void)fogetPWD
{
    [self.navigationController pushViewController:[[DD_forgetViewController alloc] init] animated:YES];
    
}

/**
 * 注册账号
 */
-(void)CreateCount
{
    DD_RegisterViewController *_Register=[[DD_RegisterViewController alloc]initWithBlock:^(NSString *type) {
        //        注册成功
        _successblock(type);
    }];
    [self.navigationController pushViewController:_Register animated:YES];
}

/**
 * 三方授权
 */
-(void)GetUserInfo:(SSDKPlatformType)platformType
{
    [ShareSDK cancelAuthorize:platformType];
    [ShareSDK getUserInfo:platformType
           onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
     {

         if (state == SSDKResponseStateSuccess)
         {
             NSString *url=nil;
             NSString *_icon=nil;
             if(platformType==SSDKPlatformTypeWechat)
             {
                 url=@"user/weiXinLogin.do";
                 _icon=user.icon;
             }else if(platformType==SSDKPlatformSubTypeQZone)
             {
                 url=@"user/sinaLogin.do";
                 if([user.rawData objectForKey:@"figureurl_qq_2"])
                 {
                     _icon=[user.rawData objectForKey:@"figureurl_qq_2"];
                 }else
                 {
                     _icon=user.icon;
                 }
                 
             }else if(platformType==SSDKPlatformTypeSinaWeibo)
             {
                 url=@"user/qqLogin.do";
                 if([user.rawData objectForKey:@"avatar_hd"])
                 {
                     _icon=[user.rawData objectForKey:@"avatar_hd"];
                 }else
                 {
                     _icon=user.icon;
                 }
             }
             
             NSString *_works=nil;
             if(user.works==nil)
             {
                 _works=@"";
             }else if(user.works.count==0)
             {
                 _works=@"";
             }else
             {
                 _works=[user.works objectAtIndex:0];
             }
             NSString *_aboutMe=nil;
             if([NSString isNilOrEmpty:user.aboutMe])
             {
                 _aboutMe=@"";
             }else
             {
                 _aboutMe=user.aboutMe;
             }
             
             NSDictionary *_parameters=@{@"uid":user.uid,@"nickname":user.nickname,@"icon":_icon,@"gender":[NSNumber numberWithInteger:user.gender],@"aboutMe":_aboutMe,@"works":_works};
             [[JX_AFNetworking alloc] GET:url parameters:_parameters success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
                 if(success)
                 {
                     [DD_UserModel setLocalUserInfo:data];
                     // 更新当前权限状态
//                     [regular UpdateRoot];
                     // 更新友盟用户统计和渠道
                     [regular updateProfileSignInWithPUID];
                     [[NSNotificationCenter defaultCenter] postNotificationName:@"rootChange" object:@"login"];
                     _successblock(@"success");
                     
                     [self.navigationController popViewControllerAnimated:YES];
                 }else
                 {
                     [self presentViewController:successAlert animated:YES completion:nil];
                 }
             } failure:^(NSError *error, UIAlertController *failureAlert) {
                 [self presentViewController:failureAlert animated:YES completion:nil];
             }];
         }
         else
         {
             if(error)
             {
                  [self presentViewController:[regular alertTitle_Simple:NSLocalizedString(error.description, @"")] animated:YES completion:nil];
             }
         }
     }];
}
/**
 * Wechat
 */
-(void)WechatLogin
{
    [self GetUserInfo:SSDKPlatformTypeWechat];
}

/**
 * QQ
 */
-(void)QQLogin
{
    [self GetUserInfo:SSDKPlatformSubTypeQZone];
}

/**
 * Sina
 */
-(void)SinaLogin
{
    [self GetUserInfo:SSDKPlatformTypeSinaWeibo];
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if(textField == _PSWTextfiled)
    {
        [self loginAction];
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
}



@end
