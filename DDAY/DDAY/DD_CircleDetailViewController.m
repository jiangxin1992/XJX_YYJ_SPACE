//
//  DD_CircleDetailViewController.m
//  DDAY
//
//  Created by yyj on 16/6/22.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_CircleDetailViewController.h"

#import "DD_LoginViewController.h"
#import "DD_CircleDetailHeadView.h"
#import "DD_CircleCommentModel.h"
#import "DD_CircleComentInputView.h"
#import "DD_CircleCommentCell.h"
#import "DD_CircleShowDetailImgViewController.h"
#import "DD_ItemsModel.h"
#import "DD_GoodsDetailViewController.h"
#import "DD_DesignerHomePageViewController.h"
#import "DD_TarentoHomePageViewController.h"

@interface DD_CircleDetailViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation DD_CircleDetailViewController
{
    UITableView *_tableview;
    NSMutableArray *_dataArr;
    NSInteger _page;
    
    DD_CircleComentInputView *_commentview;//评论框
    DD_CircleDetailHeadView *_headView;
    
    void (^cellBlock)(NSString *type,NSInteger index);//cell点击回调
    
    NSString *commToId;//回复人的id
    DD_CircleListModel *nowListModel;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self SomePrepare];
    [self UIConfig];
}
#pragma mark - 初始化
-(instancetype)initWithCircleListModel:(DD_CircleListModel *)ListModel WithShareID:(NSString *)ShareID WithBlock:(void (^)(NSString *type))block
{
    self=[super init];
    if(self)
    {
        _block=block;
        _ShareID=ShareID;
        _ListModel=ListModel;
    }
    return self;
}

#pragma mark - SomePrepare
-(void)SomePrepare
{
    [self PrepareData];
    [self PrepareUI];
    [self SomeBlocks];
}
-(void)PrepareData
{
    commToId=@"";
    _page=1;
    _dataArr=[[NSMutableArray alloc] init];
}
-(void)PrepareUI
{
    self.navigationItem.titleView=[regular returnNavView:NSLocalizedString(@"circle_detail_title", @"") withmaxwidth:200];
}

-(void)SomeBlocks
{
    __block DD_CircleDetailViewController *__DetailView=self;
    cellBlock=^(NSString *type,NSInteger index)
    {
        if([type isEqualToString:@"praise_cancel"])
        {
            //            取消点赞
            [__DetailView praiseActionIsCancel:YES WithIndex:index];
        }else if([type isEqualToString:@"praise"])
        {
            //            点赞
            [__DetailView praiseActionIsCancel:NO WithIndex:index];
        }
    };
}
#pragma mark - UIConfig
-(void)UIConfig
{
    [self CreateTabbar];
    [self CreateTableView];
    [self RequestDataHeadData];
    [self MJRefresh];
}
-(void)CreateTabbar
{
    _commentview=[[DD_CircleComentInputView alloc] initWithBlock:^(NSString *type, NSString *content) {
        if([type isEqualToString:@"send"])
        {
            //            发送
            [self sendActionWithContent:content];
        }
    }];
    [self.view addSubview:_commentview];
    [_commentview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.left.and.right.mas_equalTo(0);
    }];
}
-(void)CreateTableView
{
    _tableview=[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.view addSubview:_tableview];
    //    消除分割线
    _tableview.backgroundColor=_define_backview_color;
    _tableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableview.delegate=self;
    _tableview.dataSource=self;
    
    [_tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(64);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(_commentview.mas_top).with.offset(0);
    }];
    
}
-(void)CreateTableViewHead
{
    __block DD_CircleDetailViewController *_DetailView=self;
    _headView=[[DD_CircleDetailHeadView alloc] initWithCircleListModel:nowListModel WithBlock:^(NSString *type,NSInteger index,DD_OrderItemModel *item) {
//        涉及用户登录权限
        if([type isEqualToString:@"collect_cancel"]||[type isEqualToString:@"collect"]||[type isEqualToString:@"praise_cancel"]||[type isEqualToString:@"praise"]||[type isEqualToString:@"delete"])
        {
            if(![DD_UserModel isLogin])
            {
                [self presentViewController:[regular alertTitleCancel_Simple:NSLocalizedString(@"login_first", @"") WithBlock:^{
                    [self pushLoginView];
                }] animated:YES completion:nil];
            }else
            {
                if([type isEqualToString:@"collect_cancel"])
                {
                    //            取消收藏
                    [_DetailView collectActionIsCancel:YES];
                }else if([type isEqualToString:@"collect"])
                {
                    //            收藏
                    [_DetailView collectActionIsCancel:NO];
                }
                else if([type isEqualToString:@"praise_cancel"])
                {
                    //            取消点赞
                    [_DetailView praiseActionIsCancel:YES];
                }else if([type isEqualToString:@"praise"])
                {
                    //             点赞
                    [_DetailView praiseActionIsCancel:NO];
                }
                else if([type isEqualToString:@"delete"])
                {
                    [_DetailView deleteThisCircle];
                }
            }
        }else
        {
            if([type isEqualToString:@"show_item_list"])
            {
                //            显示商品列表
                //            [_DetailView PushItemListViewWithID:_ShareID];
            }else if([type isEqualToString:@"head_click"])
            {
                //            点击用户头像
                [_DetailView pushUserHomePage];
                
            }else if([type isEqualToString:@"share"])
            {
                //            分享
                [_DetailView presentViewController:[regular alertTitle_Simple:NSLocalizedString(@"pay_attention", @"")] animated:YES completion:nil];
            }else if([type isEqualToString:@"comment"])
            {
                //            跳转评论页面
                [_commentview becomeFirstResponder];
                
            }else if([type isEqualToString:@"show_img"])
            {
                //            显示图片
                [_DetailView.navigationController pushViewController:[[DD_CircleShowDetailImgViewController alloc] initWithCircleArr:nowListModel.pics WithType:@"model" WithIndex:index WithBlock:^(NSString *type) {
                    
                }] animated:YES];
            }else if([type isEqualToString:@"item_click"])
            {
                //                查看商品
                [_DetailView pushItemViewWithItemModel:item];
            }
            
        }
        
    }];
    _headView.frame=CGRectMake(0, 0, ScreenWidth,[DD_CircleDetailHeadView heightWithModel:_ListModel]);
    _headView.userInteractionEnabled=YES;
    [_headView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(KeyBoardDismiss)]];

    _tableview.tableHeaderView=_headView;
    
}

