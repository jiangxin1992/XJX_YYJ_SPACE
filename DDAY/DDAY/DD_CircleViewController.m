//
//  DD_CircleViewController.m
//  DDAY
//
//  Created by yyj on 16/5/20.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_CircleListCell.h"
#import "DD_CircleListModel.h"
#import "DD_CircleItemListViewController.h"
#import "DD_CircleApplyViewController.h"
#import "DD_CirclePublishViewController.h"
#import "DD_CircleDetailViewController.h"
#import "MJRefresh.h"

#import "DD_CircleViewController.h"

@interface DD_CircleViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation DD_CircleViewController
{
    NSMutableArray *_dataArr;
    NSInteger _page;
    UITableView *_tableview;
    BOOL _getChangeNot;
    void (^cellBlock)(NSString *type,NSInteger index);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self SomePrepare];
    [self UIConfig];
}
#pragma mark - SomePrepare
-(void)SomePrepare
{
    [self hideBackNavBtn];
    [self PrepareData];
    [self PrepareUI];
    [self SomeBlock];
}
-(void)PrepareData
{
    _dataArr=[[NSMutableArray alloc] init];
    _page=1;
    _getChangeNot=NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ChangeNotAction) name:@"getChangeNot" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RootChangeAction) name:@"rootChange" object:nil];
}
-(void)PrepareUI{
    self.navigationItem.titleView=[regular returnNavView:NSLocalizedString(@"circle_title", @"") withmaxwidth:200];
    [self RootChangeAction];
}
/**
 * cell中交互回调
 */
