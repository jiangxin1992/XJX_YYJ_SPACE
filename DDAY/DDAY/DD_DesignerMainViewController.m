//
//  DD_DesignerMainViewController.m
//  DDAY
//
//  Created by yyj on 16/6/12.
//  Copyright © 2016年 YYJ. All rights reserved.
//
#import "GeTuiSdk.h"
#import "DD_DesignerMainViewController.h"
#import "DD_DesignerViewController.h"
#import "DD_DesignerFollowViewController.h"
#import "DD_DesignerHomePageViewController.h"
@interface DD_DesignerMainViewController ()

@end

@implementation DD_DesignerMainViewController
{
    UIPageViewController *_pageVc;
    NSInteger currentPage;
    DD_DesignerViewController *left;
    DD_DesignerFollowViewController *right;
    UIView *dibu;
    NSMutableArray *btnarr;
    CGRect _rect_left;
    CGRect _rect_right;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self SomePrepare];
    [self CreatePageView];
}
#pragma mark - SomePrepare
-(void)SomePrepare
{
    [self PrepareData];
    [self PrepareUI];
}
-(void)PrepareData
{
    _rect_left=CGRectMake(0, 39, 100, 3);
    _rect_right=CGRectMake(150, 39, 100, 3);
    btnarr=[[NSMutableArray alloc] init];
}
-(void)PrepareUI
{
    UIView *navview=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 250, 44)];
    for (int i=0; i<2; i++) {
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake((CGRectGetWidth(navview.frame)-100)*i, 0, 100, CGRectGetHeight(navview.frame));
        [navview addSubview:btn];
        [btn addTarget:self action:@selector(qiehuan:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag=100+i;
        btn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
        NSString *str=i==0?@"所有设计师":@"我关注的";
        btn.titleLabel.font=(kIOSVersions>=9.0? [UIFont systemFontOfSize:16.0f]:[UIFont fontWithName:@"Helvetica Neue" size:16.0f]);
        [btn setTitle:str forState:UIControlStateNormal];
        [btn.titleLabel setAttributedText:[regular createAttributeString:str andFloat:@(3.0)]];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        if(i==0)
        {
            btn.selected=YES;
        }
        [btnarr addObject:btn];
    }
    self.navigationItem.titleView=navview;
    dibu=[[UIView alloc] initWithFrame:_rect_left];
    dibu.backgroundColor=[UIColor blackColor];
    [navview addSubview:dibu];
}
#pragma mark - UIConfig

-(void)CreatePageView
{
    _pageVc = [[UIPageViewController alloc]initWithTransitionStyle:1 navigationOrientation:0 options:nil];
    _pageVc.view.frame = CGRectMake(0, 0, 1000 , 1000 );
    _pageVc.view.backgroundColor=[UIColor whiteColor];
    if(left==nil)
    {
        left=[[DD_DesignerViewController alloc] initWithBlock:^(DD_DesignerModel *model) {
            DD_DesignerHomePageViewController *_DesignerHomePage=[[DD_DesignerHomePageViewController alloc] init];
            _DesignerHomePage.title=model.name;
            _DesignerHomePage.designerId=model.designerId;
            [self.navigationController pushViewController:_DesignerHomePage animated:YES];
            [[DD_CustomViewController sharedManager] tabbarHide];
        }];
    }
    [_pageVc setViewControllers:@[left] direction:0 animated:YES completion:nil];
    currentPage=0;
    [self.view addSubview:_pageVc.view];
}
#pragma mark - SomeAction
-(void)qiehuan:(UIButton *)btn
{
    if(btn.tag-100==0)
    {
        if(currentPage>0)
        {
            if(!left)
            {
                left=[[DD_DesignerViewController alloc] initWithBlock:^(DD_DesignerModel *model) {
                    DD_DesignerHomePageViewController *_DesignerHomePage=[[DD_DesignerHomePageViewController alloc] init];
                    _DesignerHomePage.title=model.name;
                    _DesignerHomePage.designerId=model.designerId;
                    [self.navigationController pushViewController:_DesignerHomePage animated:YES];
                    [[DD_CustomViewController sharedManager] tabbarHide];
                }];
            }
            [_pageVc setViewControllers:@[left] direction:0 animated:YES completion:nil];
            [UIView beginAnimations:@"anmationName1" context:nil];
            [UIView setAnimationDuration:0.5];
            [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
            [UIView setAnimationDelegate:self];
            dibu.frame=_rect_left;
            [UIView commitAnimations];
        }
        
        for (UIButton *_btn in btnarr) {
            _btn.selected=NO;
            if(_btn.tag==btn.tag)
            {
                _btn.selected=YES;
                currentPage=_btn.tag-100;
            }
        }
    }else if(btn.tag-100==1)
    {
        
        if([[DD_UserModel getToken]isEqualToString:@""])
        {
            [self presentViewController:[regular alertTitle_Simple:NSLocalizedString(@"login_first", @"")] animated:YES completion:nil];
        }else
        {
            if(!right)
            {
                right =[[DD_DesignerFollowViewController alloc] initWithBlock:^(DD_DesignerModel *model) {
                    DD_DesignerHomePageViewController *_DesignerHomePage=[[DD_DesignerHomePageViewController alloc] init];
                    _DesignerHomePage.title=model.name;
                    _DesignerHomePage.designerId=model.designerId;
                    [self.navigationController pushViewController:_DesignerHomePage animated:YES];
                    [[DD_CustomViewController sharedManager] tabbarHide];
                }];
            }
            if(currentPage<1)
            {
                [_pageVc setViewControllers:@[right] direction:1 animated:YES completion:nil];
            }
            [UIView beginAnimations:@"anmationName2" context:nil];
            [UIView setAnimationDuration:0.5];
            [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
            [UIView setAnimationDelegate:self];
            dibu.frame=_rect_right;
            [UIView commitAnimations];
            for (UIButton *_btn in btnarr) {
                _btn.selected=NO;
                if(_btn.tag==btn.tag)
                {
                    _btn.selected=YES;
                    currentPage=_btn.tag-100;
                }
            }
        }
    }
}
#pragma mark - Others
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[DD_CustomViewController sharedManager] tabbarAppear];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
