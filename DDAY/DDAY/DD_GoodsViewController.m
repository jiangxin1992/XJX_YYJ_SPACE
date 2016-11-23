//
//  DD_GoodsViewController.m
//  DDAY
//
//  Created by yyj on 16/5/20.
//  Copyright © 2016年 YYJ. All rights reserved.
//
#import "DD_GoodsDetailViewController.h"

#import "DD_GoodsViewController.h"
#import "DD_ShopViewController.h"
#import "DD_BenefitDetailViewController.h"

#import "Waterflow.h"
#import "WaterflowCell.h"
#import "DD_GoodsListView.h"
#import "DD_GoodsListTableView.h"
#import "DD_headViewBenefitView.h"

#import "DD_ItemTool.h"
#import "DD_ItemsModel.h"
#import "DD_GoodsCategoryModel.h"
#import "DD_ImageModel.h"
#import "DD_BenefitInfoModel.h"

@interface DD_GoodsViewController ()<WaterflowDataSource,WaterflowDelegate>

@end

@implementation DD_GoodsViewController
{
    Waterflow *mywaterflow;
    NSMutableArray *_dataArr;
    DD_BenefitInfoModel *_benefitInfoModel;
    NSInteger _page;
    BOOL _isReadBenefit;
    DD_headViewBenefitView *_headView;
    
    NSString *_categoryOneName;
    NSString *_categoryTwoName;
    NSString *_categoryID;
    
    DD_GoodsListTableView *listTableView;
    NSMutableArray *_categoryArr;
    
    CGFloat _benefitHeight;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self SomePrepare];
    [self UIConfig];
    
    [regular SigninAction];
}

