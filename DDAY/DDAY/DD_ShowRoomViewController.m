//
//  DD_ShowRoomViewController.m
//  YCO SPACE
//
//  Created by yyj on 16/8/19.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_ShowRoomViewController.h"

#import "DD_ShowRoomDetailViewController.h"

#import "DD_ShowRoomSimpleCell.h"

#import "DD_ShowRoomModel.h"


@interface DD_ShowRoomViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation DD_ShowRoomViewController
{
    UITableView *_tableview;
    NSMutableArray *_dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self SomePrepare];
    [self UIConfig];
}
#pragma mark - SomePrepare
-(void)SomePrepare
{
    [self PrepareData];
    [self PrepareUI];
}

-(void)PrepareData
{
    _dataArr=[[NSMutableArray alloc] init];
}
-(void)PrepareUI
{
    self.navigationItem.titleView=[regular returnNavView:NSLocalizedString(@"user_showroom", @"") withmaxwidth:200];
}

#pragma mark - UIConfig
-(void)UIConfig
{
    [self CreateTableView];
    [self MJRefresh];
}
-(void)CreateTableView
{
    _tableview=[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    [self.view addSubview:_tableview];
    //    消除分割线
    _tableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableview.delegate=self;
    _tableview.dataSource=self;
    [_tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 0, -ktabbarHeight, 0));
    }];
}
-(void)MJRefresh
{
    _tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        [self RequestData];
    }];
    
    [_tableview.mj_header beginRefreshing];
}
#pragma mark - RequestData
-(void)RequestData
{
    [[JX_AFNetworking alloc] GET:@"physicalStore/queryPhysicalStores.do" parameters:@{@"token":[DD_UserModel getToken]} success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
        if(success)
        {
            [_dataArr removeAllObjects];//删除所有数据
            [_dataArr addObjectsFromArray:[DD_ShowRoomModel getShowRoomModelArr:[data objectForKey:@"stores"]]];
            [_tableview reloadData];

        }else
        {
            [self presentViewController:successAlert animated:YES completion:nil];
        }
        [_tableview.mj_header endRefreshing];
        [_tableview.mj_footer endRefreshing];
        
    } failure:^(NSError *error, UIAlertController *failureAlert) {
        [_tableview.mj_header endRefreshing];
        [_tableview.mj_footer endRefreshing];
        [self presentViewController:failureAlert animated:YES completion:nil];
    }];
}
#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DD_ShowRoomModel *model=[_dataArr objectAtIndex:indexPath.section];
    CGFloat height=[DD_ShowRoomSimpleCell heightWithModel:model];
    return height;
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
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid ];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    static NSString *cellid=@"showroom_cell";
    DD_ShowRoomSimpleCell *cell=[_tableview dequeueReusableCellWithIdentifier:cellid];
    if(!cell)
    {
        cell=[[DD_ShowRoomSimpleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }

    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.showRoomModel=[_dataArr objectAtIndex:indexPath.section];
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DD_ShowRoomModel *roomModel=[_dataArr objectAtIndex:indexPath.section];
    DD_ShowRoomDetailViewController *showroom=[[DD_ShowRoomDetailViewController alloc] initWithShowRoomID:roomModel.s_id];
    showroom.title=roomModel.storeName;
    [self.navigationController pushViewController:showroom animated:YES];
}
#pragma mark - Other

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
