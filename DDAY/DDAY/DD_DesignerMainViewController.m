//
//  DD_DesignerMainViewController.m
//  DDAY
//
//  Created by yyj on 16/6/12.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_DesignerMainViewController.h"

#import "DD_DesignerViewController.h"
#import "DD_DesignerFollowViewController.h"
#import "DD_DesignerHomePageViewController.h"
#import "DD_CustomViewController.h"

#import "DD_DesignerModel.h"

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
//    UIImageView *view=[[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth-200)/2.0f, (ScreenHeight-200)/2.0f, 200, 200)];
//    [self.view addSubview:view];
//    view.image=[UIImage imageNamed:@"start_icon.jpg"];
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RootChangeAction:) name:@"rootChange" object:nil];
    CGFloat _width=[regular getWidthWithHeight:40 WithContent:@"全部" WithFont:[regular getSemiboldFont:18.0f]];
    _rect_left=CGRectMake(0, kNavigationBarHeight-4, _width, 4);
    _rect_right=CGRectMake(ScreenWidth-2*kEdge-_width, kNavigationBarHeight-4, _width, 4);
    btnarr=[[NSMutableArray alloc] init];
}
-(void)PrepareUI
{
//    UIView *navview=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth-2*kEdge, kNavigationBarHeight)];
//    CGFloat _width=[regular getWidthWithHeight:40 WithContent:@"全部" WithFont:[regular getSemiboldFont:18.0f]];
//    for (int i=0; i<2; i++) {
//        UIButton *btn=[UIButton getCustomTitleBtnWithAlignment:i==0?1:2 WithFont:18.0f WithSpacing:0 WithNormalTitle:i==0?@"全部":@"关注" WithNormalColor:_define_light_gray_color1 WithSelectedTitle:i==0?@"全部":@"关注" WithSelectedColor:nil];
//        [navview addSubview:btn];
//        btn.titleLabel.font=[regular getSemiboldFont:18.0f];
//        [btn setEnlargeEdge:20];
//        btn.frame=CGRectMake((CGRectGetWidth(navview.frame)-_width)*i, 0, _width, kNavigationBarHeight-4);
//        [btn addTarget:self action:@selector(qiehuan:) forControlEvents:UIControlEventTouchUpInside];
//        btn.tag=100+i;
//        if(i==0)
//        {
//            btn.selected=YES;
//            [btn setEnlargeEdgeWithTop:0 right:0 bottom:0 left:kEdge];
//        }else
//        {
//            [btn setEnlargeEdgeWithTop:0 right:kEdge bottom:0 left:0];
//        }
//        [btnarr addObject:btn];
//    }
//    UIView *titleView = [regular returnNavView:NSLocalizedString(@"designer_title", @"") withmaxwidth:130];
//    [navview addSubview:titleView];
//    titleView.frame=CGRectMake((CGRectGetWidth(navview.frame)-130)/2.0f, 0, 130, kNavigationBarHeight);
//    
//    self.navigationItem.titleView=navview;
//    dibu=[[UIView alloc] initWithFrame:_rect_left];
//    dibu.backgroundColor=_define_black_color;
//    [navview addSubview:dibu];
    
    self.navigationItem.titleView=[regular returnNavView:NSLocalizedString(@"designer_title", @"") withmaxwidth:100];
//    designer_follow_title
    DD_NavBtn *allBtn=[DD_NavBtn getNavBtnIsLeft:YES WithSize:CGSizeMake(23, 23) WithImgeStr:@"Designer_All"];
//    [allBtn addTarget:self action:@selector(qiehuan:) forControlEvents:UIControlEventTouchUpInside];
    allBtn.tag=100;
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:allBtn];
    [allBtn bk_addEventHandler:^(id sender) {
        [self qiehuan:allBtn];
    } forControlEvents:UIControlEventTouchUpInside];
    [btnarr addObject:allBtn];
    
    DD_NavBtn *followBtn=[DD_NavBtn getNavBtnIsLeft:NO WithSize:CGSizeMake(34, 19) WithImgeStr:@"Designer_Eyes"];
