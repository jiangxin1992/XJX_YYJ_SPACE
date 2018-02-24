//
//  DD_DDAYOffllineApplyViewController.m
//  YCOSPACE
//
//  Created by yyj on 2016/12/19.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_DDAYOffllineApplyViewController.h"

#import "DD_DDayDetailModel.h"

@interface DD_DDAYOffllineApplyViewController ()

@end

@implementation DD_DDAYOffllineApplyViewController
{
    UILabel *nickNameLabel;
    UITextField *phoneTextField;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self SomePrepare];
    [self UIConfig];
    [self SetState];
}
-(instancetype)initWithGoodsDetailModel:(DD_DDayDetailModel *)model WithUserInfo:(DD_UserModel *)userInfo WithBlock:(void (^)(NSString *type))block
{
    self=[super init];
    if(self)
    {
        _detailModel=model;
        _userInfo=userInfo;
        _block=block;
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
    self.navigationItem.titleView=[regular returnNavView:NSLocalizedString(@"dday_offline_title", @"") withmaxwidth:200];
}
#pragma mark - UIConfig
-(void)UIConfig
{
    UILabel *nickNameTitleLabel=[UILabel getLabelWithAlignment:0 WithTitle:@"昵称" WithFont:15.0f WithTextColor:_define_black_color WithSpacing:0];
    [self.view addSubview:nickNameTitleLabel];
    [nickNameTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kEdge);
        make.top.mas_equalTo(kStatusBarAndNavigationBarHeight+12);
        make.height.mas_equalTo(32);
        make.width.mas_equalTo(60);
    }];
    
    nickNameLabel=[UILabel getLabelWithAlignment:0 WithTitle:@"" WithFont:13.0f WithTextColor:_define_light_gray_color1 WithSpacing:0];
    [self.view addSubview:nickNameLabel];
    [nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(nickNameTitleLabel.mas_right).with.offset(8);
        make.height.top.mas_equalTo(nickNameTitleLabel);
        make.right.mas_equalTo(-kEdge);
    }];
    
    UILabel *phoneTitleLabel=[UILabel getLabelWithAlignment:0 WithTitle:@"手机号" WithFont:15.0f WithTextColor:_define_black_color WithSpacing:0];
    [self.view addSubview:phoneTitleLabel];
    [phoneTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kEdge);
        make.top.mas_equalTo(nickNameLabel.mas_bottom).with.offset(12);
        make.height.mas_equalTo(32);
        make.width.mas_equalTo(60);
    }];
    
    UIView *leftview=[UIView getCustomViewWithColor:_define_white_color];
    leftview.frame=CGRectMake(0, 0, 8, 32);
    phoneTextField=[UITextField getTextFieldWithPlaceHolder:@" 请输入手机号" WithAlignment:0 WithFont:13.0f WithTextColor:_define_black_color WithLeftView:leftview WithRightView:nil WithSecureTextEntry:NO];
    [self.view addSubview:phoneTextField];
    [regular setBorder:phoneTextField];
    [phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-kEdge);
        make.left.mas_equalTo(phoneTitleLabel.mas_right).with.offset(0);
        make.height.mas_equalTo(32);
        make.centerY.mas_equalTo(phoneTitleLabel);
    }];
    
    UIButton *ApplyButton=[UIButton getCustomTitleBtnWithAlignment:0 WithFont:18.0f WithSpacing:0 WithNormalTitle:@"确定报名" WithNormalColor:_define_white_color WithSelectedTitle:nil WithSelectedColor:nil];
    [self.view addSubview:ApplyButton];
    ApplyButton.backgroundColor=_define_black_color;
    [ApplyButton addTarget:self action:@selector(applyAction) forControlEvents:UIControlEventTouchUpInside];
    [ApplyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(phoneTextField.mas_bottom).with.offset(65);
        make.centerX.mas_equalTo(self.view);
        make.width.mas_equalTo(240);
        make.height.mas_equalTo(45);
    }];
    
}
#pragma mark - SetState
-(void)SetState
{
    if(_detailModel)
    {
        nickNameLabel.text=_userInfo.nickName;
        phoneTextField.text=_userInfo.phone;
    }
}
-(void)applyAction
{
    if([NSString isNilOrEmpty:phoneTextField.text])
    {
        [self presentViewController:[regular alertTitle_Simple:NSLocalizedString(@"login_phone_null", @"")] animated:YES completion:nil];
    }else
    {
        if([regular phoneVerify:phoneTextField.text])
        {
            NSString *url=@"series/v1_0_7/joinSeries.do";
            [[JX_AFNetworking alloc] GET:url parameters:@{@"token":[DD_UserModel getToken],@"seriesId":_detailModel.s_id,@"joinPhone":phoneTextField.text} success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
                if(success)
                {
                    _detailModel.isJoin=[[data objectForKey:@"isJoin"] boolValue];
                    _detailModel.isQuotaLimt=[[data objectForKey:@"isQuotaLimt"] boolValue];
                    _detailModel.leftQuota=[[data objectForKey:@"leftQuota"] longLongValue];
                    _block(@"apply_success");
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
            [self presentViewController:[regular alertTitle_Simple:NSLocalizedString(@"login_phone_flase", @"")] animated:YES completion:nil];
        }
    }
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [regular dismissKeyborad];
}
#pragma mark - other
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