#pragma mark - RequestData
-(void)RequestData
{
    NSDictionary *_parameters=@{@"page":[NSNumber numberWithInteger:_page],@"token":[DD_UserModel getToken],@"shareId":_ShareID};
    [[JX_AFNetworking alloc] GET:@"share/queryCommentList.do" parameters:_parameters success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
        if(success)
        {
            NSArray *modelArr=[DD_CircleCommentModel getCircleCommentModelArr:[data objectForKey:@"commentList"]];
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
-(void)RequestDataHeadData
{
    NSDictionary *_parameters=@{@"token":[DD_UserModel getToken],@"shareId":_ShareID};
    [[JX_AFNetworking alloc] GET:@"share/queryShareDetail.do" parameters:_parameters success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
        if(success)
        {
            nowListModel=[DD_CircleListModel getCircleListModel:[data objectForKey:@"shareInfo"]];
//            已创建就更新
            if(_headView)
            {
                _headView.listModel=nowListModel;
            }else
            {
                [self CreateTableViewHead];
            }
        }else
        {
            [self presentViewController:successAlert animated:YES completion:nil];
        }
    } failure:^(NSError *error, UIAlertController *failureAlert) {
        [self presentViewController:failureAlert animated:YES completion:nil];
    }];
}
#pragma mark - MJRefresh
-(void)MJRefresh
{
    _tableview.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        _page=1;
        [self RequestData];
        [self RequestDataHeadData];
    }];
    
    _tableview.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        _page+=1;
        [self RequestData];
    }];
    
    [_tableview.header beginRefreshing];
}

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DD_CircleCommentModel *commentModel=[_dataArr objectAtIndex:indexPath.section];
    return 80+commentModel.commHeight;
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
    
    static NSString *cellid=@"cell_title";
    DD_CircleCommentCell *cell=[_tableview dequeueReusableCellWithIdentifier:cellid];
    if(!cell)
    {
        cell=[[DD_CircleCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    cell.CommentModel=[_dataArr objectAtIndex:indexPath.section];
    cell.index=indexPath.section;
    cell.cellBlock=cellBlock;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_commentview return_KeyBoard];
    [self cellClickActionWithIndex:indexPath.section];
}

#pragma mark - SomeAction
/**
 * touch开始时
 */
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_commentview return_KeyBoard];
}
-(void)KeyBoardDismiss
{
    [_commentview return_KeyBoard];
}
/**
 * 跳转登录界面
 */
-(void)pushLoginView
{
    if(![DD_UserModel isLogin])
    {
        DD_LoginViewController *_login=[[DD_LoginViewController alloc] initWithBlock:^(NSString *type) {
            if([type isEqualToString:@"success"])
            {
                [_tableview.header beginRefreshing];
            }
        }];
        [self.navigationController pushViewController:_login animated:YES];
    }
}
/**
 * 跳转单品详情页
 */
