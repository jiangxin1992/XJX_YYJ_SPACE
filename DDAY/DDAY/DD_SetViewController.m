//
//  DD_SetViewController.m
//  DDAY
//
//  Created by yyj on 16/5/21.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_SetTool.h"
#import "DD_SetViewController.h"
#import "DD_SuggestViewController.h"
#import "DD_UserViewController.h"
#import "DD_UserCell.h"
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
#pragma mark - SomeAction
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
            [MobClick profileSignOff];
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
#pragma mark - UIConfig
-(void)UIConfig
{
    [self CreateTableView];
}
-(void)CreateTableView
{
    _tableview=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight+ktabbarHeight) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableview];
    //    消除分割线
    _tableview.backgroundColor=_define_backview_color;
    _tableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableview.delegate=self;
    _tableview.dataSource=self;
}
#pragma mark - UITableViewDelegate
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

    if([[_dataArr objectAtIndex:indexPath.section] isEqualToString:@"clean"])
    {
        //获取到数据以后
        static NSString *cellid=@"cell_title";
        DD_UserCell *cell=[_tableview dequeueReusableCellWithIdentifier:cellid];
        if(!cell)
        {
            cell=[[DD_UserCell alloc] initWithF_titleStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        }
        cell.f_title=[[NSString alloc] initWithFormat:@"%@ M",[regular getSize]];
        cell.title=[_datadict objectForKey:[_dataArr objectAtIndex:indexPath.section]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    //获取到数据以后
    static NSString *cellid=@"cell_user";
    DD_UserCell *cell=[_tableview dequeueReusableCellWithIdentifier:cellid];
    if(!cell)
    {
        cell=[[DD_UserCell alloc] initWithTitleStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    cell.title=[_datadict objectForKey:[_dataArr objectAtIndex:indexPath.section]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger _index=indexPath.section;
    if(_index==0)
    {
//        新消息通知
        [regular pushSystem];
        
    }else if(_index==1)
    {
//        清除缓存
        [self ClearCache];
    }else if(_index==2)
    {
//        建议与反馈
        [self.navigationController pushViewController:[[DD_SuggestViewController alloc] init] animated:YES];
    }else if(_index==3)
    {
//        关于dday
    }else if(_index==4)
    {
//        退出当前账号
        [self logout];
    }
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

#pragma mark - Other
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[DD_CustomViewController sharedManager] tabbarHide];
    [MobClick beginLogPageView:@"DD_SetViewController"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"DD_SetViewController"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
