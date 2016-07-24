//
//  DD_AddressViewController.m
//  DDAY
//
//  Created by yyj on 16/5/17.
//  Copyright © 2016年 mike_xie. All rights reserved.
//

#import "DD_CityTool.h"
#import "DD_AddNewAddressViewController.h"
#import "DD_AdressTableViewCell.h"
#import "DD_AddressModel.h"
#import "DD_AddressViewController.h"


@interface DD_AddressViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation DD_AddressViewController{
    NSMutableArray *_dataArr;
    UITableView *_tableview;
    NSString *_defaultID;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self SomePrepare];
    [self UIConfig];
    [self RequestData];
    
}
-(instancetype)initWithType:(NSString *)type WithBlock:(void (^)(NSString *, DD_AddressModel *))touchBlock
{
    self=[super init];
    if(self)
    {
        _type=type;
        _touchBlock=touchBlock;
    }
    return self;
}
#pragma mark - SomePrepare
-(void)SomePrepare
{
    [self PrepareData];
    [self PrepareUI];
}
-(void)PrepareData{
    _dataArr=[[NSMutableArray alloc] init];
    _defaultID=@"";
}
-(void)PrepareUI{
    self.navigationItem.titleView=[regular returnNavView:@"收件地址" withmaxwidth:200];
    self.view.backgroundColor=_define_backview_color;
}
#pragma mark - RequestData
-(void)RequestData
{
    [[JX_AFNetworking alloc] GET:@"user/queryDeliverAddress.do" parameters:@{@"token":[DD_UserModel getToken]} success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
        if(success)
        {
            [_dataArr addObjectsFromArray:[DD_AddressModel getAddressModelArray:[data objectForKey:@"deliverAddress"]]];
            _defaultID=[data objectForKey:@"defaultId"];
            [_tableview reloadData];
        }else
        {
            [self presentViewController:successAlert animated:YES completion:nil];
        }
    } failure:^(NSError *error, UIAlertController *failureAlert) {
        [self presentViewController:failureAlert animated:YES completion:nil];
    }];
}
#pragma mark - UIConfig
-(void)UIConfig
{
    [self CreateTableView];
    [self CreateAddBtn];
}
-(void)CreateAddBtn
{
    //    添加新地址
    UIButton *tabbar=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:tabbar];
    tabbar.frame=CGRectMake(0, ScreenHeight-ktabbarHeight, ScreenWidth, ktabbarHeight);
    [tabbar addTarget:self action:@selector(pushNewAddress) forControlEvents:UIControlEventTouchUpInside];
    tabbar.backgroundColor=[UIColor orangeColor];
    [tabbar setTitle:@"添加新地址" forState:UIControlStateNormal];
    
}
-(void)CreateTableView
{
    _tableview=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-ktabbarHeight) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableview];
    
    //    消除分割线
    _tableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableview.delegate=self;
    _tableview.dataSource=self;
    
}
#pragma mark - SomeAction
-(DD_AddressModel *)getDefaultModel
{
//    DD_AddressModel *_AddressModel=[_AddressModel]
    for (DD_AddressModel *_AddressModel in _dataArr) {
        if([_AddressModel.udaId isEqualToString:_defaultID])
        {
            return _AddressModel;
        }
    }
    return nil;
}
-(void)DeleteAddressWithIndex:(NSInteger )_index
{
    DD_AddressModel *address_model=_dataArr[_index];
    [[JX_AFNetworking alloc] GET:@"user/deleteDeliverAddress.do" parameters:@{@"token":[DD_UserModel getToken],@"udaId":address_model.udaId} success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
        if(success)
        {
            if(data)
            {
                _defaultID=[data objectForKey:@"defaultId"];
                [_dataArr removeObjectAtIndex:_index];
                if(address_model.isDefault)
                {
                    [_tableview reloadData];
                }else
                {
                    [_tableview deleteSections:[NSIndexSet indexSetWithIndex:_index] withRowAnimation:UITableViewRowAnimationFade];
                }
                if([_type isEqualToString:@"address"])
                {
                    if([self getDefaultModel])
                    {
                        _touchBlock(@"add_address",[self getDefaultModel]);
                    }
                }
            }else
            {
                [_dataArr removeObjectAtIndex:_index];
                if([_type isEqualToString:@"address"])
                {
                    _touchBlock(@"add_address",nil);
                }
                [_tableview reloadData];
            }
            
        }else
        {
            [self presentViewController:successAlert animated:YES completion:nil];
        }
    } failure:^(NSError *error, UIAlertController *failureAlert) {
        [self presentViewController:failureAlert animated:YES completion:nil];
    }];
    
}
-(void)updateDataArr:(DD_AddressModel *)model
{

    for (int i=0; i<_dataArr.count; i++) {
        DD_AddressModel *_model=[_dataArr objectAtIndex:i];
        if([_model.udaId isEqualToString:model.udaId])
        {
            _dataArr[i]=model;
            break;
        }
    }
    
}
-(void)alertActionWithNum:(NSInteger )_num
{
//    跳转修改界面
    DD_AddNewAddressViewController *AddNewAddress=[[DD_AddNewAddressViewController alloc] initWithModel:_dataArr[_num] WithBlock:^(NSString *type, DD_AddressModel *model,NSString *defaultID) {
        if([type isEqualToString:@"modify"])
        {
            //            修改地址
            [self updateDataArr:model];
            _defaultID=defaultID;
            [_tableview reloadData];
        }
    }];
    AddNewAddress.title=@"添加新地址";
    [self.navigationController pushViewController:AddNewAddress animated:YES];
}
-(void)pushNewAddress
{
    DD_AddNewAddressViewController *_newAddress=[[DD_AddNewAddressViewController alloc] initWithModel:nil WithBlock:^(NSString *type, DD_AddressModel *model,NSString *defaultID) {
        if([type isEqualToString:@"add"])
        {
            //            新增地址
            [_dataArr addObject:model];
            _defaultID=defaultID;
            [_tableview reloadData];
        }
    }];
    _newAddress.title=@"添加新地址";
    [self.navigationController pushViewController:_newAddress animated:YES];
}
#pragma mark - TableViewDelegate
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self DeleteAddressWithIndex:indexPath.section];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
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
    //获取到数据以后
    static NSString *cellid=@"cell_p";
    DD_AdressTableViewCell *cell=[_tableview dequeueReusableCellWithIdentifier:cellid];
    if(!cell)
    {
        cell=[[DD_AdressTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid WithBlock:^(NSString *type) {
            if([type isEqualToString:@"alert"])
            {
//                修改
                [self alertActionWithNum:indexPath.section];
            }
        }];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    [cell setAddressModel:_dataArr[indexPath.section] WithDefaultID:_defaultID];
    return cell;
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
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([_type isEqualToString:@"address"])
    {
        _touchBlock(@"add_address",[_dataArr objectAtIndex:indexPath.section]);
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
#pragma mark - Other
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"DD_AddressViewController"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"DD_AddressViewController"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