//    [followBtn addTarget:self action:@selector(qiehuan:) forControlEvents:UIControlEventTouchUpInside];
    followBtn.tag=101;
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:followBtn];
    [followBtn bk_addEventHandler:^(id sender) {
        [self qiehuan:followBtn];
    } forControlEvents:UIControlEventTouchUpInside];
    [btnarr addObject:followBtn];
    
}
#pragma mark - UIConfig

-(void)CreatePageView
{
    _pageVc = [[UIPageViewController alloc]initWithTransitionStyle:1 navigationOrientation:0 options:nil];
    _pageVc.view.frame = CGRectMake(0, 0, 1000 , 1000 );
    _pageVc.view.backgroundColor=_define_white_color;
    if(left==nil)
    {
        left=[[DD_DesignerViewController alloc] initWithBlock:^(NSString *type ,DD_DesignerModel *model) {
            if([type isEqualToString:@"login"])
            {
                [self presentViewController:[regular alertTitleCancel_Simple:NSLocalizedString(@"login_first", @"") WithBlock:^{
                    [self pushLoginView];
                }] animated:YES completion:nil];
            }else if([type isEqualToString:@"select"]||[type isEqualToString:@"click"])
            {
                DD_DesignerHomePageViewController *_DesignerHomePage=[[DD_DesignerHomePageViewController alloc] init];
                _DesignerHomePage.designerId=model.designerId;
                [self.navigationController pushViewController:_DesignerHomePage animated:YES];
                [[DD_CustomViewController sharedManager] tabbarHide];
            }
            
        }];
    }
    [_pageVc setViewControllers:@[left] direction:0 animated:YES completion:nil];
    currentPage=0;
    [self.view addSubview:_pageVc.view];
}
#pragma mark - SomeAction
-(void)RootChangeAction:(NSNotification *)not
{
    if([not.object isEqualToString:@"logout"]||[not.object isEqualToString:@"login"])
    {
        for (UIButton *_btn in btnarr) {
            _btn.selected=NO;
            if(_btn.tag==100)
            {
                _btn.selected=YES;
                currentPage=_btn.tag-100;
            }
        }
        [_pageVc setViewControllers:@[left] direction:0 animated:YES completion:nil];
        dibu.frame=_rect_left;
    }
}
-(void)qiehuan:(UIButton *)btn
{
    if(btn.tag-100==0)
    {
        if(currentPage>0)
        {
            self.navigationItem.titleView=[regular returnNavView:NSLocalizedString(@"designer_title", @"") withmaxwidth:100];
            if(!left)
            {
                left=[[DD_DesignerViewController alloc] initWithBlock:^(NSString *type,DD_DesignerModel *model) {
                    if([type isEqualToString:@"login"])
                    {
                        [self presentViewController:[regular alertTitleCancel_Simple:NSLocalizedString(@"login_first", @"") WithBlock:^{
                            [self pushLoginView];
                        }] animated:YES completion:nil];
                    }else if([type isEqualToString:@"select"]||[type isEqualToString:@"click"])
                    {
                        DD_DesignerHomePageViewController *_DesignerHomePage=[[DD_DesignerHomePageViewController alloc] init];
                        _DesignerHomePage.designerId=model.designerId;
                        [self.navigationController pushViewController:_DesignerHomePage animated:YES];
                        [[DD_CustomViewController sharedManager] tabbarHide];
                    }
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
            self.navigationItem.titleView=[regular returnNavView:NSLocalizedString(@"designer_follow_title", @"") withmaxwidth:100];
            if(!right)
            {
                right =[[DD_DesignerFollowViewController alloc] initWithBlock:^(NSString *type ,DD_DesignerModel *model) {
                    if([type isEqualToString:@"login"])
                    {
                        [self presentViewController:[regular alertTitleCancel_Simple:NSLocalizedString(@"login_first", @"") WithBlock:^{
                            [self pushLoginView];
                        }] animated:YES completion:nil];
                    }else
                    {
                        DD_DesignerHomePageViewController *_DesignerHomePage=[[DD_DesignerHomePageViewController alloc] init];
                        _DesignerHomePage.designerId=model.designerId;
                        [self.navigationController pushViewController:_DesignerHomePage animated:YES];
                        [[DD_CustomViewController sharedManager] tabbarHide];
                    }
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
