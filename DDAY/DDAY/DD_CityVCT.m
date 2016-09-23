//
//  DD_CityVCT.m
//  DDAY
//
//  Created by yyj on 16/5/17.
//  Copyright © 2016年 mike_xie. All rights reserved.
//

#import "DD_CityVCT.h"

#import "DD_AddNewAddressViewController.h"

#import "DD_CityTool.h"
#import "DD_ProvinceModel.h"
#import "DD_CityModel.h"

@interface DD_CityVCT ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation DD_CityVCT{
    NSArray *_dataArr;
    UITableView *_tableview;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self SomePrepare];
    [self CreateTableView];
    
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
#pragma mark - SomePrepare
-(void)SomePrepare
{
    _dataArr=[[NSArray alloc] init];
    NSArray *_all_data=[DD_CityTool getCityModelArr];
    for (int i=0; i<_all_data.count; i++) {
        DD_ProvinceModel *_p_model=[_all_data objectAtIndex:i];
        if([_p_model.p_id isEqualToString:_p_id])
        {
            _dataArr=_p_model.City;
            break;
        }
    }

}
-(void)CreateTableView
{
    _tableview=[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    [self.view addSubview:_tableview];
    //    消除分割线
//    _tableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableview.delegate=self;
    _tableview.dataSource=self;
    [_tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 0, -ktabbarHeight, 0));
    }];
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
    DD_CityModel *_c_model=_dataArr[indexPath.section];
    cell.textLabel.text=_c_model.name;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DD_CityModel *_c_model=_dataArr[indexPath.section];
    for (id _obj in self.navigationController.viewControllers) {
        if([_obj isKindOfClass:[DD_AddNewAddressViewController class]])
        {
            self.chooseblock(_p_id,_c_model.c_id);
            [self.navigationController popToViewController:_obj animated:YES];
        }
    } 
}

#pragma mark - Other
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
