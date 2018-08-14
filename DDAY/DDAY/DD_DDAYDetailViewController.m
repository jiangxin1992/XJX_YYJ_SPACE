//
//  DD_DDAYDetailViewController.m
//  DDAY
//
//  Created by yyj on 16/6/2.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_DDAYDetailViewController.h"

#import "DD_DDAYMeetViewController.h"
#import "DD_ShopViewController.h"
#import "DD_DesignerHomePageViewController.h"
#import "DD_BenefitListViewController.h"
#import "DD_LoginViewController.h"
#import "DD_CustomViewController.h"

#import "DD_DDAYContainerView.h"
#import "DD_DDAYDetailBar.h"
#import "DD_ShareView.h"
#import "DD_BenefitView.h"
#import "DD_CustomChooseView.h"

#import "DD_ShareTool.h"
#import "DD_DDayDetailModel.h"
#import "DD_DDAYModel.h"

@interface DD_DDAYDetailViewController ()

@end

@implementation DD_DDAYDetailViewController
{
    DD_DDAYDetailBar *_tabBar;
    DD_DDayDetailModel *_detailModel;
    UIScrollView *_scrollView;
    UIView *_container;
    
    DD_ShareView *shareView;
    UIImageView *mengban;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self SomePrepare];
    [self UIConfig];
    [self RequestData];
}
#pragma mark - 初始化
-(instancetype)initWithModel:(DD_DDAYModel *)model WithBlock:(void (^)(NSString *type))block
{
    self=[super init];
    if(self)
    {
        _block=block;
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
    titleLabel.text=@"发布会";
    [navView addSubview:titleLabel];
    self.navigationItem.titleView=navView;
    
    DD_NavBtn *shopBtn=[DD_NavBtn getShopBtn];
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
    
    DD_NavBtn *shareBtn=[DD_NavBtn getNavBtnIsLeft:NO WithSize:CGSizeMake(25, 25) WithImgeStr:@"Share_Navbar"];
//    [shareBtn addTarget:self action:@selector(ShareAction) forControlEvents:UIControlEventTouchUpInside];
    [shareBtn bk_addEventHandler:^(id sender) {
        [self ShareAction];
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
    _container = [DD_DDAYContainerView new];
    [_scrollView addSubview:_container];
    [_container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(_scrollView);
        make.width.mas_equalTo(_scrollView);
    }];
}
-(void)showAPNSAlertview
{
    __block UIImageView *mengbanClear=[UIImageView getCustomImg];
    [self.view.window addSubview:mengbanClear];
    mengbanClear.image=[UIImage imageNamed:@"System_Transparent_Mask"];
    mengbanClear.contentMode=UIViewContentModeScaleAspectFill;
    mengbanClear.frame=CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    mengbanClear.userInteractionEnabled=YES;
    
    __block DD_CustomChooseView *chooseView=[[DD_CustomChooseView alloc] initWithTitle:@"通知已关闭提醒" message:@"通知为关闭状态，你可能会错过订单和重要活动的消息。\n立即去设置-通知-YCO SPACE中设置" cancelButtonTitle:@"取 消" otherButtonTitles:@"立即开启" WithBlock:^(NSString *type) {
        if([type isEqualToString:@"cancel"])
        {
            [chooseView removeFromSuperview];
            chooseView=nil;
            [mengbanClear removeFromSuperview];
            mengbanClear=nil;
        }else if([type isEqualToString:@"other"])
        {
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]])
            {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            }
        }
    }];
    [mengbanClear addSubview:chooseView];
    [chooseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(mengbanClear);
        make.width.mas_equalTo(295);
    }];
}
-(void)CreateTabbar
{
    _tabBar=[[DD_DDAYDetailBar alloc] initWithFrame:CGRectMake(0, ScreenHeight-kTabbarHeight, ScreenWidth, kTabbarHeight) WithGoodsDetailModel:_detailModel WithBlock:^(NSString *type) {
//        if([type isEqualToString:@"cancel"]||[type isEqualToString:@"join"])
        if([type isEqualToString:@"join"])
        {
            if(![DD_UserModel isLogin])
            {
                [self UpdateData];
            }else{
                if(![regular isAllowedNotification])
                {
                    [self showAPNSAlertview];
                }else
                {
                    //                NSString *url=nil;
                    //                if([type isEqualToString:@"cancel"])
                    //                {
                    //                    url=@"series/quitSeries.do";
                    //                }else if([type isEqualToString:@"join"])
                    //                {
                    //                    url=@"series/joinSeries.do";
                    //                }
                    NSString *url=@"series/joinSeries.do";
                    [[JX_AFNetworking alloc] GET:url parameters:@{@"token":[DD_UserModel getToken],@"seriesId":_detailModel.s_id} success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
                        if(success)
                        {
                            _detailModel.isJoin=[[data objectForKey:@"isJoin"] boolValue];
                            _detailModel.isQuotaLimt=[[data objectForKey:@"isQuotaLimt"] boolValue];
                            _detailModel.leftQuota=[[data objectForKey:@"leftQuota"] longLongValue];
                            
                            _model.isJoin=_detailModel.isJoin;
                            _model.leftQuota=_detailModel.leftQuota;
                            _model.isQuotaLimt=_detailModel.isQuotaLimt;
                            
                            _block(@"update");
                            
                            _tabBar.detailModel=_detailModel;
                            [_tabBar setState];
                            
                            [[DD_CustomViewController sharedManager] startSignInAnimationWithTitle:@"设置成功!" WithType:@"success"];
                            
                        }else
                        {
                            [self presentViewController:successAlert animated:YES completion:nil];
                        }
                    } failure:^(NSError *error, UIAlertController *failureAlert) {
                        [self presentViewController:failureAlert animated:YES completion:nil];
                    }];
                }
            }
            
        }else if([type isEqualToString:@"enter_meet"])
        {
//            进入发布会
            [self.navigationController pushViewController:[[DD_DDAYMeetViewController alloc] initWithType:@"meet" WithSeriesID:_detailModel.s_id WithBlock:^(NSString *type) {
                
            }] animated:YES];
            
        }else if([type isEqualToString:@"check_good"])
        {
//            查看发布品
            [self.navigationController pushViewController:[[DD_DDAYMeetViewController alloc] initWithType:@"meet" WithSeriesID:_detailModel.s_id WithBlock:^(NSString *type) {
                
            }] animated:YES];
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
                NSDictionary *_parameters=@{@"token":[DD_UserModel getToken],@"seriesId":_model.s_id};
                [[JX_AFNetworking alloc] GET:@"series/querySeriesPageInfo.do" parameters:_parameters success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
                    if(success)
                    {
                        _detailModel=[DD_DDayDetailModel getDDayDetailModel:[data objectForKey:@"seriesPageInfo"]];
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
    
    shareView=[[DD_ShareView alloc] initWithType:@"dday_detail" WithParams:@{@"detailModel":_detailModel} WithBlock:^(NSString *type,DD_BenefitInfoModel *model) {
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
    JXLOG(@"token=%@",[DD_UserModel getToken]);
    NSDictionary *_parameters=@{@"token":[DD_UserModel getToken],@"seriesId":_model.s_id};
    [[JX_AFNetworking alloc] GET:@"series/querySeriesPageInfo.do" parameters:_parameters success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
        if(success)
        {
            _detailModel=[DD_DDayDetailModel getDDayDetailModel:[data objectForKey:@"seriesPageInfo"]];
            DD_DDAYContainerView *_DDAYContainerView=[[DD_DDAYContainerView alloc] initWithGoodsDetailModel:_detailModel WithBlock:^(NSString *type) {
                if([type isEqualToString:@"enter_designer_homepage"])
                {
                    //                设计师
                    DD_DesignerHomePageViewController *_DesignerHomePage=[[DD_DesignerHomePageViewController alloc] init];
                    _DesignerHomePage.designerId=_detailModel.designerId;
                    [self.navigationController pushViewController:_DesignerHomePage animated:YES];
                }
            }];
            [_container addSubview:_DDAYContainerView];
            [_DDAYContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.top.mas_equalTo(0);
            }];
            [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.right.mas_equalTo(0);
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
