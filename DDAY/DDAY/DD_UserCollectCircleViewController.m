//
//  DD_UserCollectCircleViewController.m
//  DDAY
//
//  Created by yyj on 16/6/13.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_UserCollectCircleViewController.h"

#import "Waterflow.h"
#import "WaterflowCell.h"
#import "DD_ImageModel.h"

#import "DD_CircleListCell.h"

@interface DD_UserCollectCircleViewController ()<WaterflowDataSource,WaterflowDelegate>

@end

@implementation DD_UserCollectCircleViewController
{
    Waterflow *mywaterflow;
    NSMutableArray *_dataArr;
    NSInteger _page;
    
    void (^cellBlock)(NSString *type,NSInteger index,DD_OrderItemModel *item);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self SomePrepare];
    [self UIConfig];
}
#pragma mark - 初始化
-(instancetype)initWithBlock:(void(^)(NSString *type,DD_CircleListModel *model,DD_OrderItemModel *item))block
{
    self=[super init];
    if(self)
    {
        _block=block;
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
    _page=1;
    _dataArr=[[NSMutableArray alloc] init];
}

-(void)PrepareUI{}
#pragma mark - RequestData
-(void)RequestData
{
    [[JX_AFNetworking alloc] GET:@"share/queryCollectShares.do" parameters:@{@"page":[NSNumber numberWithInteger:_page],@"token":[DD_UserModel getToken]} success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
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
                [mywaterflow reloadData];
            }else
            {
            }
        }else
        {
            [self presentViewController:successAlert animated:YES completion:nil];
        }
        [mywaterflow.header endRefreshing];
        [mywaterflow.footer endRefreshing];
        
    } failure:^(NSError *error, UIAlertController *failureAlert) {
        [mywaterflow.header endRefreshing];
        [mywaterflow.footer endRefreshing];
        [self presentViewController:failureAlert animated:YES completion:nil];
    }];
}
#pragma mark - UIConfig
-(void)UIConfig
{
    [self CreateWaterFlow];
    [self MJRefresh];
}
-(void)CreateWaterFlow
{
    mywaterflow = [[Waterflow alloc] init];
    
    
    mywaterflow.frame = CGRectMake(0, 17, ScreenWidth,ScreenHeight-36-64-17);
    
    mywaterflow.dataSource = self;
    
    mywaterflow.delegate = self;
    
    [self.view addSubview:mywaterflow];
}
#pragma mark - MJRefresh
-(void)MJRefresh
{
    mywaterflow.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        _page=1;
        [self RequestData];
    }];
    
    mywaterflow.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        _page+=1;
        [self RequestData];
    }];
    
    [mywaterflow.header beginRefreshing];
}
#pragma mark - SomeAction


#pragma mark - WaterflowDelegate

// cell的个数，必须实现
- (NSUInteger)numberOfCellsInWaterflow:(Waterflow *)waterflow{
    
    return _dataArr.count;
}
// 返回cell，必须实现
- (WaterflowCell *)waterflow:(Waterflow *)waterflow cellAtIndex:(NSUInteger)index{
    WaterflowCell *cell = [WaterflowCell waterflowCellWithWaterflow:waterflow];
    DD_CircleListModel *listModel=[_dataArr objectAtIndex:index];
    if(listModel.pics.count)
    {
        DD_ImageModel *imgModel=[listModel.pics objectAtIndex:0];
        UIImageView *img=[UIImageView getCustomImg];
        [cell addSubview:img];
        [img JX_loadImageUrlStr:imgModel.pic WithSize:800 placeHolderImageName:nil radius:0];
        img.contentMode=UIViewContentModeScaleAspectFill;
        [img mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(cell);
        }];
    }
    return cell;
}
// 这个方法可选不是必要的，默认是3列
- (NSUInteger)numberOfColumnsInWaterflow:(Waterflow *)waterflow{
    return 2;
}
// 返回每一个cell的高度，非必要，默认为80
- (CGFloat)waterflow:(Waterflow *)waterflow heightAtIndex:(NSUInteger)index{
    DD_CircleListModel *listModel=[_dataArr objectAtIndex:index];
    if(listModel.pics.count)
    {
        DD_ImageModel *imgModel=[listModel.pics objectAtIndex:0];
        CGFloat _height=((ScreenWidth-water_margin*2-water_Spacing)/2)*([imgModel.height floatValue]/[imgModel.width floatValue]);
        return _height;
    }
    return 0;
}
// 间隔，非必要，默认均为10
- (CGFloat)waterflow:(Waterflow *)waterflow marginOfWaterflowMarginType:(WaterflowMarginType)type{
    switch (type) {
        case WaterflowMarginTypeTop:return water_Top;
        case WaterflowMarginTypeLeft:return water_margin;
        case WaterflowMarginTypeRight:return water_margin;
        case WaterflowMarginTypeRow:return water_Spacing;
        case WaterflowMarginTypeColumn:return water_Bottom+water_Top;
        case WaterflowMarginTypeBottom:return water_Bottom;
            //        case WaterflowMarginTypeColumn:return 0;
        default:return 0;
    }
}
// 非必要
- (void)waterflow:(Waterflow *)waterflow didSelectCellAtIndex:(NSUInteger)index{
    DD_CircleListModel *listModel=[_dataArr objectAtIndex:index];
    _block(@"push_circle_detail",listModel,nil);
}


