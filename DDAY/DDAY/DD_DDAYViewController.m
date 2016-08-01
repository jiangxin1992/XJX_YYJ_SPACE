//
//  DD_DDAYViewController.m
//  DDAY
//
//  Created by yyj on 16/5/20.
//  Copyright © 2016年 YYJ. All rights reserved.
//
#import "DD_DDAYModel.h"
#import "DD_DDAYCell.h"
#import "DD_ShopViewController.h"
#import "DD_DDAYViewController.h"
#import "DD_DDAYDetailViewController.h"

@interface DD_DDAYViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation DD_DDAYViewController
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
    NSMutableArray *fontNames = [[NSMutableArray alloc] init];
    
    NSArray *fontFamilyNames = [UIFont familyNames];
    
    for (NSString *familyName in fontFamilyNames) {
        
        //        NSLog(@"Font Family Name = %@", familyName);
        
        NSArray *names = [UIFont fontNamesForFamilyName:familyName];
        
        //        NSLog(@"Font Names = %@", fontNames);
        
        [fontNames addObjectsFromArray:names];
        
    }
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
    
    self.navigationItem.titleView=[regular returnNavView:@"YCO SPACE" withmaxwidth:200];
    
    UIButton *buyBtn=[regular getBarCustomBtnWithImg:@"System_Buy" WithSelectImg:@"System_Buy" WithSize:CGSizeMake(24, 25)];
    [buyBtn addTarget:self action:@selector(PushShopView) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:buyBtn];
    
    UIButton *_calendarBtn=[regular getBarCustomBtnWithImg:@"DDAY_Calendar" WithSelectImg:@"DDAY_Calendar" WithSize:CGSizeMake(25, 25)];
    [_calendarBtn addTarget:self action:@selector(PushCalendarView) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:_calendarBtn];
    
}
#pragma mark - SomeBlock
-(void)SomeBlock
{
    __block NSArray *__dataArr=_dataArr;
    __block UITableView *__tableview=_tableview;
    __block DD_DDAYViewController *_dayView=self;
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
    [[JX_AFNetworking alloc] GET:@"series/querySeries.do" parameters:@{@"page":[NSNumber numberWithInteger:_page],@"token":[DD_UserModel getToken]} success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
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
                if([DD_NOTInformClass GET_NEWSERIES_NOT_SERIESID])
                {
                    [self PushNotView:@"NEWSERIES"];
                }
                if([DD_NOTInformClass GET_STARTSERIES_NOT_SERIESID])
                {
                    [self PushNotView:@"STARTSERIES"];
                }
                [_tableview reloadData];
                
                
            }else
            {

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
    return  kIPhone4s?568-ktabbarHeight-kNavHeight:ScreenHeight-ktabbarHeight-kNavHeight;
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
    static NSString *cellid=@"cell_dday";
    DD_DDAYCell *cell=[_tableview dequeueReusableCellWithIdentifier:cellid];
    if(!cell)
    {
        cell=[[DD_DDAYCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    DD_DDAYModel *ddaymodel=[_dataArr objectAtIndex:indexPath.section];
    cell.DDAYModel=ddaymodel;
    cell.ddayblock=ddayblock;
    cell.index=indexPath.section;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
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
/**
 * 跳转日历
 */
-(void)PushCalendarView
{
    
}
/**
 * 发布日详情页
 */
-(void)PushDDAYDetailView
{
    if(_dataArr)
    {
        [_tableview.header beginRefreshing];
    }
}
/**
 * 跳转推送详情页
 */
-(void)PushNotView:(NSString *)type
{
    if(_dataArr)
    {
        NSString *_seriesId=nil;

        if([type isEqualToString:@"NEWSERIES"])
        {
            _seriesId=[DD_NOTInformClass GET_NEWSERIES_NOT_SERIESID];
        }else if([type isEqualToString:@"STARTSERIES"])
        {
            _seriesId=[DD_NOTInformClass GET_STARTSERIES_NOT_SERIESID];
        }
        if(_seriesId)
        {
            for (DD_DDAYModel *_ddaymodel in _dataArr) {
                
                if([_ddaymodel.s_id isEqualToString:_seriesId])
                {
                    [self.navigationController pushViewController:[[DD_DDAYDetailViewController alloc] initWithModel:_ddaymodel WithBlock:^(NSString *type) {
                        if([type isEqualToString:@"update"])
                        {
                            [_tableview reloadData];
                        }
                    }] animated:YES];
                }
            }
        }
        if([type isEqualToString:@"NEWSERIES"])
        {
            [DD_NOTInformClass REMOVE_NEWSERIES_NOT_SERIESID];
        }else if([type isEqualToString:@"STARTSERIES"])
        {
            [DD_NOTInformClass REMOVE_STARTSERIES_NOT_SERIESID];
        }
        
    }
   
}
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
    [[DD_CustomViewController sharedManager] tabbarAppear];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [MobClick beginLogPageView:@"DD_DDAYViewController"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"DD_DDAYViewController"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end