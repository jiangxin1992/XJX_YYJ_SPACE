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
#import "Tools.h"
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
    [self hideBackNavBtn];
    [self PrepareData];
    [self PrepareUI];
}
-(void)PrepareData
{
    CGSize size = [Tools sizeOfStr:@"全部" andFont:[regular getFont:15.0f] andMaxSize:CGSizeMake(999999, 30) andLineBreakMode:NSLineBreakByWordWrapping];
    CGFloat _width=size.width;
    _rect_left=CGRectMake(0, 33, _width, 3);
    _rect_right=CGRectMake(ScreenWidth-2*kEdge-_width, 33, _width, 3);
    btnarr=[[NSMutableArray alloc] init];
}
-(void)PrepareUI
{
    UIView *navview=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth-2*kEdge, kNavigationBarHeight)];
    CGFloat _width=CGRectGetWidth(navview.frame)/2.0f;
    for (int i=0; i<2; i++) {
        UIButton *btn=[UIButton getCustomTitleBtnWithAlignment:i==0?1:2 WithFont:15.0f WithSpacing:0 WithNormalTitle:i==0?@"全部":@"关注" WithNormalColor:_define_light_gray_color1 WithSelectedTitle:i==0?@"全部":@"关注" WithSelectedColor:nil];
        btn.titleLabel.font=[regular getSemiboldFont:15.0f];
        [navview addSubview:btn];
        btn.frame=CGRectMake(_width*i, 0, _width, 33);
        [btn addTarget:self action:@selector(qiehuan:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag=100+i;
        if(i==0)
        {
            btn.selected=YES;
            [btn setEnlargeEdgeWithTop:0 right:0 bottom:0 left:kEdge];
        }else
        {
            [btn setEnlargeEdgeWithTop:0 right:kEdge bottom:0 left:0];
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
            [self presentViewController:[regular alertTitleCancel_Simple:NSLocalizedString(@"login_first", @"") WithBlock:^{
                [self pushLoginView];
            }] animated:YES completion:nil];
        }else
        {
            if(!right)
            {
                right =[[DD_DesignerFollowViewController alloc] initWithBlock:^(DD_DesignerModel *model) {
                    DD_DesignerHomePageViewController *_DesignerHomePage=[[DD_DesignerHomePageViewController alloc] init];
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
