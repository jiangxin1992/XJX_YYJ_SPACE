//
//  DD_SexViewController.m
//  YCO SPACE
//
//  Created by yyj on 16/9/1.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_SexViewController.h"

#import "DD_CustomBtn.h"

@interface DD_SexViewController ()

@end

@implementation DD_SexViewController
{
    DD_CustomBtn *maleBtn;
    DD_CustomBtn *femaleBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self SomePrepare];
    [self UIConfig];
}
#pragma mark - 初始化
-(instancetype)initWithModel:(DD_UserModel *)usermodel WithSex:(NSString *)sex WithBlock:(void (^)(DD_UserModel *model))block
{
    
    self=[super init];
    if(self)
    {
        _block=block;
        _sex=sex;
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
#pragma mark - UIConfig
-(void)UIConfig
{
    maleBtn=[DD_CustomBtn getCustomTitleBtnWithAlignment:1 WithFont:15.0f WithSpacing:0 WithNormalTitle:@"男" WithNormalColor:_define_black_color WithSelectedTitle:@"男" WithSelectedColor:_define_white_color];
    [self.view addSubview:maleBtn];
    maleBtn.type=@"male";
    [regular setBorder:maleBtn];
    [maleBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 9, 0, 0)];
    [maleBtn addTarget:self action:@selector(changeSexAction:) forControlEvents:UIControlEventTouchUpInside];
    [maleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kEdge);
        make.right.mas_equalTo(-kEdge);
        make.top.mas_equalTo(15+kNavHeight);
        make.height.mas_equalTo(32);
    }];
    
    femaleBtn=[DD_CustomBtn getCustomTitleBtnWithAlignment:1 WithFont:15.0f WithSpacing:0 WithNormalTitle:@"女" WithNormalColor:_define_black_color WithSelectedTitle:@"女" WithSelectedColor:_define_white_color];
    [self.view addSubview:femaleBtn];
    [regular setBorder:femaleBtn];
    [femaleBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 9, 0, 0)];
    femaleBtn.type=@"female";
    [femaleBtn addTarget:self action:@selector(changeSexAction:) forControlEvents:UIControlEventTouchUpInside];
    [femaleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kEdge);
        make.right.mas_equalTo(-kEdge);
        make.top.mas_equalTo(maleBtn.mas_bottom).with.offset(15);
        make.height.mas_equalTo(maleBtn);
    }];
    
    
    if([NSString isNilOrEmpty:_sex])
    {
        maleBtn.selected=NO;
        maleBtn.backgroundColor=_define_white_color;
        femaleBtn.selected=NO;
        femaleBtn.backgroundColor=_define_white_color;
    }else
    {
        if([self.sex integerValue]==0)
        {
            maleBtn.selected=YES;
            maleBtn.backgroundColor=_define_black_color;
            femaleBtn.selected=NO;
            femaleBtn.backgroundColor=_define_white_color;
            
        }else if([self.sex integerValue]==1)
        {
            maleBtn.selected=NO;
            maleBtn.backgroundColor=_define_white_color;
            femaleBtn.selected=YES;
            femaleBtn.backgroundColor=_define_black_color;
        }else
        {
            maleBtn.selected=NO;
            maleBtn.backgroundColor=_define_white_color;
            femaleBtn.selected=NO;
            femaleBtn.backgroundColor=_define_white_color;
        }
    }
}

#pragma mark - SomeAction
-(void)setTitle:(NSString *)title
{
    self.navigationItem.titleView=[regular returnNavView:title withmaxwidth:180];
}

-(void)changeSexAction:(DD_CustomBtn *)btn
{
    NSString *_keystr=nil;
    if([btn.type isEqualToString:@"female"])
    {
//        女
        _keystr=@"1";
    }else if([btn.type isEqualToString:@"male"])
    {
//        男
        _keystr=@"0";
    }else
    {
        _keystr=@"2";
    }
    NSDictionary *_parameters=@{@"gender":_keystr,@"token":[DD_UserModel getToken]};
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

#pragma mark - Other
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"DD_SexViewController"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"DD_SexViewController"];
}


@end
