//
//  DD_UserDDAYViewController.m
//  DDAY
//
//  Created by yyj on 16/6/13.
//  Copyright © 2016年 YYJ. All rights reserved.
//
#import "DD_DDAYModel.h"
#import "DD_DDAYCell.h"
#import "DD_ShopViewController.h"
#import "DD_DDAYDetailViewController.h"
#import "DD_UserDDAYViewController.h"

@interface DD_UserDDAYViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation DD_UserDDAYViewController
{
    NSMutableArray *_dataArr;
    NSInteger _page;
    void (^ddayblock)(NSInteger index,NSString *type);
    
    UITableView *_tableview;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self SomePrepare];
    [self UIConfig];
    [self SomeBlock];
}
#pragma mark - SomePrepare
-(void)SomePrepare
{
    [self PrepareData];
    [self PrepareUI];
}
-(void)PrepareData
{
    _page=1;
    _dataArr=[[NSMutableArray alloc] init];
}
-(void)PrepareUI
{
    self.navigationItem.titleView=[regular returnNavView:NSLocalizedString(@"user_conference", @"") withmaxwidth:200];//设置标题
}
#pragma mark - SomeBlock
-(void)SomeBlock
{
    __block NSArray *__dataArr=_dataArr;
    __block UITableView *__tableview=_tableview;
    __block DD_UserDDAYViewController *_dayView=self;
    ddayblock=^(NSInteger index,NSString *type)
    {
        DD_DDAYModel *dayModel=[__dataArr objectAtIndex:index];
        NSString *url=nil;
        if([type isEqualToString:@"cancel"])
        {
            url=@"series/quitSeries.do";
        }else if([type isEqualToString:@"join"])
        {
            url=@"series/joinSeries.do";
        }
        [[JX_AFNetworking alloc] GET:url parameters:@{@"token":[DD_UserModel getToken],@"seriesId":dayModel.s_id} success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
            if(success)
            {
                dayModel.isJoin=[[data objectForKey:@"isJoin"] boolValue];
                dayModel.isQuotaLimt=[[data objectForKey:@"isQuotaLimt"] boolValue];
                dayModel.leftQuota=[[data objectForKey:@"leftQuota"] longValue];
                [__tableview reloadData];
            }else
            {
                [_dayView presentViewController:successAlert animated:YES completion:nil];
            }
        } failure:^(NSError *error, UIAlertController *failureAlert) {
            [_dayView presentViewController:failureAlert animated:YES completion:nil];
        }];
    };
}
#pragma mark - UIConfig
-(void)UIConfig
{
    [self CreateTableview];
    [self MJRefresh];
}
-(void)CreateTableview
{
    _tableview=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableview];
    //    消除分割线
    _tableview.backgroundColor=_define_backview_color;
    _tableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableview.delegate=self;
    _tableview.dataSource=self;
}

#pragma mark - RequestData
-(void)RequestData
{
    NSDictionary *_parameters=@{@"page":[NSNumber numberWithInteger:_page],@"token":[DD_UserModel getToken]};
    [[JX_AFNetworking alloc] GET:@"series/queryParticipantSeries.do" parameters:_parameters success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
        if(success)
        {
            NSArray *modelArr=[DD_DDAYModel getDDAYModelArr:[data objectForKey:@"series"]];
            if(modelArr.count)
            {
                if(_page==1)
                {
                    [_dataArr removeAllObjects];//删除所有数据
                }
                [_dataArr addObjectsFromArray:modelArr];
                [_tableview reloadData];
            }else
            {
//                [self presentViewController:[regular alertTitle_Simple:NSLocalizedString(@"no_more", @"")] animated:YES completion:nil];
            }
            
        }else
        {
            [self presentViewController:successAlert animated:YES completion:nil];
        }
        [_tableview.header endRefreshing];
        [_tableview.footer endRefreshing];
        
    } failure:^(NSError *error, UIAlertController *failureAlert) {
        [_tableview.header endRefreshing];
        [_tableview.footer endRefreshing];
        [self presentViewController:failureAlert animated:YES completion:nil];
    }];
}
#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 500;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    数据还未获取时候
    if(_dataArr.count==indexPath.section)
    {
        static NSString *cellid=@"cellid";
        UITableViewCell *cell=[_tableview dequeueReusableCellWithIdentifier:cellid];
        if(!cell)
        {
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    static NSString *CellIdentifier = @"cell_dday";
    BOOL nibsRegistered = NO;
    if (!nibsRegistered) {
        UINib *nib = [UINib nibWithNibName:NSStringFromClass([DD_DDAYCell class]) bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:CellIdentifier];
        nibsRegistered = YES;
    }
    DD_DDAYCell *cell = (DD_DDAYCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.ddayblock=ddayblock;
    
    DD_DDAYModel *ddaymodel=[_dataArr objectAtIndex:indexPath.section];
    cell.DDAYModel=ddaymodel;
    cell.index=indexPath.section;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DD_DDAYModel *ddaymodel=[_dataArr objectAtIndex:indexPath.section];
    [self.navigationController pushViewController:[[DD_DDAYDetailViewController alloc] initWithModel:ddaymodel WithBlock:^(NSString *type) {
        if([type isEqualToString:@"update"])
        {
            [_tableview reloadData];
        }
    }] animated:YES];
}
//section头部间距
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;//section头部高度
}
//section头部视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [regular getViewForSection];
}
//section底部间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
//section底部视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [regular getViewForSection];
}

#pragma mark - SomeAction
//跳转购物车
-(void)PushShopView
{
    DD_ShopViewController *_shop=[[DD_ShopViewController alloc] init];
    [self.navigationController pushViewController:_shop animated:YES];
}
-(void)MJRefresh
{
    _tableview.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        _page=1;
        [self RequestData];
    }];
    
    _tableview.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        _page+=1;
        [self RequestData];
    }];
    
    [_tableview.header beginRefreshing];
}
#pragma mark - Other
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[DD_CustomViewController sharedManager] tabbarHide];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [MobClick beginLogPageView:@"DD_UserDDAYViewController"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"DD_UserDDAYViewController"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
