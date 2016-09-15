//
//  DD_UserMessageViewController.m
//  YCO SPACE
//
//  Created by yyj on 16/8/10.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_UserMessageViewController.h"

#import "DD_DesignerHomePageViewController.h"
#import "DD_TarentoHomePageViewController.h"
#import "DD_FansViewController.h"
#import "DD_CircleApplyViewController.h"

#import "DD_UserMessageHeadView.h"
#import "DD_UserMessageHeadCell.h"
#import "DD_UserMessageNormalCell.h"

#import "DD_UserMessageModel.h"

@interface DD_UserMessageViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation DD_UserMessageViewController
{
    UITableView *_tableview;
    NSMutableArray *_dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self SomePrepare];
    [self UIConfig];
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
    _dataArr=[[NSMutableArray alloc] init];
}
-(void)PrepareUI
{
    self.navigationItem.titleView=[regular returnNavView:NSLocalizedString(@"user_message_title", @"") withmaxwidth:200];
}
#pragma mark - RequestData
-(void)RequestData
{
    [[JX_AFNetworking alloc] GET:@"user/queryMessage.do" parameters:@{@"token":[DD_UserModel getToken]} success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
        if(success)
        {
            NSArray *modelArr=[DD_UserMessageModel getUserMessageModelArr:[data objectForKey:@"messageData"]];
            [_dataArr removeAllObjects];//删除所有数据
            [_dataArr addObjectsFromArray:modelArr];
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


#pragma mark - TableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 45;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    DD_UserMessageModel *_userModel=[_dataArr objectAtIndex:section];
    if(_userModel.is_expand)
    {
        return _userModel.messages.count;
    }
    return 0;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(!_dataArr.count)
    {
        static NSString *cellid=@"cellid";
        UITableViewCell *cell=[_tableview dequeueReusableCellWithIdentifier:cellid];
        if(!cell)
        {
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.textLabel.text=[[NSString alloc] initWithFormat:@"%ld-%ld",indexPath.section,indexPath.row];
        return cell;
    }
    DD_UserMessageModel *_messageModel=[_dataArr objectAtIndex:indexPath.section];
    DD_UserMessageItemModel *_itemModel=[_messageModel.messages objectAtIndex:indexPath.row];
    if(_itemModel.type==2||_itemModel.type==4||_itemModel.type==5||_itemModel.type==6||_itemModel.type==7||_itemModel.type==8)
    {
        static NSString *cellid=@"cellid";
        DD_UserMessageHeadCell *cell=[_tableview dequeueReusableCellWithIdentifier:cellid];
        if(!cell)
        {
            cell=[[DD_UserMessageHeadCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid WithBlock:^(NSString *type,DD_UserModel *user) {
                if([type isEqualToString:@"headClick"]&&user)
                {
                    if([user.userType integerValue]==2)
                    {
                        //                设计师
                        DD_DesignerHomePageViewController *_DesignerHomePage=[[DD_DesignerHomePageViewController alloc] init];
                        _DesignerHomePage.designerId=user.u_id;
                        [self.navigationController pushViewController:_DesignerHomePage animated:YES];
                    }else if([user.userType integerValue]==4)
                    {
                        //                达人
                        [self.navigationController pushViewController:[[DD_TarentoHomePageViewController alloc] initWithUserId:user.u_id] animated:YES];
                    }else
                    {
                        [self presentViewController:[regular alertTitle_Simple:NSLocalizedString(@"no_homepage", @"")] animated:YES completion:nil];
                    }
                }
            }];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.messageItem=_itemModel;
        return cell;
    }else
    {
        static NSString *cellid=@"DD_UserMessageNormalCell";
        DD_UserMessageNormalCell *cell=[_tableview dequeueReusableCellWithIdentifier:cellid];
        if(!cell)
        {
            cell=[[DD_UserMessageNormalCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid WithBlock:^(NSString *type) {
                
            }];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.messageItem=_itemModel;
        return cell;
    }
}
//section头部间距
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    //section头部高度
    return 45;
}
//section头部视图
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    DD_UserMessageModel *_userModel=[_dataArr objectAtIndex:section];
    DD_UserMessageHeadView *head=[[DD_UserMessageHeadView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 45) WithUserMessageModel:_userModel WithSection:section WithBlock:^(NSString *type, NSInteger section) {
        if([type isEqualToString:@"click"])
        {
            if(_userModel.is_expand)
            {
                _userModel.is_expand=NO;
            }else
            {
                if(!_userModel.readStatus)
                {
                    
                    [[JX_AFNetworking alloc] GET:@"user/readUserMessage.do" parameters:@{@"token":[DD_UserModel getToken],@"types":[_userModel.type JSONString]} success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
                        if(success)
                        {
                            _userModel.readStatus=YES;
                        }else
                        {
                            [self presentViewController:successAlert animated:YES completion:nil];
                        }
                    } failure:^(NSError *error, UIAlertController *failureAlert) {
                        [self presentViewController:failureAlert animated:YES completion:nil];
                    }];
                }
                _userModel.is_expand=YES;
            }
            [_tableview reloadData];
        }
    }];
    return head;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DD_UserMessageModel *_userModel=[_dataArr objectAtIndex:indexPath.section];
    DD_UserMessageItemModel *_itemModel=[_userModel.messages objectAtIndex:indexPath.row];
    
    if(_itemModel.paramType==1)
    {
//        跳转物流详情页
    }else if(_itemModel.paramType==2)
    {
//        跳转订单详情页 以支付（orderCode）未支付（tradeOrderCode） 还需要是否支付
    }else if(_itemModel.paramType==3)
    {
//        跳转发布品详情页 (itemId,colorCode)
    }else if(_itemModel.paramType==4)
    {
//        跳转搭配详情页 (shareId)
    }else if(_itemModel.paramType==5)
    {
//        跳转发布会详情页(seriesId)
    }else if(_itemModel.paramType==6)
    {
//        跳转粉丝列表
        if([DD_UserModel isLogin])
        {
            [self.navigationController pushViewController:[[DD_FansViewController alloc] initWithBlock:nil] animated:YES];
        }else
        {
            [self presentViewController:[regular alertTitleCancel_Simple:NSLocalizedString(@"login_first", @"") WithBlock:^{
                [self pushLoginView];
            }] animated:YES completion:nil];
        }
    }else if(_itemModel.paramType==7)
    {
//        跳转申请详情页
        [self.navigationController pushViewController:[[DD_CircleApplyViewController alloc] initWithBlock:^(NSString *type) {
        }] animated:YES];
    }
}
#pragma mark - Other
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"DD_UserMessageViewController"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"DD_UserMessageViewController"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
