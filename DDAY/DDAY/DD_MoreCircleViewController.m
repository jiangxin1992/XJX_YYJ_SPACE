//
//  DD_MoreCircleViewController.m
//  YCO SPACE
//
//  Created by yyj on 16/8/23.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_MoreCircleViewController.h"

#import "DD_TarentoHomePageViewController.h"
#import "DD_DesignerHomePageViewController.h"
#import "DD_CircleApplyViewController.h"
#import "DD_CirclePublishViewController.h"
#import "DD_CircleDetailViewController.h"
#import "DD_GoodsDetailViewController.h"

#import "DD_CircleListCell.h"
#import "DD_CircleDailyListCell.h"

#import "DD_CircleListModel.h"
#import "DD_OrderItemModel.h"
#import "DD_ItemsModel.h"

@interface DD_MoreCircleViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_dataArr;
    NSInteger _page;
    UITableView *_tableview;
    void (^cellBlock)(NSString *type,NSInteger index,DD_OrderItemModel *item);
}

@end

@implementation DD_MoreCircleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self SomePrepare];
    [self UIConfig];
}
-(instancetype)initWithColorCode:(NSString *)colorCode WithItemId:(NSString *)itemId
{
    self=[super init];
    if(self)
    {
        _colorCode=colorCode;
        _itemId=itemId;
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
    self.navigationItem.titleView=[regular returnNavView:NSLocalizedString(@"goods_more_circle", @"") withmaxwidth:200];
}
/**
 * cell中交互回调
 */
-(void)SomeBlock
{
    __block DD_MoreCircleViewController *_CircleView=self;
    __block NSMutableArray *___dataArr=_dataArr;
    cellBlock=^(NSString *type,NSInteger index,DD_OrderItemModel *item)
    {
        
        DD_CircleListModel *listModel=___dataArr[index];
        if([type isEqualToString:@"collect_cancel"]||[type isEqualToString:@"collect"]||[type isEqualToString:@"praise_cancel"]||[type isEqualToString:@"praise"]||[type isEqualToString:@"delete"])
        {
            //            涉及用户权限的操作
            if(![DD_UserModel isLogin])
            {
                [_CircleView presentViewController:[regular alertTitleCancel_Simple:NSLocalizedString(@"login_first", @"") WithBlock:^{
                    [_CircleView pushLoginView];
                }] animated:YES completion:nil];
            }else
            {
                if([type isEqualToString:@"collect_cancel"])
                {
                    
                    //            取消收藏
                    [_CircleView collectActionIsCancel:YES WithIndex:index];
                }else if([type isEqualToString:@"collect"])
                {
                    //            收藏
                    [_CircleView collectActionIsCancel:NO WithIndex:index];
                }
                else if([type isEqualToString:@"praise_cancel"])
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
                    [_CircleView presentViewController:[regular alertTitleCancel_Simple:@"删除该评论?" WithBlock:^{
                        [_CircleView deleteActionWithIndex:index];
                    }] animated:YES completion:nil];
                    
                }
            }
        }else
        {
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
                
            }else if([type isEqualToString:@"comment"])
            {
                //            跳转评论页面
                [_CircleView PushCommentViewWithIndex:index];
            }else if([type isEqualToString:@"item_click"])
            {
                //            点击item
                DD_ItemsModel *_item=[[DD_ItemsModel alloc] init];
                _item.g_id=item.itemId;
                _item.colorCode=item.colorCode;
                DD_GoodsDetailViewController *_GoodsDetail=[[DD_GoodsDetailViewController alloc] initWithModel:_item WithBlock:^(DD_ItemsModel *model, NSString *type) {
                    //        if(type)
                }];
                [_CircleView.navigationController pushViewController:_GoodsDetail animated:YES];
            }
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
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 0, -ktabbarHeight, 0));
    }];
}
#pragma mark - RequestData
-(void)RequestData
{
    NSDictionary *_parameters=@{@"page":[NSNumber numberWithInteger:_page],@"token":[DD_UserModel getToken],@"itemId":_itemId,@"colorCode":_colorCode};
    [[JX_AFNetworking alloc] GET:@"share/queryMoreShares.do" parameters:_parameters success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
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
                if([DD_NOTInformClass GET_COMMENTSHARE_NOT_SHAREID]&&[DD_NOTInformClass GET_COMMENTSHARE_NOT_COMMENTID])
                {
                    [self PushNotView:@"COMMENTSHARE"];
                }
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



#pragma mark - SomeAction
-(void)MJRefresh
{
    //    MJRefreshNormalHeader *header= [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    NSArray *refreshingImages=[regular getGifImg];
    
    //     Set the ordinary state of animated images
    [header setImages:refreshingImages duration:1.5 forState:MJRefreshStateIdle];
    //     Set the pulling state of animated images（Enter the status of refreshing as soon as loosen）
    [header setImages:refreshingImages duration:1.5 forState:MJRefreshStatePulling];
    //     Set the refreshing state of animated images
    [header setImages:refreshingImages duration:1.5 forState:MJRefreshStateRefreshing];
    
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
            DD_CircleListModel *listModel=_dataArr[i];
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
    DD_CircleListModel *listModel=_dataArr[index];
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
}
/**
 * 跳转评论页面
 */
-(void)PushCommentViewWithIndex:(NSInteger )index
{
    DD_CircleListModel *listModel=_dataArr[index];
    [self.navigationController pushViewController:[[DD_CircleDetailViewController alloc] initWithCircleListModel:listModel WithShareID:listModel.shareId IsHomePage:NO WithBlock:^(NSString *type) {
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
-(void)PushCommentViewWithShareID:(NSString *)shareId
{
    [self.navigationController pushViewController:[[DD_CircleDetailViewController alloc] initWithCircleListModel:nil WithShareID:shareId IsHomePage:NO  WithBlock:^(NSString *type) {
        if([type isEqualToString:@"reload"])
        {
            [_tableview reloadData];
        }
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
    DD_CircleListModel *listModel=_dataArr[index];
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
    DD_CircleListModel *listModel=_dataArr[index];
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


#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    DD_CircleListModel *listModel=_dataArr[indexPath.section];
//    CGFloat _height=[DD_CircleListCell heightWithModel:listModel IsUserHomePage:NO];
//    return _height;
    DD_CircleListModel *listModel=_dataArr[indexPath.section];
    return listModel.height;
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
    DD_CircleListModel *listModel=_dataArr[indexPath.section];
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
#pragma mark - Other
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(_tableview)
    {
        _page=1;
        [self RequestData];
    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
