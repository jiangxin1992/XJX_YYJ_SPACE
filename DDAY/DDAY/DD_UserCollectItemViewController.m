//
//  DD_UserCollectItemViewController.m
//  DDAY
//
//  Created by yyj on 16/6/13.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_UserCollectItemViewController.h"

#import "DD_ItemTool.h"
#import "DD_ItemsModel.h"

#import "MJRefresh.h"

#import "Waterflow.h"
#import "WaterflowCell.h"


@interface DD_UserCollectItemViewController ()<WaterflowDataSource,WaterflowDelegate>

@end

@implementation DD_UserCollectItemViewController
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
-(instancetype)initWithBlock:(void(^)(NSString *type,DD_ItemsModel *model))block
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
    [self hideBackNavBtn];
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
    NSDictionary *_parameters=@{@"page":[NSNumber numberWithInteger:_page],@"token":[DD_UserModel getToken]};
    [[JX_AFNetworking alloc] GET:@"item/queryItemCollections.do" parameters:_parameters success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
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
            }else
            {
                //                [self presentViewController:[regular alertTitle_Simple:NSLocalizedString(@"no_more", @"")] animated:YES completion:nil];
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
    
    
    mywaterflow.frame = CGRectMake(0, 0, ScreenWidth,ScreenHeight-kNavHeight-54);
    
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
- (CGFloat)waterflow:(Waterflow *)waterflow marginOfWaterflowType:(WaterflowMarginType)type{
    return 13;
}
// 非必要
- (void)waterflow:(Waterflow *)waterflow didSelectCellAtIndex:(NSUInteger)index{
    
    DD_ItemsModel *_model=[_dataArr objectAtIndex:index];
    _block(@"detail",_model);
}

#pragma mark - Other
-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    [[DD_CustomViewController sharedManager] tabbarHide];
    [MobClick beginLogPageView:@"DD_UserCollectItemViewController"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"DD_UserCollectItemViewController"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
