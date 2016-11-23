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
#import "DD_TarentoHomePageViewController.h"
#import "DD_UserMainCollectViewController.h"
#import "DD_UserMessageViewController.h"
#import "DD_FansViewController.h"
#import "DD_UserDDAYViewController.h"
#import "DD_ShowRoomViewController.h"
#import "DD_IntegralViewController.h"
#import "DD_BenefitListViewController.h"

#import "DD_UserItemBtn.h"

#import "DD_UserTool.h"
#import "DD_UnReadMsgModel.h"

@interface DD_UserViewController ()

@end

@implementation DD_UserViewController
{
    NSArray *_dataArr;
    NSArray *_imgDataArr;
    NSDictionary *_datadict;
    DD_UserModel *_usermodel;
    
    UIImageView *_userHeadImg;
    UILabel *_headImgLabel;
    UILabel *_userName;
    
    DD_UnReadMsgModel *_unReadMsgModel;
    BOOL _firstLoad;
    
    UIScrollView *_scrollView;
    UIView *container;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self SomePrepare];
    [self SetDataArr];
    [self CreateScrollView];
    [self UIConfig];
    [self RequestData];
    [self Has_readMessage];
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
    _firstLoad=YES;
}
-(void)PrepareUI
{
    [self setNotBtnWithExist:NO];
}
#pragma mark - UIConfig
-(void)CreateScrollView
{
    _scrollView=[[UIScrollView alloc] init];
    [self.view addSubview:_scrollView];
    container = [UIView new];
    [_scrollView addSubview:container];
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_scrollView);
        make.width.equalTo(_scrollView);
    }];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}
-(void)UIConfig
{
    UIButton *_headBack=[UIButton getCustomBtn];
    [container addSubview:_headBack];
    [_headBack addTarget:self action:@selector(pushLoginView) forControlEvents:UIControlEventTouchUpInside];
    [_headBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(98);
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(13);
    }];
    _headBack.layer.masksToBounds=YES;
    _headBack.layer.cornerRadius=97/2.0f;
    _headBack.layer.borderColor=[_define_black_color CGColor];
    _headBack.layer.borderWidth=2.0f;
    [_headBack setEnlargeEdgeWithTop:0 right:50 bottom:60 left:50];
    
    _userHeadImg=[UIImageView getCornerRadiusImg];
    [container addSubview:_userHeadImg];
    _userHeadImg.contentMode=2;
    [_userHeadImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(84);
        make.center.mas_equalTo(_headBack);
    }];
    
    _headImgLabel=[UILabel getLabelWithAlignment:1 WithTitle:@"" WithFont:15.0f WithTextColor:nil WithSpacing:0];
    [_userHeadImg addSubview:_headImgLabel];
    [_headImgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(_userHeadImg);
    }];
    
    _userName=[UILabel getLabelWithAlignment:1 WithTitle:@"" WithFont:15.0f WithTextColor:nil WithSpacing:0];
    [container addSubview:_userName];
    _userName.font=[regular getSemiboldFont:15.0f];
    [_userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(_headBack.mas_bottom).with.offset(15);
    }];
    
    CGFloat _y_p=IsPhone6_gt?320:IsPhone5_gt?250:220;
    _y_p=_y_p-64;
    CGFloat _offset=kIiPhone6?25:15;
    CGFloat _bianju=kIiPhone6?43:33;
    CGFloat _width=(ScreenWidth-_bianju*2)/2.0f;
    CGFloat _height=IsPhone5_gt?60:50;
    CGFloat _end_y = 0;
    for (int i=0; i<_dataArr.count; i++) {
        DD_UserItemBtn *item=[DD_UserItemBtn getUserItemBtnWithFrame:CGRectMake(_bianju+(_width+_offset)*(i%2), _y_p+_height*(i/2), i%2?_width-_offset:_width, _height) WithImgSize:CGSizeMake(21, 21) WithImgeStr:_imgDataArr[i] WithTitle:[_datadict objectForKey:_dataArr[i]] isBig:[_dataArr[i] isEqualToString:@"benefit"]];
        [container addSubview:item];
        item.type=_dataArr[i];
        [item addTarget:self action:@selector(itemAction:) forControlEvents:UIControlEventTouchUpInside];
        _end_y=CGRectGetMaxY(item.frame)+20;
    }
    [container mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(_end_y);
    }];

}
#pragma mark - RequestData
-(void)RequestData
{
    if([DD_UserModel isLogin])
    {
        _headImgLabel.text=@"";
        [[JX_AFNetworking alloc] GET:@"user/queryUserInfo.do" parameters:@{@"token":[DD_UserModel getToken]} success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
            if(success)
            {
                
                if(_userHeadImg)
                {
                    [self MonitorRootChangeAction];
                    for (UIView *view in container.subviews) {
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
                    [self updateRewardPoints];
                    _userName.textColor=_define_black_color;
                    _userName.text=_usermodel.nickName;
                    [_userHeadImg JX_ScaleAspectFill_loadImageUrlStr:_usermodel.head WithSize:800 placeHolderImageName:nil radius:94/2.0f];
                    
//                    [self startAnimation];
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
        //获取未登录时候  注册即送50红包之类的内容
        _headImgLabel.text=@"点击登录";
        _userName.text=@"";
        [[JX_AFNetworking alloc] GET:@"user/registBenefitTips.do" parameters:@{@"token":[DD_UserModel getToken]} success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
            if(success)
            {
                _userName.textColor=_define_light_red_color;
                _userName.text=[data objectForKey:@"benefitTips"];
            }else
            {
            }
        } failure:^(NSError *error, UIAlertController *failureAlert) {
            
        }];
    }
}
-(void)Has_readMessage
{
    if([DD_UserModel isLogin])
    {
        [[JX_AFNetworking alloc] GET:@"/user/isHaveUnReadMessage.do" parameters:@{@"token":[DD_UserModel getToken]} success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
            if(success)
            {
                
                _unReadMsgModel=[DD_UnReadMsgModel getUnReadMsgModel:data];

                [self setNotBtnWithExist:_unReadMsgModel.isHaveUnReadMessage];
                
                [((DD_CustomViewController *)[DD_CustomViewController sharedManager]) UpdateUnReadMsgModel:_unReadMsgModel];
                
                [self readBottomRedPoint];
                
            }else
            {
//                [self presentViewController:successAlert animated:YES completion:nil];
            }
        } failure:^(NSError *error, UIAlertController *failureAlert) {
//            [self presentViewController:failureAlert animated:YES completion:nil];
        }];
    }else
    {
        [self setNotBtnWithExist:NO];
    }
}
-(void)readBottomRedPoint
{
    [[JX_AFNetworking alloc] GET:@"user/readBottomRedPoint.do" parameters:@{@"token":[DD_UserModel getToken]} success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
        if(success)
        {
            _unReadMsgModel=[DD_UnReadMsgModel getUnReadMsgModel:data];
            
            [self setNotBtnWithExist:_unReadMsgModel.isHaveUnReadMessage];
            
            [((DD_CustomViewController *)[DD_CustomViewController sharedManager]) UpdateUnReadMsgModel:_unReadMsgModel];
        }else
        {
//            [self presentViewController:successAlert animated:YES completion:nil];
        }
    } failure:^(NSError *error, UIAlertController *failureAlert) {
//        [self presentViewController:failureAlert animated:YES completion:nil];
    }];
}
#pragma mark - SomeAction
//-(void)startAnimation
//{
//    if(_dailyIntegralView)
//    {
//        [_dailyIntegralView startAnimation];
//    }
//}
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
    }else if([btn.type isEqualToString:@"integral"])
    {
        [self PushScoreView];
    }else if([btn.type isEqualToString:@"benefit"])
    {
        [self PushBenefitView];
    }

}
/**
 * 跳转优惠券页面
 */
