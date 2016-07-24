//
//  DD_BodyViewController.m
//  DDAY
//
//  Created by yyj on 16/5/22.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_BodyViewController.h"

@interface DD_BodyViewController ()

@end

@implementation DD_BodyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _heightTextfield.text=_usermodel.height;
    _weightTextfield.text=_usermodel.weight;
}
#pragma mark - 初始化
-(instancetype)initWithModel:(DD_UserModel *)usermodel WithBlock:(void (^)(DD_UserModel *model))block
{
    self=[super init];
    if(self)
    {
        _block=block;
        _usermodel=usermodel;
    }
    return self;
}
#pragma mark - SomeAction
- (IBAction)saveAction:(id)sender {
    if([NSString isNilOrEmpty:_heightTextfield.text]||[NSString isNilOrEmpty:_weightTextfield.text])
    {
        [self presentViewController:[regular alertTitle_Simple:NSLocalizedString(@"content_empty", @"")] animated:YES completion:nil];
    }else
    {
        if([regular numberVerift:_heightTextfield.text]&&[regular numberVerift:_weightTextfield.text])
        {
            NSDictionary *_parameters=@{@"height":_heightTextfield.text,@"weight":_weightTextfield.text,@"token":[DD_UserModel getToken]};
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
        }else
        {
            [self presentViewController:[regular alertTitle_Simple:NSLocalizedString(@"right_format", @"")] animated:YES completion:nil];
        }
        
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
    [[DD_CustomViewController sharedManager] tabbarHide];
    [MobClick beginLogPageView:@"DD_BodyViewController"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"DD_BodyViewController"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
