//
//  DD_OrderLogisticsViewController.m
//  DDAY
//
//  Created by yyj on 16/6/7.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_OrderLogisticsViewController.h"

#import "MJRefresh.h"

#import "DD_OrderLogisticsCell.h"
#import "DD_OrderLogisticsHeadView.h"

#import "DD_OrderLogisticsModel.h"
#import "DD_OrderLogisticsManageModel.h"
#import "DD_OrderModel.h"

@interface DD_OrderLogisticsViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

@end

@implementation DD_OrderLogisticsViewController
{
    UITableView *_tableview;
    DD_OrderLogisticsManageModel *LogisticsManageModel;
    DD_OrderLogisticsHeadView *headView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self SomePrepare];
    [self UIConfig];
    [self RequestData];
}
#pragma mark - 初始化
-(instancetype)initWithModel:(DD_OrderModel *)model WithBlock:(void (^)(NSString *type))block
{
    self=[super init];
    if(self)
    {
        _block=block;
        _OrderModel=model;
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
    self.navigationItem.titleView=[regular returnNavView:NSLocalizedString(@"order_logistics", @"") withmaxwidth:200];//设置标题
}
#pragma mark - UIConfig
-(void)UIConfig{
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
        make.left.right.top.mas_equalTo(0);
        make.bottom.mas_equalTo(ktabbarHeight);
    }];

}

#pragma mark - RequestData
-(void)RequestData
{
    [[JX_AFNetworking alloc] GET:@"order/queryOrderDeliveryTraces" parameters:@{@"token":[DD_UserModel getToken],@"orderCode":_OrderModel.subOrderCode} success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
        if(success)
        {
            LogisticsManageModel=[DD_OrderLogisticsManageModel getLogisticsManageModel:data];
            JXLOG(@"%@",LogisticsManageModel);
            [_tableview reloadData];
            if(LogisticsManageModel.LogisticCode)
            {
                if(!headView)
                {
                    headView=[[DD_OrderLogisticsHeadView alloc] initWithCircleListModel:LogisticsManageModel WithBlock:^(NSString *type) {
                        
                    }];
                    headView.frame=CGRectMake(0, 0, ScreenWidth, [DD_OrderLogisticsHeadView heightWithModel:LogisticsManageModel]);
                }else
                {
                    headView.LogisticsManageModel=LogisticsManageModel;
                    [headView setState];
                    headView.frame=CGRectMake(0, 0, ScreenWidth, [DD_OrderLogisticsHeadView heightWithModel:LogisticsManageModel]);
                }
                _tableview.tableHeaderView=headView;
            }
            
        }else
        {
            [self presentViewController:successAlert animated:YES completion:nil];
        }
        [_tableview.mj_header endRefreshing];
        [_tableview.mj_footer endRefreshing];
    } failure:^(NSError *error, UIAlertController *failureAlert) {
        [self presentViewController:failureAlert animated:YES completion:nil];
        [_tableview.mj_header endRefreshing];
        [_tableview.mj_footer endRefreshing];
    }];
}
#pragma mark - SomeAction
-(void)CallActionWithPhoneNum:(NSString *)phoneNumber
{
    NSString *phoneStr = [NSString stringWithFormat:@"tel://%@",phoneNumber];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:phoneNumber message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *dialAction = [UIAlertAction actionWithTitle:@"呼叫" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneStr]];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:cancelAction];
        [alert addAction:dialAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:phoneNumber message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"呼叫", nil];
        
        [alertView show];
    }
}
-(void)MJRefresh
{
    //    MJRefreshNormalHeader *header= [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    NSArray *refreshingImages=[regular getGifImg];
    
    //     Set the ordinary state of animated images
    [header setImages:refreshingImages duration:1.5 forState:MJRefreshStateIdle];
    //     Set the pulling state of animated images（Enter the status of refreshing as soon as loosen）
    [header setImages:refreshingImages duration:1.5 forState:MJRefreshStatePulling];
    //     Set the refreshing state of animated images
    [header setImages:refreshingImages duration:1.5 forState:MJRefreshStateRefreshing];
    
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;    _tableview.mj_header = header;
    [_tableview.mj_header beginRefreshing];
}
-(void)loadNewData
{
    // 进入刷新状态后会自动调用这个block
    [self RequestData];
}
#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [DD_OrderLogisticsCell heightWithModel:LogisticsManageModel.Traces[indexPath.section]];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(LogisticsManageModel.Traces)
    {
        return 1;
    }
    return 0;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(LogisticsManageModel.Traces)
    {
        return LogisticsManageModel.Traces.count;
    }
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    数据还未获取时候
    if(!LogisticsManageModel.Traces)
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
    
    static NSString *cellid=@"cell_logistics";
    DD_OrderLogisticsCell *cell=[_tableview dequeueReusableCellWithIdentifier:cellid];
    if(!cell)
    {
        cell=[[DD_OrderLogisticsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid WithBlock:^(NSString *type,NSString *phoneNum) {
            if([type isEqualToString:@"phone_click"]){
                [self CallActionWithPhoneNum:phoneNum];
            }
        }];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    [cell setLogisticsModel:LogisticsManageModel.Traces[indexPath.section] IsFirst:indexPath.section==0 IsLast:indexPath.section==LogisticsManageModel.Traces.count-1];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    _block(@"choose_design",_dataArr[indexPath.section]);
//    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark  ---------------UIAlertViewDelegate--------------

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    NSString *phoneStr = [NSString stringWithFormat:@"tel://%@",alertView.title];
    if (buttonIndex == 0) {

    }
    else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneStr]];
    }
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
}


@end
