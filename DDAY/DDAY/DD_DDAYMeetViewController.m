//
//  DD_DDAYMeetViewController.m
//  DDAY
//
//  Created by yyj on 16/6/3.
//  Copyright © 2016年 YYJ. All rights reserved.
//
#import "DD_ItemsModel.h"
#import "DD_ItemCell.h"
#import "MJRefresh.h"
#import "DD_ShopViewController.h"
#import "DD_DDAYMeetViewController.h"
#import "DD_GoodsDetailViewController.h"

@interface DD_DDAYMeetViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation DD_DDAYMeetViewController
{
    UITableView *_tableview;
    NSMutableArray *_dataArr;
    NSInteger _page;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self SomePrepare];
    [self UIConfig];
}
#pragma mark - 初始化
-(instancetype)initWithType:(NSString *)type WithSeriesID:(NSString *)SeriesID WithBlock:(void(^)(NSString *type))meetBlock;
{
    self=[super init];
    if(self)
    {
        _SeriesID=SeriesID;
        _meetBlock=meetBlock;
        _Type=type;
    }
    return self;
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

    if([_Type isEqualToString:@"meet"])
    {
        self.navigationItem.titleView=[regular returnNavView:@"查看发布会" withmaxwidth:200];
    }else if([_Type isEqualToString:@"good"])
    {
        self.navigationItem.titleView=[regular returnNavView:@"查看发布品" withmaxwidth:200];
    }

    UIButton *buyBtn=[regular getBarCustomBtnWithImg:@"System_Buy" WithSelectImg:@"System_Buy" WithSize:CGSizeMake(24, 25)];
    
    [buyBtn addTarget:self action:@selector(PushShopView) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:buyBtn];
}
#pragma mark - RequestData
-(void)RequestData
{
    NSDictionary *_parameters=@{@"page":[NSNumber numberWithInteger:_page],@"token":[DD_UserModel getToken],@"seriesId":_SeriesID};
    [[JX_AFNetworking alloc] GET:@"series/querySeriesColorsItems.do" parameters:_parameters success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
        if(success)
        {
            NSArray *modelArr=[DD_ItemsModel getItemsModelArr:[data objectForKey:@"items"]];
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
#pragma mark - MJRefresh
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
#pragma mark - SomeAction
//跳转购物车
-(void)PushShopView
{
    DD_ShopViewController *_shop=[[DD_ShopViewController alloc] init];
    [self.navigationController pushViewController:_shop animated:YES];
}

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
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
    
    static NSString *CellIdentifier = @"cell_goods";
    BOOL nibsRegistered = NO;
    if (!nibsRegistered) {
        UINib *nib = [UINib nibWithNibName:NSStringFromClass([DD_ItemCell class]) bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:CellIdentifier];
        nibsRegistered = YES;
    }
    DD_ItemCell *cell = (DD_ItemCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.item=[_dataArr objectAtIndex:indexPath.section];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DD_ItemsModel *_model=[_dataArr objectAtIndex:indexPath.section];
    DD_GoodsDetailViewController *_GoodsDetail=[[DD_GoodsDetailViewController alloc] initWithModel:_model WithBlock:^(DD_ItemsModel *model, NSString *type) {
        //        if(type)
    }];
    _GoodsDetail.title=_model.name;
    [self.navigationController pushViewController:_GoodsDetail animated:YES];
    
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

#pragma mark - Others
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[DD_CustomViewController sharedManager] tabbarHide];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [MobClick beginLogPageView:@"DD_DDAYMeetViewController"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"DD_DDAYMeetViewController"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
