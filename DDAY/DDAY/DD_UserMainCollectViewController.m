//
//  DD_UserMainCollectViewController.m
//  DDAY
//
//  Created by yyj on 16/6/13.
//  Copyright © 2016年 YYJ. All rights reserved.
//
#import "DD_GoodsDetailViewController.h"
#import "DD_UserCollectItemViewController.h"
#import "DD_UserCollectCircleViewController.h"
#import "DD_CircleItemListViewController.h"
#import "DD_CircleDetailViewController.h"

#import "DD_UserMainCollectViewController.h"

@interface DD_UserMainCollectViewController ()

@end

@implementation DD_UserMainCollectViewController
{
    UIView *_UpView;
    UIView *dibu;
    
    CGRect _rect_left;
    CGRect _rect_right;
    
    NSInteger currentPage;
    
    DD_UserCollectItemViewController *ctn1;
    DD_UserCollectCircleViewController *ctn2;
    UIPageViewController *_pageVc;
    
    NSMutableArray *btnarr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self SomePrepare];
    [self UIConfig];
}
#pragma mark - SomePrepare
-(void)SomePrepare
{
    [self PrepareData];
    [self PrepareUI];
}
-(void)PrepareData
{
    btnarr=[[NSMutableArray alloc] init];
}
-(void)PrepareUI
{
    self.navigationItem.titleView=[regular returnNavView:NSLocalizedString(@"user_collection", @"") withmaxwidth:200];//设置标题
}
#pragma mark - UIConfig
-(void)UIConfig
{
    [self CreateUpView];
    [self CreatePageViewCtn];
}
-(void)CreatePageViewCtn
{
    _pageVc = [[UIPageViewController alloc]initWithTransitionStyle:1 navigationOrientation:0 options:nil];
    _pageVc.view.frame = CGRectMake(0, CGRectGetMaxY(_UpView.frame)+2, 1000, 1000);
    _pageVc.view.backgroundColor = [UIColor yellowColor];
    if(ctn1==nil)
    {
        ctn1=[[DD_UserCollectItemViewController alloc] initWithBlock:^(NSString *type, DD_ItemsModel *model) {
            if([type isEqualToString:@"detail"])
            {
                DD_GoodsDetailViewController *_GoodsDetail=[[DD_GoodsDetailViewController alloc] initWithModel:model WithBlock:^(DD_ItemsModel *model, NSString *type) {
                    //        if(type)
                }];
                [self.navigationController pushViewController:_GoodsDetail animated:YES];
            }
            
        }];
    }
    [_pageVc setViewControllers:@[ctn1] direction:0 animated:YES completion:nil];
    currentPage=0;
    [self.view addSubview:_pageVc.view];
}
-(void)CreateUpView
{
    _UpView=[[UIView alloc] initWithFrame:CGRectMake(0, 64+2, ScreenWidth, 50)];
    [self.view addSubview:_UpView];
    _UpView.backgroundColor=[UIColor whiteColor];
    
    CGFloat _width=(ScreenWidth-50*2-30)/2.0f;
    for (int i=0; i<2; i++) {
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake(50+(_width+30)*i, 0, _width, CGRectGetHeight(_UpView.frame));
        CGRect _rect=CGRectMake(50+(_width+30)*i, CGRectGetHeight(_UpView.frame)-3, _width, 3);
        if(i==0){
            _rect_left=_rect;
        }else if(i==1){
            _rect_right=_rect;
        }
        [_UpView addSubview:btn];
        [btn addTarget:self action:@selector(qiehuan:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag=100+i;
        btn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
        NSString *str=i==0?@"发布品":@"共享搭配";
        btn.titleLabel.font=(kIOSVersions>=9.0? [UIFont systemFontOfSize:13.0f]:[UIFont fontWithName:@"Helvetica Neue" size:13.0f]);
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
    dibu=[[UIView alloc] initWithFrame:_rect_left];
    dibu.backgroundColor=[UIColor blackColor];
    [_UpView addSubview:dibu];  
}
#pragma mark - SomeAction
/**
 * 切换视图
 */
-(void)qiehuan:(UIButton *)btn
{
    if(btn.tag-100==0)
    {
        if(currentPage>0)
        {
            if(!ctn1)
            {
                ctn1=[[DD_UserCollectItemViewController alloc] initWithBlock:^(NSString *type, DD_ItemsModel *model) {
                    if([type isEqualToString:@"detail"])
                    {
                        DD_GoodsDetailViewController *_GoodsDetail=[[DD_GoodsDetailViewController alloc] initWithModel:model WithBlock:^(DD_ItemsModel *model, NSString *type) {
                            //        if(type)
                        }];
                        [self.navigationController pushViewController:_GoodsDetail animated:YES];
                    }
                }];
            }
            [_pageVc setViewControllers:@[ctn1] direction:0 animated:YES completion:nil];
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
            if(!ctn2)
            {
                ctn2 =[[DD_UserCollectCircleViewController alloc] initWithBlock:^(NSString *type, DD_CircleListModel *model) {
                    if([type isEqualToString:@"push_item_list"])
                    {
                        [self.navigationController pushViewController:[[DD_CircleItemListViewController alloc] initWithShareID:model.shareId WithBlock:^(NSString *type) {
                    
                        }] animated:YES];
                    }else if([type isEqualToString:@"push_circle_detail"])
                    {
                        [self.navigationController pushViewController:[[DD_CircleDetailViewController alloc] initWithCircleListModel:model WithShareID:model.shareId WithBlock:^(NSString *type) {
                            if([type isEqualToString:@"reload"])
                            {
                                [ctn2 reloadData];
                                [[NSNotificationCenter defaultCenter] postNotificationName:@"getChangeNot" object:nil];
                            }
                        }] animated:YES];
                    }
                    
                }];
            }
            if(currentPage<1)
            {
                [_pageVc setViewControllers:@[ctn2] direction:1 animated:YES completion:nil];
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
    [[DD_CustomViewController sharedManager] tabbarHide];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
