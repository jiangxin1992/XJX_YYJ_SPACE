//
//  CalarViewController.m
//  TimeTest
//
//  Created by LvJianfeng on 16/7/21.
//  Copyright © 2016年 LvJianfeng. All rights reserved.
//

#import "CalendarViewController.h"

#import "DD_ShopViewController.h"
#import "DD_DDAYDetailViewController.h"
#import "DD_DDAYDetailOfflineViewController.h"

#import "DD_CalendarCell.h"

#import "DD_CalendarTool.h"
#import "DD_DDAYModel.h"
#import "DD_MonthModel.h"

#define LL_SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define LL_SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define HeaderViewHeight 40
#define WeekViewHeight 40

#define cellW floor(([UIScreen mainScreen].bounds.size.width-40-12)/7)
#define cellH floor((([UIScreen mainScreen].bounds.size.width-40-12)/7)-6)

@interface CalendarViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *dayModelArray;
@property (strong, nonatomic) UILabel *dateLabel;
@property (strong, nonatomic) UIButton *leftBtn;
@property (strong, nonatomic) UIButton *rightBtn;
@property (strong, nonatomic) NSDate *tempDate;
@property (strong, nonatomic) UIView *upView;
@end

@implementation CalendarViewController
{
    
    UIView *backView;
    NSMutableArray *blockArr;
    NSMutableArray *_SeriesArr;
    
    UIScrollView *_scrollView;
    NSMutableArray *_monthArr;
    NSMutableArray *_monthSeriesViewArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self SomePrepare];
    [self UIConfig];
    [self setData];
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
    blockArr=[[NSMutableArray alloc] init];
    _SeriesArr=[[NSMutableArray alloc] init];
    
    _monthArr=[[NSMutableArray alloc] init];
    _monthSeriesViewArr=[[NSMutableArray alloc] init];
}
-(void)PrepareUI
{
    self.navigationItem.titleView=[regular returnNavView:NSLocalizedString(@"dday_calendar", @"") withmaxwidth:200];
    DD_NavBtn *shopBtn=[DD_NavBtn getShopBtn];
//    [shopBtn addTarget:self action:@selector(PushShopView) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:shopBtn];
    [shopBtn bk_addEventHandler:^(id sender) {
//        跳转购物车
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
    } forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark - UIConfig
-(void)UIConfig
{
    [self CreateScrollView];
    [self ViewConfig];
}
-(void)CreateScrollView
{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight+ktabbarHeight)];
    [self.view addSubview:_scrollView];
    _scrollView.contentSize=CGSizeMake(ScreenWidth, 3000);
}
-(void)ViewConfig
{
    _dateLabel=[UILabel getLabelWithAlignment:1 WithTitle:@"" WithFont:24.0f WithTextColor:nil WithSpacing:0];
    [_scrollView addSubview:_dateLabel];
    _dateLabel.font=[regular getSemiboldFont:24.0f];
    _dateLabel.frame=CGRectMake((ScreenWidth-100)/2.0f, 0, 100, 38);
    
    
    _leftBtn=[UIButton getCustomTitleBtnWithAlignment:1 WithFont:15.0f WithSpacing:0 WithNormalTitle:@"" WithNormalColor:_define_light_gray_color1 WithSelectedTitle:nil WithSelectedColor:nil];
    [_scrollView addSubview:_leftBtn];
    [_leftBtn setEnlargeEdgeWithTop:0 right:0 bottom:0 left:kEdge];
    _leftBtn.frame=CGRectMake(kEdge, 0, 100, 38);
    _leftBtn.titleLabel.font=[regular getSemiboldFont:15.0f];
    [_leftBtn addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    _rightBtn=[UIButton getCustomTitleBtnWithAlignment:2 WithFont:15.0f WithSpacing:0 WithNormalTitle:@"" WithNormalColor:_define_light_gray_color1 WithSelectedTitle:nil WithSelectedColor:nil];
    [_scrollView addSubview:_rightBtn];
    [_rightBtn setEnlargeEdgeWithTop:0 right:kEdge bottom:0 left:0];
    _rightBtn.frame=CGRectMake(ScreenWidth-kEdge-100, 0 , 100, 38);
    _rightBtn.titleLabel.font=[regular getSemiboldFont:15.0f];
    [_rightBtn addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    _upView=[UIView getCustomViewWithColor:_define_black_color];
    [_scrollView addSubview:_upView];
    _upView.frame=CGRectMake(15, CGRectGetMaxY(_rightBtn.frame)+12, ScreenWidth-15*2, 27);
    
    
    backView=[UIView getCustomViewWithColor:nil];
    [_scrollView addSubview:backView];
    backView.backgroundColor=_define_white_color;
    [regular setBorder:backView];
    CGFloat _bianju=(ScreenWidth-cellW*7)/2.0f-6;
    backView.frame=CGRectMake(_bianju, CGRectGetMaxY(_rightBtn.frame)+25, cellW * 7+12, cellH * 7+12);
    
    
    [_scrollView addSubview:self.collectionView];
}
- (UICollectionView *)collectionView{
    if (!_collectionView) {
//        6
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        
        layout.itemSize = CGSizeMake(cellW, cellH);
        layout.footerReferenceSize  = CGSizeMake(0, 0);
        layout.headerReferenceSize = CGSizeMake(LL_SCREEN_WIDTH, HeaderViewHeight);
        
        layout.sectionInset            = UIEdgeInsetsMake(0, 0, 0, 0);
        layout.minimumInteritemSpacing = 0.0f;
        layout.minimumLineSpacing      = 0.0f;
        
        //        cellWH

         _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake((ScreenWidth-cellW*7)/2.0f, 25+38+6, cellW * 7, cellH * 7) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor =  _define_clear_color;
        _collectionView.alwaysBounceVertical=NO;
        _collectionView.alwaysBounceHorizontal=NO;
        _collectionView.scrollEnabled=NO;
        [_collectionView registerClass:[DD_CalendarCell class] forCellWithReuseIdentifier:@"DD_CalendarCell"];
        [_collectionView registerClass:[CalendarHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CalendarHeaderView"];
        
    }
    return _collectionView;
}
-(void)setData
{
    self.tempDate = [NSDate nowDate];
    NSString *day=self.tempDate.yyyyMMByLineWithDate;
    _dateLabel.text =day;
    [self getDataDayModel:self.tempDate];
    [_leftBtn setTitle:self.tempDate.getLastMonthWithDate forState:UIControlStateNormal];
    [_rightBtn setTitle:self.tempDate.getNextMonthWithDate forState:UIControlStateNormal];
}

#pragma mark - SomeAction
/**
 * 跳转系列详情页
 */
-(void)seriesBtnAction:(UIButton *)btn
{
    DD_DDAYModel *seriesModel=_monthArr[btn.tag-100];
    if(seriesModel.stype)
    {
        //线下
        [self.navigationController pushViewController:[[DD_DDAYDetailOfflineViewController alloc] initWithModel:seriesModel] animated:YES];
    }else
    {
        //线上
        [self.navigationController pushViewController:[[DD_DDAYDetailViewController alloc] initWithModel:seriesModel WithBlock:^(NSString *type) {
        }] animated:YES];
    }
}
////跳转购物车
//-(void)PushShopView
//{
//    if(![DD_UserModel isLogin])
//    {
//        [self presentViewController:[regular alertTitleCancel_Simple:NSLocalizedString(@"login_first", @"") WithBlock:^{
//            [self pushLoginView];
//        }] animated:YES completion:nil];
//    }else
//    {
//        DD_ShopViewController *_shop=[[DD_ShopViewController alloc] init];
//        [self.navigationController pushViewController:_shop animated:YES];
//    }
//}
/**
 * 上个月
 */
- (void)leftAction
{
    self.tempDate = [self.tempDate getLastMonth];
    NSString *day=self.tempDate.yyyyMMByLineWithDate;
    _dateLabel.text = day;
    [self getDataDayModel:self.tempDate];
    JXLOG(@"monthArr=%@",_monthArr);
    [_leftBtn setTitle:self.tempDate.getLastMonthWithDate forState:UIControlStateNormal];
    [_rightBtn setTitle:self.tempDate.getNextMonthWithDate forState:UIControlStateNormal];
}
/**
 * 下个月
 */
- (void)rightAction
{
    self.tempDate =[self.tempDate getNextMonth];
    NSString *day=self.tempDate.yyyyMMByLineWithDate;
    _dateLabel.text = day;
    [self getDataDayModel:self.tempDate];
    JXLOG(@"monthArr=%@",_monthArr);
    [_leftBtn setTitle:self.tempDate.getLastMonthWithDate forState:UIControlStateNormal];
    [_rightBtn setTitle:self.tempDate.getNextMonthWithDate forState:UIControlStateNormal];
}
/**
 * 更新数据
 */
- (void)getDataDayModel:(NSDate *)date{
    
    [self BlockReSet];
    [self SeriesReset];
    
    NSUInteger days = [date numberOfDaysInMonth];
    NSInteger week = [date startDayOfWeek];
    self.dayModelArray = [[NSMutableArray alloc] initWithCapacity:42];
    int day = 1;
    for (int i= 1; i<43; i++) {
        if (i<week) {
            [self.dayModelArray addObject:@""];
        }else if(i<days+week)
        {
            DD_MonthModel *mon = [DD_MonthModel new];
            mon.dayValue = day;
            NSDate *dayDate = [self dateOfDay:day];
            mon.dateValue = dayDate;
            NSInteger _week=(i-1)%7;
            mon.week=[[NSString alloc] initWithFormat:@"%ld",_week];
            if ([dayDate.yyyyMMddByLineWithDate isEqualToString:[NSDate nowDate].yyyyMMddByLineWithDate]) {
                mon.isSelectedDay = YES;
            }
            [self.dayModelArray addObject:mon];
            day++;
        }else
        {
            [self.dayModelArray addObject:@""];
        }
    }
    
    [_monthArr removeAllObjects];
    if(_SeriesArr.count)
    {
       [DD_CalendarTool SetUnSelectWithArr:_SeriesArr];
       [_monthArr addObjectsFromArray:[DD_CalendarTool getMonthSeriesWithDayModel:date WithSeriesArr:_SeriesArr WithDataArr:_dayModelArray]];
    }
    
    [self.collectionView reloadData];
    
    [self resetBackView];
    [self resetMonthSeriesView];
}
-(void)BlockReSet
{
    [blockArr enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];

    [blockArr removeAllObjects];
}
-(void)SeriesReset
{
    //    删除系列按钮
    [_monthSeriesViewArr enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];

    [_monthSeriesViewArr removeAllObjects];
}
/**
 * 更新backview（系列时间view）
 */
-(void)resetBackView
{
    if(_SeriesArr.count)
    {
        for (int i=0; i<6; i++) {
            NSArray *weekArr = [DD_CalendarTool getWeekSeriesWithDayModel:self.tempDate WithWeekNum:i+1 WithSeriesArr:_SeriesArr WithDataArr:_dayModelArray];
            NSArray *viewArr = [DD_CalendarTool getWeekViewWithDayModel:self.tempDate WithWeekArr:weekArr WithWeekNum:i+1 WithDataArr:_dayModelArray];
            
            [viewArr enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [backView addSubview:obj];
                [blockArr addObject:obj];
            }];
        }
    }
}
/**
 * 更新系列
 */
-(void)resetMonthSeriesView
{
    if(_monthArr.count)
    {
        __block UIView *lastView=nil;
        [_monthArr enumerateObjectsUsingBlock:^(DD_DDAYModel *seriesModel, NSUInteger idx, BOOL * _Nonnull stop) {
            UIView *_backView_s=[UIView getCustomViewWithColor:nil];
            [_scrollView addSubview:_backView_s];
            
            [_backView_s mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(0);
                make.width.mas_equalTo(ScreenWidth);
                if(lastView)
                {
                    make.top.mas_equalTo(lastView.mas_bottom).with.offset(IsPhone6_gt?26:20);
                }else
                {
                    make.top.mas_equalTo(backView.mas_bottom).with.offset(IsPhone6_gt?26:20);
                }
            }];
            
            DD_DDAYModel *dday=_monthArr[idx];
            UIButton *seriesBtn=[UIButton getCustomTitleBtnWithAlignment:0 WithFont:15.0f WithSpacing:0 WithNormalTitle:dday.name WithNormalColor:[UIColor colorWithHexString:seriesModel.seriesColor] WithSelectedTitle:nil WithSelectedColor:nil];
            [_backView_s addSubview:seriesBtn];
            if(seriesModel.is_select)
            {
                seriesBtn.backgroundColor=[UIColor colorWithHexString:seriesModel.seriesColor];
                [seriesBtn setTitleColor:_define_white_color forState:UIControlStateNormal];
            }else
            {
                [regular setBorder:seriesBtn WithColor:[UIColor colorWithHexString:seriesModel.seriesColor] WithWidth:2];
                seriesBtn.backgroundColor=_define_white_color;
                [seriesBtn setTitleColor:[UIColor colorWithHexString:seriesModel.seriesColor] forState:UIControlStateNormal];
            }
            
            [seriesBtn addTarget:self action:@selector(seriesBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            seriesBtn.tag=100+idx;
            
            [seriesBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(kEdge);
                make.right.mas_equalTo(-kEdge);
                make.height.mas_equalTo(IsPhone6_gt?30:25);
                make.top.mas_equalTo(0);
                make.bottom.mas_equalTo(0);
            }];
            [_monthSeriesViewArr addObject:_backView_s];
            lastView=_backView_s;
        }];
        NSLog(@"backView=%lf",CGRectGetMaxY(backView.frame));
        _scrollView.contentSize=CGSizeMake(ScreenWidth, CGRectGetMaxY(backView.frame)+((IsPhone6_gt?30:25)+(IsPhone6_gt?26:20))*_monthArr.count+(IsPhone6_gt?26:20));
        
    }else
    {
        _scrollView.contentSize=CGSizeMake(ScreenWidth, CGRectGetMaxY(backView.frame)+20);
    }
    
}
/**
 * 系列数据请求，只请求一次  获取所有系列的信息
 */
-(void)RequestData
{
    [[JX_AFNetworking alloc] GET:@"series/querySeriesCalendar.do" parameters:@{@"token":[DD_UserModel getToken]} success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
        if(success)
        {
            [_SeriesArr addObjectsFromArray:[DD_DDAYModel getDDAYModelArr:[data objectForKey:@"seriesCalendar"]]];
            [self.collectionView reloadData];
            [self resetBackView];
            [_monthArr removeAllObjects];
            [self SeriesReset];
            [_monthArr addObjectsFromArray:[DD_CalendarTool getMonthSeriesWithDayModel:self.tempDate WithSeriesArr:_SeriesArr WithDataArr:_dayModelArray]];
            [self resetMonthSeriesView];
           
        }else
        {
            [self presentViewController:successAlert animated:YES completion:nil];
        }
    } failure:^(NSError *error, UIAlertController *failureAlert) {
        [self presentViewController:failureAlert animated:YES completion:nil];
    }];
}
#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dayModelArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DD_CalendarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DD_CalendarCell" forIndexPath:indexPath];
    cell.dayLabel.textColor = _define_black_color;
    cell.dayLabel.font=[UIFont systemFontOfSize:15.0f];
    id mon = self.dayModelArray[indexPath.row];
    if(indexPath.row<7)
    {
        cell.backgroundColor= _define_clear_color;
        cell.alpha=0.7;
    }
    if ([mon isKindOfClass:[DD_MonthModel class]]) {
        cell.monthModel = (DD_MonthModel *)mon;
    }else{
        cell.dayLabel.text = @"";
        cell.dayLabel.backgroundColor =  _define_clear_color;
    }
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    CalendarHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"CalendarHeaderView" forIndexPath:indexPath];
    return headerView;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    id mon = self.dayModelArray[indexPath.row];
    if ([mon isKindOfClass:[DD_MonthModel class]]) {
        DD_MonthModel *_mon=(DD_MonthModel *)mon;
        NSArray *currentArr=[DD_CalendarTool getCurrentSeriesWithMonthModel:_mon WithData:_SeriesArr];
        NSArray *getArr=[DD_CalendarTool sortWithCurrentSeries:currentArr WithMonthSeriesArr:_monthArr];
        [_monthArr removeAllObjects];
        [_monthArr addObjectsFromArray:getArr];
    }else
    {
        NSArray *getArr=[DD_CalendarTool sortWithCurrentSeries:nil WithMonthSeriesArr:_monthArr];
        [_monthArr removeAllObjects];
        [_monthArr addObjectsFromArray:getArr];
    }
    
    [self SeriesReset];
    [self resetMonthSeriesView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -Private

- (NSDate *)dateOfDay:(NSInteger)day{
    NSCalendar *greCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [greCalendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    NSDateComponents *comps = [greCalendar
                               components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay
                               fromDate:self.tempDate];
    comps.day = day;
    return [greCalendar dateFromComponents:comps];
}

@end

@implementation CalendarHeaderView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor= _define_clear_color;
        NSArray *weekArray = [[NSArray alloc] initWithObjects:@"日",@"一",@"二",@"三",@"四",@"五",@"六", nil];
        [weekArray enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UILabel *weekLabel = [[UILabel alloc] initWithFrame:CGRectMake(idx*cellW, 0, cellW, HeaderViewHeight)];
            weekLabel.textAlignment = NSTextAlignmentCenter;
            if(idx==0||idx==6)
            {
                weekLabel.textColor = _define_light_gray_color1;
            }else
            {
                weekLabel.textColor = _define_black_color;
            }
            weekLabel.font = [UIFont systemFontOfSize:13.0f];
            weekLabel.text = obj;
            [self addSubview:weekLabel];
        }];

    }
    return self;
}
@end
