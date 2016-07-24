//
//  DD_ClearingViewController.m
//  DDAY
//
//  Created by yyj on 16/5/18.
//  Copyright © 2016年 mike_xie. All rights reserved.
//
#import <AlipaySDK/AlipaySDK.h>
#import "DataSigner.h"
#import "DD_ClearingSeriesModel.h"
#import "DD_AddressViewController.h"
#import "DD_SetAddressBtn.h"
#import "DD_ClearingView.h"
#import "DD_ClearingTool.h"
#import "DD_ClearingViewController.h"
#import "DD_ClearingTableViewCell.h"
#import "DD_ClearingOrderModel.h"
#import "DD_RemarksViewController.h"
#import "DD_ClearingDoneViewController.h"
@interface DD_ClearingViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableDictionary *_dataDict;
    NSMutableArray *_dataArr;
    
    UITableView *_tableview;
    
    UIView *_tabBar;
    
    DD_ClearingView *_ClearingView;
    DD_SetAddressBtn *_AddressBtn;// 选择地址按钮
    
    NSString *remarksStr;// 订单备注 默认为空
}

@end

@implementation DD_ClearingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self SomePrepare];
    [self UIConfig];
    [self AnalysisData];
    [self CreateHeadView];
    [self CreateFootView];
}
#pragma mark - 初始化
-(instancetype)initWithModel:(DD_ClearingModel *)_model WithBlock:(void (^)(NSString *type))block
{
    self=[super init];
    if(self)
    {
        _Clearingmodel=_model;
//        NSMutableArray *sss=[[NSMutableArray alloc] init];
//        [sss addObjectsFromArray:_Clearingmodel.orders];
//        [sss addObjectsFromArray:_Clearingmodel.orders];
//        _Clearingmodel.orders=sss;
        _successblock=block;
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
    
    remarksStr=@"";
    _dataDict=[[NSMutableDictionary alloc] init];
    _dataArr=[[NSMutableArray alloc] init];
    /**
     * 支付宝回调。
     * 客户端回调，会回调AppDelegate里面的支付宝结算回调中
     * 通过通知，发送回调消息
     */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payAction:) name:@"payAction" object:nil];
}
-(void)PrepareUI{
    self.navigationItem.titleView=[regular returnNavView:NSLocalizedString(@"checkorder_title", @"") withmaxwidth:200];
    self.view.backgroundColor=_define_backview_color;
}
#pragma mark - UIConfig
-(void)UIConfig
{
    [self CreateTableView];
    [self CreateTabBar];
}
-(void)CreateTableView
{
    _tableview=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableview];
    
    //    消除分割线
    _tableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableview.delegate=self;
    _tableview.dataSource=self;
    _tableview.tableHeaderView=[[UIView alloc]initWithFrame:CGRectMake(0,0,0,0.1)];
    _tableview.tableFooterView=[[UIView alloc]initWithFrame:CGRectMake(0,0,0,0.1)];
}
/**
 * 确认订单按钮
 */
-(void)CreateTabBar
{
    _tabBar=[[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight-ktabbarHeight, ScreenWidth, ktabbarHeight)];
    _tabBar.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_tabBar];
    UIButton *ConfirmBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    ConfirmBtn.frame=CGRectMake(0, 0, ScreenWidth, ktabbarHeight);
    [_tabBar addSubview:ConfirmBtn];
    [ConfirmBtn addTarget:self action:@selector(ConfirmAction) forControlEvents:UIControlEventTouchUpInside];
    ConfirmBtn.backgroundColor=[UIColor blackColor];
    [ConfirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [ConfirmBtn setTitle:@"确认订单" forState:UIControlStateNormal];
}
/**
 * 创建地址视图 HeadView
 */
-(void)CreateHeadView
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 122)];
    
    _AddressBtn=[DD_SetAddressBtn buttonWithType:UIButtonTypeCustom WithFrame:CGRectMake(0, 0, ScreenWidth, 120)WithAddressModel:_Clearingmodel.address WithBlock:^(NSString *type) {
        if([type isEqualToString:@"address"])
        {
            //            添加收货地址
            [self.navigationController pushViewController:[[DD_AddressViewController alloc]initWithType:@"address" WithBlock:^(NSString *type, DD_AddressModel *addressModel) {
                if([type isEqualToString:@"add_address"])
                {
                    _Clearingmodel.address=addressModel;
                    if(addressModel)
                    {
                        [_dataDict setObject:@{@"addressId":addressModel.udaId,@"deliverName":addressModel.deliverName,@"deliverPhone":addressModel.deliverPhone,@"detailAddress":addressModel.detailAddress} forKey:@"address"];
                    }else
                    {
                        [_dataDict removeObjectForKey:@"address"];
                    }
                    _AddressBtn.AddressModel=addressModel;
                    [_AddressBtn SetState];
                }
                
            }] animated:YES];
        }
    }];
    view.backgroundColor=[UIColor clearColor];
    [view addSubview:_AddressBtn];
    _tableview.tableHeaderView=view;
}
/**
 * 创建总结视图 FootView
 */
-(void)CreateFootView
{
    _ClearingView=[[DD_ClearingView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 300) WithDataArr:_dataArr Withfreight:_Clearingmodel.freight WithCountPrice:[_dataDict objectForKey:@"subTotal"] WithBlock:^(NSString *type, CGFloat height) {
        if([type isEqualToString:@"remarks"])
        {
            //            跳转remarks界面
            [self PushRemarksView];
            
        }else if([type isEqualToString:@"height"])
        {
            _ClearingView.frame=CGRectMake(CGRectGetMinX(_ClearingView.frame), CGRectGetMinY(_ClearingView.frame), ScreenWidth, height);
            _tableview.tableFooterView=_ClearingView;
        }
    }];
    _tableview.tableFooterView=_ClearingView;
}
#pragma mark - AnalysisData
/**
 * 数据解析
 */
