//
//  DD_UserCollectItemViewController.m
//  DDAY
//
//  Created by yyj on 16/6/13.
//  Copyright © 2016年 YYJ. All rights reserved.
//
#import "DD_GoodsDetailViewController.h"
#import "DD_ItemCell.h"
#import "MJRefresh.h"
#import "DD_ShopViewController.h"
#import "DD_UserCollectItemViewController.h"

@interface DD_UserCollectItemViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation DD_UserCollectItemViewController
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
-(instancetype)initWithBlock:(void(^)(NSString *type,DD_ItemsModel *model))block
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
-(void)PrepareData
{
    _page=1;
    _dataArr=[[NSMutableArray alloc] init];
}
-(void)PrepareUI{}
#pragma mark - RequestData
-(void)RequestData
{
    NSDictionary *_parameters=@{@"page":[NSNumber numberWithInteger:_page],@"token":[DD_UserModel getToken]};
    [[JX_AFNetworking alloc] GET:@"item/queryItemCollections.do" parameters:_parameters success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
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
    _tableview=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth,ScreenHeight-kNavHeight-54) style:UITableViewStyleGrouped];
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
    _block(@"detail",_model);
    
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

#pragma mark - Other
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"DD_UserCollectItemViewController"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"DD_UserCollectItemViewController"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
