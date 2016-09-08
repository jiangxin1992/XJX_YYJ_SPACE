//
//  DD_ClearingViewController.m
//  DDAY
//
//  Created by yyj on 16/5/18.
//  Copyright © 2016年 mike_xie. All rights reserved.
//

#import "DD_ClearingViewController.h"

#import <AlipaySDK/AlipaySDK.h>
#import "DataSigner.h"

#import "DD_ClearingTableViewCell.h"
#import "DD_RemarksViewController.h"
#import "DD_AddressViewController.h"

#import "DD_SetAddressBtn.h"
#import "DD_ClearingView.h"
#import "DD_ClearingTabbar.h"

#import "DD_ClearingTool.h"
#import "DD_ClearingSeriesModel.h"
#import "DD_CityTool.h"

@interface DD_ClearingViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableDictionary *_dataDict;
    NSMutableArray *_dataArr;
    
    UITableView *_tableview;
    
    DD_ClearingTabbar *_tabBar;
    
    DD_ClearingView *_ClearingView;
    DD_SetAddressBtn *_AddressBtn;// 选择地址按钮
    
    NSString *remarksStr;// 订单备注 默认为空
    
    NSString *payWay;//alipay  wechat unionpay
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
    [self CreateTabBar];
}
#pragma mark - 初始化
-(instancetype)initWithModel:(DD_ClearingModel *)_model WithBlock:(void (^)(NSString *type,NSDictionary *resultDic))block
{
    self=[super init];
    if(self)
    {
        _Clearingmodel=_model;
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
    payWay=@"alipay";
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
 * 确认订单按钮
 */
-(void)CreateTabBar
{
    NSInteger _freight=[_Clearingmodel.freight integerValue];
    CGFloat _Freight=_dataArr.count*_freight;
    CGFloat _count=[[_dataDict objectForKey:@"subTotal"] floatValue];
    CGFloat _countPrice=_count+_Freight;
    
    _tabBar=[[DD_ClearingTabbar alloc] initWithNumStr:[[NSString alloc] initWithFormat:@"%ld件商品",[self getGoodsCount]] WithCountStr:[[NSString alloc] initWithFormat:@"总计 ￥%.1lf",_countPrice] WithBlock:^(NSString *type) {
        if([type isEqualToString:@"confirm"])
        {
            [self ConfirmAction];
        }
    }];
    [self.view addSubview:_tabBar];
    
    [_tabBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(ktabbarHeight);
    }];
    
//    UIView *upline=[UIView getCustomViewWithColor:_define_black_color];
//    [_tabBar addSubview:upline];
//    [upline mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(1);
//        make.top.left.right.mas_equalTo(0);
//    }];
//    
//    UIButton *ConfirmBtn=[UIButton getCustomTitleBtnWithAlignment:0 WithFont:18.0f WithSpacing:0 WithNormalTitle:@"确认订单" WithNormalColor:_define_white_color WithSelectedTitle:nil WithSelectedColor:nil];
//    [_tabBar addSubview:ConfirmBtn];
//    [ConfirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(0);
//        make.top.mas_equalTo(upline.mas_bottom).with.offset(0);
//        make.width.mas_equalTo(130);
//        make.bottom.mas_equalTo(0);
//    }];
//    [ConfirmBtn addTarget:self action:@selector(ConfirmAction) forControlEvents:UIControlEventTouchUpInside];
//    ConfirmBtn.backgroundColor=_define_black_color;
//    
//    NSInteger _freight=[_Clearingmodel.freight integerValue];
//    UILabel *numlabel=[UILabel getLabelWithAlignment:0 WithTitle:[[NSString alloc] initWithFormat:@"%ld件商品",_freight] WithFont:14.0f WithTextColor:nil WithSpacing:0];
//    [_tabBar addSubview:numlabel];
//    [numlabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(26);
//        make.centerY.mas_equalTo(_tabBar);
//    }];
//    [numlabel sizeToFit];
//    
//    CGFloat _Freight=_dataArr.count*_freight;
//    
//    CGFloat _count=[[_dataDict objectForKey:@"subTotal"] floatValue];
//    CGFloat _countPrice=_count+_Freight;
//    
//    UILabel *countlabel=[UILabel getLabelWithAlignment:2 WithTitle:[[NSString alloc] initWithFormat:@"总计￥%.1lf",_countPrice] WithFont:14.0f WithTextColor:nil WithSpacing:0];
//    [_tabBar addSubview:countlabel];
//    [countlabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(ConfirmBtn.mas_left).with.offset(-16);
//        make.left.mas_equalTo(numlabel.mas_right).with.offset(10);
//        make.top.bottom.mas_equalTo(0);
//    }];
    
    
}
/**
 * 创建地址视图 HeadView
 */
-(void)CreateHeadView
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
    _AddressBtn=[DD_SetAddressBtn buttonWithType:UIButtonTypeCustom WithAddressModel:_Clearingmodel.address WithBlock:^(NSString *type) {
        if([type isEqualToString:@"address"])
        {
            //            添加收货地址
            [self.navigationController pushViewController:[[DD_AddressViewController alloc]initWithType:@"address" WithBlock:^(NSString *type, DD_AddressModel *addressModel) {
                if([type isEqualToString:@"add_address"])
                {
                    _Clearingmodel.address=addressModel;
                    if(addressModel)
                    {
                        [_dataDict setObject:@{
                                               @"deliverName":addressModel.deliverName
                                               ,@"deliverPhone":addressModel.deliverPhone
                                               ,@"detailAddress":addressModel.detailAddress
                                               ,@"addressId":addressModel.udaId
                                               ,@"countryName":addressModel.countryName
                                               ,@"provinceName":addressModel.provinceName
                                               ,@"cityName":addressModel.cityName
                                               } forKey:@"address"];
                        
                    }else
                    {
                        [_dataDict removeObjectForKey:@"address"];
                    }
                    _AddressBtn.AddressModel=addressModel;
                    [_AddressBtn SetState];
                    CGFloat height = [headView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
                    CGRect frame = headView.frame;
                    frame.size.height = height;
                    headView.frame = frame;
                    _tableview.tableHeaderView = headView;
                }
                
            }] animated:YES];
        }
    }];
    [headView addSubview:_AddressBtn];
    [_AddressBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(headView);
    }];
    CGFloat height = [headView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    CGRect frame = headView.frame;
    frame.size.height = height;
    
    headView.frame = frame;
    _tableview.tableHeaderView = headView;
}
/**
 * 创建总结视图 FootView
 */
-(void)CreateFootView
{
    _ClearingView=[[DD_ClearingView alloc] initWithDataArr:_dataArr Withfreight:_Clearingmodel.freight WithPayWay:payWay WithBlock:^(NSString *type, CGFloat height,NSString *_payway) {
        if([type isEqualToString:@"remarks"])
        {
            //            跳转remarks界面
            [self PushRemarksView];
            
        }
        else if([type isEqualToString:@"height"])
        {
            _ClearingView.frame=CGRectMake(CGRectGetMinX(_ClearingView.frame), CGRectGetMinY(_ClearingView.frame), ScreenWidth, height);
            _tableview.tableFooterView=_ClearingView;
        }else if([type isEqualToString:@"pay_way_change"])
        {
            payWay=_payway;
        }
    }];
    _ClearingView.frame=CGRectMake(0, 0, ScreenWidth, 105);
    _tableview.tableFooterView = _ClearingView;
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
 * 获取结算页面的订单个数
 */
-(NSInteger )getGoodsCount
{
    NSInteger _num=0;
    for (DD_ClearingSeriesModel *_Series in _dataArr) {
        _num+=_Series.items.count;
    }
    return _num;
}
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
                id<DataSigner> signer = CreateRSADataSigner([data objectForKey:@"privateKey"]);
                NSString *signedString = [signer signString:orderSpec];
                NSString *orderString = nil;
                if (signedString != nil) {
                    orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                                   orderSpec, signedString, @"RSA"];
                    [DD_UserModel setTradeOrderCode:[data objectForKey:@"tradeOrderCode"]];
                    [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                        
                        NSDictionary *_resultDic=@{@"resultStatus":[resultDic objectForKey:@"resultStatus"],@"tradeOrderCode":[data objectForKey:@"tradeOrderCode"]};
                        [self.navigationController popViewControllerAnimated:YES];
                        _successblock(@"pay_back",_resultDic);
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

    if([self isVisible])
    {
        NSDictionary *resultDic=@{@"resultStatus":[not.object objectForKey:@"resultStatus"],@"tradeOrderCode":[not.object objectForKey:@"tradeOrderCode"]};
        [self.navigationController popViewControllerAnimated:YES];
        _successblock(@"pay_back",resultDic);
    }
}


#pragma mark - TableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
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
    static NSString *cellid=@"cell_normal";
    DD_ClearingTableViewCell *cell=[_tableview dequeueReusableCellWithIdentifier:cellid];
    if(!cell)
    {
        cell=[[DD_ClearingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid WithBlock:nil];
    }
    DD_ClearingSeriesModel *_Series=[_dataArr objectAtIndex:indexPath.section];
    cell.ClearingModel=[_Series.items objectAtIndex:indexPath.row];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
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
#pragma mark - 弃用代码
/**
 * 创建总结视图 FootView
 */
//-(void)CreateFootView
//{
//    _ClearingView=[[DD_ClearingView alloc] initWithDataArr:_dataArr Withfreight:_Clearingmodel.freight WithPayWay:payWay WithCountPrice:[_dataDict objectForKey:@"subTotal"] WithBlock:^(NSString *type, CGFloat height,NSString *_payway) {
//        if([type isEqualToString:@"remarks"])
//        {
//            //            跳转remarks界面
//            [self PushRemarksView];
//            
//        }
//        else if([type isEqualToString:@"height"])
//        {
//            _ClearingView.frame=CGRectMake(CGRectGetMinX(_ClearingView.frame), CGRectGetMinY(_ClearingView.frame), ScreenWidth, height);
//            _tableview.tableFooterView=_ClearingView;
//        }else if([type isEqualToString:@"pay_way_change"])
//        {
//            payWay=_payway;
//        }
//    }];
//    _ClearingView.frame=CGRectMake(0, 0, ScreenWidth, 105);
//    _tableview.tableFooterView = _ClearingView;
//}
////section头部间距
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    //section头部高度
//    return 40;
//}
////section头部视图
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    return [(DD_ClearingSeriesModel *)[_dataArr objectAtIndex:section] getViewHeader];
//}
////section底部间距
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//
//    return 40;
//}
////section底部视图
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    return [(DD_ClearingSeriesModel *)[_dataArr objectAtIndex:section] getViewFooter];
//}

@end
