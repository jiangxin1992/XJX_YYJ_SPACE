//
//  DD_CircleChooseDetailView.m
//  DDAY
//
//  Created by yyj on 16/6/20.
//  Copyright © 2016年 YYJ. All rights reserved.
//
#import "DD_ItemsModel.h"
#import "DD_CricleChooseItemModel.h"
#import "DD_CricleCategoryModel.h"
#import "DD_GoodsDetailViewController.h"
#import "DD_CircleChooseDetailView.h"

#import "Waterflow.h"
#import "WaterflowCell.h"
#import "DD_CirclePublishTool.h"
#import "DD_CircleSearchView.h"
//#import "DD_CricleChooseCell.h"
//#import "UIButton+WebCache.h"

@interface DD_CircleChooseDetailView ()<WaterflowDataSource,WaterflowDelegate>

@end

@implementation DD_CircleChooseDetailView
{
    UIView *_upView;//上部view
    UIView *_downView;//下部view
    Waterflow *mywaterflow;
    UIScrollView *_scrollView;
    
    CGFloat _width;//已选款式view宽度
    CGFloat intes;
    long _page;//当前页
    NSString *queryStr;//关键词
    NSMutableArray *btnArr;//存放的按钮数组
    NSMutableArray *_dataArr;//当前款式列表数据
    
    UIButton *searchBtn;
    DD_CircleSearchView *_searchView;

//    void (^cellblock)(NSString *type,NSInteger index);//cell回调block
    //    NSString *categoryCode;//当前选择分类code
    //    UILabel *_numLabel;//剩余可选款数
    //    UIButton *_screeningBtn;//选择分类按钮
    //    UITableView *_tableView;//选择款式tableview
    //    UITableView *_chooseTableView;//下拉框
    //    BOOL _isShow;// 当前下拉框是否显示
    //    NSMutableArray *_categoryArr;//下拉框数据
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self SomePrepare];
    [self UIConfig];
}
#pragma mark - 初始化
-(instancetype)initWithCircleModel:(DD_CircleModel *)CircleModel WithLimitNum:(NSInteger )num WithBlock:(void (^)(NSString *type,NSInteger index))block
{
    self=[super init];
    if(self)
    {
        _circleModel=CircleModel;
        _block=block;
        _num=num;
    }
    return self;
}
#pragma mark - SomePrepare
-(void)SomePrepare
{
    [self PrepareData];
    [self PrepareUI];
//    [self SomeBlock];
}

-(void)PrepareData
{
    btnArr=[[NSMutableArray alloc] init];
    _dataArr=[[NSMutableArray alloc] init];
    _page=1;
    queryStr=@"";
    intes=12;//间距为12
    _width=(ScreenWidth-intes*2-kEdge*2)/3.0f;
    //    _categoryArr=[[NSMutableArray alloc] init];
    //    _isShow=NO;
    //    categoryCode=@"";
}
-(void)PrepareUI
{
    self.navigationItem.titleView=[regular returnNavView:@"款式选择" withmaxwidth:200];
}

#pragma mark - UIConfig
-(void)UIConfig
{
    [self CreateUpView];
    [self CreateDownView];
}
-(void)CreateUpView
{
    [self initUpView];
    [self CreateSearchBar];
    [self CreateImgView];
}
-(void)initUpView
{
    _upView=[UIView getCustomViewWithColor:nil];
    [self.view addSubview:_upView];
    [_upView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(ScreenWidth);
        make.top.mas_equalTo(64);
    }];
}
-(void)CreateSearchBar
{
    UIView *searchView=[UIView getCustomViewWithColor:nil];
    [_upView addSubview:searchView];
    [searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(43);
    }];
