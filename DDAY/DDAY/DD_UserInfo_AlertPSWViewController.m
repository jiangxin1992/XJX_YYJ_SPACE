
//
//  DD_UserInfo_AlertPSWViewController.m
//  DDAY
//
//  Created by yyj on 16/5/22.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_UserInfo_AlertPSWViewController.h"

@interface DD_UserInfo_AlertPSWViewController ()

@end

@implementation DD_UserInfo_AlertPSWViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
#pragma mark - SomeAction
/**
 * 修改验证
 */
- (IBAction)SaveAction:(id)sender {

    if([NSString isNilOrEmpty:_oldPSWTextfield.text]||[NSString isNilOrEmpty:_newpsw.text]||[NSString isNilOrEmpty:_repeat_newpsw.text])
    {
        [self presentViewController:[regular alertTitle_Simple:NSLocalizedString(@"content_empty", @"")] animated:YES completion:nil];
    }else
    {
        if([regular pswLengthVerify:_oldPSWTextfield.text]&&[regular pswLengthVerify:_newpsw.text]&&[regular pswLengthVerify:_repeat_newpsw.text])
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
            [self presentViewController:[regular alertTitle_Simple:NSLocalizedString(@"login_psw_length", @"")] animated:YES completion:nil];
        }
    }
}
/**
 * 修改
 */
-(void)enterSaveAction
{

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
    [[DD_CustomViewController sharedManager] tabbarHide];
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