-(void)PushBenefitView
{
    if([DD_UserModel isLogin])
    {
        [self.navigationController pushViewController:[[DD_BenefitListViewController alloc] init] animated:YES];
    }else
    {
        [self presentViewController:[regular alertTitleCancel_Simple:NSLocalizedString(@"login_first", @"") WithBlock:^{
            [self pushLoginView];
        }] animated:YES completion:nil];
    }
}
/**
 * 跳转积分页面
 */
-(void)PushScoreView
{
    if([DD_UserModel isLogin])
    {
        [self.navigationController pushViewController:[[DD_IntegralViewController alloc] init] animated:YES];
    }else
    {
        [self presentViewController:[regular alertTitleCancel_Simple:NSLocalizedString(@"login_first", @"") WithBlock:^{
            [self pushLoginView];
        }] animated:YES completion:nil];
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
 * 跳转消息界面
 */
-(void)messageAction
{
    if([DD_UserModel isLogin])
    {
        [self.navigationController pushViewController:[DD_UserMessageViewController new] animated:YES];
    }else
    {
        [self presentViewController:[regular alertTitleCancel_Simple:NSLocalizedString(@"login_first", @"") WithBlock:^{
            [self pushLoginView];
        }] animated:YES completion:nil];
    }
   
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
                [regular SigninAction];
            }
        }];
        [self.navigationController pushViewController:_login animated:YES];
    }
}
/**
 * 更新当前积分
 */
-(void)updateRewardPoints
{
    for (id obj in container.subviews) {
        if([obj isKindOfClass:[DD_UserItemBtn class]])
        {
            DD_UserItemBtn *_UserItemBtn=(DD_UserItemBtn *)obj;
            if([_UserItemBtn.type isEqualToString:@"integral"])
            {
                if(_usermodel.rewardPoints)
                {
                    _UserItemBtn.rewardPoints_label.text=[[NSString alloc] initWithFormat:@"%ld",_usermodel.rewardPoints];
                }else
                {
                    _UserItemBtn.rewardPoints_label.text=@"";
                }
            }else if([_UserItemBtn.type isEqualToString:@"benefit"])
            {
                if(_usermodel.benefitNumber)
                {
                    _UserItemBtn.rewardPoints_label.text=[[NSString alloc] initWithFormat:@"%ld",_usermodel.benefitNumber];
                }else
                {
                    _UserItemBtn.rewardPoints_label.text=@"";
                }
            }
        }
    }
}
/**
 * 设置当前消息已读状态
 */
-(void)setNotBtnWithExist:(BOOL )is_exist
{
    NSString *_img=nil;
    if(is_exist)
    {
        _img=@"User_News";
    }else
    {
        _img=@"User_NoNews";
    }
    
    DD_NavBtn *message=[DD_NavBtn getNavBtnIsLeft:NO WithSize:CGSizeMake(23, 28) WithImgeStr:_img];
    [message addTarget:self action:@selector(messageAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:message];
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
 * 界面更新
 */
-(void)UpdateUI
{
    [self SetDataArr];
    for (UIView *view in container.subviews) {
        [view removeFromSuperview];
    }
    [self UIConfig];
    _usermodel=[DD_UserModel getLocalUserInfo];
}

/**
 * 获取当前的list arr
 */
-(void)SetDataArr
{
    _dataArr=[DD_UserTool getUserListArr];
    _imgDataArr=[DD_UserTool getUserImgListArr];
}

#pragma mark - Other
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(!_firstLoad)
    {
        [self RequestData];
        [self Has_readMessage];
    }else
    {
        _firstLoad=NO;
    }
    [[DD_CustomViewController sharedManager] tabbarAppear];
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
