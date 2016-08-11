
//
//  DD_AlertViewController.m
//  DDAY
//
//  Created by yyj on 16/5/22.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_AlertViewController.h"

@interface DD_AlertViewController ()

@end

@implementation DD_AlertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self SomePrepare]; 
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
#pragma mark - SomePrepare
-(void)SomePrepare
{
    [self PrepareData];
    [self PrepareUI];
}
-(void)PrepareData{}
-(void)PrepareUI{}

#pragma mark - SomeAction
/**
 * 保存
 */
- (IBAction)SaveAction:(id)sender {

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
-(void)setContent:(NSString *)content
{
    _content=content;
    _inputTextfield.text=_content;
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
