//
//  DD_ClearingOrderViewController.m
//  YCO SPACE
//
//  Created by yyj on 16/8/9.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_ClearingOrderViewController.h"

#import <AlipaySDK/AlipaySDK.h>
#import "DD_ClearingViewController.h"
#import "DD_OrderDetailViewController.h"
#import "DD_OrderLogisticsViewController.h"
#import "DD_ClearingDoneViewController.h"

#import "DataSigner.h"

#import "DD_OrderHeadView.h"
#import "DD_OrderCell.h"
#import "DD_OrderMoreCell.h"


#import "DD_ClearingModel.h"
#import "DD_OrderModel.h"

@interface DD_ClearingOrderViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation DD_ClearingOrderViewController
{
    NSMutableArray *_dataArr;
    UITableView *_tableview;
    void (^cellblock)(NSString *type,NSIndexPath *indexPath);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self SomePrepare];
    [self UIConfig];
    [self SomeBlock];
}
-(instancetype)initWithDataArr:(NSMutableArray *)dataArr WithTradeOrderCode:(NSString *)tradeOrderCode
{
    self=[super init];
    if(self)
    {
        _dataArr=dataArr;
        _tradeOrderCode=tradeOrderCode;
    }
    return self;
}
#pragma mark - SomeBlock
-(void)SomeBlock
{
    __block DD_ClearingOrderViewController *_orderView=self;
    __block NSArray *__dataArr=_dataArr;
    cellblock=^(NSString *type,NSIndexPath *indexPath)
    {
        if([type isEqualToString:@"pay"])
        {
            //            支付 1
            [_orderView PayActionWithModel:[__dataArr objectAtIndex:indexPath.section]];
            
        }else if([type isEqualToString:@"cancel"])
        {
            //            取消订单 1
            [_orderView CancelActionWithModel:[__dataArr objectAtIndex:indexPath.section] WithIndex:indexPath.section];
            
        }else if([type isEqualToString:@"confirm"])
        {
            //            确认收货
            [_orderView ConfirmActionWithModel:[__dataArr objectAtIndex:indexPath.section] WithIndex:indexPath.section];
        }else if([type isEqualToString:@"delect"])
        {
            //            删除订单
            [_orderView DelectActionWithModel:[__dataArr objectAtIndex:indexPath.section] WithIndex:indexPath.section];
        }else if([type isEqualToString:@"logistics"])
        {
            //            查看物流
            [_orderView checkLogisticsInfoWithModel:[__dataArr objectAtIndex:indexPath.section]];
        }else if([type isEqualToString:@"click"])
        {
            //            跳转订单详情
            [_orderView.navigationController pushViewController:[[DD_OrderDetailViewController alloc] initWithModel:[__dataArr objectAtIndex:indexPath.section] WithBlock:nil] animated:YES];
        }
    };
}

#pragma mark - MJRefresh
-(void)MJRefresh
{
    _tableview.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        [self RequestData];
    }];
}
#pragma mark - SomePrepare
-(void)SomePrepare
{
    [self PrepareData];
    [self PrepareUI];
}
-(void)PrepareData
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payAction:) name:@"payAction" object:nil];
}
-(void)PrepareUI
{
    self.navigationItem.titleView=[regular returnNavView:NSLocalizedString(@"clearing_order_list", @"") withmaxwidth:200];//设置标题
}
/**
 * 支付回调
 */
-(void)payAction:(NSNotification *)not
{
    
    DD_ClearingDoneViewController *_DoneView=[[DD_ClearingDoneViewController alloc] initWithReturnCode:[not.object objectForKey:@"returnCode"] WithTradeOrderCode:[not.object objectForKey:@"out_trade_no"] WithType:@"clear" WithBlock:^(NSString *type) {
        [self RequestData];
    }];
    [self.navigationController pushViewController:_DoneView animated:YES];
}
#pragma mark - UIConfig
-(void)UIConfig
{
    [self CreateTableView];
    [self MJRefresh];
}
/**
 * tableview创建
 */
