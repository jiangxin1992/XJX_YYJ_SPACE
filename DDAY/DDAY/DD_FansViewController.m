//
//  DD_FansViewController.m
//  DDAY
//
//  Created by yyj on 16/6/27.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_FansViewController.h"

#import "DD_DesignerHomePageViewController.h"
#import "DD_TarentoHomePageViewController.h"

#import "DD_FansCell.h"

#import "DD_FansModel.h"

@interface DD_FansViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation DD_FansViewController
{
    NSMutableArray *_dataArr;
    NSInteger _page;
    UITableView *_tableview;
    
    void (^cellBlock)(NSString *type,NSInteger index);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self SomePrepare];
    [self UIConfig];
}
-(instancetype)initWithBlock:(void (^)(NSString *))block
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
    _dataArr=[[NSMutableArray alloc] init];
    _page=1;
}
-(void)PrepareUI{
    self.navigationItem.titleView=[regular returnNavView:NSLocalizedString(@"user_fans", @"") withmaxwidth:200];
}
#pragma mark - UIConfig
-(void)UIConfig
{
    [self CreateTableview];
    [self MJRefresh];
}
-(void)CreateTableview
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
#pragma mark - RequestData
-(void)RequestData
{
    [[JX_AFNetworking alloc] GET:@"designer/queryFans.do" parameters:@{@"page":[NSNumber numberWithInteger:_page],@"token":[DD_UserModel getToken]} success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
        if(success)
        {
            NSArray *modelArr=[DD_FansModel getFansModelArr:[data objectForKey:@"fans"]];
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
                if(_page==1)
                {
                    [_dataArr removeAllObjects];//删除所有数据
                    [_tableview reloadData];
                }
            }
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
    return 68;
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
    static NSString *cellid=@"cellid";
    DD_FansCell *cell=[_tableview dequeueReusableCellWithIdentifier:cellid];
    if(!cell)
    {
        cell=[[DD_FansCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    cell.fansModel=[_dataArr objectAtIndex:indexPath.section];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DD_FansModel *fanModel=[_dataArr objectAtIndex:indexPath.section];
    
    if([fanModel.userType integerValue]==2)
    {
        //                设计师
        DD_DesignerHomePageViewController *_DesignerHomePage=[[DD_DesignerHomePageViewController alloc] init];
        _DesignerHomePage.designerId=fanModel.userId;
        [self.navigationController pushViewController:_DesignerHomePage animated:YES];
    }else if([fanModel.userType integerValue]==4)
    {
        //                达人
        [self.navigationController pushViewController:[[DD_TarentoHomePageViewController alloc] initWithUserId:fanModel.userId] animated:YES];
    }else
    {
        [self presentViewController:[regular alertTitle_Simple:NSLocalizedString(@"no_homepage", @"")] animated:YES completion:nil];
    }
    
}
#pragma mark - SomeAction
-(void)MJRefresh
{
    MJRefreshNormalHeader *header= [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    _tableview.mj_header = header;
    
    MJRefreshAutoNormalFooter *_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [_footer setTitle:@"" forState:MJRefreshStateNoMoreData];
    [_footer setTitle:@"" forState:MJRefreshStateIdle];
    [_footer setTitle:@"" forState:MJRefreshStatePulling];
    [_footer setTitle:@"" forState:MJRefreshStateRefreshing];
    [_footer setTitle:@"" forState:MJRefreshStateWillRefresh];
    _footer.refreshingTitleHidden = YES;
    _footer.stateLabel.textColor = _define_light_gray_color1;
    _tableview.mj_footer = _footer;
    
    [_tableview.mj_header beginRefreshing];
    
}
-(void)loadNewData
{
    // 进入刷新状态后会自动调用这个block
    _page=1;
    [self RequestData];
}
-(void)loadMoreData
{
    // 进入刷新状态后会自动调用这个block
    _page+=1;
    [self RequestData];
}
#pragma mark - Other
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"DD_FansViewController"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"DD_FansViewController"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
