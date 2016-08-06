//
//  DD_DDAYDetailViewController.m
//  DDAY
//
//  Created by yyj on 16/6/2.
//  Copyright © 2016年 YYJ. All rights reserved.
//
#import "DD_DDAYDetailView.h"
#import "DD_DDayDetailModel.h"
#import "DD_DDAYDetailViewController.h"
#import "DD_DDAYMeetViewController.h"
@interface DD_DDAYDetailViewController ()

@end

@implementation DD_DDAYDetailViewController
{
    DD_DDAYDetailView *_tabBar;
    DD_DDayDetailModel *_detailModel;
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
    self.navigationItem.titleView=[regular returnNavView:_model.name withmaxwidth:200];
}
#pragma mark - UIConfig
-(void)UIConfig
{
    
}
-(void)CreateTabbar
{
    _tabBar=[[DD_DDAYDetailView alloc] initWithFrame:CGRectMake(0, ScreenHeight-ktabbarHeight, ScreenWidth, ktabbarHeight) WithGoodsDetailModel:_detailModel WithBlock:^(NSString *type) {
        if([type isEqualToString:@"cancel"]||[type isEqualToString:@"join"])
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
        }else if([type isEqualToString:@"enter_meet"])
        {
//            进入发布会
            [self.navigationController pushViewController:[[DD_DDAYMeetViewController alloc] initWithType:@"meet" WithSeriesID:_detailModel.s_id WithBlock:^(NSString *type) {
                
            }] animated:YES];
        }else if([type isEqualToString:@"check_good"])
        {
//            查看发布品
            [self.navigationController pushViewController:[[DD_DDAYMeetViewController alloc] initWithType:@"good" WithSeriesID:_detailModel.s_id WithBlock:^(NSString *type) {
                
            }] animated:YES];
        }
        
    }];
    [self.view addSubview:_tabBar];

}
#pragma mark - RequestData
-(void)RequestData
{
    [[JX_AFNetworking alloc] GET:@"series/querySeriesDetail.do" parameters:@{@"token":[DD_UserModel getToken],@"seriesId":_model.s_id} success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
        if(success)
        {
            _detailModel=[DD_DDayDetailModel getDDayDetailModel:[data objectForKey:@"seriesDetail"]];
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
    [[DD_CustomViewController sharedManager] tabbarHide];
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
