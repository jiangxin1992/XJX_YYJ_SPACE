//
//  CalarViewController.m
//  TimeTest
//
//  Created by LvJianfeng on 16/7/21.
//  Copyright © 2016年 LvJianfeng. All rights reserved.
//

#import "CalendarViewController.h"

#import "DD_CalendarCell.h"

#import "DD_ShopViewController.h"

#import "NSDate+Formatter.h"
#import "DD_DDAYModel.h"
#import "DD_MonthModel.h"

#define LL_SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define LL_SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define HeaderViewHeight 40
#define WeekViewHeight 40

#define cellWH floor((ScreenWidth-40)/7)

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

- (void)viewDidLoad {
    [super viewDidLoad];
    [self SomePrepare];
    [self UIConfig];
    [self setData];
    [self RequestData];
}
#pragma mark - UIConfig
-(void)UIConfig
{
    _dateLabel=[UILabel getLabelWithAlignment:1 WithTitle:@"" WithFont:24.0f WithTextColor:nil WithSpacing:0];
    [self.view addSubview:_dateLabel];
    _dateLabel.font=[regular getSemiboldFont:24.0f];
    [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(64);
        make.height.mas_equalTo(38);
        make.width.mas_equalTo(100);
    }];
    
    _leftBtn=[UIButton getCustomTitleBtnWithAlignment:0 WithFont:15.0f WithSpacing:0 WithNormalTitle:@"" WithNormalColor:_define_light_gray_color1 WithSelectedTitle:nil WithSelectedColor:nil];
    [self.view addSubview:_leftBtn];
    _leftBtn.titleLabel.font=[regular getSemiboldFont:15.0f];
    [_leftBtn addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    [_leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(_dateLabel);
        make.width.mas_equalTo(65);
        make.height.mas_equalTo(_dateLabel);
    }];
    
    _rightBtn=[UIButton getCustomTitleBtnWithAlignment:0 WithFont:15.0f WithSpacing:0 WithNormalTitle:@"" WithNormalColor:_define_light_gray_color1 WithSelectedTitle:nil WithSelectedColor:nil];
    [self.view addSubview:_rightBtn];
    _rightBtn.titleLabel.font=[regular getSemiboldFont:15.0f];
    [_rightBtn addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(_dateLabel);
        make.width.mas_equalTo(65);
        make.height.mas_equalTo(_dateLabel);
    }];
    
    _upView=[UIView getCustomViewWithColor:_define_black_color];
    [self.view addSubview:_upView];
    [_upView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(_rightBtn.mas_bottom).with.offset(12);
        make.height.mas_equalTo(27);
    }];
    
    [self.view addSubview:self.collectionView];
    
}
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        //        NSInteger width = Iphone6Scale(54);
        //        NSInteger height = Iphone6Scale(54);
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        
        layout.itemSize = CGSizeMake(cellWH, cellWH);
        layout.footerReferenceSize  = CGSizeMake(0, 0);
        layout.headerReferenceSize = CGSizeMake(LL_SCREEN_WIDTH, HeaderViewHeight);
        
        layout.sectionInset            = UIEdgeInsetsMake(0, 0, 0, 0);
        layout.minimumInteritemSpacing = 0.0f;
        layout.minimumLineSpacing      = 0.0f;
        
        //        cellWH
        //        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(35, 64 + WeekViewHeight, cellWH * 7, LL_SCREEN_HEIGHT - 64 - WeekViewHeight) collectionViewLayout:flowLayout];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake((ScreenWidth-cellWH*7)/2.0f, 64 + WeekViewHeight+12+14, cellWH * 7, cellWH * 7) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        
        _collectionView.layer.masksToBounds=YES;
        _collectionView.layer.borderWidth=1;
        _collectionView.layer.borderColor=[[UIColor blackColor] CGColor];
        
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
#pragma mark - SomePrepare
-(void)SomePrepare
{
    [self PrepareData];
    [self PrepareUI];
}
-(void)PrepareData{}
-(void)PrepareUI
{
    self.navigationItem.titleView=[regular returnNavView:NSLocalizedString(@"dday_calendar", @"") withmaxwidth:200];
    DD_NavBtn *shopBtn=[DD_NavBtn getShopBtn];
    [shopBtn addTarget:self action:@selector(PushShopView) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:shopBtn];
}
#pragma mark - SomeAction
- (void)leftAction
{
    self.tempDate = [self.tempDate getLastMonth];
    NSString *day=self.tempDate.yyyyMMByLineWithDate;
    _dateLabel.text = day;
    [self getDataDayModel:self.tempDate];
    
    [_leftBtn setTitle:self.tempDate.getLastMonthWithDate forState:UIControlStateNormal];
    [_rightBtn setTitle:self.tempDate.getNextMonthWithDate forState:UIControlStateNormal];
}

- (void)rightAction
{
    self.tempDate = [self.tempDate getNextMonth];
    NSString *day=self.tempDate.yyyyMMByLineWithDate;
    _dateLabel.text = day;
    [self getDataDayModel:self.tempDate];
    
    [_leftBtn setTitle:self.tempDate.getLastMonthWithDate forState:UIControlStateNormal];
    [_rightBtn setTitle:self.tempDate.getNextMonthWithDate forState:UIControlStateNormal];
}
- (void)getDataDayModel:(NSDate *)date{
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
            NSLog(@"week=%ld",_week);
            mon.week=[[NSString alloc] initWithFormat:@"%ld",_week];
            if ([dayDate.yyyyMMddByLineWithDate isEqualToString:[NSDate date].yyyyMMddByLineWithDate]) {
                mon.isSelectedDay = YES;
            }
            [self.dayModelArray addObject:mon];
            
            
            day++;
        }
    }
    [self.collectionView reloadData];
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
-(void)RequestData
{
    [[JX_AFNetworking alloc] GET:@"series/querySeriesCalendar.do" parameters:@{@"token":[DD_UserModel getToken]} success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
        if(success)
        {
            _SeriesArr=[DD_DDAYModel getDDAYModelArr:[data objectForKey:@"seriesCalendar"]];
            [self.collectionView reloadData];
            
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
        
        NSArray *weekArray = [[NSArray alloc] initWithObjects:@"日",@"一",@"二",@"三",@"四",@"五",@"六", nil];
//        NSInteger width=([UIScreen mainScreen].bounds.size.width-70)/7.0f;
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
