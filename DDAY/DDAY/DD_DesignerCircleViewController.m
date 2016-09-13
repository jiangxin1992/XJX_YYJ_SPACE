//
//  DD_DesignerCircleViewController.m
//  DDAY
//
//  Created by yyj on 16/6/12.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_DesignerCircleViewController.h"

#import "DD_CircleListCell.h"

@interface DD_DesignerCircleViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation DD_DesignerCircleViewController
{
    NSMutableArray *_dataArr;
    NSInteger _page;
    UITableView *_tableview;
    
    void (^cellBlock)(NSString *type,NSInteger index,DD_OrderItemModel *item);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self SomePrepare];
    [self UIConfig];
}
-(instancetype)initWithDesignerID:(NSString *)DesignerID WithBlock:(void(^)(NSString *type,DD_CircleListModel *listModel))block
{
    self=[super init];
    if(self)
    {
        _DesignerID=DesignerID;
        _block=block;
    }
    return self;
}
#pragma mark - SomePrepare
-(void)SomePrepare
{
    [self PrepareData];
    [self PrepareUI];
    [self SomeBlock];
}
-(void)PrepareData
{
    _dataArr=[[NSMutableArray alloc] init];
    _page=1;
}
-(void)PrepareUI{
    self.navigationItem.titleView=[regular returnNavView:NSLocalizedString(@"circle_title", @"") withmaxwidth:200];
}
/**
 * cell中交互回调
 */
-(void)SomeBlock
{
    __block DD_DesignerCircleViewController *_CircleView=self;
//    __block NSMutableArray *___dataArr=_dataArr;
    cellBlock=^(NSString *type,NSInteger index,DD_OrderItemModel *item)
    {
//        DD_CircleListModel *listModel=[___dataArr objectAtIndex:index];
        if([type isEqualToString:@"show_item_list"])
        {
            //            显示商品列表
//            [_CircleView PushItemListViewWithID:listModel.shareId];
        }else if([type isEqualToString:@"head_click"])
        {
            //            点击用户头像
            [_CircleView PushHomePageView];
        }else if([type isEqualToString:@"collect_cancel"])
        {
            //            取消收藏
            [_CircleView collectActionIsCancel:YES WithIndex:index];
        }else if([type isEqualToString:@"collect"])
        {
            //            收藏
            [_CircleView collectActionIsCancel:NO WithIndex:index];
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
    _tableview=[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:_tableview];
    //    消除分割线
    _tableview.backgroundColor=_define_backview_color;
    _tableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableview.delegate=self;
    _tableview.dataSource=self;
    [_tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.mas_equalTo(0);
        make.height.mas_equalTo(ScreenHeight-kNavHeight-171);
        make.width.mas_equalTo(ScreenWidth);
    }];
}
#pragma mark - RequestData
-(void)RequestData
{
    [[JX_AFNetworking alloc] GET:@"share/queryDesignerShares.do" parameters:@{@"page":[NSNumber numberWithInteger:_page],@"token":[DD_UserModel getToken],@"designerId":_DesignerID} success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
        if(success)
        {
            NSArray *modelArr=[DD_CircleListModel getCircleListImgModelArr:[data objectForKey:@"shares"]];
            if(modelArr.count)
            {
                if(_page==1)
                {
                    [_dataArr removeAllObjects];//删除所有数据
                }
                [_dataArr addObjectsFromArray:modelArr];
                [_tableview reloadData];
            }else
            {
                if(_page==1)
                {
                    [_dataArr removeAllObjects];//删除所有数据
                    [_tableview reloadData];
                }
            }
        }else
        {
            [self presentViewController:successAlert animated:YES completion:nil];
        }
        [_tableview.mj_header endRefreshing];
        [_tableview.mj_footer endRefreshing];
        
    } failure:^(NSError *error, UIAlertController *failureAlert) {
        [_tableview.mj_header endRefreshing];
        [_tableview.mj_footer endRefreshing];
        [self presentViewController:failureAlert animated:YES completion:nil];
    }];
}
#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DD_CircleListModel *listModel=[_dataArr objectAtIndex:indexPath.section];
//    return 454+listModel.suggestHeight;
    return [DD_CircleListCell heightWithModel:listModel IsUserHomePage:YES];
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
    static NSString *cellid=@"cell_design_list";
    DD_CircleListCell *cell=[_tableview dequeueReusableCellWithIdentifier:cellid];
    if(!cell)
    {
        cell=[[DD_CircleListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid IsUserHomePage:YES];
    }
    cell.listModel=[_dataArr objectAtIndex:indexPath.section];
    cell.index=indexPath.section;
    cell.cellBlock=cellBlock;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _block(@"push_comment",[_dataArr objectAtIndex:indexPath.section]);
}
////section头部间距
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 1;//section头部高度
//}
////section头部视图
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    return [regular getViewForSection];
//}
////section底部间距
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 1;
//}
////section底部视图
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    return [regular getViewForSection];
//}
#pragma mark - SomeAction
-(void)MJRefresh
{
    MJRefreshNormalHeader *header= [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    _tableview.mj_header = header;
    
    MJRefreshAutoNormalFooter *_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [_footer setTitle:@"" forState:MJRefreshStateNoMoreData];
    [_footer setTitle:@"" forState:MJRefreshStateIdle];
    [_footer setTitle:@"" forState:MJRefreshStatePulling];
    [_footer setTitle:@"" forState:MJRefreshStateRefreshing];
    [_footer setTitle:@"" forState:MJRefreshStateWillRefresh];
    _footer.refreshingTitleHidden = YES;
    _footer.stateLabel.textColor = _define_light_gray_color1;
    _tableview.mj_footer = _footer;
    
    [_tableview.mj_header beginRefreshing];
    
}
-(void)loadNewData
{
    // 进入刷新状态后会自动调用这个block
    _page=1;
    [self RequestData];
}
-(void)loadMoreData
{
    // 进入刷新状态后会自动调用这个block
    _page+=1;
    [self RequestData];
}
#pragma mark - SomeAction
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
-(void)reloadData
{
    [_tableview reloadData];
}
/**
 * 跳转评论页面
 */
-(void)PushCommentViewWithIndex:(NSInteger )index
{
    _block(@"push_comment",[_dataArr objectAtIndex:index]);
}
/**
 * 跳转用户主页
 */
-(void)PushHomePageView
{
    _block(@"head_click",nil);
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
//-(void)PushItemListViewWithID:(NSString *)shareId
//{
//    [self.navigationController pushViewController:[[DD_CircleItemListViewController alloc] initWithShareID:shareId WithBlock:^(NSString *type) {
//        
//    }] animated:YES];
//}

#pragma mark - Other
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [MobClick beginLogPageView:@"DD_DesignerCircleViewController"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"DD_DesignerCircleViewController"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
