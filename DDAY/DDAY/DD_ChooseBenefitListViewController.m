//
//  DD_ChooseBenefitListViewController.m
//  YCO SPACE
//
//  Created by yyj on 2016/11/7.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_ChooseBenefitListViewController.h"

#import "DD_BenefitRuleViewController.h"

#import "DD_BenefitListCell.h"
#import "DD_BenefitHeadView.h"

#import "DD_BenefitInfoModel.h"
#import "DD_ClearingModel.h"

@interface DD_ChooseBenefitListViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation DD_ChooseBenefitListViewController
{
    UITableView *_tableview;
    UIButton *_tabbar;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self SomePrepare];
    [self UIConfig];
}

-(instancetype)initWithClearingModel:(DD_ClearingModel *)clearingModel WithBlock:(void (^)(NSString *type))block
{
    self=[super init];
    if(self)
    {
        _clearingModel=clearingModel;
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
-(void)PrepareUI{
    self.navigationItem.titleView=[regular returnNavView:NSLocalizedString(@"user_benefit_title", @"") withmaxwidth:200];
}
#pragma mark - UIConfig
-(void)UIConfig
{
    [self CreateTableview];
    [self CreateTableHeadView];
    [self CreateTabBar];
}
-(void)CreateTabBar
{
    _tabbar=[UIButton getCustomTitleBtnWithAlignment:0 WithFont:18.0f WithSpacing:0 WithNormalTitle:@"不使用优惠券" WithNormalColor:_define_white_color WithSelectedTitle:nil WithSelectedColor:nil];
    [self.view addSubview:_tabbar];
    _tabbar.backgroundColor=_define_black_color;
    [_tabbar addTarget:self action:@selector(disuseBenefit) forControlEvents:UIControlEventTouchUpInside];
    [_tabbar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.mas_equalTo(0);
        make.height.mas_equalTo(ktabbarHeight);
    }];
}
-(void)CreateTableview
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
-(void)CreateTableHeadView
{
    DD_BenefitHeadView *_headView=[[DD_BenefitHeadView alloc] initWithBlock:^(NSString *type) {
        if([type isEqualToString:@"rule"])
        {
            //跳转红包规则页
            [self.navigationController pushViewController:[[DD_BenefitRuleViewController alloc] init] animated:YES];
        }
    }];
    _tableview.tableHeaderView=_headView;
}

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JXLOG(@"height=%lf",floor((ScreenWidth)*240.0f/750.0f));
    return floor((ScreenWidth)*240.0f/750.0f);
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _clearingModel.benefitInfo.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    数据还未获取时候
    if(_clearingModel.benefitInfo.count==indexPath.section)
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
    static NSString *cellid=@"cellid";
    DD_BenefitListCell *cell=[_tableview dequeueReusableCellWithIdentifier:cellid];
    if(!cell)
    {
        cell=[[DD_BenefitListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    cell.benefitInfoModel=[_clearingModel.benefitInfo objectAtIndex:indexPath.section];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DD_BenefitInfoModel *_benefitInfoModel=[_clearingModel.benefitInfo objectAtIndex:indexPath.section];
    _clearingModel.choosedBenefitId=_benefitInfoModel.benefitId;
    _block(@"choose_benefit");
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - Action
-(void)disuseBenefit
{
    _clearingModel.choosedBenefitId=nil;
    _block(@"choose_benefit");
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - Other
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