-(void)CreateTableView
{
    
    _tableview=[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:_tableview];
    //    消除分割线
    _tableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableview.delegate=self;
    _tableview.dataSource=self;
    _tableview.alwaysBounceHorizontal=NO;
    _tableview.alwaysBounceVertical=YES;
    [_tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 0, -ktabbarHeight, 0));
    }];
    [_tableview reloadData];
    
}
#pragma mark - RequestData
-(void)RequestData
{
    
    [[JX_AFNetworking alloc] GET:@"order/queryTradeOrderInfo.do" parameters:@{@"tradeOrderCode":_tradeOrderCode,@"token":[DD_UserModel getToken]} success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
        if(success)
        {
            [_dataArr removeAllObjects];
            NSArray *getArr=[DD_OrderModel getOrderModelArr:[data objectForKey:@"orders"]];
            [_dataArr addObjectsFromArray:getArr];
            [_tableview.header endRefreshing];
            [_tableview.footer endRefreshing];
        }else
        {
            [self presentViewController:successAlert animated:YES completion:nil];
            [_tableview.header endRefreshing];
            [_tableview.footer endRefreshing];
        }
    } failure:^(NSError *error, UIAlertController *failureAlert) {
        [self presentViewController:failureAlert animated:YES completion:nil];
        [_tableview.header endRefreshing];
        [_tableview.footer endRefreshing];
    }];
    
}
#pragma mark - SomeActions
/**
 * 查看物流
 */
-(void)checkLogisticsInfoWithModel:(DD_OrderModel *)_OrderModel
{
    //    跳转物流信息界面
    [self.navigationController pushViewController:[[DD_OrderLogisticsViewController alloc] initWithModel:_OrderModel WithBlock:nil] animated:YES];
}
/**
 * 删除订单
 */
-(void)DelectActionWithModel:(DD_OrderModel *)_OrderModel WithIndex:(NSInteger )section
{
    [self presentViewController:[regular alertTitleCancel_Simple:NSLocalizedString(@"order_if_delete_order", @"") WithBlock:^{
        [[JX_AFNetworking alloc] GET:@"order/deleteOrder.do" parameters:@{@"token":[DD_UserModel getToken],@"orderCode":_OrderModel.subOrderCode} success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
            if(success)
            {
                [_dataArr removeObjectAtIndex:section];
                [_tableview reloadData];
            }else
            {
                [self presentViewController:successAlert animated:YES completion:nil];
            }
        } failure:^(NSError *error, UIAlertController *failureAlert) {
            [self presentViewController:failureAlert animated:YES completion:nil];
        }];
    }] animated:YES completion:nil];
    
}
/**
 * 确认收货
 */
-(void)ConfirmActionWithModel:(DD_OrderModel *)_OrderModel WithIndex:(NSInteger )section
{
    [self presentViewController:[regular alertTitleCancel_Simple:NSLocalizedString(@"order_if_confirm", @"") WithBlock:^{
        [[JX_AFNetworking alloc] GET:@"order/confirmOrder.do" parameters:@{@"token":[DD_UserModel getToken],@"orderCode":_OrderModel.subOrderCode} success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
            if(success)
            {
                _OrderModel.orderStatus=3;
                [_tableview reloadData];
            }else
            {
                [self presentViewController:successAlert animated:YES completion:nil];
            }
        } failure:^(NSError *error, UIAlertController *failureAlert) {
            [self presentViewController:failureAlert animated:YES completion:nil];
        }];
    }] animated:YES completion:nil];
    
}
/**
 * 取消订单
 */
-(void)CancelActionWithModel:(DD_OrderModel *)_OrderModel WithIndex:(NSInteger )section
{
    [self presentViewController:[regular alertTitleCancel_Simple:NSLocalizedString(@"order_if_cancel_order", @"") WithBlock:^{
        NSDictionary *_parameters = @{@"token":[DD_UserModel getToken],@"tradeOrderCode":_OrderModel.tradeOrderCode};
        [[JX_AFNetworking alloc] GET:@"order/cancelOrder.do" parameters:_parameters success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
            if(success)
            {
                [_dataArr removeObjectAtIndex:section];
                [_tableview reloadData];
            }else
            {
                [self presentViewController:successAlert animated:YES completion:nil];
            }
        } failure:^(NSError *error, UIAlertController *failureAlert) {
            [self presentViewController:failureAlert animated:YES completion:nil];
        }];
    }] animated:YES completion:nil];
    
    
}
/**
 * 继续支付
 */
