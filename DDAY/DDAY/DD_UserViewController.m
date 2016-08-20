//
//  DD_UserViewController.m
//  DDAY
//
//  Created by yyj on 16/5/20.
//  Copyright © 2016年 YYJ. All rights reserved.
//
#import "DD_UserViewController.h"

#import "DD_LoginViewController.h"
#import "DD_SetViewController.h"
#import "DD_OrderViewController.h"
#import "DD_DesignerHomePageViewController.h"
#import "DD_UserMainCollectViewController.h"
#import "DD_UserMessageViewController.h"
#import "DD_TarentoHomePageViewController.h"
#import "DD_FansViewController.h"
#import "DD_UserDDAYViewController.h"
#import "DD_ShowRoomViewController.h"

#import "DD_UserItemBtn.h"

#import "DD_UserTool.h"

@interface DD_UserViewController ()

@end

@implementation DD_UserViewController
{
    NSArray *_dataArr;
    NSArray *_imgDataArr;
    NSDictionary *_datadict;
    DD_UserModel *_usermodel;
    
    UIImageView *_userHeadImg;
    UILabel *_userName;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self SomePrepare];
    [self SetDataArr];
    [self UIConfig];
    [self RequestData];
}

#pragma mark - SomePrepare
-(void)SomePrepare
{
    [self hideBackNavBtn];
    [self PrepareData];
    [self PrepareUI];
}
-(void)PrepareData
{
    _datadict=[DD_UserTool getUserListMap];
}
-(void)PrepareUI
{
//    System_News
    DD_NavBtn *message=[DD_NavBtn getNavBtnIsLeft:NO WithSize:CGSizeMake(26, 24) WithImgeStr:@"System_NoNews"];
    [message addTarget:self action:@selector(messageAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:message];
}
#pragma mark - UIConfig
-(void)UIConfig
{
    UIButton *_headBack=[UIButton getCustomBtn];
    [self.view addSubview:_headBack];
    [_headBack addTarget:self action:@selector(pushLoginView) forControlEvents:UIControlEventTouchUpInside];
    [_headBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(97);
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(13+64);
    }];
    _headBack.layer.masksToBounds=YES;
    _headBack.layer.cornerRadius=97/2.0f;
    _headBack.layer.borderColor=[_define_black_color CGColor];
    _headBack.layer.borderWidth=3.5f;
    [_headBack setEnlargeEdgeWithTop:0 right:50 bottom:60 left:50];
    
    _userHeadImg=[UIImageView getCustomImg];
    [self.view addSubview:_userHeadImg];
    [_userHeadImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(83);
        make.center.mas_equalTo(_headBack);
    }];
    
    _userName=[UILabel getLabelWithAlignment:1 WithTitle:@"" WithFont:15.0f WithTextColor:nil WithSpacing:0];
    [self.view addSubview:_userName];
    _userName.font=[regular getSemiboldFont:15.0f];
    [_userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(_headBack.mas_bottom).with.offset(15);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(200);
    }];
    
    CGFloat _y_p=IsPhone6_gt?320:kIPhone5s?250:230;
    CGFloat _offset=kIiPhone6?25:15;
    CGFloat _bianju=kIiPhone6?43:33;
    CGFloat _width=(ScreenWidth-_bianju*2)/2.0f;
    for (int i=0; i<_dataArr.count; i++) {
        DD_UserItemBtn *item=[DD_UserItemBtn getUserItemBtnWithFrame:CGRectMake(_bianju+(_width+_offset)*(i%2), _y_p+60*(i/2), i%2?_width-_offset:_width, 60) WithImgSize:CGSizeMake(21, 21) WithImgeStr:_imgDataArr[i] WithTitle:[_datadict objectForKey:[_dataArr objectAtIndex:i]]];
        [self.view addSubview:item];
        item.type=[_dataArr objectAtIndex:i];
        [item addTarget:self action:@selector(itemAction:) forControlEvents:UIControlEventTouchUpInside];
    }
}
#pragma mark - RequestData
-(void)RequestData
{
    if([DD_UserModel isLogin])
    {
        [[JX_AFNetworking alloc] GET:@"user/queryUserInfo.do" parameters:@{@"token":[DD_UserModel getToken]} success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
            if(success)
            {
                
                if(_userHeadImg)
                {
                    [self MonitorRootChangeAction];
                    for (UIView *view in self.view.subviews) {
                        [view removeFromSuperview];
                    }
                    
                    [self UIConfig];
                }
                _usermodel=[DD_UserModel getUserModel:[data objectForKey:@"user"]];
                if(_usermodel)
                {
                    if([_usermodel.userType integerValue]!=[DD_UserModel getUserType])
                    {
                        [regular UpdateRoot];
                    }
                    _userName.text=_usermodel.nickName;
                    [_userHeadImg JX_loadImageUrlStr:_usermodel.head WithSize:800 placeHolderImageName:nil radius:83/2.0f];
                }
            }else
            {
                [self presentViewController:successAlert animated:YES completion:nil];
            }
        } failure:^(NSError *error, UIAlertController *failureAlert) {
            [self presentViewController:failureAlert animated:YES completion:nil];
        }];
    }else
    {
        _userName.text=@"点击登录";
    }
}
#pragma mark - SomeAction
/**
 * 点击事件
 */