//    31 22
    searchBtn=[UIButton getCustomTitleBtnWithAlignment:1 WithFont:12.0f WithSpacing:0 WithNormalTitle:[queryStr isEqualToString:@""]?@"搜索款式、设计师、品牌":queryStr WithNormalColor:_define_light_gray_color1 WithSelectedTitle:nil WithSelectedColor:nil];
    [searchView addSubview:searchBtn];
    [searchBtn setImage:[UIImage imageNamed:@"System_Nosearch"] forState:UIControlStateNormal];
    [searchBtn setImageEdgeInsets:UIEdgeInsetsMake((43-22)/2.0f, 16, (43-22)/2.0f, ScreenWidth-31-16-kEdge)];
    [searchBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [searchBtn addTarget:self action:@selector(ShowSearchView) forControlEvents:UIControlEventTouchUpInside];
    [searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.mas_equalTo(0);
        make.right.mas_equalTo(-kEdge);
    }];
    
    
}
-(void)UpdateImgView
{
    for (UIButton *btn in btnArr) {
        [btn removeFromSuperview];
    }
    [self CreateImgView];
//    _numLabel.text=[[NSString alloc] initWithFormat:@"还可选择%ld款",_num-_circleModel.chooseItem.count];
}
-(void)CreateImgView
{
    
    if(_circleModel.chooseItem.count)
    {
        [_upView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(_width+43);
        }];
        _scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(kEdge, 43, ScreenWidth-kEdge*2, _width)];
        [_upView addSubview:_scrollView];
        _scrollView.showsHorizontalScrollIndicator=NO;
        _scrollView.contentSize=CGSizeMake((_circleModel.chooseItem.count-1)*intes+_width*_circleModel.chooseItem.count, _width);
        
        CGFloat _x_p=0;
        for (int i=0; i<_circleModel.chooseItem.count; i++) {
            DD_CricleChooseItemModel *item=[_circleModel.chooseItem objectAtIndex:i];
            
            UIView *backView=[UIView getCustomViewWithColor:nil];
            [_scrollView addSubview:backView];
            backView.frame=CGRectMake(_x_p, 0, _width, _width);
            
            UIImageView *imgView=[UIImageView getCustomImg];
            [backView addSubview:imgView];
            imgView.userInteractionEnabled=YES;
            imgView.frame=CGRectMake(0, 16, _width-16, _width-16);
            [imgView JX_loadImageUrlStr:item.pic.pic WithSize:400 placeHolderImageName:nil radius:0];
            
            UILabel *priceLabel=[UILabel getLabelWithAlignment:0 WithTitle:[[NSString alloc] initWithFormat:@"￥%@",item.price] WithFont:12.0f WithTextColor:_define_white_color WithSpacing:0];
            [imgView addSubview:priceLabel];
            priceLabel.backgroundColor=_define_black_color;
            [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.bottom.mas_equalTo(0);
            }];
            [priceLabel sizeToFit];
            
            
            UIButton *deleteBtn=[UIButton getCustomImgBtnWithImageStr:@"System_Delete" WithSelectedImageStr:nil];
            [backView addSubview:deleteBtn];
            deleteBtn.tag=150+i;
            [deleteBtn addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
            [deleteBtn setEnlargeEdge:10];
            deleteBtn.frame=CGRectMake(CGRectGetWidth(backView.frame)-25-3.5, 3.5, 25, 25);
            
            _x_p+=_width+intes;
            
            [btnArr addObject:backView];
        }
    }else
    {
        [_upView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(43);
        }];
    }
}

-(void)CreateDownView
{
    [self initDownView];
    [self CreateWaterFlow];
    [self MJRefresh];
}
-(void)initDownView
{
    _downView=[[UIView alloc] init];
    [self.view addSubview:_downView];
    [_downView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(ScreenWidth);
        make.top.mas_equalTo(_upView.mas_bottom).with.offset(20);
        make.bottom.mas_equalTo(0);
    }];
    
}
-(void)CreateWaterFlow
{
    mywaterflow = [[Waterflow alloc] init];
    [_downView addSubview:mywaterflow];
    mywaterflow.dataSource = self;
    
    mywaterflow.delegate = self;
    
    [mywaterflow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(_downView);
    }];
  
}

