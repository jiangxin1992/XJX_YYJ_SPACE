//
//  DD_CircleItemListViewController.m
//  DDAY
//
//  Created by yyj on 16/6/21.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_GoodsDetailViewController.h"
#import "DD_ItemCell.h"
#import "DD_CricleChooseItemModel.h"

#import "DD_CircleItemListViewController.h"

@interface DD_CircleItemListViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation DD_CircleItemListViewController
{
    UITableView *_tableview;
    NSArray *_dataArr;//数据数组
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self SomePrepare];
    [self UIConfig];
    [self RequestData];
}
#pragma mark - 初始化
-(instancetype)initWithShareID:(NSString *)shareID WithBlock:(void (^)(NSString *))block
{
    self=[super init];
    if(self)
    {
        _shareID=shareID;
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

-(void)PrepareData{}
-(void)PrepareUI
{
    self.navigationItem.titleView=[regular returnNavView:@"搭配列表" withmaxwidth:200];
}

#pragma mark - UIConfig
-(void)UIConfig
{
    [self CreateTableview];
}
-(void)CreateTableview
{
    _tableview=[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    
    [self.view addSubview:_tableview];
    //    消除分割线
    _tableview.backgroundColor=_define_backview_color;
    _tableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableview.delegate=self;
    _tableview.dataSource=self;
    [_tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
}
#pragma mark - RequestData
-(void)RequestData
{
    NSDictionary *_parameters=@{@"shareId":_shareID,@"token":[DD_UserModel getToken]};
    [[JX_AFNetworking alloc] GET:@"share/queryItemsByShare.do" parameters:_parameters success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
        if(success)
        {
            _dataArr=[DD_CricleChooseItemModel getItemsModelArr:[data objectForKey:@"items"]];
            [_tableview reloadData];
        }else
        {
            [self presentViewController:successAlert animated:YES completion:nil];
        }
    } failure:^(NSError *error, UIAlertController *failureAlert) {
        [self presentViewController:failureAlert animated:YES completion:nil];
    }];
}
#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
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
    
    static NSString *CellIdentifier = @"cell_goods";
    BOOL nibsRegistered = NO;
    if (!nibsRegistered) {
        UINib *nib = [UINib nibWithNibName:NSStringFromClass([DD_ItemCell class]) bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:CellIdentifier];
        nibsRegistered = YES;
    }
    DD_ItemCell *cell = (DD_ItemCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    DD_CricleChooseItemModel *_itemModel=[_dataArr objectAtIndex:indexPath.section];
    DD_ItemsModel *_item=[[DD_ItemsModel alloc] init];
    _item.price=_itemModel.price;
    _item.name=_itemModel.name;
    _item.pics=@[_itemModel.pic];
    _item.g_id=_itemModel.g_id;
    _item.colorId=_itemModel.colorId;
    cell.item=_item;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DD_CricleChooseItemModel *_itemModel=[_dataArr objectAtIndex:indexPath.section];
    DD_ItemsModel *_item=[[DD_ItemsModel alloc] init];
    _item.g_id=_itemModel.g_id;
    _item.colorId=_itemModel.colorId;
    DD_GoodsDetailViewController *_GoodsDetail=[[DD_GoodsDetailViewController alloc] initWithModel:_item WithBlock:^(DD_ItemsModel *model, NSString *type) {
        //        if(type)
    }];
    _GoodsDetail.title=_itemModel.name;
    [self.navigationController pushViewController:_GoodsDetail animated:YES];
    
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
#pragma mark - Other
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [[DD_CustomViewController sharedManager] tabbarHide];
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
