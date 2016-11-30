//
//  DD_BodyViewController.m
//  DDAY
//
//  Created by yyj on 16/5/22.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_BodyViewController.h"

@interface DD_BodyViewController ()
//<UITextFieldDelegate>

@end

@implementation DD_BodyViewController
{
    UITextField *_heightTextfield;
    UITextField *_weightTextfield;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}
#pragma mark - 初始化
-(instancetype)initWithModel:(DD_UserModel *)usermodel WithBlock:(void (^)(DD_UserModel *model))block
{
    self=[super init];
    if(self)
    {
        _block=block;
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
-(void)PrepareData
{
    _heightTextfield=[[UITextField alloc] init];
    _weightTextfield=[[UITextField alloc] init];
}
-(void)PrepareUI
{
    DD_NavBtn *confirmBtn=[DD_NavBtn getNavBtnIsLeft:NO WithSize:CGSizeMake(24, 24) WithImgeStr:@"System_Confirm"];
//    [confirmBtn addTarget:self action:@selector(DoneAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:confirmBtn];
    [confirmBtn bk_addEventHandler:^(id sender) {
        [self DoneAction];
    } forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark - UIConfig
-(void)UIConfig
{
    UIView *lastView=nil;
    for (int i=0; i<2; i++) {
        UILabel *titleLabel=[UILabel getLabelWithAlignment:0 WithTitle:i==0?@"身高":@"体重" WithFont:15.0f WithTextColor:nil WithSpacing:0];
        [self.view addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(kEdge);
            if(lastView)
            {
                make.top.mas_equalTo(lastView.mas_bottom).with.offset(15);
            }else
            {
                make.top.mas_equalTo(kNavHeight+15);
            }
            make.width.mas_equalTo(45);
            make.height.mas_equalTo(32);
        }];
        
        UITextField *textfield=i==0?_heightTextfield:_weightTextfield;
        [self.view addSubview:textfield];
        textfield.textColor=_define_black_color;
        textfield.placeholder=i==0?@"快来填写身高(cm)吧":@"快来填写体重(kg)吧";
        textfield.font=[regular getFont:13.0f];
        textfield.textAlignment=0;
        textfield.keyboardType=UIKeyboardTypeNumberPad;
//        textfield.delegate=self;
        [textfield setBk_shouldReturnBlock:^BOOL(UITextField *textfield) {
            [textfield resignFirstResponder];
            return YES;
        }];
        textfield.returnKeyType=UIReturnKeyDone;
        textfield.clearButtonMode=UITextFieldViewModeAlways;
        [regular setBorder:textfield];
        textfield.text=i==0?_usermodel.height:_usermodel.weight;
        
        textfield.leftViewMode=UITextFieldViewModeAlways;
        textfield.leftView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 11, 32)];
        [textfield becomeFirstResponder];
        
        [textfield mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(titleLabel.mas_right).with.offset(0);
            make.right.mas_equalTo(-kEdge);
            make.top.mas_equalTo(titleLabel);
            make.height.mas_equalTo(titleLabel);
        }];
        lastView=titleLabel;
    }
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
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (BOOL)textFieldShouldReturn:(UITextField *)textField
//{
//    [textField resignFirstResponder];
//    return YES;
//}
@end
