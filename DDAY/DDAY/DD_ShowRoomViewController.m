//
//  DD_ShowRoomViewController.m
//  YCO SPACE
//
//  Created by yyj on 16/8/19.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_ShowRoomViewController.h"

#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

#import "DD_ShowRoomSimpleCell.h"

#import "DD_ShowRoomModel.h"


@interface DD_ShowRoomViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation DD_ShowRoomViewController
{
    UITableView *_tableview;
    NSMutableArray *_dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self SomePrepare];
    [self UIConfig];
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
    self.navigationItem.titleView=[regular returnNavView:NSLocalizedString(@"user_showroom", @"") withmaxwidth:200];
}

#pragma mark - UIConfig
-(void)UIConfig
{
    [self CreateTableView];
    [self MJRefresh];
}
-(void)CreateTableView
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
-(void)MJRefresh
{
    _tableview.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        [self RequestData];
    }];
    
    [_tableview.header beginRefreshing];
}
#pragma mark - RequestData
-(void)RequestData
{
    [[JX_AFNetworking alloc] GET:@"physicalStore/queryPhysicalStores.do" parameters:@{@"token":[DD_UserModel getToken]} success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
        if(success)
        {
            [_dataArr removeAllObjects];//删除所有数据
            [_dataArr addObjectsFromArray:[DD_ShowRoomModel getShowRoomModelArr:[data objectForKey:@"stores"]]];
            [_tableview reloadData];

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
    DD_ShowRoomModel *model=[_dataArr objectAtIndex:indexPath.section];
    CGFloat height=[DD_ShowRoomSimpleCell heightWithModel:model];
    return height;
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
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid ];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    static NSString *cellid=@"showroom_cell";
    DD_ShowRoomSimpleCell *cell=[_tableview dequeueReusableCellWithIdentifier:cellid];
    if(!cell)
    {
        cell=[[DD_ShowRoomSimpleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }

    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.showRoomModel=[_dataArr objectAtIndex:indexPath.section];
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0)
    {
        BOOL gaoDeMapCanOpen=[[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]];
        [self openGaoDeMap];
    }else
    {
//        BOOL baiduMapCanOpen=[[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]];
//        [self openBaiDuMap];
        [self openAppleMap];
    }
}
//打开高德地图导航

- (void)openGaoDeMap{
    
    NSString *urlString = [[NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=%@&poiname=%@&lat=%f&lon=%f&dev=1&style=2",@"app name", @"YGche", @"终点", 29.9724500000, 120.2725810000] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:urlString]];
    
}

//打开百度地图导航

- (void)openBaiDuMap{
    
    MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
    NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin=latlng:%f,%f|name:我的位置&destination=latlng:%f,%f|name:终点&mode=driving",30.0410591836, 121.1528907660,currentLocation.placemark.location.coordinate.latitude,currentLocation.placemark.location.coordinate.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ;
    
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:urlString]];
    
}
//打开苹果自带地图导航

- (void)openAppleMap{
    
    MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
    
    //目的地的位置
    
    CLLocationCoordinate2D coords2 = CLLocationCoordinate2DMake(29.9724500000,120.2725810000);
    
    MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:coords2 addressDictionary:nil]];
    
    toLocation.name =@"青芝坞";
    
    NSArray *items = [NSArray arrayWithObjects:currentLocation, toLocation, nil];
    
    NSDictionary *options = @{ MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving, MKLaunchOptionsMapTypeKey: [NSNumber numberWithInteger:MKMapTypeStandard], MKLaunchOptionsShowsTrafficKey:@YES };
    
    //打开苹果自身地图应用，并呈现特定的item
    
    [MKMapItem openMapsWithItems:items launchOptions:options];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
