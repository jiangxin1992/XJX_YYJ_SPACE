//
//  DD_OrderDetailViewController.m
//  DDAY
//
//  Created by yyj on 16/6/7.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_OrderDetailViewController.h"

#import <AlipaySDK/AlipaySDK.h>
#import "DataSigner.h"

#import "DD_OrderRefundViewController.h"
#import "DD_OrderLogisticsViewController.h"
#import "DD_GoodsDetailViewController.h"
#import "DD_ClearingDoneViewController.h"

#import "DD_OrderTabBar.h"
#import "DD_OrderClearingView.h"
#import "DD_ClearingTableViewCell.h"
#import "DD_OrderAddressView.h"

#import "DD_OrderTool.h"
#import "DD_OrderDetailModel.h"
#import "DD_ItemsModel.h"

@interface DD_OrderDetailViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation DD_OrderDetailViewController
{
    DD_OrderDetailModel *_OrderDetailModel;
    UITableView *_tableview;
    DD_OrderTabBar *_tabBar;
    DD_OrderClearingView *_ClearingView;
    DD_OrderAddressView *_AddressView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self SomePrepare];
    [self UIConfig];
    [self RequestData];
}
#pragma mark - 初始化
-(instancetype)initWithModel:(DD_OrderModel *)model WithBlock:(void (^)(NSString *type,NSDictionary *resultDic))block
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
-(void)PrepareData
{
    /**
     * 支付宝回调。
     * 客户端回调，会回调AppDelegate里面的支付宝结算回调中
     * 通过通知，发送回调消息
     */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payAction:) name:@"payAction" object:nil];
}
-(void)PrepareUI
{
    self.navigationItem.titleView=[regular returnNavView:NSLocalizedString(@"order_detail", @"") withmaxwidth:200];//设置标题
}
#pragma mark - UIConfig
-(void)UIConfig
{
    [self CreateTableView];
}
-(void)CreateTableView
{
    _tableview=[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:_tableview];
    //    消除分割线
    _tableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableview.delegate=self;
    _tableview.dataSource=self;
    _tableview.tableHeaderView=[[UIView alloc]initWithFrame:CGRectMake(0,0,0,0.1)];
    _tableview.tableFooterView=[[UIView alloc]initWithFrame:CGRectMake(0,0,0,0.1)];
    [_tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

/**
 * 创建总结视图 FootView
 */
-(void)CreateFootView
{
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
    _ClearingView=[[DD_OrderClearingView alloc] initWithOrderDetailInfoModel:_OrderDetailModel.orderInfo Withfreight:_OrderDetailModel.orderInfo.allFreight WithCountPrice:_OrderModel.totalAmount WithBlock:nil];
    
    [headView addSubview:_ClearingView];
    [_ClearingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(headView);
    }];
    CGFloat height = [headView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    CGRect frame = headView.frame;
    frame.size.height = height;
    
    headView.frame = frame;
    _tableview.tableFooterView = headView;
    
    
}
/**
 * 创建地址视图 HeadView
 */
-(void)CreateHeadView
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
    _AddressView=[[DD_OrderAddressView alloc] initWithOrderDetailInfoModel:_OrderDetailModel WithBlock:^(NSString *type) {
        if([type isEqualToString:@"refund"])
        {
            //            跳转退款界面
            [self RefundAction];
        }
    }];
    [headView addSubview:_AddressView];
    [_AddressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(headView);
    }];
    CGFloat height = [headView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    CGRect frame = headView.frame;
    frame.size.height = height;
    
    headView.frame = frame;
    _tableview.tableHeaderView = headView;
    
}
/**
 * 确认订单按钮
 */
-(void)CreateTabBar
{
    _tabBar=[[DD_OrderTabBar alloc] initWithFrame:CGRectMake(0, ScreenHeight-ktabbarHeight, ScreenWidth, ktabbarHeight) WithOrderDetailInfoModel:_OrderDetailModel.orderInfo WithBlock:^(NSString *type) {
        if([type isEqualToString:@"pay"])
        {
            //            支付
            [self PayActionWithTradeOrderCode:_OrderDetailModel.orderInfo.tradeOrderCode];
            
        }else if([type isEqualToString:@"logistics"])
        {
            //            查看物流
             [self checkLogisticsInfo];
        }else if([type isEqualToString:@"cancel"])
        {
            //            取消订单
            [self CancelAction];
            
        }else if([type isEqualToString:@"confirm"])
        {
            //            确认收货
            [self ConfirmAction];
        }else if([type isEqualToString:@"delect"])
        {
            //            删除订单
            [self DelectAction];
        }else if([type isEqualToString:@"contact"])
        {
            //            联系客服
            [self contactAction];
        }
        
    }];
    _tabBar.backgroundColor=_define_white_color;
    [self.view addSubview:_tabBar];
}
#pragma mark - SomeActions
/**
 * 退款
 */
-(void)RefundAction
{
    [self presentViewController:[regular alertTitleCancel_Simple:NSLocalizedString(@"order_if_refund_order", @"") WithBlock:^{
        [self.navigationController pushViewController:[[DD_OrderRefundViewController alloc] initWithModel:_OrderDetailModel WithBlock:^(NSString *type) {
            if([type isEqualToString:@"update"])
            {
                [_tableview reloadData];
                _tabBar.orderInfo=_OrderDetailModel.orderInfo;
                [_tabBar UIConfig];
                _AddressView.DetailModel=_OrderDetailModel;
                [_AddressView SetState];
            }
        }] animated:YES];
    }] animated:YES completion:nil];
    
}
/**
 * 查看物流信息
 */
-(void)checkLogisticsInfo
{
    if(_OrderDetailModel.orderInfo.orderList.count)
    {
        DD_OrderModel *_order=[_OrderDetailModel.orderInfo.orderList objectAtIndex:0];
        [self.navigationController pushViewController:[[DD_OrderLogisticsViewController alloc] initWithModel:_order WithBlock:nil] animated:YES];
    }
}
/**
 * 支付回调
 */
-(void)payAction:(NSNotification *)not
{   
    if([self isVisible])
    {
        if([self haveClearingDoneView])
        {
            NSDictionary *resultDic=@{@"resultStatus":[not.object objectForKey:@"resultStatus"],@"tradeOrderCode":[not.object objectForKey:@"tradeOrderCode"]};
            [self popToClearingBeforeViewWithResultDic:resultDic];
        }else
        {
            DD_ClearingDoneViewController *_DoneView=[[DD_ClearingDoneViewController alloc] initWithReturnCode:[not.object objectForKey:@"resultStatus"] WithTradeOrderCode:[not.object objectForKey:@"tradeOrderCode"] WithType:@"detail_order_havenot_clearing_done" WithBlock:^(NSString *type) {
                //                            if(type)
            }];
            [self.navigationController pushViewController:_DoneView animated:YES];
        }
    }
    
}
/**
 * 前面是否有 DD_ClearingDoneViewController
 */
-(BOOL)haveClearingDoneView
{
    NSArray *controllers=self.navigationController.viewControllers;
    for (int i=0; i<controllers.count; i++) {
        id obj=controllers[i];
        if([obj isKindOfClass:[DD_ClearingDoneViewController class]])
        {
            return YES;
        }
    }
    return NO;
}
/**
 * 跳转到 DD_ClearingDoneViewController的前一页
 */
-(void)popToClearingBeforeViewWithResultDic:(NSDictionary *)resultDic
{
    NSArray *controllers=self.navigationController.viewControllers;
    for (int i=0; i<controllers.count; i++) {
        id obj=controllers[i];
        if([obj isKindOfClass:[DD_ClearingDoneViewController class]])
        {
            if(i)
            {
                DD_BaseViewController *base=controllers[i-1];
                [self.navigationController popToViewController:base animated:YES];
                [base pushCleaingDoneViewWithResultDic:resultDic WithType:@"detail_order_have_clearing_done"];
            }
        }
    }
}

/**
 * 删除订单
 */
-(void)DelectAction
{

    [self presentViewController:[regular alertTitleCancel_Simple:NSLocalizedString(@"order_if_delete_order", @"") WithBlock:^{
        if(_OrderDetailModel.orderInfo.orderList.count)
        {
            DD_OrderModel *_order=[_OrderDetailModel.orderInfo.orderList objectAtIndex:0];
            NSDictionary *_parameters=@{@"token":[DD_UserModel getToken],@"orderCode":_order.subOrderCode};
            [[JX_AFNetworking alloc] GET:@"order/deleteOrder.do" parameters:_parameters success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
                if(success)
                {
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"已成功删除订单" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"ok", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [self.navigationController popViewControllerAnimated:YES];
                    }];
                    [alertController addAction:okAction];
                    [self presentViewController:alertController animated:YES completion:nil];
                }else
                {
                    [self presentViewController:successAlert animated:YES completion:nil];
                }
            } failure:^(NSError *error, UIAlertController *failureAlert) {
                [self presentViewController:failureAlert animated:YES completion:nil];
            }];
        }
    }] animated:YES completion:nil];
    
    
}
/**
 * 确认收货
 */
