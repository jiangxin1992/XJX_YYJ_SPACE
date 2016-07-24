//
//  DD_ProvinceVCT.m
//  DDAY
//
//  Created by yyj on 16/5/17.
//  Copyright © 2016年 mike_xie. All rights reserved.
//
#import "DD_ProvinceVCT.h"
#import "DD_CityVCT.h"
#import "DD_CityTool.h"
@interface DD_ProvinceVCT ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation DD_ProvinceVCT
{
    NSArray *_dataArr;
    UITableView *_tableview;
}
#pragma mark - 初始化
-(instancetype)initWithBlock:(void(^)(NSString *p_id,NSString *c_id))block
{
    self=[super init];
    if(self)
    {
        self.chooseblock=block;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self SomePrepare];
    [self CreateTableView];
    
}
#pragma mark - SomePrepare
-(void)SomePrepare
{
    _dataArr=[DD_CityTool getCityModelArr];
    self.view.backgroundColor=_define_backview_color;
}
-(void)CreateTableView
{
    _tableview=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableview];
    
    //    消除分割线
    _tableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableview.delegate=self;
    _tableview.dataSource=self;

}
#pragma mark - TableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
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
    static NSString *cellid=@"cell_p";
    UITableViewCell *cell=[_tableview dequeueReusableCellWithIdentifier:cellid];
    if(!cell)
    {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    DD_ProvinceModel *_p_model=_dataArr[indexPath.section];
    cell.textLabel.text=_p_model.name;
    return cell;
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DD_ProvinceModel *_p_model=_dataArr[indexPath.section];
    DD_CityVCT *_city=[[DD_CityVCT alloc] initWithBlock:^(NSString *p_id, NSString *c_id) {
        self.chooseblock(p_id,c_id);
    }];
    _city.title=@"选择城市";
    _city.p_id=_p_model.p_id;
    [self.navigationController pushViewController:_city animated:YES];
//
//    self.chooseblock(_p_model.p_id,@"");
}
#pragma mark - Other
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"DD_ProvinceVCT"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"DD_ProvinceVCT"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
