//
//  DD_DDAYDetailOfflineViewController.m
//  YCOSPACE
//
//  Created by yyj on 2016/12/12.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_DDAYDetailOfflineViewController.h"

#import "DD_DDAYMeetViewController.h"
#import "DD_ShopViewController.h"
#import "DD_DesignerHomePageViewController.h"
#import "DD_BenefitListViewController.h"
#import "DD_DDAYOffllineApplyViewController.h"
#import "DD_ShowRoomDetailViewController.h"
#import "DD_LoginViewController.h"
#import "DD_CustomViewController.h"

#import "DD_DDAYOfflineContainerView.h"
#import "DD_DDAYOfflineDetailBar.h"
#import "DD_ShareView.h"
#import "DD_BenefitView.h"
#import "DD_CustomChooseView.h"

#import "DD_ShareTool.h"
#import "DD_DDayDetailModel.h"
#import "DD_DDAYModel.h"
#import "DD_UserModel.h"
#import "DD_ShowRoomModel.h"

@interface DD_DDAYDetailOfflineViewController ()

@end

@implementation DD_DDAYDetailOfflineViewController
{
    DD_DDAYOfflineDetailBar *_tabBar;
    DD_DDayDetailModel *_detailModel;
    DD_UserModel *_userInfo;
    UIScrollView *_scrollView;
    UIView *_container;
    
    DD_ShareView *shareView;
    UIImageView *mengban;
    UIImageView *mengbanClear;
    
    DD_NavBtn *shopBtn;
    DD_NavBtn *shareBtn;
    DD_NavBtn *moreBtn;
    
    UIButton *cancelButton;
    __block DD_CustomChooseView *chooseView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self SomePrepare];
    [self UIConfig];
    [self RequestData];
}
#pragma mark - 初始化
-(instancetype)initWithModel:(DD_DDAYModel *)model
{
    self=[super init];
    if(self)
    {
        _model=model;
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

    UIView *navView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    UILabel *titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(navView.frame), CGRectGetHeight(navView.frame))];
    titleLabel.font =  [regular getSemiboldFont:IsPhone6_gt?18.0f:15.0f];
    titleLabel.textAlignment=1;
    titleLabel.text=@"活动详情";
    [navView addSubview:titleLabel];
    self.navigationItem.titleView=navView;
    
    shopBtn=[DD_NavBtn getShopBtn];
    [shopBtn bk_addEventHandler:^(id sender) {
        //        跳转购物车
        if(![DD_UserModel isLogin])
        {
            [self UpdateData];
        }else
        {
            DD_ShopViewController *_shop=[[DD_ShopViewController alloc] init];
            [self.navigationController pushViewController:_shop animated:YES];
        }
    } forControlEvents:UIControlEventTouchUpInside];
    
    shareBtn=[DD_NavBtn getNavBtnIsLeft:NO WithSize:CGSizeMake(25, 25) WithImgeStr:@"Share_Navbar"];
    [shareBtn bk_addEventHandler:^(id sender) {
        [self ShareAction];
    } forControlEvents:UIControlEventTouchUpInside];
    
    moreBtn=[DD_NavBtn getNavBtnIsLeft:NO WithSize:CGSizeMake(25, 25) WithImgeStr:@"Circle_More"];
    [moreBtn bk_addEventHandler:^(id sender) {
        //取消报名
        [self ShowCancelApplyView];
//        DDAY_Toast
    } forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItems=@[[[UIBarButtonItem alloc] initWithCustomView:shopBtn]
                                              ,[[UIBarButtonItem alloc] initWithCustomView:shareBtn]
                                              ];
    
}
#pragma mark - UIConfig
-(void)UIConfig
{
    _scrollView=[[UIScrollView alloc] init];
    [self.view addSubview:_scrollView];
    _container = [DD_DDAYOfflineContainerView new];
    [_scrollView addSubview:_container];
    [_container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(_scrollView);
        make.width.mas_equalTo(_scrollView);
    }];
}
-(void)CreateTabbar
{
    
    _tabBar=[[DD_DDAYOfflineDetailBar alloc] initWithFrame:CGRectMake(0, ScreenHeight-kTabbarHeight, ScreenWidth, kTabbarHeight) WithGoodsDetailModel:_detailModel WithBlock:^(NSString *type) {
        if([type isEqualToString:@"cancel"]||[type isEqualToString:@"join"])
        {
            if(![DD_UserModel isLogin])
            {
                [self UpdateData];
            }else
            {
                if([type isEqualToString:@"join"])
                {
//                    跳转报名页面
                    [self.navigationController pushViewController:[[DD_DDAYOffllineApplyViewController alloc] initWithGoodsDetailModel:_detailModel WithUserInfo:_userInfo WithBlock:^(NSString *type) {
                        //报名成功
                        if([type isEqualToString:@"apply_success"])
                        {
                            //更新底部bar
                            _model.isJoin=_detailModel.isJoin;
                            _model.leftQuota=_detailModel.leftQuota;
                            _model.isQuotaLimt=_detailModel.isQuotaLimt;
                            _tabBar.detailModel=_detailModel;
                            [_tabBar setState];
                            [self SetNavState];
                            [[DD_CustomViewController sharedManager] startSignInAnimationWithTitle:@"报名成功!" WithType:@"success"];
                        }
                    }] animated:YES];
                }
            }
            
        }
        
    }];
    [self.view addSubview:_tabBar];
    
}
#pragma mark - SomeAction
-(void)UpdateData
{
    [self presentViewController:[regular alertTitleCancel_Simple:NSLocalizedString(@"login_first", @"") WithBlock:^{
        DD_LoginViewController *_login=[[DD_LoginViewController alloc] initWithBlock:^(NSString *type) {
            if([type isEqualToString:@"success"])
            {
                //更新数据
                NSDictionary *_parameters=@{@"token":[DD_UserModel getToken],@"seriesId":_model.s_id};
                [[JX_AFNetworking alloc] GET:@"series/queryLiveSeriesPageInfo.do" parameters:_parameters success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
                    if(success)
                    {
                        _detailModel=[DD_DDayDetailModel getDDayDetailModel:[data objectForKey:@"seriesPageInfo"]];
                        _userInfo=[DD_UserModel getUserModel:[data objectForKey:@"userInfo"]];
                        [self SetNavState];
                        if(_tabBar)
                        {
                            _tabBar.detailModel=_detailModel;
                            [_tabBar setState];
                        }
                    }
                } failure:^(NSError *error, UIAlertController *failureAlert) {
                }];
            }
        }];
        [self.navigationController pushViewController:_login animated:YES];
    }] animated:YES completion:nil];
}
-(void)SetNavState
{
    if(_detailModel.isJoin)
    {
        self.navigationItem.rightBarButtonItems=@[[[UIBarButtonItem alloc] initWithCustomView:moreBtn]
                                                  ,[[UIBarButtonItem alloc] initWithCustomView:shopBtn]
                                                  ,[[UIBarButtonItem alloc] initWithCustomView:shareBtn]
                                                  ];
    }else
    {
        self.navigationItem.rightBarButtonItems=@[[[UIBarButtonItem alloc] initWithCustomView:shopBtn]
                                                  ,[[UIBarButtonItem alloc] initWithCustomView:shareBtn]
                                                  ];
    }
}
//蒙板消失
-(void)mengban_clear_dismiss_cancel:(BOOL )is_cancel
{
    if(!chooseView)
    {
        if(cancelButton)
        {
            [cancelButton removeFromSuperview];
            cancelButton=nil;
        }
        
        [mengbanClear removeFromSuperview];
        mengbanClear=nil;
    }else
    {
        if(is_cancel)
        {
            [chooseView removeFromSuperview];
            chooseView=nil;
            [mengbanClear removeFromSuperview];
            mengbanClear=nil;
        }
    }
}
-(void)ShowCancelApplyView
{
    mengbanClear=[UIImageView getCustomImg];
    [self.view.window addSubview:mengbanClear];
    mengbanClear.image=[UIImage imageNamed:@"System_Transparent_Mask"];
    mengbanClear.contentMode=UIViewContentModeScaleAspectFill;
    mengbanClear.frame=CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    mengbanClear.userInteractionEnabled=YES;
    [mengbanClear bk_whenTapped:^{
        [self mengban_clear_dismiss_cancel:NO];
    }];
    
    cancelButton=[UIButton getCustomTitleBtnWithAlignment:0 WithFont:15.0f WithSpacing:0 WithNormalTitle:@"取消报名" WithNormalColor:_define_black_color WithSelectedTitle:nil WithSelectedColor:nil];
    [mengbanClear addSubview:cancelButton];
    [cancelButton setTitle:@"取消报名" forState:UIControlStateNormal];
    cancelButton.contentEdgeInsets= UIEdgeInsetsMake(11,0, 0, 0);
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"DDAY_Toast"] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(CancelApplyAction) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(50);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(kStatusBarAndNavigationBarHeight-10);
    }];
    
}
-(void)CancelApplyAction
{
    if(_detailModel.isJoin)
    {
        [cancelButton removeFromSuperview];
        cancelButton=nil;
        chooseView=[[DD_CustomChooseView alloc] initWithTitle:@"确认取消报名吗" message:@"取消报名后将不能参加此次活动" cancelButtonTitle:@"暂不取消" otherButtonTitles:@"取消报名" WithBlock:^(NSString *type) {
            if([type isEqualToString:@"cancel"])
            {
                [self mengban_clear_dismiss_cancel:YES];
            }else if([type isEqualToString:@"other"])
            {
                //取消报名
                [[JX_AFNetworking alloc] GET:@"series/quitSeries.do" parameters:@{@"token":[DD_UserModel getToken],@"seriesId":_detailModel.s_id} success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
                    if(success)
                    {
                        _detailModel.isJoin=[[data objectForKey:@"isJoin"] boolValue];
                        _detailModel.isQuotaLimt=[[data objectForKey:@"isQuotaLimt"] boolValue];
                        _detailModel.leftQuota=[[data objectForKey:@"leftQuota"] longLongValue];
                        
                        _model.isJoin=_detailModel.isJoin;
                        _model.leftQuota=_detailModel.leftQuota;
                        _model.isQuotaLimt=_detailModel.isQuotaLimt;
                        
                        _tabBar.detailModel=_detailModel;
                        [_tabBar setState];
                        [self SetNavState];
                        [mengbanClear removeFromSuperview];
                        mengbanClear=nil;
                    }else
                    {
                        [self presentViewController:successAlert animated:YES completion:nil];
                    }
                } failure:^(NSError *error, UIAlertController *failureAlert) {
                    [self presentViewController:failureAlert animated:YES completion:nil];
                }];
            }
        }];
        [mengbanClear addSubview:chooseView];
        [chooseView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(mengbanClear);
            make.width.mas_equalTo(295);
        }];
    }
    
}
//蒙板消失
-(void)mengban_dismiss
{
    [UIView animateWithDuration:0.5 animations:^{
        shareView.frame=CGRectMake(0, ScreenHeight, ScreenWidth, CGRectGetHeight(shareView.frame));
    } completion:^(BOOL finished) {
        [mengban removeFromSuperview];
        mengban=nil;
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }];
    
}
//分享
-(void)ShareAction
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    mengban=[UIImageView getMaskImageView];
    [self.view addSubview:mengban];
    //    [mengban addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mengban_dismiss)]];
    [mengban bk_whenTapped:^{
        [self mengban_dismiss];
    }];
    
    shareView=[[DD_ShareView alloc] initWithType:@"dday_offline_detail" WithParams:@{@"detailModel":_detailModel} WithBlock:^(NSString *type,DD_BenefitInfoModel *model) {
        if([type isEqualToString:@"cancel"])
        {
            [self mengban_dismiss];
        }else if([type isEqualToString:@"benefit"])
        {
            [self showBenefitWithModel:model];
        }
    }];
    
    [mengban addSubview:shareView];
    
    CGFloat _height=[DD_ShareTool getHeight];
    shareView.frame=CGRectMake(0, ScreenHeight, ScreenWidth, _height);
    [UIView animateWithDuration:0.5 animations:^{
        shareView.frame=CGRectMake(0, ScreenHeight-CGRectGetHeight(shareView.frame), ScreenWidth, CGRectGetHeight(shareView.frame));
    }];
    
}
-(void)showBenefitWithModel:(DD_BenefitInfoModel *)model
{
    DD_BenefitView *_benefitView=[DD_BenefitView sharedManagerWithModel:model WithBlock:^(NSString *type) {
        [self.view.window.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if([obj isKindOfClass:[DD_BenefitView class]])
            {
                DD_BenefitView *sss=(DD_BenefitView *)obj;
                [sss removeFromSuperview];
            }
        }];
        if([type isEqualToString:@"close"])
        {
            
        }else if([type isEqualToString:@"enter"])
        {
            [self.navigationController pushViewController:[[DD_BenefitListViewController alloc] init] animated:YES];
        }
    }];
    [self.view.window addSubview:_benefitView];
}