#pragma mark - SomePrepare
-(void)setNoTabbar:(BOOL)noTabbar
{
    _noTabbar=noTabbar;
}
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
    _categoryArr=[[NSMutableArray alloc] init];
    _categoryOneName=@"";
    _categoryTwoName=@"";
    _categoryID=@"";
    _isReadBenefit=NO;
    _benefitHeight=0;
}
-(void)PrepareUI
{
    self.navigationItem.titleView=[regular returnNavView:NSLocalizedString(@"goods_title", @"") withmaxwidth:200];
    
    DD_NavBtn *shopBtn=[DD_NavBtn getShopBtn];
    [shopBtn addTarget:self action:@selector(PushShopView) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:shopBtn];
    
    DD_NavBtn *listBtn=[DD_NavBtn getNavBtnIsLeft:YES WithSize:CGSizeMake(25, 17) WithImgeStr:@"Item_list"];
    [listBtn addTarget:self action:@selector(ChooseCategoryAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:listBtn];
    
    //
    //    titleView=[[DD_GoodsListView alloc] initWithFrame:CGRectMake(0, 0, 170, 40)];
    //    [titleView setImage:[UIImage imageNamed:@"System_Triangle"] forState:UIControlStateNormal];
    //
    //    [titleView setImage:[UIImage imageNamed:@"System_UpTriangle"] forState:UIControlStateSelected];
    //    [titleView setTitle:@"类别" forState:UIControlStateNormal];
    //    titleView.titleLabel.font=[regular getSemiboldFont:17.0f];
    //    [titleView addTarget:self action:@selector(ChooseCategoryAction:) forControlEvents:UIControlEventTouchUpInside];
    //    self.navigationItem.titleView=titleView;
    
    if(_noTabbar)
    {
        DD_NavBtn *backBtn=[DD_NavBtn getBackBtn];
        [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchDown];
        self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:backBtn];
    }
}
-(void)ChooseCategoryAction:(UIButton *)btn
{
    if(btn.selected)
    {
        btn.selected=NO;
        [UIView animateWithDuration:0.5 animations:^{
            listTableView.frame=CGRectMake(0, -(ScreenHeight-ktabbarHeight-kNavHeight), ScreenWidth, ScreenHeight-ktabbarHeight-kNavHeight);
        } completion:^(BOOL finished) {
            [self listTableViewHide];
        }];
        
    }else
    {
        btn.selected=YES;
        listTableView=[[DD_GoodsListTableView alloc] initWithFrame:CGRectMake(0, -(ScreenHeight-ktabbarHeight-kNavHeight), ScreenWidth, ScreenHeight-ktabbarHeight-kNavHeight) style:UITableViewStylePlain WithBlock:^(NSString *type,NSString *categoryOneName,NSString *categoryTwoName,NSString *categoryID) {
            
            btn.selected=NO;
            if([type isEqualToString:@"click"])
            {
                if(![categoryID isEqualToString:@""])
                {
                    self.navigationItem.titleView=[regular returnNavView:categoryTwoName withmaxwidth:200];
                }else
                {
                    self.navigationItem.titleView=[regular returnNavView:categoryOneName withmaxwidth:200];
                }
            }else if([type isEqualToString:@"all"])
            {
                self.navigationItem.titleView=[regular returnNavView:NSLocalizedString(@"goods_title", @"") withmaxwidth:200];
                
            }
            _categoryOneName=categoryOneName;
            _categoryTwoName=categoryTwoName;
            _categoryID=categoryID;
            [mywaterflow.mj_header beginRefreshing];
            [self listTableViewHide];
            
        }];
        [self.view addSubview:listTableView];
        [UIView animateWithDuration:0.5 animations:^{
            listTableView.frame=CGRectMake(0, kNavHeight, ScreenWidth, ScreenHeight-ktabbarHeight-kNavHeight);
        }];
        [self RequestListData];
    }
}
-(void)listTableViewHide
{
    [listTableView removeFromSuperview];
    listTableView=nil;
    [_categoryArr removeAllObjects];
}
#pragma mark - RequestData
-(void)RequestData
{
    
    NSMutableDictionary *_parameters=[[NSMutableDictionary alloc] initWithDictionary:@{@"page":[NSNumber numberWithInteger:_page],@"token":[DD_UserModel getToken]}];
    if(![_categoryOneName isEqualToString:@""])
    {
        if([_categoryID isEqualToString:@""])
        {
            [_parameters setObject:_categoryOneName forKey:@"catOneName"];
        }else
        {
            [_parameters setObject:_categoryOneName forKey:@"catOneName"];
            [_parameters setObject:_categoryTwoName forKey:@"catTwoName"];
        }
    }
    [[JX_AFNetworking alloc] GET:@"item/v1_0_7/queryColorItemsByCategory.do" parameters:_parameters success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
        if(success)
        {
            NSArray *modelArr=[DD_ItemsModel getItemsModelArr:[data objectForKey:@"items"]];
            
            if(modelArr.count)
            {
                if(_page==1)
                {
                    [_dataArr removeAllObjects];//删除所有数据
                    
                    _benefitInfoModel=[DD_BenefitInfoModel getBenefitInfoModel:[data objectForKey:@"benefitInfo"]];
                    
                    if(_benefitInfoModel)
                    {
                        _benefitHeight=floor(([_benefitInfoModel.picInfo.height floatValue]/[_benefitInfoModel.picInfo.width floatValue])*ScreenWidth);
                    }else
                    {
                        _benefitHeight=0;
                    }
                    
                    JXLOG(@"_benefitHeight=%lf",_benefitHeight);
                    
                    [self updateHeadViewState];
                    
                }
                [_dataArr addObjectsFromArray:modelArr];
                [mywaterflow reloadData];
            }else
            {
                if(_page==1)
                {
                    [_dataArr removeAllObjects];//删除所有数据
                    [mywaterflow reloadData];
                }
            }
        }else
        {
            [self presentViewController:successAlert animated:YES completion:nil];
        }
        [mywaterflow.mj_header endRefreshing];
        [mywaterflow.mj_footer endRefreshing];
        
    } failure:^(NSError *error, UIAlertController *failureAlert) {
        [mywaterflow.mj_header endRefreshing];
        [mywaterflow.mj_footer endRefreshing];
        [self presentViewController:failureAlert animated:YES completion:nil];
    }];
}
-(void)RequestListData
{
    [[JX_AFNetworking alloc] GET:@"item/querySearchCategory.do" parameters:@{@"token":[DD_UserModel getToken]} success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
        if(success)
        {
            [_categoryArr addObjectsFromArray:[DD_GoodsCategoryModel getGoodsCategoryModelArr:[data objectForKey:@"category"]]];
            JXLOG(@"_categoryModel=%@",_categoryArr);
            if(listTableView&&_categoryArr.count)
            {
                listTableView.categoryArr=_categoryArr;
            }
        }else
        {
            [self presentViewController:successAlert animated:YES completion:nil];
        }
    } failure:^(NSError *error, UIAlertController *failureAlert) {
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
    
    if(_noTabbar)
    {
        mywaterflow.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight+ktabbarHeight);
    }else
    {
        
        mywaterflow.frame = CGRectMake(0, 0, ScreenWidth, IsPhone6_gt?(ScreenHeight-16):ScreenHeight);
    }
    
    mywaterflow.dataSource = self;
    
    mywaterflow.delegate = self;
    
    //    mywaterflow.showsVerticalScrollIndicator=NO;
    
    [self.view addSubview:mywaterflow];
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
    mywaterflow.mj_header = header;
    
    MJRefreshAutoNormalFooter *_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [_footer setTitle:@"" forState:MJRefreshStateNoMoreData];
    [_footer setTitle:@"" forState:MJRefreshStateIdle];
    [_footer setTitle:@"" forState:MJRefreshStatePulling];
    [_footer setTitle:@"" forState:MJRefreshStateRefreshing];
    [_footer setTitle:@"" forState:MJRefreshStateWillRefresh];
    _footer.refreshingTitleHidden = YES;
    _footer.stateLabel.textColor = _define_light_gray_color1;
    mywaterflow.mj_footer = _footer;
    
    [mywaterflow.mj_header beginRefreshing];
}
#pragma mark - SomeAction
-(void)reload
{
    if(mywaterflow)
    {
        if(_benefitInfoModel&&![DD_UserModel isLogin])
        {
            [self unLoginAction];
            [mywaterflow reloadData];
        }
    }
}

