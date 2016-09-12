//
//  DD_AddressViewController.m
//  DDAY
//
//  Created by yyj on 16/5/17.
//  Copyright © 2016年 mike_xie. All rights reserved.
//

#import "DD_AddressViewController.h"

#import "DD_AddNewAddressViewController.h"
#import "DD_AdressTableViewCell.h"

#import "DD_AddressModel.h"

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
    
    self.navigationItem.titleView=[regular returnNavView:NSLocalizedString(@"user_address_title", @"") withmaxwidth:200];
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
    [self CreateFootView];
}
-(void )CreateFootView
{
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
    UIButton *_AddressBtn=[UIButton getCustomTitleBtnWithAlignment:0 WithFont:18.0f WithSpacing:0 WithNormalTitle:@"添加新地址" WithNormalColor:_define_white_color WithSelectedTitle:nil WithSelectedColor:nil];
    [footView addSubview:_AddressBtn];
    _AddressBtn.backgroundColor=_define_black_color;
    [_AddressBtn addTarget:self action:@selector(pushNewAddress) forControlEvents:UIControlEventTouchUpInside];
    [_AddressBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.bottom.mas_equalTo(-20);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(155);
        make.centerX.mas_equalTo(footView);
    }];
    CGFloat height = [footView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    CGRect frame = footView.frame;
    frame.size.height = height;
    footView.frame = frame;
    _tableview.tableFooterView = footView;
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
    DD_AddressModel *addressModel=_dataArr[_num];
//    跳转修改界面
    DD_AddNewAddressViewController *AddNewAddress=[[DD_AddNewAddressViewController alloc] initWithModel:addressModel isDefault:addressModel.isDefault WithBlock:^(NSString *type, DD_AddressModel *model,NSString *defaultID) {
        if([type isEqualToString:@"modify"])
        {
            //            修改地址
            [self updateDataArr:model];
            _defaultID=defaultID;
            [_tableview reloadData];
            
            _touchBlock(@"alert_address",model);
        }
    }];
    AddNewAddress.title=@"修改地址";
    [self.navigationController pushViewController:AddNewAddress animated:YES];
}
-(void)pushNewAddress
{
    BOOL _isDefault=NO;
    if(!_dataArr.count)
    {
        _isDefault=YES;
    }
    DD_AddNewAddressViewController *_newAddress=[[DD_AddNewAddressViewController alloc] initWithModel:nil isDefault:_isDefault WithBlock:^(NSString *type, DD_AddressModel *model,NSString *defaultID) {
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
    CGFloat _height=[DD_AdressTableViewCell heightWithModel:_dataArr[indexPath.section] WithDefaultID:_defaultID];
    return _height;
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
    if(_dataArr.count>indexPath.section+1)
    {
        cell.is_last=NO;
    }else
    {
        cell.is_last=YES;
    }
    [cell setAddressModel:_dataArr[indexPath.section] WithDefaultID:_defaultID];
    return cell;
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