-(void)pushItemViewWithItemModel:(DD_OrderItemModel *)item
{
    DD_ItemsModel *_item=[[DD_ItemsModel alloc] init];
    _item.g_id=item.itemId;
    _item.colorId=item.colorId;
    _item.colorCode=item.colorCode;
    DD_GoodsDetailViewController *_GoodsDetail=[[DD_GoodsDetailViewController alloc] initWithModel:_item WithBlock:^(DD_ItemsModel *model, NSString *type) {
        //        if(type)
    }];
    [self.navigationController pushViewController:_GoodsDetail animated:YES];
}
/**
 * 跳转主页
 */
-(void)pushUserHomePage
{
    if([nowListModel.userType integerValue]==2)
    {
        //                设计师
        DD_DesignerHomePageViewController *_DesignerHomePage=[[DD_DesignerHomePageViewController alloc] init];
        _DesignerHomePage.designerId=nowListModel.userId;
        [self.navigationController pushViewController:_DesignerHomePage animated:YES];
    }else if([nowListModel.userType integerValue]==4)
    {
        //                达人
        [self.navigationController pushViewController:[[DD_TarentoHomePageViewController alloc] initWithUserId:nowListModel.userId] animated:YES];
    }else
    {
        [self presentViewController:[regular alertTitle_Simple:NSLocalizedString(@"no_homepage", @"")] animated:YES completion:nil];
    }
}
/**
 * 删除该搭配
 */
-(void)deleteThisCircle
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle: UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"cancel", @"") style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"删除该搭配" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [[JX_AFNetworking alloc] GET:@"share/deleteShare.do" parameters:@{@"token":[DD_UserModel getToken],@"shareId":_ShareID} success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
            if(success)
            {
                [self.navigationController popViewControllerAnimated:YES];
                if(_ListModel)
                {
                    _block(@"delete");
                }
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
 * 收藏和取消收藏
 */
-(void)collectActionIsCancel:(BOOL)is_cancel
{
    if(![DD_UserModel isLogin])
    {
        [self presentViewController:[regular alertTitleCancel_Simple:NSLocalizedString(@"login_first", @"") WithBlock:^{
            [self pushLoginView];
        }] animated:YES completion:nil];
    }else
    {
        NSString *url=nil;
        if(is_cancel)
        {
            url=@"share/delCollectShare.do";
        }else
        {
            url=@"share/collectShare.do";
        }
        [[JX_AFNetworking alloc] GET:url parameters:@{@"token":[DD_UserModel getToken],@"shareId":_ShareID} success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
            if(success)
            {
                nowListModel.isCollect=[[data objectForKey:@"isCollect"] boolValue];
                if(_ListModel)
                {
                    _ListModel.isCollect=[[data objectForKey:@"isCollect"] boolValue];
                }
                [_headView setState];
                if(_ListModel)
                {
                    _block(@"reload");
                }
                
            }else
            {
                [self presentViewController:successAlert animated:YES completion:nil];
            }
        } failure:^(NSError *error, UIAlertController *failureAlert) {
            [self presentViewController:failureAlert animated:YES completion:nil];
        }];
    }
    
}
/**
 * 对搭配的点赞和取消点赞
 */
-(void)praiseActionIsCancel:(BOOL)is_cancel
{
    if(![DD_UserModel isLogin])
    {
        [self presentViewController:[regular alertTitleCancel_Simple:NSLocalizedString(@"login_first", @"") WithBlock:^{
            [self pushLoginView];
        }] animated:YES completion:nil];
    }else
    {
        NSString *url=nil;
        if(is_cancel)
        {
            url=@"share/unLikeShare.do";
        }else
        {
            url=@"share/likeShare.do";
        }
        NSDictionary *_parameters=@{@"token":[DD_UserModel getToken],@"shareId":_ShareID};
        [[JX_AFNetworking alloc] GET:url parameters:_parameters success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
            if(success)
            {
                nowListModel.isLike=[[data objectForKey:@"isLike"] boolValue];
                nowListModel.likeTimes=[[data objectForKey:@"likeTimes"] longValue];
                if(_ListModel)
                {
                    _ListModel.isLike=[[data objectForKey:@"isLike"] boolValue];
                    _ListModel.likeTimes=[[data objectForKey:@"likeTimes"] longValue];
                }
                [_headView setState];
                if(_ListModel)
                {
                    _block(@"reload");
                }
                
            }else
            {
                [self presentViewController:successAlert animated:YES completion:nil];
            }
        } failure:^(NSError *error, UIAlertController *failureAlert) {
            [self presentViewController:failureAlert animated:YES completion:nil];
        }];
    }
}
/**
 * 点赞和取消点赞
 */