-(void)SomeBlock
{
    __block DD_CircleViewController *_CircleView=self;
    __block NSMutableArray *___dataArr=_dataArr;
    cellBlock=^(NSString *type,NSInteger index)
    {
        DD_CircleListModel *listModel=[___dataArr objectAtIndex:index];
        if([type isEqualToString:@"show_item_list"])
        {
//            显示商品列表
            [_CircleView PushItemListViewWithID:listModel.shareId];
        }else if([type isEqualToString:@"head_click"])
        {
//            点击用户头像
        }else if([type isEqualToString:@"collect_cancel"])
        {
//            取消收藏
            [_CircleView collectActionIsCancel:YES WithIndex:index];
        }else if([type isEqualToString:@"collect"])
        {
//            收藏
            [_CircleView collectActionIsCancel:NO WithIndex:index];
        }else if([type isEqualToString:@"share"])
        {
//            分享
            [_CircleView presentViewController:[regular alertTitle_Simple:NSLocalizedString(@"pay_attention", @"")] animated:YES completion:nil];
        }else if([type isEqualToString:@"comment"])
        {
//            跳转评论页面
            [_CircleView PushCommentViewWithIndex:index];
        }else if([type isEqualToString:@"praise_cancel"])
        {
//            取消点赞
            [_CircleView praiseActionIsCancel:YES WithIndex:index];
        }else if([type isEqualToString:@"praise"])
        {
//             点赞
            [_CircleView praiseActionIsCancel:NO WithIndex:index];
        }else if([type isEqualToString:@"delete"])
        {
//            删除
            [_CircleView deleteActionWithIndex:index];
        }
    };
}
#pragma mark - UIConfig
-(void)UIConfig
{
    [self CreateTableview];
    [self MJRefresh];
}
-(void)CreateTableview
{
    _tableview=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableview];
    //    消除分割线
    _tableview.backgroundColor=_define_backview_color;
    _tableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableview.delegate=self;
    _tableview.dataSource=self;
}
#pragma mark - RequestData
-(void)RequestData
{
    [[JX_AFNetworking alloc] GET:@"share/queryShareList.do" parameters:@{@"page":[NSNumber numberWithInteger:_page],@"token":[DD_UserModel getToken]} success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
        if(success)
        {
            _getChangeNot=NO;
            NSArray *modelArr=[DD_CircleListModel getCircleListModelArr:[data objectForKey:@"shares"]];
            if(modelArr.count)
            {
                if(_page==1)
                {
                    [_dataArr removeAllObjects];//删除所有数据
                }
                [_dataArr addObjectsFromArray:modelArr];
                if([DD_NOTInformClass GET_COMMENTSHARE_NOT_SHAREID]&&[DD_NOTInformClass GET_COMMENTSHARE_NOT_COMMENTID])
                {
                    [self PushNotView:@"COMMENTSHARE"];
                }
                [_tableview reloadData];
            }else
            {
//                [self presentViewController:[regular alertTitle_Simple:NSLocalizedString(@"no_more", @"")] animated:YES completion:nil];
            }
        }else
        {
            [self presentViewController:successAlert animated:YES completion:nil];
        }
        [_tableview.header endRefreshing];
        [_tableview.footer endRefreshing];
        
    } failure:^(NSError *error, UIAlertController *failureAlert) {
        [_tableview.header endRefreshing];
        [_tableview.footer endRefreshing];
        [self presentViewController:failureAlert animated:YES completion:nil];
    }];
}
#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DD_CircleListModel *listModel=[_dataArr objectAtIndex:indexPath.section];
    return 454+listModel.suggestHeight;
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
    DD_CircleListCell *cell=[_tableview dequeueReusableCellWithIdentifier:cellid];
    if(!cell)
    {
        cell=[[DD_CircleListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    cell.listModel=[_dataArr objectAtIndex:indexPath.section];
    cell.index=indexPath.section;
    cell.cellBlock=cellBlock;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self PushCommentViewWithIndex:indexPath.section];
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

#pragma mark - SomeAction
-(void)MJRefresh
{
    _tableview.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        _page=1;
        [self RequestData];
    }];
    [_tableview.header beginRefreshing];
    [_tableview.footer resetNoMoreData];
    _tableview.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        _page+=1;
        [self RequestData];
    }];
    
}
#pragma mark - SomeAction
-(void)PushNotView:(NSString *)type
{
    NSString *_commentId=nil;
    NSString *_shareId=nil;
    if([type isEqualToString:@"COMMENTSHARE"])
    {
        _commentId=[DD_NOTInformClass GET_COMMENTSHARE_NOT_COMMENTID];
        _shareId=[DD_NOTInformClass GET_COMMENTSHARE_NOT_SHAREID];
    }else if([type isEqualToString:@"REPLYCOMMENT"])
    {
        _commentId=[DD_NOTInformClass GET_REPLYCOMMENT_NOT_COMMENTID];
        _shareId=[DD_NOTInformClass GET_REPLYCOMMENT_NOT_SHAREID];
    }
    if(_commentId&&_shareId)
    {
        BOOL _is_exist=NO;
        NSInteger _index=0;
        for (int i=0; i<_dataArr.count; i++) {
            DD_CircleListModel *listModel=[_dataArr objectAtIndex:i];
            if([listModel.shareId isEqualToString:_shareId])
            {
                _is_exist=YES;
                _index=i;
                break;
            }
        }
        if(_is_exist)
        {
            [self PushCommentViewWithIndex:_index];
        }else
        {
            [self PushCommentViewWithShareID:_shareId];
        }
        
    }
    if([type isEqualToString:@"COMMENTSHARE"])
    {
        [DD_NOTInformClass REMOVE_COMMENTSHARE_NOT_COMMENT];
    }else
    {
        [DD_NOTInformClass REMOVE_REPLYCOMMENT_NOT_COMMENT];
    }

}
-(void)PushCircleApplyView
{
    [self.navigationController pushViewController:[[DD_CircleApplyViewController alloc] initWithBlock:^(NSString *type) {
    }] animated:YES];
}
-(void)PushCircleDetailView
{
    if(_dataArr)
    {
        if([DD_NOTInformClass GET_COMMENTSHARE_NOT_SHAREID]&&[DD_NOTInformClass GET_COMMENTSHARE_NOT_COMMENTID])
        {
            [self PushNotView:@"COMMENTSHARE"];
        }
        if([DD_NOTInformClass GET_REPLYCOMMENT_NOT_SHAREID]&&[DD_NOTInformClass GET_COMMENTSHARE_NOT_COMMENTID])
        {
            [self PushNotView:@"REPLYCOMMENT"];
        }
    }
}
/**
 * 删除
 */
-(void)deleteActionWithIndex:(NSInteger )index
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle: UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"cancel", @"") style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"删除该搭配" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        DD_CircleListModel *listModel=[_dataArr objectAtIndex:index];
        [[JX_AFNetworking alloc] GET:@"share/deleteShare.do" parameters:@{@"token":[DD_UserModel getToken],@"shareId":listModel.shareId} success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
            if(success)
            {
                [_dataArr removeObjectAtIndex:index];
                [_tableview reloadData];
            }else
            {
                [self presentViewController:successAlert animated:YES completion:nil];
            }
        } failure:^(NSError *error, UIAlertController *failureAlert) {
            [self presentViewController:failureAlert animated:YES completion:nil];
        }];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:deleteAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
/**
 * 跳转评论页面
 */