#pragma mark - RequestData
-(void)RequestData
{
    NSDictionary *_parameters=@{@"token":[DD_UserModel getToken],@"seriesId":_model.s_id};
    [[JX_AFNetworking alloc] GET:@"series/queryLiveSeriesPageInfo.do" parameters:_parameters success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
        if(success)
        {
            _detailModel=[DD_DDayDetailModel getDDayDetailModel:[data objectForKey:@"seriesPageInfo"]];
            _userInfo=[DD_UserModel getUserModel:[data objectForKey:@"userInfo"]];
            [self SetNavState];
            DD_DDAYOfflineContainerView *_DDAYContainerView=[[DD_DDAYOfflineContainerView alloc] initWithGoodsDetailModel:_detailModel WithBlock:^(NSString *type) {
                if([type isEqualToString:@"enter_designer_homepage"])
                {
                    //                设计师
                    DD_DesignerHomePageViewController *_DesignerHomePage=[[DD_DesignerHomePageViewController alloc] init];
                    _DesignerHomePage.designerId=_detailModel.designerId;
                    [self.navigationController pushViewController:_DesignerHomePage animated:YES];
                }else if([type isEqualToString:@"address_detail"])
                {
                    //跳转地址详情
                    DD_ShowRoomDetailViewController *showroom=[[DD_ShowRoomDetailViewController alloc] initWithShowRoomID:_detailModel.physicalStore.s_id];
                    showroom.title=_detailModel.physicalStore.storeName;
                    [self.navigationController pushViewController:showroom animated:YES];
                }
            }];
            [_container addSubview:_DDAYContainerView];
            [_DDAYContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.top.mas_equalTo(0);
            }];
            [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.top.mas_equalTo(self.view);
                make.bottom.mas_equalTo(-kTabbarHeight);
                // 让scrollview的contentSize随着内容的增多而变化
                make.bottom.mas_equalTo(_DDAYContainerView.mas_bottom).with.offset(0);
            }];
            [self CreateTabbar];
        }else
        {
            [self presentViewController:successAlert animated:YES completion:nil];
        }
    } failure:^(NSError *error, UIAlertController *failureAlert) {
        [self presentViewController:failureAlert animated:YES completion:nil];
    }];
}
#pragma mark - Other
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

@end
