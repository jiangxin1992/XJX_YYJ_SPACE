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

#import "DD_CalendarCell.h"

#import "DD_CalendarTool.h"
#import "NSDate+Formatter.h"
#import "DD_DDAYModel.h"
#import "DD_MonthModel.h"

#define LL_SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define LL_SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define HeaderViewHeight 40
#define WeekViewHeight 40

#define cellWH floor(([UIScreen mainScreen].bounds.size.width-40-12)/7)

@interface CalendarViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *dayModelArray;
@property (strong, nonatomic) UILabel *dateLabel;
@property (strong, nonatomic) UIButton *leftBtn;
@property (strong, nonatomic) UIButton *rightBtn;
@property (strong, nonatomic) NSDate *tempDate;
@property (strong, nonatomic) NSArray *SeriesArr;
@property (strong, nonatomic) UIView *upView;
@end

@implementation CalendarViewController
{
    
    UIView *backView;
    NSMutableArray *blockArr;
    NSMutableArray *seriesArr;
    
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
    seriesArr=[[NSMutableArray alloc] init];
    
    _monthArr=[[NSMutableArray alloc] init];
    _monthSeriesViewArr=[[NSMutableArray alloc] init];
}
-(void)PrepareUI
{
    self.navigationItem.titleView=[regular returnNavView:NSLocalizedString(@"dday_calendar", @"") withmaxwidth:200];
    DD_NavBtn *shopBtn=[DD_NavBtn getShopBtn];
    [shopBtn addTarget:self action:@selector(PushShopView) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:shopBtn];
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
    backView.backgroundColor=[UIColor whiteColor];
    backView.layer.masksToBounds=YES;
    backView.layer.borderWidth=1;
    backView.layer.borderColor=[[UIColor blackColor] CGColor];
    CGFloat _bianju=(ScreenWidth-cellWH*7)/2.0f-6;
    backView.frame=CGRectMake(_bianju, CGRectGetMaxY(_rightBtn.frame)+25, cellWH * 7+12, cellWH * 7+12);
    
    
    [_scrollView addSubview:self.collectionView];
}
- (UICollectionView *)collectionView{
    if (!_collectionView) {
//        6
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        
        layout.itemSize = CGSizeMake(cellWH, cellWH);
        layout.footerReferenceSize  = CGSizeMake(0, 0);
        layout.headerReferenceSize = CGSizeMake(LL_SCREEN_WIDTH, HeaderViewHeight);
        
        layout.sectionInset            = UIEdgeInsetsMake(0, 0, 0, 0);
        layout.minimumInteritemSpacing = 0.0f;
        layout.minimumLineSpacing      = 0.0f;
        
        //        cellWH

         _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake((ScreenWidth-cellWH*7)/2.0f, 25+38+6, cellWH * 7, cellWH * 7) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        
        [_collectionView registerClass:[DD_CalendarCell class] forCellWithReuseIdentifier:@"DD_CalendarCell"];
        [_collectionView registerClass:[CalendarHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CalendarHeaderView"];
        
    }
    return _collectionView;
}
-(void)setData
{
    self.tempDate = [NSDate date];
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
    DD_DDAYModel *seriesModel=[_monthArr objectAtIndex:btn.tag-100];
    [self.navigationController pushViewController:[[DD_DDAYDetailViewController alloc] initWithModel:seriesModel WithBlock:^(NSString *type) {
        
    }] animated:YES];
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
/**
 * 上个月
 */
- (void)leftAction
{
    self.tempDate = [self.tempDate getLastMonth];
    NSString *day=self.tempDate.yyyyMMByLineWithDate;
    _dateLabel.text = day;
    [self getDataDayModel:self.tempDate];
    
    [_leftBtn setTitle:self.tempDate.getLastMonthWithDate forState:UIControlStateNormal];
    [_rightBtn setTitle:self.tempDate.getNextMonthWithDate forState:UIControlStateNormal];
}
/**
 * 下个月
 */
- (void)rightAction
{
    self.tempDate = [self.tempDate getNextMonth];
    NSString *day=self.tempDate.yyyyMMByLineWithDate;
    _dateLabel.text = day;
    [self getDataDayModel:self.tempDate];
    
    [_leftBtn setTitle:self.tempDate.getLastMonthWithDate forState:UIControlStateNormal];
    [_rightBtn setTitle:self.tempDate.getNextMonthWithDate forState:UIControlStateNormal];
}
/**
 * 更新数据
 */
- (void)getDataDayModel:(NSDate *)date{
    
    for (UIView *view in blockArr) {
        [view removeFromSuperview];
    }
    [blockArr removeAllObjects];
    
    [_monthArr removeAllObjects];
    //    删除系列按钮
    for (UIView *view in _monthSeriesViewArr) {
        [view removeFromSuperview];
    }
    [_monthSeriesViewArr removeAllObjects];
    
//    NSInteger _count = [DD_CalendarTool getWeekCountWithDayModel:self.tempDate];
//    NSLog(@"count=%ld",_count);
    NSUInteger days = [date numberOfDaysInMonth];
    NSInteger week = [date startDayOfWeek];
    self.dayModelArray = [[NSMutableArray alloc] initWithCapacity:42];
    int day = 1;
    for (int i= 1; i<days+week; i++) {
        if (i<week) {
            [self.dayModelArray addObject:@""];
        }else{
            DD_MonthModel *mon = [DD_MonthModel new];
            mon.dayValue = day;
            NSDate *dayDate = [self dateOfDay:day];
            mon.dateValue = dayDate;
            NSInteger _week=(i-1)%7;
            mon.week=[[NSString alloc] initWithFormat:@"%ld",_week];
            if ([dayDate.yyyyMMddByLineWithDate isEqualToString:[NSDate date].yyyyMMddByLineWithDate]) {
                mon.isSelectedDay = YES;
            }
            [self.dayModelArray addObject:mon];
            day++;
        }
    }
    [self.collectionView reloadData];
    
    [self resetBackView];
    [self resetMonthSeriesView];
    
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
            
            for (UIView *view in viewArr) {
                [backView addSubview:view];
                [blockArr addObject:view];
            }
        }
    }
}
/**
 * 更新系列
 */
-(void)resetMonthSeriesView
{
    
    [_monthArr addObjectsFromArray:[DD_CalendarTool getMonthSeriesWithDayModel:self.tempDate WithSeriesArr:_SeriesArr WithDataArr:_dayModelArray]];

    if(_monthArr.count)
    {
        UIView *lastView=nil;
        for (int i=0; i<_monthArr.count; i++) {
            DD_DDAYModel *seriesModel = [_monthArr objectAtIndex:i];
            UIView *_backView_s=[UIView getCustomViewWithColor:nil];
            [_scrollView addSubview:_backView_s];
            
            [_backView_s mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(0);
                make.width.mas_equalTo(ScreenWidth);
                if(lastView)
                {
                    make.top.mas_equalTo(lastView.mas_bottom).with.offset(0);
                }else
                {
                    make.top.mas_equalTo(backView.mas_bottom).with.offset(0);
                }
            }];
            
            UILabel *s_name=[UILabel getLabelWithAlignment:1 WithTitle:seriesModel.name WithFont:12.0f WithTextColor:nil WithSpacing:0];
            [_backView_s addSubview:s_name];
            
            [s_name mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(_backView_s);
                make.top.mas_equalTo(26);
            }];

            UIView *colorBlockView=[UIView getCustomViewWithColor:[UIColor colorWithHexString:seriesModel.seriesColor]];
            [_backView_s addSubview:colorBlockView];
            [colorBlockView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.width.mas_equalTo(14);
                make.centerY.mas_equalTo(s_name);
                make.right.mas_equalTo(s_name.mas_left).with.offset(-6);
            }];
            
            UIButton *seriesBtn=[UIButton getCustomTitleBtnWithAlignment:0 WithFont:15.0f WithSpacing:0 WithNormalTitle:@"查看详情" WithNormalColor:_define_white_color WithSelectedTitle:nil WithSelectedColor:nil];
            [_backView_s addSubview:seriesBtn];
            [seriesBtn addTarget:self action:@selector(seriesBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            seriesBtn.tag=100+i;
            seriesBtn.backgroundColor=[UIColor colorWithHexString:seriesModel.seriesColor];
            seriesBtn.frame=CGRectMake(kEdge, CGRectGetHeight(_backView_s.frame)-28, ScreenWidth-2*kEdge, 28);
            [seriesBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(kEdge);
                make.right.mas_equalTo(-kEdge);
                make.height.mas_equalTo(28);
                make.top.mas_equalTo(s_name.mas_bottom).with.offset(10);
                make.bottom.mas_equalTo(0);
            }];
            [_monthSeriesViewArr addObject:_backView_s];
            lastView=_backView_s;
        }
        _scrollView.contentSize=CGSizeMake(ScreenWidth, CGRectGetMaxY(backView.frame)+88*_monthArr.count+20);
        
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
            _SeriesArr=[DD_DDAYModel getDDAYModelArr:[data objectForKey:@"seriesCalendar"]];
            [self.collectionView reloadData];
            [self resetBackView];
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
    cell.dayLabel.backgroundColor = [UIColor whiteColor];
    cell.dayLabel.textColor = [UIColor blackColor];
    cell.dayLabel.font=[UIFont systemFontOfSize:15.0f];
    id mon = self.dayModelArray[indexPath.row];
    if(indexPath.row<7)
    {
        cell.backgroundColor=[UIColor clearColor];
        cell.alpha=0.7;
    }
    if ([mon isKindOfClass:[DD_MonthModel class]]) {
        cell.monthModel = (DD_MonthModel *)mon;
    }else{
        cell.dayLabel.text = @"";
    }
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    CalendarHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"CalendarHeaderView" forIndexPath:indexPath];
    return headerView;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    id mon = self.dayModelArray[indexPath.row];
//    if ([mon isKindOfClass:[MonthModel class]]) {
//        NSString *day=[(MonthModel *)mon dateValue].yyyyMMddByLineWithDate;
//        self.dateLabel.text = day;
//    }
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
        self.backgroundColor=[UIColor clearColor];
        NSArray *weekArray = [[NSArray alloc] initWithObjects:@"日",@"一",@"二",@"三",@"四",@"五",@"六", nil];
        for (int i=0; i<weekArray.count; i++) {
            UILabel *weekLabel = [[UILabel alloc] initWithFrame:CGRectMake(i*cellWH, 0, cellWH, HeaderViewHeight)];
            weekLabel.textAlignment = NSTextAlignmentCenter;
            if(i==0||i==6)
            {
                weekLabel.textColor = [UIColor grayColor];
            }else
            {
                weekLabel.textColor = [UIColor blackColor];
            }
            weekLabel.font = [UIFont systemFontOfSize:13.0f];
            weekLabel.text = weekArray[i];
            [self addSubview:weekLabel];
        }
        
    }
    return self;
}
@end
