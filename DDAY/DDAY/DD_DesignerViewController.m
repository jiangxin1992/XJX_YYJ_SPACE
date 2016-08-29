//
//  DD_DesignerViewController.m
//  DDAY
//
//  Created by yyj on 16/5/20.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_DesignerViewController.h"

#import "DD_DesignerCell.h"

@interface DD_DesignerViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation DD_DesignerViewController
{
    UITableView *_tableview;
    NSMutableArray *_dataArr;
    NSInteger _page;
    void (^followblock)(NSInteger index,NSString *type);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self SomePrepare];
    [self UIConfig];
    [self SomeBlock];
    
}
#pragma mark - 初始化
-(instancetype)initWithBlock:(void(^)(NSString *type ,DD_DesignerModel *model))block;
{
    self=[super init];
    if(self)
    {
        _block=block;
    }
    return self;
}
#pragma mark - SomeBlock
-(void)SomeBlock
{
    
    __block NSArray *__dataArr=_dataArr;
    __block UITableView *__tableview=_tableview;
    __block DD_DesignerViewController *_desginerView=self;
    __block void (^___block)(NSString *type ,DD_DesignerModel *model)=_block;
    followblock=^(NSInteger index,NSString *type)
    {
        if([type isEqualToString:@"click"])
        {
            DD_DesignerModel *_model=[__dataArr objectAtIndex:index];
            ___block(@"click",_model);
        }else
        {
            if(![DD_UserModel isLogin])
            {
                ___block(@"login",nil);
            }else
            {
                DD_DesignerModel *_model=[__dataArr objectAtIndex:index];
                NSString *url=nil;
                if([type isEqualToString:@"unfollow"])
                {
                    //            取消关注
                    url=@"designer/unCareDesigner.do";
                }else if([type isEqualToString:@"follow"])
                {
                    //            关注
                    url=@"designer/careDesigner.do";
                }
                [[JX_AFNetworking alloc] GET:url parameters:@{@"token":[DD_UserModel getToken],@"designerId":_model.designerId} success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
                    if(success)
                    {
                        _model.guanzhu=[[data objectForKey:@"guanzhu"] boolValue];
                        [__tableview reloadData];
                    }else
                    {
                        [_desginerView presentViewController:successAlert animated:YES completion:nil];
                    }
                } failure:^(NSError *error, UIAlertController *failureAlert) {
                    [_desginerView presentViewController:failureAlert animated:YES completion:nil];
                }];
            }
            
        }
        
    };
}
#pragma mark - SomeAction
-(void)updateDesigner
{
    //    如果设计师状态发生改变
    //    回到页面的时候刷新
    //    [_tableview.header beginRefreshing];
    //    自动刷新，不用回到页面
    _page=1;
    [self RequestData];
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
    [[JX_AFNetworking alloc] GET:@"designer/queryDesigners.do" parameters:@{@"page":[NSNumber numberWithInteger:_page],@"token":[DD_UserModel getToken]} success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
        if(success)
        {
            NSArray *modelArr=[DD_DesignerModel getDesignerModelArr:[data objectForKey:@"designers"]];
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
#pragma mark - UIConfig
-(void)UIConfig
{
    [self CreateTableview];
    [self MJRefresh];
}
-(void)CreateTableview
{
    
    _tableview=[[UITableView alloc] initWithFrame:CGRectMake(0, kNavHeight, ScreenWidth, ScreenHeight-ktabbarHeight-kNavHeight) style:UITableViewStylePlain];
    [self.view addSubview:_tableview];
    //    消除分割线
    _tableview.backgroundColor=_define_backview_color;
    _tableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableview.delegate=self;
    _tableview.dataSource=self;
    
}
#pragma mark - MJRefresh
-(void)MJRefresh
{
    _tableview.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        _page=1;
        [self RequestData];
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
    //    728-34
    //    364-17 347
    return [DD_DesignerCell heightWithModel:[_dataArr objectAtIndex:indexPath.section]];
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
    static NSString *cellid=@"cell_dday";
    DD_DesignerCell *cell=[_tableview dequeueReusableCellWithIdentifier:cellid];
    if(!cell)
    {
        cell=[[DD_DesignerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.followblock=followblock;
    cell.index=indexPath.section;
    cell.Designer=[_dataArr objectAtIndex:indexPath.section];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DD_DesignerModel *_model=[_dataArr objectAtIndex:indexPath.section];
    _block(@"select",_model);
}

#pragma mark - Other
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(_tableview)
    {
        [self updateDesigner];
    }
    [MobClick beginLogPageView:@"DD_DesignerViewController"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"DD_DesignerViewController"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