-(void)AnalysisData
{
    [_dataDict setDictionary:[_Clearingmodel getOrderInfo]];
    [_dataArr addObjectsFromArray:[[_dataDict objectForKey:@"orders"] objectForKey:@"remain"]];
    [_dataArr addObjectsFromArray:[[_dataDict objectForKey:@"orders"] objectForKey:@"saleing"]];
    [_tableview reloadData];
}

#pragma mark - SomeAction
/**
 * 确认订单按钮点击动作
 */
-(void)ConfirmAction
{
    if([_dataDict objectForKey:@"address"])
    {
        //    结算验证  不反悔参数
        NSDictionary *_parameters=@{@"token":[DD_UserModel getToken],@"buyItems":[[_Clearingmodel getItemsArr] JSONString]};
        [[JX_AFNetworking alloc] GET:@"item/buyCheckWithOutReturnData.do" parameters:_parameters success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
            if(success)
            {
                [self CreateOrder];
            }else
            {
                [self presentViewController:successAlert animated:YES completion:nil];
            }
        } failure:^(NSError *error, UIAlertController *failureAlert) {
            [self presentViewController:failureAlert animated:YES completion:nil];
        }];
    }else
    {
        [self presentViewController:[regular alertTitle_Simple:NSLocalizedString(@"clearing_no_address", @"")] animated:YES completion:nil];
    }

}

/**
 * 订单验证通过之后，创建支付宝订单，进行支付
 */
-(void)CreateOrder
{
    if([_dataDict objectForKey:@"address"])
    {
        NSDictionary *_parameters=@{
                                    @"token":[DD_UserModel getToken]
                                    ,@"orderInfo":[[DD_ClearingTool getPayOrderInfoWithDataDict:_dataDict WithDataArr:_dataArr WithRemarks:remarksStr WithFreight:_Clearingmodel.freight] JSONString]
                                    };
        [[JX_AFNetworking alloc] GET:@"order/createOrder.do" parameters:_parameters success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
            if(success)
            {
                NSString *appScheme = @"DDAY";
                NSString *orderSpec = [data objectForKey:@"order"];
//                NSString *orderSpec = @"payment_type=\"1\"&out_trade_no=\"113381717ez12\"&partner=\"2088911850774983\"&_input_charset=\"utf-8\"&subject=\"L.Chan\"&service=\"mobile.securitypay.pay\"&total_fee=\"0.01\"&body=\"testBody\"&notify_url=\"http://121.40.57.9/service/pay/appAlipayNotify\"&seller_id=\"info@yunejian.com\"";
//                NSLog(@"orderSpec = %@",orderSpec);
                id<DataSigner> signer = CreateRSADataSigner([data objectForKey:@"privateKey"]);
                NSString *signedString = [signer signString:orderSpec];
                NSString *orderString = nil;
                if (signedString != nil) {
                    orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                                   orderSpec, signedString, @"RSA"];
                    NSLog(@"%@",orderString);
                    [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                        [self.navigationController pushViewController:[[DD_ClearingDoneViewController alloc] initWithReturnCode:[resultDic objectForKey:@"resultStatus"] WithType:@"clear" WithBlock:^(NSString *type) {
                            //                            if(type)
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
        [self presentViewController:[regular alertTitle_Simple:NSLocalizedString(@"clearing_no_address", @"")] animated:YES completion:nil];
    }
}
/**
 * 跳转填写备注界面
 */
-(void)PushRemarksView
{
    [self.navigationController pushViewController:[[DD_RemarksViewController alloc] initWithRemarks:remarksStr WithLimit:0 WithTitle:@"订单备注" WithBlock:^(NSString *type, NSString *content) {
        if([type isEqualToString:@"done"])
        {
            if(_ClearingView)
            {
                [_ClearingView setRemarksWithWebView:content];
                remarksStr=content;
            }
        }
    }] animated:YES];
}
/**
 * 支付回调
 */
-(void)payAction:(NSNotification *)not
{
    DD_ClearingDoneViewController *_DoneView=[[DD_ClearingDoneViewController alloc] initWithReturnCode:not.object WithType:@"clear" WithBlock:^(NSString *type) {
        //                            if(type)
    }];
    [self.navigationController pushViewController:_DoneView animated:YES];
}


#pragma mark - TableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    DD_ClearingSeriesModel *_Series=[_dataArr objectAtIndex:section];
    return _Series.items.count;
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
    
    //获取到数据以后
    static NSString *cellid=@"cell_p";
    DD_ClearingTableViewCell *cell=[_tableview dequeueReusableCellWithIdentifier:cellid];
    if(!cell)
    {
        cell=[[DD_ClearingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid WithBlock:^(NSString *type) {
            if([type isEqualToString:@"click"])
            {
                //                修改
            }
        }];
    }
    DD_ClearingSeriesModel *_Series=[_dataArr objectAtIndex:indexPath.section];
    cell.ClearingModel=[_Series.items objectAtIndex:indexPath.row];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
//section头部间距
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    //section头部高度
    return 40;
}
//section头部视图
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [(DD_ClearingSeriesModel *)[_dataArr objectAtIndex:section] getViewHeader];
}
//section底部间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{

    return 40;
}
//section底部视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [(DD_ClearingSeriesModel *)[_dataArr objectAtIndex:section] getViewFooter];
}

#pragma mark - Other
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"DD_ClearingViewController"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"DD_ClearingViewController"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
