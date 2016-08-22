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

#import "DD_DDAYContainerView.h"
#import "DD_DDAYDetailView.h"

#import "DD_DDayDetailModel.h"

@interface DD_DDAYDetailViewController ()

@end

@implementation DD_DDAYDetailViewController
{
    DD_DDAYDetailView *_tabBar;
    DD_DDayDetailModel *_detailModel;
    UIScrollView *_scrollView;
    UIView *_container;
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
-(instancetype)initWithBlock:(void (^)(NSString *type))block
{
    self=[super init];
    if(self)
    {
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
    self.navigationItem.titleView=[regular returnNavView:_model.name withmaxwidth:140];
    DD_NavBtn *shopBtn=[DD_NavBtn getShopBtn];
    [shopBtn addTarget:self action:@selector(PushShopView) forControlEvents:UIControlEventTouchUpInside];
    
    DD_NavBtn *shareBtn=[DD_NavBtn getNavBtnIsLeft:NO WithSize:CGSizeMake(25, 25) WithImgeStr:@"System_share"];
    [shareBtn addTarget:self action:@selector(ShareAction) forControlEvents:UIControlEventTouchUpInside];
    
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
        make.edges.equalTo(_scrollView);
        make.width.equalTo(_scrollView);
    }];
}
-(void)CreateTabbar
{
    _tabBar=[[DD_DDAYDetailView alloc] initWithFrame:CGRectMake(0, ScreenHeight-ktabbarHeight, ScreenWidth, ktabbarHeight) WithGoodsDetailModel:_detailModel WithBlock:^(NSString *type) {
        if([type isEqualToString:@"cancel"]||[type isEqualToString:@"join"])
        {
            if(![DD_UserModel isLogin])
            {
                [self presentViewController:[regular alertTitleCancel_Simple:NSLocalizedString(@"login_first", @"") WithBlock:^{
                    [self pushLoginView];
                }] animated:YES completion:nil];
            }else
            {
                NSString *url=nil;
                if([type isEqualToString:@"cancel"])
                {
                    url=@"series/quitSeries.do";
                }else if([type isEqualToString:@"join"])
                {
                    url=@"series/joinSeries.do";
                }
                [[JX_AFNetworking alloc] GET:url parameters:@{@"token":[DD_UserModel getToken],@"seriesId":_detailModel.s_id} success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
                    if(success)
                    {
                        _detailModel.isJoin=[[data objectForKey:@"isJoin"] boolValue];
                        _detailModel.isQuotaLimt=[[data objectForKey:@"isQuotaLimt"] boolValue];
                        _detailModel.leftQuota=[[data objectForKey:@"leftQuota"] longValue];
                        
                        _model.isJoin=_detailModel.isJoin;
                        _model.leftQuota=_detailModel.leftQuota;
                        _model.isQuotaLimt=_detailModel.isQuotaLimt;
                        
                        _block(@"update");
                        
                        _tabBar.detailModel=_detailModel;
                        [_tabBar setState];
                        
                    }else
                    {
                        [self presentViewController:successAlert animated:YES completion:nil];
                    }
                } failure:^(NSError *error, UIAlertController *failureAlert) {
                    [self presentViewController:failureAlert animated:YES completion:nil];
                }];
            }
            
        }else if([type isEqualToString:@"enter_meet"])
        {
//            进入发布会
            if(![DD_UserModel isLogin])
            {
                [self presentViewController:[regular alertTitleCancel_Simple:NSLocalizedString(@"login_first", @"") WithBlock:^{
                    [self pushLoginView];
                }] animated:YES completion:nil];
            }else
            {
                [self.navigationController pushViewController:[[DD_DDAYMeetViewController alloc] initWithType:@"meet" WithSeriesID:_detailModel.s_id WithBlock:^(NSString *type) {
                    
                }] animated:YES];
            }
            
        }else if([type isEqualToString:@"check_good"])
        {
//            查看发布品
            if(![DD_UserModel isLogin])
            {
                [self presentViewController:[regular alertTitleCancel_Simple:NSLocalizedString(@"login_first", @"") WithBlock:^{
                    [self pushLoginView];
                }] animated:YES completion:nil];
            }else
            {
                [self.navigationController pushViewController:[[DD_DDAYMeetViewController alloc] initWithType:@"good" WithSeriesID:_detailModel.s_id WithBlock:^(NSString *type) {
                    
                }] animated:YES];
            }
        }
        
    }];
    [self.view addSubview:_tabBar];

}
#pragma mark - SomeAction
//分享
-(void)ShareAction
{
    
}
//跳转购物车视图
-(void)PushShopView
{
    if(![DD_UserModel isLogin])
    {
        [self presentViewController:[regular alertTitleCancel_Simple:NSLocalizedString(@"login_first", @"") WithBlock:^{
            [self pushLoginView];
        }] animated:YES completion:nil];
    }else
    {
        DD_ShopViewController *_shop=[[DD_ShopViewController alloc] init];
        [self.navigationController pushViewController:_shop animated:YES];
    }
}
#pragma mark - RequestData
-(void)RequestData
{
    NSLog(@"token=%@",[DD_UserModel getToken]);
    [[JX_AFNetworking alloc] GET:@"series/querySeriesPageInfo.do" parameters:@{@"token":[DD_UserModel getToken],@"seriesId":_model.s_id} success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
        if(success)
        {
            _detailModel=[DD_DDayDetailModel getDDayDetailModel:[data objectForKey:@"seriesPageInfo"]];
            DD_DDAYContainerView *_DDAYContainerView=[[DD_DDAYContainerView alloc] initWithGoodsDetailModel:_detailModel WithBlock:nil];
            [_container addSubview:_DDAYContainerView];
            [_DDAYContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.top.mas_equalTo(0);
                make.top.mas_equalTo(kNavHeight);
            }];
            [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(self.view);
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
    [MobClick beginLogPageView:@"DD_DDAYDetailViewController"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"DD_DDAYDetailViewController"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
