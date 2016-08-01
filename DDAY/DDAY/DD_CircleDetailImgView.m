//
//  DD_CircleDetailImgView.m
//  DDAY
//
//  Created by yyj on 16/6/23.
//  Copyright © 2016年 YYJ. All rights reserved.
//
#define yellow_color [UIColor colorWithRed:248.0f/255.0f green:210.0f/255.0f blue:82.0f/255.0f alpha:1]

#import "ImageViewController.h"
#import "DD_CircleDetailImgView.h"

@implementation DD_CircleDetailImgView
{
    UIPageViewController *_pageViewControler;
    UIPageControl *_pageControl;

    UIButton *itemBtn;//单品按钮，点击进入该搭配的单品列表
}

#pragma mark - 初始化
-(instancetype)initWithCircleListModel:(DD_CircleListModel *)model WithBlock:(void (^)(NSString *,NSInteger index))block
{
    self=[super init];
    if(self)
    {
        _block=block;
        _detailModel=model;
    }
    return self;
}
#pragma mark - UIConfig
-(void)UIConfig
{
    //    创建pageViewControler（活动图片浏览视图）
    _pageViewControler = [[UIPageViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    [self addSubview:_pageViewControler.view];
    ImageViewController *imgvc = [[ImageViewController alloc]initWithSize:CGSizeMake(ScreenWidth, 300) WithBlock:^(NSString *type, NSInteger index) {
        _block(type,index);
    }];
    imgvc.array=_detailModel.pics;
    imgvc.view.backgroundColor = [UIColor clearColor];
    imgvc.currentPage = 0;
    [_pageViewControler setViewControllers:@[imgvc] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    _pageViewControler.delegate = self;
    _pageViewControler.dataSource = self;
    [_pageViewControler.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.and.right.mas_equalTo(0);
        make.height.mas_equalTo(300);
        make.bottom.mas_equalTo(0);
    }];
    
    _pageControl = [[UIPageControl alloc]init];
    [self addSubview:_pageControl];
    _pageControl.numberOfPages = _detailModel.pics.count;
    _pageControl.currentPageIndicatorTintColor = yellow_color;
    _pageControl.pageIndicatorTintColor = [UIColor colorWithRed:204.0f/255.0f green:204.0f/255.0f blue:204.0f/255.0f alpha:1];
    [_pageControl mas_makeConstraints:^(MASConstraintMaker * make){
        make.bottom.equalTo(self.mas_bottom).with.offset(-10);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    itemBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:itemBtn];
    itemBtn.alpha=0.7;
    [itemBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    itemBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
    itemBtn.titleLabel.font=[regular get_en_Font:20.0f];
    itemBtn.backgroundColor=[UIColor whiteColor];
    [itemBtn addTarget:self action:@selector(showItemListAction) forControlEvents:UIControlEventTouchUpInside];
    [itemBtn setTitle:[[NSString alloc] initWithFormat:@"%ld",_detailModel.items.count] forState:UIControlStateNormal];
    [itemBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.and.height.mas_equalTo(@80);
        make.right.and.bottom.mas_equalTo(-20);
    }];
}
-(void)setDetailModel:(DD_CircleListModel *)detailModel
{
    _detailModel=detailModel;
    [self setState];
}
#pragma mark - setState
-(void)setState
{
    [self UIConfig];
}
#pragma  mark-pageViewController代理方法
-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    ImageViewController *vc = (ImageViewController*)viewController;
    NSInteger index = vc.currentPage;
    index ++ ;
    
    ImageViewController *imgvc = [[ImageViewController alloc]initWithSize:CGSizeMake(ScreenWidth, 300) WithBlock:^(NSString *type, NSInteger index) {
        _block(type,index);
    }];
    imgvc.array=_detailModel.pics;
    imgvc.view.backgroundColor = [UIColor clearColor];
    imgvc.maxPage = _detailModel.pics.count-1;
    imgvc.currentPage = index;
    return imgvc;
    
    
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    ImageViewController *vc = (ImageViewController*)viewController;
    NSInteger index = vc.currentPage;
    index -- ;
    
    ImageViewController *imgvc = [[ImageViewController alloc]initWithSize:CGSizeMake(ScreenWidth, 300) WithBlock:^(NSString *type, NSInteger index) {
        _block(type,index);
    }];
    imgvc.array=_detailModel.pics;
    imgvc.view.backgroundColor = [UIColor clearColor];
    imgvc.maxPage =_detailModel.pics.count-1;
    imgvc.currentPage = index;
    
    return imgvc;
    
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    
    ImageViewController *vc =  pageViewController.viewControllers[0];
    _pageControl.currentPage = vc.currentPage;
    return;
}

#pragma mark - SomeAction
/**
 * 跳转当前搭配对应的单品列表
 */
-(void)showItemListAction
{
    _block(@"show_item_list",0);
}
@end