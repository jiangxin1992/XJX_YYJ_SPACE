//
//  DD_UserViewController.m
//  DDAY
//
//  Created by yyj on 16/5/20.
//  Copyright © 2016年 YYJ. All rights reserved.
//
#import "DD_UserCell.h"
#import "DD_UserTool.h"
#import "DD_UserHeadView.h"
#import "DD_UserViewController.h"
#import "DD_LoginViewController.h"
#import "DD_SetViewController.h"
#import "DD_UserInfoViewController.h"
#import "DD_OrderViewController.h"
#import "DD_DesignerHomePageViewController.h"
#import "DD_UserMainCollectViewController.h"
#import "DD_TarentoHomePageViewController.h"
#import "DD_FansViewController.h"

#import "DD_UserDDAYViewController.h"
@interface DD_UserViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation DD_UserViewController
{
    UITableView *_tableview;
    NSArray *_dataArr;
    NSDictionary *_datadict;
    DD_UserHeadView *_headView;
    DD_UserModel *_usermodel;
    
    BOOL hasNewFans;
    NSString *FansNum;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self SomePrepare];
    [self SetDataArr];
    [self UIConfig];
    [self RequestData];
}
#pragma mark - RequestData
-(void)RequestData
{
    if([DD_UserModel isLogin])
    {
        [[JX_AFNetworking alloc] GET:@"user/queryUserInfo.do" parameters:@{@"token":[DD_UserModel getToken]} success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
            if(success)
            {
                _usermodel=[DD_UserModel getUserModel:[data objectForKey:@"user"]];
                if(_usermodel)
                {
                    if([_usermodel.userType integerValue]!=[DD_UserModel getUserType])
                    {
                        [regular UpdateRoot];
                    }
                    [self CreateHeadView];
                    [self RequestNewFansStatus];
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
        [self CreateHeadView];
    }
}
-(void)RequestNewFansStatus
{

    [[JX_AFNetworking alloc] GET:@"designer/queryHasNewFans.do" parameters:@{@"token":[DD_UserModel getToken]} success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
        if(success)
        {
            FansNum=[[NSString alloc] initWithFormat:@"%ld",[[data objectForKey:@"fansNum"] integerValue]];
            hasNewFans=[[data objectForKey:@"hasNewFans"] boolValue];
            [_tableview reloadData];
        }else
        {
            [self presentViewController:successAlert animated:YES completion:nil];
        }
    } failure:^(NSError *error, UIAlertController *failureAlert) {
        [self presentViewController:failureAlert animated:YES completion:nil];
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
    hasNewFans=NO;
    FansNum=@"";
    _datadict=[DD_UserTool getUserListMap];
}
-(void)PrepareUI
{
    self.navigationItem.rightBarButtonItems=@[
                                              [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(setAction)]
                                              ,[[UIBarButtonItem alloc] initWithTitle:@"消息" style:UIBarButtonItemStylePlain target:self action:@selector(messageAction)]
                                              ];
    self.navigationItem.titleView=[regular returnNavView:NSLocalizedString(@"user_title", @"") withmaxwidth:200];
    self.view.backgroundColor=[UIColor colorWithHexString:_define_white_color];
    
}
#pragma mark - SomeAction
/**
 * 跳转粉丝页面
 */
-(void)PushFansView
{
    [self.navigationController pushViewController:[[DD_FansViewController alloc] initWithBlock:^(NSString *type) {
        if([type isEqualToString:@"reset_is_new"])
        {
            if(hasNewFans)
            {
                hasNewFans=NO;
                [_tableview reloadData];
            }
        }
    }] animated:YES];
}
/**
 * 跳转个人主页
 */
-(void)pushHomePageView
{
    //        1 管理员 2 设计师 3 普通用户 4 达人
    if([DD_UserModel getUserType]==2)
    {
        //        我的主页
        DD_DesignerHomePageViewController *_DesignerHomePage=[[DD_DesignerHomePageViewController alloc] init];
        _DesignerHomePage.title=@"我的主页";
        _DesignerHomePage.designerId=_usermodel.u_id;
        [self.navigationController pushViewController:_DesignerHomePage animated:YES];
        [[DD_CustomViewController sharedManager] tabbarHide];
    }else if([DD_UserModel getUserType]==4)
    {
        [self.navigationController pushViewController:[[DD_TarentoHomePageViewController alloc] initWithUserModel:_usermodel] animated:YES];
    }
}
/**
 * 用户权限变化
 */
-(void)MonitorRootChangeAction
{
    _dataArr=[DD_UserTool getUserListArr];
    [_tableview reloadData];
}
/**
 * 跳转消息界面
 */
-(void)messageAction{}
/**
 * 界面更新
 */
-(void)UpdateUI
{
    [self SetDataArr];
    _usermodel=[DD_UserModel getLocalUserInfo];
    [_tableview reloadData];
    _headView.usermodel=_usermodel;
    [_headView updateState];
}
/**
 * 跳转设置界面
 */
-(void)setAction
{
    if([DD_UserModel isLogin])
    {
        DD_SetViewController *_set=[[DD_SetViewController alloc] initWithBlock:^(NSString *type) {
            if([type isEqualToString:@"logout"])
            {
                _usermodel=nil;
                [self UpdateUI];
                
            }
        }];
        [self.navigationController pushViewController:_set animated:YES];
    }
}
/**
 * 获取当前的list arr
 */
-(void)SetDataArr
{
    _dataArr=[DD_UserTool getUserListArr];
}
/**
 * 跳转登录界面
 */
-(void)pushLoginView
{
    DD_LoginViewController *_login=[[DD_LoginViewController alloc] initWithBlock:^(NSString *type) {
        if([type isEqualToString:@"success"])
        {
            [self UpdateUI];
        }
    }];
    [self.navigationController pushViewController:_login animated:YES];
}
#pragma mark - UIConfig
-(void)UIConfig
{
    [self CreateTableView];
}
-(void)CreateTableView
{
    _tableview=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableview];
    //    消除分割线
    _tableview.backgroundColor=_define_backview_color;
    _tableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableview.delegate=self;
    _tableview.dataSource=self;
    _tableview.tableHeaderView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 100)];
}
-(void)CreateHeadView
{
    _headView =[DD_UserHeadView buttonWithType:UIButtonTypeCustom WithModel:_usermodel WithBlock:^(NSString *type) {
        if([type isEqualToString:@"userinfo"])
        {
//            跳转用户信息界面
            
            DD_UserInfoViewController *_UserInfo=[[DD_UserInfoViewController alloc] initWithModel:_usermodel WithBlock:^(DD_UserModel *model) {
                _usermodel=model;
                [_tableview reloadData];
            }];
            [self.navigationController pushViewController:_UserInfo animated:YES];
            
        }else if([type isEqualToString:@"login"])
        {
//            跳转登录页面
            [self pushLoginView];
        }
    }];
    
    _headView.frame=CGRectMake(0, 0, ScreenWidth, 100);
    _tableview.tableHeaderView=_headView;
    [_headView updateState];
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
    if([DD_UserModel getUserType]==2&&indexPath.section==1)
    {
        //获取到数据以后
        static NSString *cellid=@"cell_ftitle_user";
        DD_UserCell *cell=[_tableview dequeueReusableCellWithIdentifier:cellid];
        if(!cell)
        {
            cell=[[DD_UserCell alloc] initWithNotF_titleStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        }
        cell.title=[_datadict objectForKey:[_dataArr objectAtIndex:indexPath.section]];
        cell.f_title=FansNum;
        cell.hasNewFans=hasNewFans;
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
    cell.textLabel.text=[_datadict objectForKey:[_dataArr objectAtIndex:indexPath.section]];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([[_datadict objectForKey:[_dataArr objectAtIndex:indexPath.section]] isEqualToString:NSLocalizedString(@"user_order", @"")])
    {
        [self.navigationController pushViewController:[DD_OrderViewController new] animated:YES];
    }else if ([[_datadict objectForKey:[_dataArr objectAtIndex:indexPath.section]] isEqualToString:NSLocalizedString(@"user_collection", @"")])
    {
        [self.navigationController pushViewController:[[DD_UserMainCollectViewController alloc] init] animated:YES];
    }else if([[_datadict objectForKey:[_dataArr objectAtIndex:indexPath.section]] isEqualToString:NSLocalizedString(@"user_conference", @"")])
    {
        [self.navigationController pushViewController:[[DD_UserDDAYViewController alloc] init] animated:YES];
    }else if([[_datadict objectForKey:[_dataArr objectAtIndex:indexPath.section]] isEqualToString:NSLocalizedString(@"user_home_page", @"")])
    {
        [self pushHomePageView];
    }else if([[_datadict objectForKey:[_dataArr objectAtIndex:indexPath.section]] isEqualToString:NSLocalizedString(@"user_fans", @"")])
    {
        [self PushFansView];
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
    if(_tableview)
    {
        [self RequestData];
        [self MonitorRootChangeAction];
    }
    [[DD_CustomViewController sharedManager] tabbarAppear];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [MobClick beginLogPageView:@"DD_UserViewController"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"DD_UserViewController"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
