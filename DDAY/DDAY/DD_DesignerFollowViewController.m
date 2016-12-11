//
//  DD_DesignerFollowViewController.m
//  DDAY
//
//  Created by yyj on 16/6/12.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_DesignerFollowViewController.h"

#import "DD_CustomViewController.h"

#import "MJRefresh.h"

#import "DD_DesignerCell.h"

#import "DD_DesignerModel.h"

@interface DD_DesignerFollowViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation DD_DesignerFollowViewController
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
    __block NSMutableArray *__dataArr=_dataArr;
    __block UITableView *__tableview=_tableview;
    __block DD_DesignerFollowViewController *_desginerView=self;
    __block void (^___block)(NSString *type ,DD_DesignerModel *model)=_block;
    followblock=^(NSInteger index,NSString *type)
    {
        if([type isEqualToString:@"click"])
        {
            DD_DesignerModel *_model=__dataArr[index];
            ___block(@"click",_model);
        }else
        {
            if(![DD_UserModel isLogin])
            {
                ___block(@"login",nil);
            }else
            {
                DD_DesignerModel *_model=__dataArr[index];
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
                        BOOL isFollow=[[data objectForKey:@"guanzhu"] boolValue];
                        
                        [((DD_CustomViewController *)[DD_CustomViewController sharedManager]) updateLeftDesignerListDataWithID:_model.designerId WithFollowState:isFollow];
                        
                        if([type isEqualToString:@"unfollow"])
                        {
                            [__dataArr removeObjectAtIndex:index];
                            
                        }else if([type isEqualToString:@"follow"])
                        {
                            _model.guanzhu=isFollow;
                        }
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
/**
 * 更新我关注的设计师数据
 * 因为无法保证数据的一致性  所以目前处理方式是页面出现的时候重新获取数据
 */
-(void)updateListDataWithDesignerId:(NSString *)desginerID WithFollowState:(BOOL )isFollow
{
    if(_tableview)
    {
        [self updateDesigner];
    }
}
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadNewData) name:@"rootChange" object:nil];
}
-(void)PrepareUI{}
#pragma mark - RequestData
-(void)RequestData
{
    NSDictionary *_parameters=@{@"page":[NSNumber numberWithInteger:_page],@"token":[DD_UserModel getToken]};
    [[JX_AFNetworking alloc] GET:@"designer/queryCareDesigners.do" parameters:_parameters success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
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
                if(_page==1)
                {
                    [_dataArr removeAllObjects];//删除所有数据
                    [_tableview reloadData];
                }
            }
            
        }else
        {
            [self presentViewController:successAlert animated:YES completion:nil];
        }
        [_tableview.mj_header endRefreshing];
        [_tableview.mj_footer endRefreshing];
        
    } failure:^(NSError *error, UIAlertController *failureAlert) {
        [_tableview.mj_header endRefreshing];
        [_tableview.mj_footer endRefreshing];
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
    _tableview=[[UITableView alloc] initWithFrame:CGRectMake(0, kNavHeight, ScreenWidth, ScreenHeight-ktabbarHeight-kNavHeight-(IsPhone6_gt?16:0)) style:UITableViewStylePlain];
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
    //    MJRefreshNormalHeader *header= [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    NSArray *refreshingImages=[regular getGifImg];
    
    //     Set the ordinary state of animated images
    [header setImages:refreshingImages duration:1.5 forState:MJRefreshStateIdle];
    //     Set the pulling state of animated images（Enter the status of refreshing as soon as loosen）
    [header setImages:refreshingImages duration:1.5 forState:MJRefreshStatePulling];
    //     Set the refreshing state of animated images
    [header setImages:refreshingImages duration:1.5 forState:MJRefreshStateRefreshing];
    
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    _tableview.mj_header = header;
    
    MJRefreshAutoNormalFooter *_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [_footer setTitle:@"" forState:MJRefreshStateNoMoreData];
    [_footer setTitle:@"" forState:MJRefreshStateIdle];
    [_footer setTitle:@"" forState:MJRefreshStatePulling];
    [_footer setTitle:@"" forState:MJRefreshStateRefreshing];
    [_footer setTitle:@"" forState:MJRefreshStateWillRefresh];
    _footer.refreshingTitleHidden = YES;
    _footer.stateLabel.textColor = _define_light_gray_color1;
    _tableview.mj_footer = _footer;
    
    [_tableview.mj_header beginRefreshing];
}
-(void)loadNewData
{
    // 进入刷新状态后会自动调用这个block
    _page=1;
    [self RequestData];
}
-(void)loadMoreData
{
    // 进入刷新状态后会自动调用这个block
    _page+=1;
    [self RequestData];
}
#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [DD_DesignerCell heightWithModel:_dataArr[indexPath.section]];
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
    cell.Designer=_dataArr[indexPath.section];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DD_DesignerModel *_model=_dataArr[indexPath.section];
    _block(@"select",_model);
}

#pragma mark - Other

/**
 * 重新进入页面刷新
 */
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(_tableview)
    {
        [self updateDesigner];
    }
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
