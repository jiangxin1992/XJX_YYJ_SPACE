//
//  DD_TarentoHomePageViewController.m
//  DDAY
//
//  Created by yyj on 16/6/27.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_TarentoHomePageViewController.h"

#import "DD_CircleDetailViewController.h"
#import "DD_DesignerHomePageViewController.h"

#import "DD_TarentoHeadView.h"
#import "DD_CircleListCell.h"
#import "DD_ShareView.h"
#import "DD_CircleDailyListCell.h"

#import "DD_ShareTool.h"
#import "DD_CircleListModel.h"

@interface DD_TarentoHomePageViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation DD_TarentoHomePageViewController
{
    UIButton *right_btn;
    
    NSMutableArray *_dataArr;
    NSInteger _page;
    UITableView *_tableview;
    void (^cellBlock)(NSString *type,NSInteger index,DD_OrderItemModel *item);
    
    DD_UserModel *_usermodel;
    
    DD_ShareView *shareView;
    UIImageView *mengban;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self SomePrepare];
    [self UIConfig];
    [self RequestUserData];
}
#pragma mark - 初始化
-(instancetype)initWithUserId:(NSString *)userID
{
    self=[super init];
    if(self)
    {
        _userID=userID;
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
    DD_NavBtn *backBtn=[DD_NavBtn getNavBtnWithSize:CGSizeMake(11, 19) WithImgeStr:@"System_Back"];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kStatusBarHeight);
        make.width.height.mas_equalTo(44);
        make.left.mas_equalTo(0);
    }];
    
//    DD_NavBtn *shareBtn=[DD_NavBtn getNavBtnWithSize:CGSizeMake(25, 25) WithImgeStr:@"System_share"];
//    [shareBtn addTarget:self action:@selector(ShareAction) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:shareBtn];
//    [shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(kStatusBarHeight);
//        make.right.mas_equalTo(0);
//        make.width.height.mas_equalTo(44);
//    }];
    
    UIView *titleView=[regular returnNavView:NSLocalizedString(@"user_home_page", @"") withmaxwidth:140];
    [self.view addSubview:titleView];
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(140);
        make.height.mas_equalTo(44);
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view.mas_top).with.offset(kStatusBarHeight);
    }];
}

/**
 * cell中交互回调
 */