-(void)praiseActionIsCancel:(BOOL)is_cancel WithIndex:(NSInteger)index
{
    if(![DD_UserModel isLogin])
    {
        [self presentViewController:[regular alertTitleCancel_Simple:NSLocalizedString(@"login_first", @"") WithBlock:^{
            [self pushLoginView];
        }] animated:YES completion:nil];
    }else
    {
        NSString *url=nil;
        if(is_cancel)
        {
            url=@"share/unLikeComment.do";
        }else
        {
            url=@"share/likeComment.do";
        }
        DD_CircleCommentModel *CommentModel=[_dataArr objectAtIndex:index];
        NSDictionary *_parameters=@{@"token":[DD_UserModel getToken],@"commentId":CommentModel.commId};
        [[JX_AFNetworking alloc] GET:url parameters:_parameters success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
            if(success)
            {
                CommentModel.isLike=[[data objectForKey:@"isLike"] boolValue];
                CommentModel.likeTimes=[[data objectForKey:@"likeTimes"] longValue];
                [_tableview reloadData];
            }else
            {
                [self presentViewController:successAlert animated:YES completion:nil];
            }
        } failure:^(NSError *error, UIAlertController *failureAlert) {
            [self presentViewController:failureAlert animated:YES completion:nil];
        }];
    }
}
/**
 * 提交评论验证
 */
-(void)sendActionWithContent:(NSString *)content
{
    if(![DD_UserModel isLogin])
    {
        [self presentViewController:[regular alertTitleCancel_Simple:NSLocalizedString(@"login_first", @"") WithBlock:^{
            [self pushLoginView];
        }] animated:YES completion:nil];
    }else if([content isEqualToString:@""])
    {
        [self presentViewController:[regular alertTitle_Simple:@"请输入评论内容"] animated:YES completion:nil];
    }else
    {
        //发送评论
        [self sendCommentWithContent:content];
    }
    [_commentview return_KeyBoard];
}
/**
 * 提交评论
 */
-(void)sendCommentWithContent:(NSString *)content
{
    [[JX_AFNetworking alloc] GET:@"share/commentShare.do" parameters:@{@"token":[DD_UserModel getToken],@"shareId":_ShareID,@"commToId":commToId,@"comment":content} success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
        if(success)
        {
            nowListModel.commentTimes=[[data objectForKey:@"commentTimes"] longValue];
            if(_ListModel)
            {
                _ListModel.commentTimes=[[data objectForKey:@"commentTimes"] longValue];
            }
            commToId=@"";
            [_tableview.header beginRefreshing];
            
            [_commentview initTextView];
            [_headView setState];
            if(_ListModel)
            {
                _block(@"reload");
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
 * 删除评论
 */
-(void)deleteActionWithIndex:(NSInteger )index
{
    if(![DD_UserModel isLogin])
    {
        [self presentViewController:[regular alertTitleCancel_Simple:NSLocalizedString(@"login_first", @"") WithBlock:^{
            [self pushLoginView];
        }] animated:YES completion:nil];
    }else
    {
        DD_CircleCommentModel *commentModel=[_dataArr objectAtIndex:index];
        commToId=@"";
        [[JX_AFNetworking alloc] GET:@"share/deleteCommentShare.do" parameters:@{@"token":[DD_UserModel getToken],@"commentId":commentModel.commId} success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
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
}
/**
 * cell点击
 */
-(void)cellClickActionWithIndex:(NSInteger )index
{
    DD_CircleCommentModel *commentModel=[_dataArr objectAtIndex:index];
    DD_UserModel *loc=[DD_UserModel getLocalUserInfo];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle: UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancelAlertAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"cancel", @"") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        commToId=@"";
    }];
    
    UIAlertAction *replyAlertAction = [UIAlertAction actionWithTitle:@"回复" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        commToId=commentModel.userId;
        [_commentview becomeFirstResponder];
    }];
    
    [alertController addAction:cancelAlertAction];
    [alertController addAction:replyAlertAction];
    if([loc.u_id isEqualToString:commentModel.userId])
    {
        UIAlertAction *deleteAlertAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self deleteActionWithIndex:index];
        }];
        [alertController addAction:deleteAlertAction];
    }
    [self presentViewController:alertController animated:YES completion:nil];
}
#pragma mark - Others
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"DD_CircleDetailViewController"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"DD_CircleDetailViewController"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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

@end