#pragma mark - Others
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(mywaterflow)
    {
        _page=1;
        [self RequestData];
    }
    [MobClick beginLogPageView:@"DD_UserCollectCircleViewController"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"DD_UserCollectCircleViewController"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//#pragma mark - UITableViewDelegate
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    DD_CircleListModel *listModel=[_dataArr objectAtIndex:indexPath.section];
//    return 454+listModel.suggestHeight;
//}
//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return 1;
//}
//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return _dataArr.count;
//}
//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    //    数据还未获取时候
//    if(_dataArr.count==indexPath.section)
//    {
//        static NSString *cellid=@"cellid";
//        UITableViewCell *cell=[_tableview dequeueReusableCellWithIdentifier:cellid];
//        if(!cell)
//        {
//            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
//        }
//        cell.selectionStyle=UITableViewCellSelectionStyleNone;
//        return cell;
//    }
//    //获取到数据以后
//    static NSString *cellid=@"cell_title";
//    DD_CircleListCell *cell=[_tableview dequeueReusableCellWithIdentifier:cellid];
//    if(!cell)
//    {
//        cell=[[DD_CircleListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
//    }
//    cell.listModel=[_dataArr objectAtIndex:indexPath.section];
//    cell.index=indexPath.section;
//    cell.cellBlock=cellBlock;
//    cell.selectionStyle=UITableViewCellSelectionStyleNone;
//    return cell;
//}
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    DD_CircleListModel *listModel=[_dataArr objectAtIndex:indexPath.section];
//    _block(@"push_circle_detail",listModel,nil);
//}
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
/**
 * cell中交互回调
 */
//-(void)SomeBlock
//{
//    __block DD_UserCollectCircleViewController *_CircleView=self;
//    cellBlock=^(NSString *type,NSInteger index,DD_OrderItemModel *item)
//    {
//        if([type isEqualToString:@"show_item_list"])
//        {
//            //            显示商品列表
//            [_CircleView PushItemListViewWithIndex:index];
//        }else if([type isEqualToString:@"head_click"])
//        {
//            //            点击用户头像
//            [_CircleView PushHomePageViewWithIndex:index];
//            
//        }else if([type isEqualToString:@"collect_cancel"])
//        {
//            //            取消收藏
//            [_CircleView collectActionIsCancel:YES WithIndex:index];
//        }else if([type isEqualToString:@"collect"])
//        {
//            //            收藏
//            [_CircleView collectActionIsCancel:NO WithIndex:index];
//        }else if([type isEqualToString:@"share"])
//        {
//            //            分享
//            [_CircleView presentViewController:[regular alertTitle_Simple:NSLocalizedString(@"pay_attention", @"")] animated:YES completion:nil];
//        }else if([type isEqualToString:@"comment"])
//        {
//            //            跳转评论页面
//        }else if([type isEqualToString:@"praise_cancel"])
//        {
//            //            取消点赞
//            [_CircleView praiseActionIsCancel:YES WithIndex:index];
//        }else if([type isEqualToString:@"praise"])
//        {
//            //             点赞
//            [_CircleView praiseActionIsCancel:NO WithIndex:index];
//        }else if([type isEqualToString:@"item_click"])
//        {
//            //            点击商品
//            [_CircleView PushItemViewWithIndex:index WithItemModel:item];
//        }
//    };
//}
//-(void)PushItemViewWithIndex:(NSInteger )index WithItemModel:(DD_OrderItemModel *)item
//{
//    DD_CircleListModel *listModel=[_dataArr objectAtIndex:index];
//    _block(@"item_click",listModel,item);
//}
//-(void)PushHomePageViewWithIndex:(NSInteger )index
//{
//    DD_CircleListModel *listModel=[_dataArr objectAtIndex:index];
//    _block(@"head_click",listModel,nil);
//}
///**
// * 刷新
// */
//-(void)reloadData
//{
//    [mywaterflow reloadData];
//}
//
//
///**
// * 点赞和取消点赞
// */
//-(void)praiseActionIsCancel:(BOOL)is_cancel WithIndex:(NSInteger)index
//{
//    NSString *url=nil;
//    if(is_cancel)
//    {
//        url=@"share/unLikeShare.do";
//    }else
//    {
//        url=@"share/likeShare.do";
//    }
//    DD_CircleListModel *listModel=[_dataArr objectAtIndex:index];
//    NSDictionary *_parameters=@{@"token":[DD_UserModel getToken],@"shareId":listModel.shareId};
//    [[JX_AFNetworking alloc] GET:url parameters:_parameters success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
//        if(success)
//        {
//            listModel.isLike=[[data objectForKey:@"isLike"] boolValue];
//            listModel.likeTimes=[[data objectForKey:@"likeTimes"] longValue];
//            [mywaterflow reloadData];
//            
//        }else
//        {
//            [self presentViewController:successAlert animated:YES completion:nil];
//        }
//    } failure:^(NSError *error, UIAlertController *failureAlert) {
//        [self presentViewController:failureAlert animated:YES completion:nil];
//    }];
//}
///**
// * 收藏和取消收藏
// */
//-(void)collectActionIsCancel:(BOOL)is_cancel WithIndex:(NSInteger)index
//{
//    NSString *url=nil;
//    if(is_cancel)
//    {
//        url=@"share/delCollectShare.do";
//    }else
//    {
//        url=@"share/collectShare.do";
//    }
//    DD_CircleListModel *listModel=[_dataArr objectAtIndex:index];
//    [[JX_AFNetworking alloc] GET:url parameters:@{@"token":[DD_UserModel getToken],@"shareId":listModel.shareId} success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
//        if(success)
//        {
//            listModel.isCollect=[[data objectForKey:@"isCollect"] boolValue];
//            [self UpdateModel];
//            [mywaterflow reloadData];
//            
//        }else
//        {
//            [self presentViewController:successAlert animated:YES completion:nil];
//        }
//    } failure:^(NSError *error, UIAlertController *failureAlert) {
//        [self presentViewController:failureAlert animated:YES completion:nil];
//    }];
//}
///**
// * 更新当前dataArr
// * 过滤已取消收藏的搭配
// */
//-(void)UpdateModel
//{
//    NSMutableArray *mu_arr=[[NSMutableArray alloc] init];
//    [mu_arr addObjectsFromArray:_dataArr];
//    [_dataArr removeAllObjects];
//    for (DD_CircleListModel *listModel in mu_arr) {
//        if(listModel.isCollect)
//        {
//            [_dataArr addObject:listModel];
//        }
//    }
//}
///**
// * 跳转搭配商品列表
// */
//-(void)PushItemListViewWithIndex:(NSInteger )index
//{
//    DD_CircleListModel *listModel=[_dataArr objectAtIndex:index];
//    _block(@"push_item_list",listModel,nil);
//}
@end