-(void)PushCommentViewWithIndex:(NSInteger )index
{
    DD_CircleListModel *listModel=[_dataArr objectAtIndex:index];
    [self.navigationController pushViewController:[[DD_CircleDetailViewController alloc] initWithCircleListModel:listModel WithShareID:listModel.shareId WithBlock:^(NSString *type) {
        if([type isEqualToString:@"reload"])
        {
            [_tableview reloadData];
        }else if([type isEqualToString:@"delete"])
        {
            [_dataArr removeObjectAtIndex:index];
            [_tableview reloadData];
        }
    }] animated:YES];
}
-(void)PushCommentViewWithShareID:(NSString *)shareId
{
    [self.navigationController pushViewController:[[DD_CircleDetailViewController alloc] initWithCircleListModel:nil WithShareID:shareId WithBlock:nil] animated:YES];
}
/**
 * 发布
 * 跳转发布界面
 * 过滤当前用户权限
 * 达人和设计师才有发布权限
 */
-(void)PublishAction
{
    [self.navigationController pushViewController:[[DD_CirclePublishViewController alloc] initWithBlock:^(NSString *type) {
        if([type isEqualToString:@"refresh"])
        {
//            重新刷新
            [_tableview.header beginRefreshing];
        }
    }] animated:YES];
}
/**
 * 申请成为达人
 * 普通用户权限才能申请
 * 测试环境所有权限下皆开放入口
 * 申请为四个状态：还未申请（填写申请表）、提交申请（审核中）、通过审核（成功变身达人）、未通过（申请被拒）
 */
-(void)ApplyAction
{
    [self.navigationController pushViewController:[[DD_CircleApplyViewController alloc] initWithBlock:^(NSString *type) {
        
    }] animated:YES];
}
/**
 * 点赞和取消点赞
 */
-(void)praiseActionIsCancel:(BOOL)is_cancel WithIndex:(NSInteger)index
{
    NSString *url=nil;
    if(is_cancel)
    {
        url=@"share/unLikeShare.do";
    }else
    {
        url=@"share/likeShare.do";
    }
    DD_CircleListModel *listModel=[_dataArr objectAtIndex:index];
    NSDictionary *_parameters=@{@"token":[DD_UserModel getToken],@"shareId":listModel.shareId};
    [[JX_AFNetworking alloc] GET:url parameters:_parameters success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
        if(success)
        {
            listModel.isLike=[[data objectForKey:@"isLike"] boolValue];
            listModel.likeTimes=[[data objectForKey:@"likeTimes"] longValue];
            [_tableview reloadData];
        }else
        {
            [self presentViewController:successAlert animated:YES completion:nil];
        }
    } failure:^(NSError *error, UIAlertController *failureAlert) {
        [self presentViewController:failureAlert animated:YES completion:nil];
    }];
}
/**
 * 收藏和取消收藏
 */
-(void)collectActionIsCancel:(BOOL)is_cancel WithIndex:(NSInteger)index
{
    NSString *url=nil;
    if(is_cancel)
    {
        url=@"share/delCollectShare.do";
    }else
    {
        url=@"share/collectShare.do";
    }
    DD_CircleListModel *listModel=[_dataArr objectAtIndex:index];
    [[JX_AFNetworking alloc] GET:url parameters:@{@"token":[DD_UserModel getToken],@"shareId":listModel.shareId} success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
        if(success)
        {
            listModel.isCollect=[[data objectForKey:@"isCollect"] boolValue];
            [_tableview reloadData];
        }else
        {
            [self presentViewController:successAlert animated:YES completion:nil];
        }
    } failure:^(NSError *error, UIAlertController *failureAlert) {
        [self presentViewController:failureAlert animated:YES completion:nil];
    }];
}
/**
 * 跳转搭配商品列表
 */
-(void)PushItemListViewWithID:(NSString *)shareId
{
    [self.navigationController pushViewController:[[DD_CircleItemListViewController alloc] initWithShareID:shareId WithBlock:^(NSString *type) {
        
    }] animated:YES];
}
/**
 * 改变_getChangeNot的值
 * _getChangeNot为yes是表示该页面数据变化  需要重新加载
 */
-(void)ChangeNotAction
{
    _getChangeNot=YES;
}
/**
 * 用户权限变化
 */
-(void)RootChangeAction
{
    //     1 管理员 2 设计师 3 普通用户 4 达人
    if([DD_UserModel getUserType]==3)
    {
        self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"申请" style:UIBarButtonItemStylePlain target:self action:@selector(ApplyAction)];
        self.navigationItem.rightBarButtonItem=nil;
    }
    if([DD_UserModel getUserType]==2||[DD_UserModel getUserType]==4||[DD_UserModel getUserType]==1)
    {
        self.navigationItem.leftBarButtonItem=nil;
        self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(PublishAction)];
    }
}
#pragma mark - Other
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(_getChangeNot)
    {
        [_tableview.header beginRefreshing];
    }
    [[DD_CustomViewController sharedManager] tabbarAppear];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [MobClick beginLogPageView:@"DD_CircleViewController"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"DD_CircleViewController"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
