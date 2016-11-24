//
//  DD_SetViewController.m
//  DDAY
//
//  Created by yyj on 16/5/21.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_SetViewController.h"

#import "DD_UserInfoViewController.h"
#import "DD_UserViewController.h"
#import "DD_UserInfo_AlertPSWViewController.h"
#import "DD_AboutViewController.h"
#import "DD_AddressViewController.h"
#import "DD_GoodsViewController.h"
#import "DD_CustomViewController.h"

#import "DD_SetCell.h"

#import "DD_SetTool.h"

@interface DD_SetViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation DD_SetViewController
{
    UITableView *_tableview;
    NSArray *_dataArr;//设置页面cell标题数组
    NSDictionary *_datadict;//设置页面cell标题map
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self SomePrepare];
    [self UIConfig];
}
#pragma mark - 初始化
-(instancetype)initWithBlock:(void (^)(NSString *type))successblock
{
    self=[super init];
    if(self)
    {
        _successblock=successblock;
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
    _datadict=[DD_SetTool getSetListMap];//获取设置页面cell标题map
    _dataArr=[DD_SetTool getSetListArr];//获取设置页面cell标题数组
}
-(void)PrepareUI
{
    self.navigationItem.titleView=[regular returnNavView:NSLocalizedString(@"user_set_title", @"") withmaxwidth:200];//设置标题
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
    [_tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 0, -ktabbarHeight, 0));
    }];
}
#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
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
    static NSString *cellid=@"cell_title";
    DD_SetCell *cell=[_tableview dequeueReusableCellWithIdentifier:cellid];
    if(!cell)
    {
        cell=[[DD_SetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    cell.title=[_datadict objectForKey:_dataArr[indexPath.section]];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSInteger _index=indexPath.section;
    NSString *_key_str=_dataArr[_index];
    if([_key_str isEqualToString:@"information"]||[_key_str isEqualToString:@"alertPSW"]||[_key_str isEqualToString:@"address"])
    {
        
        if(![DD_UserModel isLogin])
        {
            [self presentViewController:[regular alertTitleCancel_Simple:NSLocalizedString(@"login_first", @"") WithBlock:^{
                [self pushLoginView];
            }] animated:YES completion:nil];
        }else
        {
            if([_key_str isEqualToString:@"information"])
            {
                //    编辑个人资料
                [self personInfo];
            }else if([_key_str isEqualToString:@"alertPSW"])
            {
                //        修改密码
                [self alertPSWWithTitle:[_datadict objectForKey:@"alertPSW"]];
            }else if([_key_str isEqualToString:@"address"])
            {
                //         收货地址
                [self pushAddressView];
                
            }
        }
        
    }else if([_key_str isEqualToString:@"logout"])
    {
        //        退出当前账号
        [self presentViewController:[regular alertTitleCancel_Simple:@"确定退出？" WithBlock:^{
            [self logout];
        }] animated:YES completion:nil];
    }else if([_key_str isEqualToString:@"about"])
    {
        //        关于dday
        [self about];
    }else if([_key_str isEqualToString:@"clean"])
    {
        //        清除缓存
        [self ClearCache];
    }
    
}

#pragma mark - SomeAction
/**
 * 跳转地址管理界面
 */
-(void)pushAddressView
{
    [self.navigationController pushViewController:[[DD_AddressViewController alloc] initWithType:@"normal" WithBlock:^(NSString *type, DD_AddressModel *addressModel) {
        
    }] animated:YES];
}
/**
 * 关于
 */
-(void)about
{
    [self.navigationController pushViewController:[DD_AboutViewController new] animated:YES];
}
/**
 * 个人主页
 */
-(void)personInfo
{
    
    [self.navigationController pushViewController:[[DD_UserInfoViewController alloc] initWithBlock:^(NSString *type ,DD_UserModel *model) {
        if([type isEqualToString:@"info_update"])
        {
            //                我的主页  viewwillapp的时候会重新获取用户信息
            //                所以这边不做处理
        }
    }] animated:YES];
}
/**
 * 清除缓存
 */
-(void)ClearCache
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:[[NSString alloc] initWithFormat:@"当前缓存%@M，是否清除",[regular getSize]] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"ok", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
            [_tableview reloadData];
        }];
    }];
    [alertController addAction:okAction];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"cancel", @"") style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
/**
 * 登出
 */
-(void)logout
{
    [[JX_AFNetworking alloc] POST:@"user/logout.do" parameters:@{@"token":[DD_UserModel getToken]} success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
        if(success)
        {
            [DD_UserModel logout];
//            [MobClick profileSignOff];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"rootChange" object:@"logout"];
            [((DD_CustomViewController *)[DD_CustomViewController sharedManager]).goodsCtn loadNewData];
            _successblock(@"logout");
            for (id obj in self.navigationController.viewControllers) {
                if([obj isKindOfClass:[DD_UserViewController class]])
                {
                    [self.navigationController popToViewController:obj animated:YES];
                }
            }
        }else
        {
            [self presentViewController:successAlert animated:YES completion:nil];
        }
    } failure:^(NSError *error, UIAlertController *failureAlert) {
        [self presentViewController:failureAlert animated:YES completion:nil];
    }];
    
}
/**
 * 跳转修改密码界面
 */
-(void)alertPSWWithTitle:(NSString *)title
{
    DD_UserInfo_AlertPSWViewController *_AlertPSW=[[DD_UserInfo_AlertPSWViewController alloc] init];
    _AlertPSW.title=title;
    [self.navigationController pushViewController:_AlertPSW animated:YES ];
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
    // Dispose of any resources that can be recreated.
}

@end