-(void)ConfirmAction
{
    [self presentViewController:[regular alertTitleCancel_Simple:NSLocalizedString(@"order_if_confirm", @"") WithBlock:^{
        if(_OrderDetailModel.orderInfo.orderList.count)
        {
            DD_OrderModel *_order=[_OrderDetailModel.orderInfo.orderList objectAtIndex:0];
            [[JX_AFNetworking alloc] GET:@"order/confirmOrder.do" parameters:@{@"token":[DD_UserModel getToken],@"orderCode":_order.subOrderCode} success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
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
        }
    }] animated:YES completion:nil];
    
    
}

/**
 * 取消订单
 */
-(void)CancelAction
{

    [self presentViewController:[regular alertTitleCancel_Simple:NSLocalizedString(@"order_if_cancel_order", @"") WithBlock:^{
        NSDictionary *_parameters = @{@"token":[DD_UserModel getToken],@"tradeOrderCode":_OrderDetailModel.orderInfo.tradeOrderCode};
        [[JX_AFNetworking alloc] GET:@"order/cancelOrder.do" parameters:_parameters success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
            if(success)
            {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"已成功取消订单" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"ok", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    if([self haveClearingDoneView])
                    {
                        [self popToClearingBeforeView];
                    }else
                    {
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                    
                }];
                [alertController addAction:okAction];
                [self presentViewController:alertController animated:YES completion:nil];
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
 * 跳转到 DD_ClearingDoneViewController的前一页
 */
-(void)popToClearingBeforeView
{
    NSArray *controllers=self.navigationController.viewControllers;
    for (int i=0; i<controllers.count; i++) {
        id obj=controllers[i];
        if([obj isKindOfClass:[DD_ClearingDoneViewController class]])
        {
            if(i)
            {
                DD_BaseViewController *base=controllers[i-1];
                [self.navigationController popToViewController:base animated:YES];
            }
        }
    }
}

/**
 * 联系客服
 */
-(void)contactAction
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle: UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"cancel", @"") style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *take_photosAction = [UIAlertAction actionWithTitle:@"联系客服" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[[NSString alloc] initWithFormat:@"tel://%@",@"15868191992"]]];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:take_photosAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
/**
 * 继续支付
 */
-(void)PayActionWithTradeOrderCode:(NSString *)tradeOrderCode
{
    //不验证直接获取orderSpec 发起支付
    NSDictionary *_parameters=@{@"token":[DD_UserModel getToken],@"tradeOrderCode":tradeOrderCode};
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
                [DD_UserModel setTradeOrderCode:[data objectForKey:@"tradeOrderCode"]];
                [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                    if([self haveClearingDoneView])
                    {
                        NSDictionary *_resultDic=@{@"resultStatus":[resultDic objectForKey:@"resultStatus"],@"tradeOrderCode":[data objectForKey:@"tradeOrderCode"]};
                        [self popToClearingBeforeViewWithResultDic:_resultDic];
                    }else
                    {
                        [self.navigationController pushViewController:[[DD_ClearingDoneViewController alloc] initWithReturnCode:[resultDic objectForKey:@"resultStatus"] WithTradeOrderCode:[data objectForKey:@"tradeOrderCode"] WithType:@"detail_order_havenot_clearing_done" WithBlock:^(NSString *type) {
                        }] animated:YES];
                    }
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
#pragma mark - RequestData
-(void)RequestData
{
    NSString *_url=nil;
    NSDictionary *_parameters=nil;
    if(_OrderModel.isPay)
    {
        _url=@"order/querySubOrderDetail.do";
        _parameters=@{@"token":[DD_UserModel getToken],@"orderCode":_OrderModel.subOrderCode};
    }else
    {
        _url=@"order/queryOrderDetail.do";
        _parameters=@{@"token":[DD_UserModel getToken],@"tradeOrderCode":_OrderModel.tradeOrderCode};
    }
    
    [[JX_AFNetworking alloc] GET:_url parameters:_parameters success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
        if(success)
        {
            _OrderDetailModel=[DD_OrderDetailModel getOrderDetailModel:data];
            [self CreateTabBar];
            [self CreateFootView];
            [self CreateHeadView];
            [_tableview reloadData];
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
    return 140;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    子订单数量
    NSArray *_orderList=_OrderDetailModel.orderInfo.orderList;
    DD_OrderModel *__OrderModel=[_orderList objectAtIndex:section];
    return __OrderModel.itemList.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //    子订单数量
    return _OrderDetailModel.orderInfo.orderList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    数据还未获取时候
    if(_OrderDetailModel==nil)
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
        cell=[[DD_ClearingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid WithBlock:nil];
    }
    NSArray *_orderList=_OrderDetailModel.orderInfo.orderList;
    DD_OrderModel *__OrderModel=[_orderList objectAtIndex:indexPath.section];
    DD_OrderItemModel *_item=[__OrderModel.itemList objectAtIndex:indexPath.row];
    cell.ClearingModel=[DD_OrderTool getClearingOrderModel:_item];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *_orderList=_OrderDetailModel.orderInfo.orderList;
    DD_OrderModel *__OrderModel=[_orderList objectAtIndex:indexPath.section];
    DD_OrderItemModel *_item=[__OrderModel.itemList objectAtIndex:indexPath.row];
    
    DD_ItemsModel *_ItemsModel=[[DD_ItemsModel alloc] init];
    _ItemsModel.colorId=_item.colorId;
    _ItemsModel.g_id=_item.itemId;
    _ItemsModel.colorCode=_item.colorCode;
    DD_GoodsDetailViewController *_GoodsDetailView=[[DD_GoodsDetailViewController alloc] initWithModel:_ItemsModel WithBlock:^(DD_ItemsModel *model, NSString *type) {
        
    }];
    [self.navigationController pushViewController:_GoodsDetailView animated:YES];
}


#pragma mark - Other
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(_tableview)
    {
        [self RequestData];
    }
    [MobClick beginLogPageView:@"DD_OrderDetailViewController"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"PageOne"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - 弃用代码
//section头部间距
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    //section头部高度
//    return 40;
//}
//section头部视图
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    NSArray *_orderList=_OrderDetailModel.orderInfo.orderList;
//    DD_OrderModel *__OrderModel=[_orderList objectAtIndex:section];
//    return [__OrderModel getViewHeader];
//}

//section底部间距
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 40;
//}
////section底部视图
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    NSArray *_orderList=_OrderDetailModel.orderInfo.orderList;
//    DD_OrderModel *__OrderModel=[_orderList objectAtIndex:section];
//    return [__OrderModel getViewFooter];
//}

@end