#pragma mark - RequestData
-(void)RequestData
{

    NSDictionary *_parameters=@{@"itemName":queryStr,@"page":[NSNumber numberWithLong:_page],@"token":[DD_UserModel getToken]};
    [[JX_AFNetworking alloc] GET:@"item/queryColorItemsByParam.do" parameters:_parameters success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
        if(success)
        {
            if(_page==1)
            {
                [_dataArr removeAllObjects];//删除所有数据
            }
            NSArray *getarr=[DD_CricleChooseItemModel getItemsModelArr:[data objectForKey:@"items"] WithDetail:_circleModel.chooseItem];
            [_dataArr addObjectsFromArray:getarr];
            [mywaterflow reloadData];
        }else
        {
            if(_page==1)
            {
                [_dataArr removeAllObjects];//删除所有数据
            }
            [mywaterflow reloadData];
            [self presentViewController:successAlert animated:YES completion:nil];
        }
        [mywaterflow.header endRefreshing];
        [mywaterflow.footer endRefreshing];
    } failure:^(NSError *error, UIAlertController *failureAlert) {
        [self presentViewController:failureAlert animated:YES completion:nil];
        [mywaterflow.header endRefreshing];
        [mywaterflow.footer endRefreshing];
    }];
}
#pragma mark - WaterflowDelegate
// cell的个数，必须实现
- (NSUInteger)numberOfCellsInWaterflow:(Waterflow *)waterflow{
    
    return _dataArr.count;
}
// 返回cell，必须实现
- (WaterflowCell *)waterflow:(Waterflow *)waterflow cellAtIndex:(NSUInteger)index{
    
    DD_CricleChooseItemModel *item=[_dataArr objectAtIndex:index];
    CGFloat _height=((ScreenWidth-kEdge*2-8-12*2-11*4)/2)*([item.pic.height floatValue]/[item.pic.width floatValue]);
    return [[DD_CirclePublishTool alloc] getCustomWaterflowCell:waterflow cellAtIndex:index WithItemsModel:item WithHeight:_height+22 WithBlock:^(NSString *type,NSInteger index) {
        DD_CricleChooseItemModel *_itemModel=[_dataArr objectAtIndex:index];
        if(!_itemModel.isSelect)
        {
            _itemModel.isSelect=YES;
            if(_circleModel.chooseItem.count<_num)
            {
                [_circleModel.chooseItem addObject:[_dataArr objectAtIndex:index]];
                //                _numLabel.text=[[NSString alloc] initWithFormat:@"还可选择%ld款",___num-___chooseItem.count];
            }else
            {
                [self presentViewController:[regular alertTitle_Simple:[[NSString alloc] initWithFormat:@"最多可选择%ld款",_num]] animated:YES completion:nil];
            }
            [self UpdateImgView];
        }else
        {
            _itemModel.isSelect=NO;
            _block(@"delete_choose_item",index);
            [self UpdateImgView];
        }
        [waterflow reloadData];
    }];
}
// 这个方法可选不是必要的，默认是3列
- (NSUInteger)numberOfColumnsInWaterflow:(Waterflow *)waterflow{
    return 2;
}
// 返回每一个cell的高度，非必要，默认为80
- (CGFloat)waterflow:(Waterflow *)waterflow heightAtIndex:(NSUInteger)index{
    DD_CricleChooseItemModel *item=[_dataArr objectAtIndex:index];
    CGFloat _height=((ScreenWidth-kEdge*2-8-12*2-11*4)/2)*([item.pic.height floatValue]/[item.pic.width floatValue]);
    return _height+30+12+11*2;
}
// 间隔，非必要，默认均为10
- (CGFloat)waterflow:(Waterflow *)waterflow marginOfWaterflowMarginType:(WaterflowMarginType)type{
    switch (type) {
//        case WaterflowMarginTypeTop:return kEdge;
//        case WaterflowMarginTypeBottom:return kEdge;
        case WaterflowMarginTypeLeft:return 14;
        case WaterflowMarginTypeRight:return 14;
        case WaterflowMarginTypeRow:return 8;
//        case WaterflowMarginTypeColumn:return 0;
            
        default:return 0;
    }
}
// 非必要
- (void)waterflow:(Waterflow *)waterflow didSelectCellAtIndex:(NSUInteger)index{
    
    DD_CricleChooseItemModel *_itemModel=[_dataArr objectAtIndex:index];
    if(!_itemModel.isSelect)
    {
        
        if(_circleModel.chooseItem.count<_num)
        {
            _itemModel.isSelect=YES;
            [_circleModel.chooseItem addObject:[_dataArr objectAtIndex:index]];
            //                _numLabel.text=[[NSString alloc] initWithFormat:@"还可选择%ld款",___num-___chooseItem.count];
        }else
        {
            [self presentViewController:[regular alertTitle_Simple:[[NSString alloc] initWithFormat:@"最多可选择%ld款",_num]] animated:YES completion:nil];
        }
        [self UpdateImgView];
    }else
    {
        _block(@"delete_choose_item",index);
        [self UpdateImgView];
    }
    [waterflow reloadData];
    
//    DD_CricleChooseItemModel *_itemModel=[_dataArr objectAtIndex:index];
////     跳转商品详情
//    DD_ItemsModel *_item=[[DD_ItemsModel alloc] init];
//    _item.g_id=_itemModel.g_id;
//    _item.colorId=_itemModel.colorId;
//    _item.colorCode=_itemModel.colorCode;
//    DD_GoodsDetailViewController *_GoodsDetail=[[DD_GoodsDetailViewController alloc] initWithModel:_item WithBlock:^(DD_ItemsModel *model, NSString *type) {
//        //        if(type)
//    }];
//    [self.navigationController pushViewController:_GoodsDetail animated:YES];  

}
#pragma mark - SomeAction
-(void)ShowSearchView
{
    _searchView=[[DD_CircleSearchView alloc] initWithQueryStr:queryStr WithChooseItem:_circleModel.chooseItem WithBlock:^(NSString *type, NSString *_queryStr) {
        if([type isEqualToString:@"back"])
        {
            [_searchView removeFromSuperview];
        }else if([type isEqualToString:@"search"])
        {
            queryStr=_queryStr;
            [searchBtn setTitle:queryStr forState:UIControlStateNormal];
            [mywaterflow.header beginRefreshing];
            [_searchView removeFromSuperview];
        }
        [self.navigationController setNavigationBarHidden:NO animated:NO];
    }];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self.view addSubview:_searchView];
}
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
/**
 * 删除已选款式
 */