-(void)PayActionWithModel:(DD_OrderModel *)_OrderModel
{
    //不验证直接获取orderSpec 发起支付
    NSDictionary *_parameters=@{@"token":[DD_UserModel getToken],@"tradeOrderCode":_OrderModel.tradeOrderCode};
    [[JX_AFNetworking alloc] GET:@"order/queryOrderPayParams.do" parameters:_parameters success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
        if(success)
        {
            NSString *appScheme = @"DDAY";
            //            payParam
            NSString *orderSpec = [data objectForKey:@"payParam"];
            NSLog(@"orderSpec = %@",orderSpec);
            id<DataSigner> signer = CreateRSADataSigner([data objectForKey:@"privateKey"]);
            NSString *signedString = [signer signString:orderSpec];
            NSString *orderString = nil;
            if (signedString != nil) {
                orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                               orderSpec, signedString, @"RSA"];
                NSLog(@"%@",orderString);
                [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                    [self RequestData];
                    [self.navigationController pushViewController:[[DD_ClearingDoneViewController alloc] initWithReturnCode:[resultDic objectForKey:@"resultStatus"] WithTradeOrderCode:_OrderModel.tradeOrderCode WithType:@"order" WithBlock:^(NSString *type) {
                    }] animated:YES];
                }];
            }
        }else
        {
            [self presentViewController:successAlert animated:YES completion:nil];
        }
    } failure:^(NSError *error, UIAlertController *failureAlert) {
        [self presentViewController:failureAlert animated:YES completion:nil];
    }];
}
#pragma mark - TableViewDelegate


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DD_OrderModel *_order=[_dataArr objectAtIndex:indexPath.section];
    if(_order.orderStatus==1)
    {
        return 178;
    }else
    {
        return 222;
    }
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
    DD_OrderModel *_order=[_dataArr objectAtIndex:indexPath.section];
    if([_order isSingle])
    {
        static NSString *CellIdentifier = @"cell_single";
        
        DD_OrderCell *cell=[_tableview dequeueReusableCellWithIdentifier:CellIdentifier];
        if(!cell)
        {
            
            cell=[[DD_OrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier WithBlock:^(NSString *type, NSIndexPath *indexPath) {
                
            }];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.indexPath=indexPath;
        cell.cellblock=cellblock;
        cell.OrderModel=_order;
        return cell;
    }else
    {
        static NSString *CellIdentifier = @"cell_single_f";
        DD_OrderMoreCell *cell=[_tableview dequeueReusableCellWithIdentifier:CellIdentifier];
        if(!cell)
        {
            
            cell=[[DD_OrderMoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier WithBlock:^(NSString *type, NSIndexPath *indexPath) {
                
            }];
        }
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.indexPath=indexPath;
        cell.cellblock=cellblock;
        cell.OrderModel=_order;
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    跳转订单详情
    [self.navigationController pushViewController:[[DD_OrderDetailViewController alloc] initWithModel:[_dataArr objectAtIndex:indexPath.section] WithBlock:nil] animated:YES];
}
//section头部间距
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    //section头部高度
    return 35;
}
//section头部视图
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[DD_OrderHeadView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 35) WithOrderModel:[_dataArr objectAtIndex:section] WithSection:section WithBlock:^(NSString *type, NSInteger section) {
        if([type isEqualToString:@"click"])
        {
            [self.navigationController pushViewController:[[DD_OrderDetailViewController alloc] initWithModel:[_dataArr objectAtIndex:section] WithBlock:nil] animated:YES];
        }
    }];
}
//section底部间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

#pragma mark - Others
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(_tableview)
    {
        [self RequestData];
    }
    [MobClick beginLogPageView:@"DD_OrderViewController"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"DD_OrderViewController"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end