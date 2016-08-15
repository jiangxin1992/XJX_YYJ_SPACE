//
//  DD_DDAYMeetViewController.m
//  DDAY
//
//  Created by yyj on 16/6/3.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_DDAYMeetViewController.h"

#import "DD_GoodsDetailViewController.h"

#import "DD_ItemTool.h"
#import "DD_ItemsModel.h"
#import "MJRefresh.h"
#import "DD_ShopViewController.h"
#import "Waterflow.h"
#import "WaterflowCell.h"

@interface DD_DDAYMeetViewController ()<WaterflowDataSource,WaterflowDelegate>

@end

@implementation DD_DDAYMeetViewController
{
    Waterflow *mywaterflow;
    NSMutableArray *_dataArr;
    NSInteger _page;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self SomePrepare];
    [self UIConfig];
}
#pragma mark - 初始化
-(instancetype)initWithType:(NSString *)type WithSeriesID:(NSString *)SeriesID WithBlock:(void(^)(NSString *type))meetBlock;
{
    self=[super init];
    if(self)
    {
        _SeriesID=SeriesID;
        _meetBlock=meetBlock;
        _Type=type;
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
-(void)PrepareUI
{

    if([_Type isEqualToString:@"meet"])
    {
        self.navigationItem.titleView=[regular returnNavView:@"查看发布会" withmaxwidth:200];
    }else if([_Type isEqualToString:@"good"])
    {
        self.navigationItem.titleView=[regular returnNavView:@"查看发布品" withmaxwidth:200];
    }
}
#pragma mark - RequestData
-(void)RequestData
{
    
    NSDictionary *_parameters=@{@"page":[NSNumber numberWithInteger:_page],@"token":[DD_UserModel getToken],@"seriesId":_SeriesID};
    [[JX_AFNetworking alloc] GET:@"series/querySeriesColorsItems.do" parameters:_parameters success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
        if(success)
        {
            NSArray *modelArr=[DD_ItemsModel getItemsModelArr:[data objectForKey:@"items"]];
            if(modelArr.count)
            {
                if(_page==1)
                {
                    [_dataArr removeAllObjects];//删除所有数据
                }
                [_dataArr addObjectsFromArray:modelArr];
                [mywaterflow reloadData];
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
    
    mywaterflow.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight+ktabbarHeight);
    
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

#pragma mark - UITableViewDelegate
// cell的个数，必须实现
- (NSUInteger)numberOfCellsInWaterflow:(Waterflow *)waterflow{
    
    return _dataArr.count;
}
// 返回cell，必须实现
- (WaterflowCell *)waterflow:(Waterflow *)waterflow cellAtIndex:(NSUInteger)index{
    DD_ItemsModel *item=[_dataArr objectAtIndex:index];
    DD_ImageModel *imgModel=[item.pics objectAtIndex:0];
    CGFloat _height=((ScreenWidth-13*3-10*2)/2)*([imgModel.height floatValue]/[imgModel.width floatValue]);
    return [DD_ItemTool getCustomWaterflowCell:waterflow cellAtIndex:index WithItemsModel:item WithHeight:_height];
}
// 这个方法可选不是必要的，默认是3列
- (NSUInteger)numberOfColumnsInWaterflow:(Waterflow *)waterflow{
    return 2;
}
// 返回每一个cell的高度，非必要，默认为80
- (CGFloat)waterflow:(Waterflow *)waterflow heightAtIndex:(NSUInteger)index{
    DD_ItemsModel *item=[_dataArr objectAtIndex:index];
    if(item.pics)
    {
        DD_ImageModel *imgModel=[item.pics objectAtIndex:0];
        CGFloat _height=((ScreenWidth-13*3-10*2)/2)*([imgModel.height floatValue]/[imgModel.width floatValue]);
        return _height+95;
    }
    return 95;
}
// 间隔，非必要，默认均为10
- (CGFloat)waterflow:(Waterflow *)waterflow marginOfWaterflowMarginType:(WaterflowMarginType)type{
    return 13;
}
// 非必要
- (void)waterflow:(Waterflow *)waterflow didSelectCellAtIndex:(NSUInteger)index{
    
    DD_ItemsModel *_model=[_dataArr objectAtIndex:index];
    DD_GoodsDetailViewController *_GoodsDetail=[[DD_GoodsDetailViewController alloc] initWithModel:_model WithBlock:^(DD_ItemsModel *model, NSString *type) {
        //        if(type)
    }];
    [self.navigationController pushViewController:_GoodsDetail animated:YES];
}

#pragma mark - Other
-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"DD_DDAYMeetViewController"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"DD_DDAYMeetViewController"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
