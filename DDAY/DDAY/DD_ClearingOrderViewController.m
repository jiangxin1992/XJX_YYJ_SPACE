//
//  DD_ClearingOrderViewController.m
//  YCO SPACE
//
//  Created by yyj on 16/8/9.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_ClearingOrderViewController.h"

#import "MJRefresh.h"

#import <AlipaySDK/AlipaySDK.h>
#import "DataSigner.h"

#import "DD_OrderDetailViewController.h"
#import "DD_OrderLogisticsViewController.h"
#import "DD_ClearingDoneViewController.h"

#import "DD_OrderHeadView.h"
#import "DD_OrderCell.h"
#import "DD_OrderMoreCell.h"

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
    __block UITableView *__tableview=_tableview;
    cellblock=^(NSString *type,NSIndexPath *indexPath)
    {
        if([type isEqualToString:@"pay"])
        {
            //            支付 1
            [_orderView PayActionWithModel:__dataArr[indexPath.section]];
            
        }else if([type isEqualToString:@"cancel"])
        {
            //            取消订单 1
            [_orderView CancelActionWithModel:__dataArr[indexPath.section] WithIndex:indexPath.section];
            
        }else if([type isEqualToString:@"confirm"])
        {
            //            确认收货
            [_orderView ConfirmActionWithModel:__dataArr[indexPath.section] WithIndex:indexPath.section];
        }else if([type isEqualToString:@"delect"])
        {
            //            删除订单
            [_orderView DelectActionWithModel:__dataArr[indexPath.section] WithIndex:indexPath.section];
        }else if([type isEqualToString:@"logistics"])
        {
            //            查看物流
            [_orderView checkLogisticsInfoWithModel:__dataArr[indexPath.section]];
        }else if([type isEqualToString:@"click"])
        {
            //            跳转订单详情
            [_orderView.navigationController pushViewController:[[DD_OrderDetailViewController alloc] initWithModel:__dataArr[indexPath.section] WithBlock:^(NSString *type, NSDictionary *resultDic) {
                if([type isEqualToString:@"reload"])
                {
                    [__tableview reloadData];
                    
                }else if([type isEqualToString:@"refresh"])
                {
                    [__tableview.mj_header beginRefreshing];
                }
                
            }] animated:YES];
        }
    };
}

#pragma mark - MJRefresh
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
    header.stateLabel.hidden = YES;
    _tableview.mj_header = header;
}
-(void)loadNewData
{
    // 进入刷新状态后会自动调用这个block
    [self RequestData];
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
    if([self isVisible]){
        DD_ClearingDoneViewController *_DoneView=[[DD_ClearingDoneViewController alloc] initWithReturnCode:[not.object objectForKey:@"resultStatus"] WithTradeOrderCode:[not.object objectForKey:@"tradeOrderCode"] WithType:@"clear" WithBlock:^(NSString *type) {
            [self RequestData];
        }];
        [self.navigationController pushViewController:_DoneView animated:YES];
    }
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
        make.edges.mas_equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 0, -kTabbarHeight, 0));
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
            [_tableview.mj_header endRefreshing];
            [_tableview.mj_footer endRefreshing];
        }else
        {
            [self presentViewController:successAlert animated:YES completion:nil];
            [_tableview.mj_header endRefreshing];
            [_tableview.mj_footer endRefreshing];
        }
    } failure:^(NSError *error, UIAlertController *failureAlert) {
        [self presentViewController:failureAlert animated:YES completion:nil];
        [_tableview.mj_header endRefreshing];
        [_tableview.mj_footer endRefreshing];
    }];
    
}
#pragma mark - SomeActions
/**
 * 查看物流
 */
-(void)checkLogisticsInfoWithModel:(DD_OrderModel *)_OrderModel
{
    if(_OrderModel.subOrderCode)
    {
        //    跳转物流信息界面
        [self.navigationController pushViewController:[[DD_OrderLogisticsViewController alloc] initWithModel:_OrderModel WithBlock:nil] animated:YES];
    }
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
        [[JX_AFNetworking alloc] GET:@"order/v1_0_7/cancelOrder.do" parameters:_parameters success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
            if(success)
            {
                _OrderModel.orderStatus=[[data objectForKey:@"status"] longLongValue];
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
    [[JX_AFNetworking alloc] GET:@"order/orderExpireCheck.do" parameters:@{@"token":[DD_UserModel getToken],@"tradeOrderCode":_OrderModel.tradeOrderCode} success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
        if(success)
        {
            //不验证直接获取orderSpec 发起支付
            NSDictionary *_parameters=@{@"token":[DD_UserModel getToken],@"tradeOrderCode":_OrderModel.tradeOrderCode};
            [[JX_AFNetworking alloc] GET:@"order/queryOrderPayParams.do" parameters:_parameters success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
                if(success)
                {
                    NSString *appScheme = @"DDAY";
                    //            payParam
                    NSString *orderSpec = [data objectForKey:@"payParam"];
                    JXLOG(@"orderSpec = %@",orderSpec);
                    id<DataSigner> signer = CreateRSADataSigner([data objectForKey:@"privateKey"]);
                    NSString *signedString = [signer signString:orderSpec];
                    NSString *orderString = nil;
                    if (signedString != nil) {
                        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                                       orderSpec, signedString, @"RSA"];
                        JXLOG(@"%@",orderString);
                        [DD_UserModel setTradeOrderCode:[data objectForKey:@"tradeOrderCode"]];
                        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                            [self RequestData];
                            
                            [self.navigationController pushViewController:[[DD_ClearingDoneViewController alloc] initWithReturnCode:[resultDic objectForKey:@"resultStatus"] WithTradeOrderCode:[data objectForKey:@"tradeOrderCode"] WithType:@"order" WithBlock:^(NSString *type) {
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
    return 222;
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
    DD_OrderModel *_order=_dataArr[indexPath.section];
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
    [self.navigationController pushViewController:[[DD_OrderDetailViewController alloc] initWithModel:_dataArr[indexPath.section] WithBlock:^(NSString *type, NSDictionary *resultDic) {
        if([type isEqualToString:@"reload"])
        {
            [_tableview reloadData];
            
        }else if([type isEqualToString:@"refresh"])
        {
            [_tableview.mj_header beginRefreshing];
        }
        
    }] animated:YES];
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
    return [[DD_OrderHeadView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 35) WithOrderModel:_dataArr[section] WithSection:section WithBlock:^(NSString *type, NSInteger section) {
        if([type isEqualToString:@"click"])
        {
            [self.navigationController pushViewController:[[DD_OrderDetailViewController alloc] initWithModel:_dataArr[section] WithBlock:^(NSString *type, NSDictionary *resultDic) {
                if([type isEqualToString:@"reload"])
                {
                    [_tableview reloadData];
                    
                }else if([type isEqualToString:@"refresh"])
                {
                    [_tableview.mj_header beginRefreshing];
                }
            }] animated:YES];
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
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