-(void)itemAction:(DD_UserItemBtn *)btn
{
    if([btn.type isEqualToString:@"homepage"])
    {
        [self pushHomePageView];
    }else if([btn.type isEqualToString:@"fans"])
    {
        [self PushFansView];
    }else if([btn.type isEqualToString:@"order"])
    {
        [self PushOrderView];
    }else if([btn.type isEqualToString:@"conference"])
    {
        [self PushConferenceView];
    }else if([btn.type isEqualToString:@"collection"])
    {
        [self PushCollectionView];
    }else if([btn.type isEqualToString:@"set"])
    {
        [self setAction];
    }else if([btn.type isEqualToString:@"showroom"])
    {
        [self PushShowRoom];
    }
}
/**
 * 跳转体验店页面
 */
-(void)PushShowRoom
{
    [self.navigationController pushViewController:[DD_ShowRoomViewController new] animated:YES];
}
/**
 * 跳转订单页面
 */
-(void)PushOrderView
{
    if([DD_UserModel isLogin])
    {
        [self.navigationController pushViewController:[DD_OrderViewController new] animated:YES];
    }else
    {
        [self presentViewController:[regular alertTitleCancel_Simple:NSLocalizedString(@"login_first", @"") WithBlock:^{
            [self pushLoginView];
        }] animated:YES completion:nil];
    }
}
/**
 * 跳转粉丝页面
 */
-(void)PushFansView
{
    if([DD_UserModel isLogin])
    {
        [self.navigationController pushViewController:[[DD_FansViewController alloc] initWithBlock:nil] animated:YES];
    }else
    {
        [self presentViewController:[regular alertTitleCancel_Simple:NSLocalizedString(@"login_first", @"") WithBlock:^{
            [self pushLoginView];
        }] animated:YES completion:nil];
    }
    
}
/**
 * 跳转收藏页面
 */
-(void)PushCollectionView
{
    if([DD_UserModel isLogin])
    {
        [self.navigationController pushViewController:[[DD_UserMainCollectViewController alloc] init] animated:YES];
    }else
    {
        [self presentViewController:[regular alertTitleCancel_Simple:NSLocalizedString(@"login_first", @"") WithBlock:^{
            [self pushLoginView];
        }] animated:YES completion:nil];
    }
}
/**
 * 跳转发布会页面
 */