-(void)updateHeadViewState
{
    if(_benefitInfoModel)
    {
//        if([DD_UserModel isLogin])
//        {
//            _isReadBenefit=_benefitInfoModel.isReadBenefit;
//            //登陆
//            //                            mywaterflow
//            if(_benefitInfoModel.isReadBenefit)
//            {
//                //隐藏headview
//                [_headView removeFromSuperview];
//                _headView=nil;
//            }else
//            {
//                if(!_headView)
//                {
//                    //显示headview
//                    _headView=[[DD_headViewBenefitView alloc] initWithModel:_benefitInfoModel WithBlock:^(NSString *type) {
//                        if([type isEqualToString:@"close"])
//                        {
//                            //关闭
//                            [[JX_AFNetworking alloc] GET:@"user/readBenefit.do" parameters:@{@"token":[DD_UserModel getToken]} success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
//                                if(success)
//                                {
//                                    _benefitInfoModel.isReadBenefit=YES;
//                                    _isReadBenefit=YES;
//                                    [_headView removeFromSuperview];
//                                    _headView=nil;
//                                    [mywaterflow reloadData];
//                                }else
//                                {
//                                    [self presentViewController:successAlert animated:YES completion:nil];
//                                }
//                            } failure:^(NSError *error, UIAlertController *failureAlert) {
//                                [self presentViewController:failureAlert animated:YES completion:nil];
//                            }];
//                            
//                            
//                        }else if([type isEqualToString:@"enter"])
//                        {
//                            [self.navigationController pushViewController:[[DD_BenefitDetailViewController alloc] initWithBenefitInfoModel:_benefitInfoModel WithBlock:^(NSString *type) {
//                            }] animated:YES];
//                        }
//                    }];
//                    [mywaterflow addSubview:_headView];
//                }else
//                {
//                    _headView.benefitInfoModel=_benefitInfoModel;
//                }
//            }
//            [mywaterflow reloadData];
//        }else
//        {
            [self unLoginAction];
//        }
    }else
    {
        _isReadBenefit=YES;
        [_headView removeFromSuperview];
        _headView=nil;
        [mywaterflow reloadData];
    }
}
-(void)unLoginAction
{
    if([DD_UserModel isLogin])
    {
        //隐藏headview
        _isReadBenefit=YES;
        [_headView removeFromSuperview];
        _headView=nil;
        [mywaterflow reloadData];

    }else
    {
        //未登陆
        _isReadBenefit=[DD_UserModel isReadWithBenefitID:_benefitInfoModel.benefitId];
        if([DD_UserModel isReadWithBenefitID:_benefitInfoModel.benefitId])
        {
            //隐藏headview
            [_headView removeFromSuperview];
            _headView=nil;
            [mywaterflow reloadData];
        }else
        {
            if(!_headView)
            {
                //显示headview
                _headView=[[DD_headViewBenefitView alloc] initWithModel:_benefitInfoModel WithBlock:^(NSString *type) {
                    if([type isEqualToString:@"close"])
                    {
                        //关闭
                        _benefitInfoModel.localRead=YES;
                        [DD_UserModel setReadBenefit:YES WithBenefitInfoModel:_benefitInfoModel];
                        _isReadBenefit=[DD_UserModel isReadWithBenefitID:_benefitInfoModel.benefitId];
                        [_headView removeFromSuperview];
                        _headView=nil;
                        [mywaterflow reloadData];
                        
                    }else if([type isEqualToString:@"enter"])
                    {
                        [self.navigationController pushViewController:[[DD_BenefitDetailViewController alloc] initWithBenefitInfoModel:_benefitInfoModel WithBlock:^(NSString *type) {
                        }] animated:YES];
                    }
                }];
                [mywaterflow addSubview:_headView];
            }else
            {
                _headView.benefitInfoModel=_benefitInfoModel;
            }
            [mywaterflow reloadData];
        }
    }
    
}
-(void)loadNewData
{
    _page=1;
    [self RequestData];
}
-(void)loadMoreData
{
    _page+=1;
    [self RequestData];
}
/**
 * 返回
 */