-(void)SomeBlock
{
    __block DD_TarentoHomePageViewController *_CircleView=self;
    __block NSMutableArray *___dataArr=_dataArr;
    cellBlock=^(NSString *type,NSInteger index,DD_OrderItemModel *item)
    {
        DD_CircleListModel *listModel=[___dataArr objectAtIndex:index];
        if([type isEqualToString:@"show_item_list"])
        {
            //            显示商品列表
//            [_CircleView PushItemListViewWithID:listModel.shareId];
        }else if([type isEqualToString:@"head_click"])
        {
            //            点击用户头像
            if([listModel.userType integerValue]==2)
            {
                //                设计师
                DD_DesignerHomePageViewController *_DesignerHomePage=[[DD_DesignerHomePageViewController alloc] init];
                _DesignerHomePage.designerId=listModel.userId;
                [_CircleView.navigationController pushViewController:_DesignerHomePage animated:YES];
            }else if([listModel.userType integerValue]==4)
            {
                //                达人
                [_CircleView.navigationController pushViewController:[[DD_TarentoHomePageViewController alloc] initWithUserId:listModel.userId] animated:YES];
            }else
            {
                [_CircleView presentViewController:[regular alertTitle_Simple:NSLocalizedString(@"no_homepage", @"")] animated:YES completion:nil];
            }
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
    _tableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableview.delegate=self;
    _tableview.dataSource=self;
    [_tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(kNavHeight, 0, 0, 0));
    }];
    
    UIView *headView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 145)];
    _tableview.tableHeaderView=headView;
}
#pragma mark - RequestData
-(void)RequestUserData
{
    NSDictionary *_parameters=@{@"userId":_userID,@"token":[DD_UserModel getToken]};
    [[JX_AFNetworking alloc] GET:@"user/queryUserInfoById.do" parameters:_parameters success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
        if(success)
        {
            _usermodel=[DD_UserModel getUserModel:[data objectForKey:@"user"]];
            DD_TarentoHeadView *headView=[[DD_TarentoHeadView alloc] initWithUserModel:_usermodel WithBlock:^(NSString *type) {
                if([type isEqualToString:@"head_click"])
                {
                    //            点击用户头像
                    if([_usermodel.userType integerValue]==2)
                    {
                        //                设计师
                        DD_DesignerHomePageViewController *_DesignerHomePage=[[DD_DesignerHomePageViewController alloc] init];
                        _DesignerHomePage.designerId=_usermodel.u_id;
                        [self.navigationController pushViewController:_DesignerHomePage animated:YES];
                    }else if([_usermodel.userType integerValue]==4)
                    {
                        //                达人
                        [self.navigationController pushViewController:[[DD_TarentoHomePageViewController alloc] initWithUserId:_usermodel.u_id] animated:YES];
                    }else
                    {
                        [self presentViewController:[regular alertTitle_Simple:NSLocalizedString(@"no_homepage", @"")] animated:YES completion:nil];
                    }
                    
                }
            }];
            headView.frame=CGRectMake(0, 0, ScreenWidth, 145);
            _tableview.tableHeaderView=headView;
        }else
        {
            [self presentViewController:successAlert animated:YES completion:nil];
        }
    } failure:^(NSError *error, UIAlertController *failureAlert) {
        [self presentViewController:failureAlert animated:YES completion:nil];
    }];
}
-(void)RequestListData
{
    [[JX_AFNetworking alloc] GET:@"share/queryDesignerShares.do" parameters:@{@"page":[NSNumber numberWithInteger:_page],@"token":[DD_UserModel getToken],@"designerId":_userID} success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
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
    CGFloat _height=[DD_CircleListCell heightWithModel:listModel IsUserHomePage:YES];
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
    DD_CircleListModel *listModel=[_dataArr objectAtIndex:indexPath.row];
    if([listModel.shareType longValue]==4)
    {
        //获取到数据以后
        static NSString *cellid=@"CircleListCell";
        DD_CircleListCell *cell=[_tableview dequeueReusableCellWithIdentifier:cellid];
        if(!cell)
        {
            cell=[[DD_CircleListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid IsUserHomePage:NO];
            cell.cellBlock=cellBlock;
            
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.layer.shouldRasterize = YES;
        cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
        cell.listModel=listModel;
        cell.index=indexPath.row;
        return cell;
    }else
    {
        //获取到数据以后
        static NSString *cellid=@"DD_CircleDailyListCell";
        DD_CircleDailyListCell *cell=[_tableview dequeueReusableCellWithIdentifier:cellid];
        if(!cell)
        {
            cell=[[DD_CircleDailyListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid IsUserHomePage:NO];
            cell.cellBlock=cellBlock;
            
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.layer.shouldRasterize = YES;
        cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
        cell.listModel=listModel;
        cell.index=indexPath.row;
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self PushCommentViewWithIndex:indexPath.section];
}
#pragma mark - SomeAction
-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
//蒙板消失
-(void)mengban_dismiss
{
    [UIView animateWithDuration:0.5 animations:^{
        shareView.frame=CGRectMake(0, ScreenHeight, ScreenWidth, shareView.height);
    } completion:^(BOOL finished) {
        [mengban removeFromSuperview];
        mengban=nil;
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }];
    
}
//分享
-(void)ShareAction
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    mengban=[UIImageView getMaskImageView];
    [self.view addSubview:mengban];
    [mengban addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mengban_dismiss)]];
    
    shareView=[[DD_ShareView alloc] initWithTitle:@"hi 我是标题君" Content:@"我也不知道分享什么" WithImg:@"System_Fans" WithUrl:@"https://appsto.re/cn/9EOHcb.i" WithBlock:^(NSString *type) {
        if([type isEqualToString:@"cancel"])
        {
            [self mengban_dismiss];
        }
    }];
    [mengban addSubview:shareView];
    
    CGFloat _height=[DD_ShareTool getHeight];
    shareView.frame=CGRectMake(0, ScreenHeight, ScreenWidth, _height);
    shareView.height=_height;
    [UIView animateWithDuration:0.5 animations:^{
        shareView.frame=CGRectMake(0, ScreenHeight-shareView.height, ScreenWidth, shareView.height);
    }];
    
}

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
    [self RequestListData];
}
-(void)loadMoreData
{
    // 进入刷新状态后会自动调用这个block
    _page+=1;
    [self RequestListData];
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
    [self.navigationController pushViewController:[[DD_CircleDetailViewController alloc] initWithCircleListModel:[_dataArr objectAtIndex:index] WithShareID:listModel.shareId IsHomePage:YES WithBlock:^(NSString *type) {
        if([type isEqualToString:@"reload"])
        {
            [_tableview reloadData];
        }
//        else if([type isEqualToString:@"delete"])
//        {
//            [_dataArr removeObjectAtIndex:index];
//            [_tableview reloadData];
//        }
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
    if(_tableview)
    {
        _page=1;
        [self RequestListData];
    }
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [MobClick beginLogPageView:@"DD_TarentoHomePageViewController"];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"DD_TarentoHomePageViewController"];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