-(void)PushConferenceView
{
    if([DD_UserModel isLogin])
    {
        [self.navigationController pushViewController:[[DD_UserDDAYViewController alloc] init] animated:YES];
    }else
    {
        [self presentViewController:[regular alertTitleCancel_Simple:NSLocalizedString(@"login_first", @"") WithBlock:^{
            [self pushLoginView];
        }] animated:YES completion:nil];
    }
}
/**
 * 跳转个人主页
 */
-(void)pushHomePageView
{
    if([DD_UserModel isLogin])
    {
        //        1 管理员 2 设计师 3 普通用户 4 达人
        if([DD_UserModel getUserType]==2)
        {
            //        我的主页
            DD_DesignerHomePageViewController *_DesignerHomePage=[[DD_DesignerHomePageViewController alloc] init];
            _DesignerHomePage.designerId=_usermodel.u_id;
            [self.navigationController pushViewController:_DesignerHomePage animated:YES];
        }else if([DD_UserModel getUserType]==4)
        {
            [self.navigationController pushViewController:[[DD_TarentoHomePageViewController alloc] initWithUserId:_usermodel.u_id] animated:YES];
        }
    }else
    {
        [self presentViewController:[regular alertTitleCancel_Simple:NSLocalizedString(@"login_first", @"") WithBlock:^{
            [self pushLoginView];
        }] animated:YES completion:nil];
    }
    
}
/**
 * 用户权限变化
 */
-(void)MonitorRootChangeAction
{
    _dataArr=[DD_UserTool getUserListArr];
    _imgDataArr=[DD_UserTool getUserImgListArr];
}
/**
 * 跳转消息界面
 */
-(void)messageAction
{
    [self.navigationController pushViewController:[DD_UserMessageViewController new] animated:YES];
}
/**
 * 界面更新
 */
-(void)UpdateUI
{
    [self SetDataArr];
    for (UIView *view in self.view.subviews) {
        [view removeFromSuperview];
    }
    [self UIConfig];
    _usermodel=[DD_UserModel getLocalUserInfo];
}
/**
 * 跳转设置界面
 */
-(void)setAction
{
    DD_SetViewController *_set=[[DD_SetViewController alloc] initWithBlock:^(NSString *type) {
        if([type isEqualToString:@"logout"])
        {
            _usermodel=nil;
            [self UpdateUI];
        }
    }];
    [self.navigationController pushViewController:_set animated:YES];
}

/**
 * 获取当前的list arr
 */
-(void)SetDataArr
{
    _dataArr=[DD_UserTool getUserListArr];
    _imgDataArr=[DD_UserTool getUserImgListArr];
}
/**
 * 跳转登录界面
 */
-(void)pushLoginView
{
    if(![DD_UserModel isLogin])
    {
        DD_LoginViewController *_login=[[DD_LoginViewController alloc] initWithBlock:^(NSString *type) {
            if([type isEqualToString:@"success"])
            {
                [self UpdateUI];
            }
        }];
        [self.navigationController pushViewController:_login animated:YES];
    }
}


#pragma mark - Other
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(_userHeadImg)
    {
        [self RequestData];
    }
    [[DD_CustomViewController sharedManager] tabbarAppear];
    [MobClick beginLogPageView:@"DD_UserViewController"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"DD_UserViewController"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 弃用代码
//-(void)RequestNewFansStatus
//{
//    
//    [[JX_AFNetworking alloc] GET:@"designer/queryHasNewFans.do" parameters:@{@"token":[DD_UserModel getToken]} success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
//        if(success)
//        {
//            FansNum=[[NSString alloc] initWithFormat:@"%ld",[[data objectForKey:@"fansNum"] integerValue]];
//            //            hasNewFans=[[data objectForKey:@"hasNewFans"] boolValue];
//            [_tableview reloadData];
//        }else
//        {
//            [self presentViewController:successAlert animated:YES completion:nil];
//        }
//    } failure:^(NSError *error, UIAlertController *failureAlert) {
//        [self presentViewController:failureAlert animated:YES completion:nil];
//    }];
//}
@end