-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
//跳转购物车
-(void)PushShopView
{
    if(![DD_UserModel isLogin])
    {
        [self presentViewController:[regular alertTitleCancel_Simple:NSLocalizedString(@"login_first", @"") WithBlock:^{
            [self pushLoginView];
        }] animated:YES completion:nil];
    }else
    {
        DD_ShopViewController *_shop=[[DD_ShopViewController alloc] init];
        [self.navigationController pushViewController:_shop animated:YES];
    }
}

#pragma mark - UITableViewDelegate
// cell的个数，必须实现
- (NSUInteger)numberOfCellsInWaterflow:(Waterflow *)waterflow{
    
    return _dataArr.count+1;
}
// 返回cell，必须实现
- (WaterflowCell *)waterflow:(Waterflow *)waterflow cellAtIndex:(NSUInteger)index{
    
    if(index)
    {
        DD_ItemsModel *item=_dataArr[index-1];
        DD_ImageModel *imgModel=item.pics[0];
        CGFloat _height=((ScreenWidth-water_margin*2-water_Spacing)/2)*([imgModel.height floatValue]/[imgModel.width floatValue]);
        return [DD_ItemTool getCustomWaterflowCell:waterflow cellAtIndex:index-1 WithItemsModel:item WithHeight:_height];
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
        DD_ItemsModel *item=_dataArr[index-1];
        if(item.pics)
        {
            
            DD_ImageModel *imgModel=item.pics[0];
            CGFloat _height=((ScreenWidth-water_margin*2-water_Spacing)/2)*([imgModel.height floatValue]/[imgModel.width floatValue]);
            return _height+56+water_Top;
        }
        return 56+water_Top;
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
//        case WaterflowMarginTypeColumn:return water_Bottom;
        case WaterflowMarginTypeColumn:return 0;
        case WaterflowMarginTypeBottom:return water_Bottom;
        case WaterflowMarginTypeTop:return _isReadBenefit?0:_benefitHeight;
        default:return 0;
    }
}
// 非必要
- (void)waterflow:(Waterflow *)waterflow didSelectCellAtIndex:(NSUInteger)index{
    if(index)
    {
        DD_ItemsModel *_model=_dataArr[index-1];
        DD_GoodsDetailViewController *_GoodsDetail=[[DD_GoodsDetailViewController alloc] initWithModel:_model WithBlock:^(DD_ItemsModel *model, NSString *type) {
            //        if(type)
        }];
        [self.navigationController pushViewController:_GoodsDetail animated:YES];
    }
}

#pragma mark - Other
-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    if(_noTabbar)
    {
        [[DD_CustomViewController sharedManager] tabbarHide];
    }else
    {
        [[DD_CustomViewController sharedManager] tabbarAppear];
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