-(void)deleteAction:(UIButton *)btn
{
    _block(@"delete_choose_item",btn.tag-150);
    [self UpdateImgView];
    [mywaterflow reloadData];
}

#pragma mark - Others
-(void)viewWillDisappear:(BOOL)animated
{
    _block(@"choose_item",0);
    [super viewWillDisappear:animated];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 弃用代码
//-(void)initDownView
//{
//    _downView=[[UIView alloc] init];
//    [self.view addSubview:_downView];
//    _downView.backgroundColor=[UIColor yellowColor];
//    [_downView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(0);
//        make.width.mas_equalTo(ScreenWidth);
//        make.top.mas_equalTo(_upView.mas_bottom).with.offset(0);
//        make.bottom.mas_equalTo(self.view).with.mas_equalTo(0);
//    }];
//    
//    _screeningBtn=[UIButton buttonWithType:UIButtonTypeCustom];
//    [_downView addSubview:_screeningBtn];
//    [_screeningBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    if([categoryCode isEqualToString:@""])
//    {
//        [_screeningBtn setTitle:@"所有的" forState:UIControlStateNormal];
//    }
//    [_screeningBtn addTarget:self action:@selector(screenAction) forControlEvents:UIControlEventTouchUpInside];
//    _screeningBtn.titleLabel.font=[regular getFont:13.0f];
//    [_screeningBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.and.top.mas_equalTo(0);
//        make.height.mas_equalTo(@30);
//        make.width.mas_equalTo(@100);
//    }];
//}
//-(void)CreateImgView
//{
//    
    //    NSInteger _count=_circleModel.chooseItem.count;
    //    CGFloat _h=0;
    //    if(_circleModel.chooseItem.count)
    //    {
    //        _h=(_width+10)*(((_count-1)/3)+1)+20;
    //    }else
    //    {
    //        _h=40;
    //    }
    //    [_upView mas_updateConstraints:^(MASConstraintMaker *make) {
    //        make.height.mas_equalTo(_h);
    //    }];
    //
    //    // 创建一个空view 代表上一个view
    //    __block UIView *lastView = nil;
    //    // 每行3个
    //    int num = 3;
    //    // 循环创建view
    //
    //    for (int i = 0; i < _circleModel.chooseItem.count; i++) {
    //        DD_CricleChooseItemModel *item=[_circleModel.chooseItem objectAtIndex:i];
    //        UIView *backView = [UIView getCustomViewWithColor:nil];
    //        [_upView addSubview:backView];
    //
    //        // 添加约束
    //        [backView mas_makeConstraints:^(MASConstraintMaker *make) {
    //            // 给个高度约束
    //            make.height.and.width.mas_equalTo(_width);
    //            // 2. 判断是否是第一列
    //            if (i % num == 0) {
    //                // 一：是第一列时 添加左侧与父视图左侧约束
    //                make.left.mas_equalTo(backView.superview).offset(kEdge);
    //            } else {
    //                // 二： 不是第一列时 添加左侧与上个view左侧约束
    //                make.left.mas_equalTo(lastView.mas_right).offset(intes);
    //            }
    //            // 4. 判断是否为第一列
    //            if (i / num == 0) {
    //                // 第一列添加顶部约束
    //                make.top.mas_equalTo(backView.superview).offset(20);
    //            } else {
    //                // 其余添加顶部约束 intes*10 是我留出的距顶部高度
    //                make.top.mas_equalTo(20+( i / num )* (_width + intes));
    //            }
    //        }];
    //
    //        UIImageView *imgView = [UIImageView getCustomImg];
    //        [backView addSubview:imgView];
    //        [imgView JX_loadImageUrlStr:item.pic.pic WithSize:400 placeHolderImageName:nil radius:0];
    //        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
    //            make.left.mas_equalTo(0);
    //            make.top.mas_equalTo(16);
    //            make.width.height.mas_equalTo(_width-16);
    //        }];
    //
    //        UIButton *deleteBtn=[UIButton getCustomImgBtnWithImageStr:@"System_Delete" WithSelectedImageStr:nil];
    //        [backView addSubview:deleteBtn];
    //        deleteBtn.tag=150+i;
    //        [deleteBtn addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
    //        [deleteBtn setEnlargeEdge:10];
    //        [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    //            make.top.mas_equalTo(3.5);
    //            make.right.mas_equalTo(-3.5);
    //            make.width.height.mas_equalTo(25);
    //        }];
    //        // 每次循环结束 此次的View为下次约束的基准
    //        lastView = backView;
    //        [btnArr addObject:backView];
    //    }
    
//}
//-(void)initUpView
//{
//    _upView=[UIView getCustomViewWithColor:nil];
//    _upView.backgroundColor=[UIColor redColor];
//    [self.view addSubview:_upView];
//    [_upView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(0);
//        make.width.mas_equalTo(ScreenWidth);
//        make.top.mas_equalTo(64);
//    }];
//
    //    UILabel *leftlabel=[UILabel getLabelWithAlignment:0 WithTitle:@"已选款式" WithFont:12.0f WithTextColor:nil WithSpacing:0];
    //    [_upView addSubview:leftlabel];
    //    [leftlabel mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.mas_equalTo(0);
    //        make.left.mas_equalTo(kEdge);
    //        make.width.mas_equalTo(@150);
    //        make.height.mas_equalTo(@20);
    //    }];
    //
    //    _numLabel=[UILabel getLabelWithAlignment:2 WithTitle:[[NSString alloc] initWithFormat:@"还可选择%ld款",_num-_circleModel.chooseItem.count] WithFont:12.0f WithTextColor:nil WithSpacing:0];
    //    [_upView addSubview:_numLabel];
    //
    //    [_numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.mas_equalTo(0);
    //        make.right.mas_equalTo(-kEdge);
    //        make.width.mas_equalTo(leftlabel);
    //        make.height.mas_equalTo(leftlabel);
    //    }];
//}
//-(void)CreateChooseTableView
//{
//    _isShow=YES;
//    _chooseTableView=[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
//    [_downView addSubview:_chooseTableView];
//    //    消除分割线
//    _tableView.backgroundColor=_define_backview_color;
//    _chooseTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
//    _chooseTableView.delegate=self;
//    _chooseTableView.dataSource=self;
//    
//    [_chooseTableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.offset(0);
//        if((_categoryArr.count)*32<200)
//        {
//            make.height.mas_equalTo(@((_categoryArr.count)*32));
//        }else
//        {
//            make.height.mas_equalTo(@200);
//        }
//        make.width.mas_equalTo(_screeningBtn);
//        make.right.mas_equalTo(0);
//    }];
//    
//}
/**
 * 选择款式
 */
//-(void)screenAction
//{
//    if(_isShow)
//    {
//        [_chooseTableView removeFromSuperview];
//        [_categoryArr removeAllObjects];
//        _page=1;
//        _isShow=NO;
//    }else
//    {
//        [[JX_AFNetworking alloc] GET:@"share/queryCategory.do" parameters:@{@"token":[DD_UserModel getToken]} success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
//            if(success)
//            {
//                [_categoryArr addObjectsFromArray:[DD_CricleCategoryModel getCricleCategoryModelArr:[data objectForKey:@"category"]]];
//                DD_CricleCategoryModel *_categoryModel=[DD_CricleCategoryModel getInitModel];
//                [_categoryArr insertObject:_categoryModel atIndex:0];
//                [self CreateChooseTableView];
//            }else
//            {
//                [self presentViewController:successAlert animated:YES completion:nil];
//            }
//        } failure:^(NSError *error, UIAlertController *failureAlert) {
//            [self presentViewController:failureAlert animated:YES completion:nil];
//        }];
//    }
//    
//}
//-(void)RequestData
//{
//    
//    NSDictionary *_parameters=@{@"itemName":itemName,@"categoryCode":categoryCode,@"page":[NSNumber numberWithLong:_page],@"token":[DD_UserModel getToken]};
//    [[JX_AFNetworking alloc] GET:@"share/queryShareItems.do" parameters:_parameters success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
//        if(success)
//        {
//            if(_page==1)
//            {
//                [_dataArr removeAllObjects];//删除所有数据
//            }
//            NSArray *getarr=[DD_CricleChooseItemModel getItemsModelArr:[data objectForKey:@"items"] WithDetail:_circleModel.chooseItem];
//            [_dataArr addObjectsFromArray:getarr];
//            [_tableView reloadData];
//        }else
//        {
//            if(_page==1)
//            {
//                [_dataArr removeAllObjects];//删除所有数据
//            }
//            [_tableView reloadData];
//            [self presentViewController:successAlert animated:YES completion:nil];
//        }
//        [_tableView.header endRefreshing];
//        [_tableView.footer endRefreshing];
//    } failure:^(NSError *error, UIAlertController *failureAlert) {
//        [self presentViewController:failureAlert animated:YES completion:nil];
//        [_tableView.header endRefreshing];
//        [_tableView.footer endRefreshing];
//    }];
//}
//#pragma mark - UITableViewDelegate
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if(tableView==_tableView)
//    {
//        return 80;
//    }
//    return 30;
//    
//}
//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return 1;
//}
//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    if(tableView==_tableView)
//    {
//        return _dataArr.count;
//    }
//    return _categoryArr.count;
//}
//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//    
//    if(tableView==_tableView)
//    {
//        //    数据还未获取时候
//        if(_dataArr.count==indexPath.section)
//        {
//            static NSString *cellid=@"cellid";
//            UITableViewCell *cell=[_tableView dequeueReusableCellWithIdentifier:cellid];
//            if(!cell)
//            {
//                cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
//            }
//            cell.selectionStyle=UITableViewCellSelectionStyleNone;
//            return cell;
//        }
//        
//        static NSString *CellIdentifier = @"cell_dday";
//        BOOL nibsRegistered = NO;
//        if (!nibsRegistered) {
//            UINib *nib = [UINib nibWithNibName:NSStringFromClass([DD_CricleChooseCell class]) bundle:nil];
//            [tableView registerNib:nib forCellReuseIdentifier:CellIdentifier];
//            nibsRegistered = YES;
//        }
//        DD_CricleChooseCell *cell = (DD_CricleChooseCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//        cell.selectionStyle=UITableViewCellSelectionStyleNone;
//        cell.block=cellblock;
//        
//        DD_CricleChooseItemModel *itemModel=[_dataArr objectAtIndex:indexPath.section];
//        cell.itemModel=itemModel;
//        cell.index=indexPath.section;
//        return cell;
//    }
//    
//    //    数据还未获取时候
//    if(_categoryArr.count==indexPath.section)
//    {
//        static NSString *cellid=@"cellid";
//        UITableViewCell *cell=[_tableView dequeueReusableCellWithIdentifier:cellid];
//        if(!cell)
//        {
//            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
//        }
//        cell.selectionStyle=UITableViewCellSelectionStyleNone;
//        return cell;
//    }
//    
//    
//    static NSString *cellid=@"cellCricle";
//    UITableViewCell *cell=[_tableView dequeueReusableCellWithIdentifier:cellid];
//    if(!cell)
//    {
//        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
//    }
//    DD_CricleCategoryModel *_categoryModel=[_categoryArr objectAtIndex:indexPath.section];
//    cell.textLabel.text=_categoryModel.name;
//    cell.textLabel.textAlignment=1;
//    cell.textLabel.font=[regular getFont:13.0f];
//    cell.selectionStyle=UITableViewCellSelectionStyleNone;
//    return cell;
//}
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if(tableView==_tableView)
//    {
//        DD_CricleChooseItemModel *_itemModel=[_dataArr objectAtIndex:indexPath.section];
//        DD_ItemsModel *_item=[[DD_ItemsModel alloc] init];
//        _item.g_id=_itemModel.g_id;
//        _item.colorId=_itemModel.colorId;
//        _item.colorCode=_itemModel.colorCode;
//        DD_GoodsDetailViewController *_GoodsDetail=[[DD_GoodsDetailViewController alloc] initWithModel:_item WithBlock:^(DD_ItemsModel *model, NSString *type) {
//            //        if(type)
//        }];
//        [self.navigationController pushViewController:_GoodsDetail animated:YES];
//    }else
//    {
//        _page=1;
//        _isShow=NO;
//        DD_CricleCategoryModel *_categoryModel=[_categoryArr objectAtIndex:indexPath.section];
//        categoryCode=_categoryModel.code;
//        //        [_screeningBtn setTitle:_categoryModel.name forState:UIControlStateNormal];
//        [_tableView.header beginRefreshing];
//        [_chooseTableView removeFromSuperview];
//        [_categoryArr removeAllObjects];
//    }
//    
//}
////section头部间距
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    
//    return 1;//section头部高度
//}
////section头部视图
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *view=[[UIView alloc] init];
//    if(tableView==_tableView)
//    {
//        view.frame=CGRectMake(0, 0, ScreenWidth, 1);
//    }else
//    {
//        view.frame=CGRectMake(0, 0, 100, 1);
//    }
//    view.backgroundColor = _define_backview_color;
//    return view;
//}
////section底部间距
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 1;//section头部高度
//}
////section底部视图
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
//    if(tableView==_tableView)
//    {
//        view.frame=CGRectMake(0, 0, ScreenWidth, 1);
//    }else
//    {
//        view.frame=CGRectMake(0, 0, 100, 1);
//    }
//    view.backgroundColor = _define_backview_color;
//    return view;
//}
//-(void)SomeBlock
//{
//    __block DD_CircleChooseDetailView *_chooseView=self;
//    __block NSMutableArray *___chooseItem=_circleModel.chooseItem;
//    __block NSMutableArray *___dataArr=_dataArr;
//    __block NSInteger ___num=_num;
//    //    __block UILabel *___numLabel =_numLabel;
//    cellblock=^(NSString *type,NSInteger index)
//    {
//        if([type isEqualToString:@"addItem"])
//        {
//            if(___chooseItem.count<___num)
//            {
//                [___chooseItem addObject:[___dataArr objectAtIndex:index]];
//                //                _numLabel.text=[[NSString alloc] initWithFormat:@"还可选择%ld款",___num-___chooseItem.count];
//            }else
//            {
//                [_chooseView presentViewController:[regular alertTitle_Simple:[[NSString alloc] initWithFormat:@"最多可选择%ld款",___num]] animated:YES completion:nil];
//            }
//            [_chooseView UpdateImgView];
//        }else if([type isEqualToString:@"delItem"])
//        {
//            _block(@"delete_choose_item",index);
//            [_chooseView UpdateImgView];
//        }
//        
//    };
//}
@end
