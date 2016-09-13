//
//  DD_CircleItemListViewController.m
//  DDAY
//
//  Created by yyj on 16/6/21.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_CircleItemListViewController.h"

#import "DD_GoodsDetailViewController.h"

#import "Waterflow.h"
#import "WaterflowCell.h"

#import "DD_CirclePublishTool.h"
#import "DD_CricleChooseItemModel.h"

@interface DD_CircleItemListViewController ()<WaterflowDataSource,WaterflowDelegate>

@end

@implementation DD_CircleItemListViewController
{
    Waterflow *mywaterflow;
    NSMutableArray *_dataArr;//数据数组
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
}
#pragma mark - 初始化
-(instancetype)initWithShareID:(NSString *)shareID WithBlock:(void (^)(NSString *))block
{
    self=[super init];
    if(self)
    {
        _shareID=shareID;
        _block=block;
        [self SomePrepare];
        [self UIConfig];
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
    _dataArr=[[NSMutableArray alloc] init];
}
-(void)PrepareUI
{
    self.navigationItem.titleView=[regular returnNavView:NSLocalizedString(@"circle_item_list", @"") withmaxwidth:200];
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
    
    mywaterflow.dataSource = self;
    
    mywaterflow.delegate = self;
    
    [self.view addSubview:mywaterflow];
    
    [mywaterflow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}
#pragma mark - MJRefresh
-(void)MJRefresh
{
    MJRefreshNormalHeader *header= [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    mywaterflow.mj_header = header;
    [mywaterflow.mj_header beginRefreshing];
}
-(void)loadNewData
{
    // 进入刷新状态后会自动调用这个block
    [self RequestData];
}
#pragma mark - RequestData
-(void)RequestData
{
    NSDictionary *_parameters=@{@"shareId":_shareID,@"token":[DD_UserModel getToken]};
    [[JX_AFNetworking alloc] GET:@"share/queryItemsByShare.do" parameters:_parameters success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
        if(success)
        {
            [_dataArr removeAllObjects];
            [_dataArr addObjectsFromArray:[DD_CricleChooseItemModel getItemsModelArr:[data objectForKey:@"items"]]];
            [mywaterflow reloadData];
        }else
        {
            [self presentViewController:successAlert animated:YES completion:nil];
        }
        [mywaterflow.mj_header endRefreshing];
        [mywaterflow.mj_footer endRefreshing];
    } failure:^(NSError *error, UIAlertController *failureAlert) {
        [self presentViewController:failureAlert animated:YES completion:nil];
        [mywaterflow.mj_header endRefreshing];
        [mywaterflow.mj_footer endRefreshing];
    }];
}
#pragma mark - WaterflowDelegate
// cell的个数，必须实现
- (NSUInteger)numberOfCellsInWaterflow:(Waterflow *)waterflow{
    
    return _dataArr.count+1;
}
// 返回cell，必须实现
- (WaterflowCell *)waterflow:(Waterflow *)waterflow cellAtIndex:(NSUInteger)index{
    if(index)
    {
        DD_CricleChooseItemModel *choose_item=[_dataArr objectAtIndex:index-1];
        CGFloat _height=0;
        if(choose_item.pic)
        {
            _height=((ScreenWidth-water_margin*2-water_Spacing)/2.0f)*([choose_item.pic.height floatValue]/[choose_item.pic.width floatValue]);
        }
        return [DD_CirclePublishTool getColCustomWaterflowCell:waterflow cellAtIndex:index-1 WithItemsModel:choose_item WithHeight:_height];
    }else
    {
        return [WaterflowCell waterflowCellWithWaterflow:waterflow];
    }
    
}
// 这个方法可选不是必要的，默认是3列
- (NSUInteger)numberOfColumnsInWaterflow:(Waterflow *)waterflow{
    return 2;
}
// 返回每一个cell的高度，非必要，默认为80
- (CGFloat)waterflow:(Waterflow *)waterflow heightAtIndex:(NSUInteger)index{
    if(index)
    {
        DD_CricleChooseItemModel *choose_item=[_dataArr objectAtIndex:index-1];
        if(choose_item.pic)
        {
            CGFloat _height=((ScreenWidth-water_margin*2-water_Spacing)/2.0f)*([choose_item.pic.height floatValue]/[choose_item.pic.width floatValue]);
            return _height+25+water_Top;
        }
        return 25+water_Top;
    }else
    {
        return 0;
    }
    
}
// 间隔，非必要，默认均为10
- (CGFloat)waterflow:(Waterflow *)waterflow marginOfWaterflowMarginType:(WaterflowMarginType)type{
    switch (type) {
        case WaterflowMarginTypeLeft:return water_margin;
        case WaterflowMarginTypeRight:return water_margin;
        case WaterflowMarginTypeRow:return water_Spacing;
        case WaterflowMarginTypeColumn:return water_Bottom;
        case WaterflowMarginTypeBottom:return water_Bottom;
        default:return 0;
    }
}
// 非必要
- (void)waterflow:(Waterflow *)waterflow didSelectCellAtIndex:(NSUInteger)index{
    if(index)
    {
        DD_ItemsModel *_item=[_dataArr objectAtIndex:index-1];
        DD_GoodsDetailViewController *_GoodsDetail=[[DD_GoodsDetailViewController alloc] initWithModel:_item WithBlock:^(DD_ItemsModel *model, NSString *type) {
            //        if(type)
        }];
        [self.navigationController pushViewController:_GoodsDetail animated:YES];
    }
    
}

//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 120;
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
//    
//    static NSString *CellIdentifier = @"cell_goods";
//    BOOL nibsRegistered = NO;
//    if (!nibsRegistered) {
//        UINib *nib = [UINib nibWithNibName:NSStringFromClass([DD_ItemCell class]) bundle:nil];
//        [tableView registerNib:nib forCellReuseIdentifier:CellIdentifier];
//        nibsRegistered = YES;
//    }
//    DD_ItemCell *cell = (DD_ItemCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    cell.selectionStyle=UITableViewCellSelectionStyleNone;
//    DD_CricleChooseItemModel *_itemModel=[_dataArr objectAtIndex:indexPath.section];
//    DD_ItemsModel *_item=[[DD_ItemsModel alloc] init];
//    _item.price=_itemModel.price;
//    _item.name=_itemModel.name;
//    _item.pics=@[_itemModel.pic];
//    _item.g_id=_itemModel.g_id;
//    _item.colorId=_itemModel.colorId;
//    cell.item=_item;
//    return cell;
//}
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    DD_CricleChooseItemModel *_itemModel=[_dataArr objectAtIndex:indexPath.section];
//    DD_ItemsModel *_item=[[DD_ItemsModel alloc] init];
//    _item.g_id=_itemModel.g_id;
//    _item.colorId=_itemModel.colorId;
//    _item.colorCode=_itemModel.colorCode;
//    DD_GoodsDetailViewController *_GoodsDetail=[[DD_GoodsDetailViewController alloc] initWithModel:_item WithBlock:^(DD_ItemsModel *model, NSString *type) {
//        //        if(type)
//    }];
//    [self.navigationController pushViewController:_GoodsDetail animated:YES];
//    
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
#pragma mark - Other
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"DD_CircleItemListViewController"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"DD_CircleItemListViewController"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
