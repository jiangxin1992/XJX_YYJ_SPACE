//
//  DD_UserMainCollectViewController.m
//  DDAY
//
//  Created by yyj on 16/6/13.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_UserMainCollectViewController.h"

#import "DD_DesignerHomePageViewController.h"
#import "DD_TarentoHomePageViewController.h"
#import "DD_GoodsDetailViewController.h"
#import "DD_UserCollectItemViewController.h"
#import "DD_UserCollectCircleViewController.h"
#import "DD_CircleDetailViewController.h"
#import "DD_CircleItemListViewController.h"

#import "DD_OrderItemModel.h"

@interface DD_UserMainCollectViewController ()

@end

@implementation DD_UserMainCollectViewController
{
    UIView *_UpView;
    
//    UIView *dibu_left;
//    UIView *dibu_right;
    
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
    _pageVc.view.frame = CGRectMake(0, CGRectGetMaxY(_UpView.frame), 1000, 1000);
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
    _UpView=[[UIView alloc] initWithFrame:CGRectMake(0, kNavHeight, ScreenWidth, 36)];
    [self.view addSubview:_UpView];
    _UpView.backgroundColor=[UIColor whiteColor];
    
    for (int i=0; i<2; i++) {
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake((ScreenWidth/2.0f)*i, 0, ScreenWidth/2.0f, CGRectGetHeight(_UpView.frame));

        [_UpView addSubview:btn];
        [btn addTarget:self action:@selector(qiehuan:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag=100+i;
        btn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
        NSString *str=i==0?@"发布品":@"共享搭配";
        btn.titleLabel.font=(kIOSVersions>=9.0? [UIFont systemFontOfSize:13.0f]:[UIFont fontWithName:@"Helvetica Neue" size:13.0f]);
        [btn setTitle:str forState:UIControlStateNormal];
        [btn.titleLabel setAttributedText:[regular createAttributeString:str andFloat:@(3.0)]];
        [btn setTitleColor:_define_black_color forState:UIControlStateSelected];
        [btn setTitleColor:_define_light_gray_color1 forState:UIControlStateNormal];
        if(i==0)
        {
            btn.selected=YES;
//            dibu_left=[UIView getCustomViewWithColor:_define_black_color];
//            [btn addSubview:dibu_left];
//            [dibu_left mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.left.mas_equalTo(37);
//                make.bottom.mas_equalTo(0);
//                make.right.mas_equalTo(-20);
//                make.height.mas_equalTo(3);
//            }];
        }else
        {
//            dibu_right=[UIView getCustomViewWithColor:_define_light_gray_color1];
//            [btn addSubview:dibu_right];
//            [dibu_right mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.left.mas_equalTo(20);
//                make.bottom.mas_equalTo(0);
//                make.right.mas_equalTo(-37);
//                make.height.mas_equalTo(3);
//            }];
        }
        [btnarr addObject:btn];
    }
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
            
        }
        [self SetBtnStateWithBtnTag:btn.tag];
    }else if(btn.tag-100==1)
    {
        
        if([[DD_UserModel getToken]isEqualToString:@""])
        {
            [self presentViewController:[regular alertTitleCancel_Simple:NSLocalizedString(@"login_first", @"") WithBlock:^{
                [self pushLoginView];
            }] animated:YES completion:nil];
        }else
        {
            if(!ctn2)
            {
                ctn2 =[[DD_UserCollectCircleViewController alloc] initWithBlock:^(NSString *type, DD_CircleListModel *model,DD_OrderItemModel *item) {
                    if([type isEqualToString:@"push_circle_detail"])
                    {
                        [self.navigationController pushViewController:[[DD_CircleDetailViewController alloc] initWithCircleListModel:model WithShareID:model.shareId IsHomePage:NO  WithBlock:^(NSString *type) {
//                            if([type isEqualToString:@"reload"])
//                            {
//                                [ctn2 reloadData];
//                            }
                        }] animated:YES];
                    }
                }];
            }
            if(currentPage<1)
            {
                [_pageVc setViewControllers:@[ctn2] direction:1 animated:YES completion:nil];
            }
            [self SetBtnStateWithBtnTag:btn.tag];
        }
    }
}
-(void)SetBtnStateWithBtnTag:(NSInteger )btnTag
{
    for (int i=0; i<btnarr.count; i++) {
        UIButton *_btn=[btnarr objectAtIndex:i];
        if(_btn.tag==btnTag)
        {
            _btn.selected=YES;
            currentPage=_btn.tag-100;
//            if(i==0)
//            {
//                dibu_left.backgroundColor=_define_black_color;
//                dibu_right.backgroundColor=_define_light_gray_color1;
//            }else if(i==1)
//            {
//                dibu_left.backgroundColor=_define_light_gray_color1;
//                dibu_right.backgroundColor=_define_black_color;
//            }
        }else
        {
            _btn.selected=NO;
        }
        
    }
}
#pragma mark - Others
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 弃用代码
///**
// * 切换视图
// */
//-(void)qiehuan:(UIButton *)btn
//{
//    if(btn.tag-100==0)
//    {
//        if(currentPage>0)
//        {
//            if(!ctn1)
//            {
//                ctn1=[[DD_UserCollectItemViewController alloc] initWithBlock:^(NSString *type, DD_ItemsModel *model) {
//                    if([type isEqualToString:@"detail"])
//                    {
//                        DD_GoodsDetailViewController *_GoodsDetail=[[DD_GoodsDetailViewController alloc] initWithModel:model WithBlock:^(DD_ItemsModel *model, NSString *type) {
//                            //        if(type)
//                        }];
//                        [self.navigationController pushViewController:_GoodsDetail animated:YES];
//                    }
//                }];
//            }
//            [_pageVc setViewControllers:@[ctn1] direction:0 animated:YES completion:nil];
//            //            [UIView beginAnimations:@"anmationName1" context:nil];
//            //            [UIView setAnimationDuration:0.5];
//            //            [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
//            //            [UIView setAnimationDelegate:self];
//            //            dibu.frame=_rect_left;
//            //            [UIView commitAnimations];
//            
//        }
//        [self SetBtnStateWithBtnTag:btn.tag];
//    }else if(btn.tag-100==1)
//    {
//        
//        if([[DD_UserModel getToken]isEqualToString:@""])
//        {
//            [self presentViewController:[regular alertTitleCancel_Simple:NSLocalizedString(@"login_first", @"") WithBlock:^{
//                [self pushLoginView];
//            }] animated:YES completion:nil];
//        }else
//        {
//            if(!ctn2)
//            {
//                ctn2 =[[DD_UserCollectCircleViewController alloc] initWithBlock:^(NSString *type, DD_CircleListModel *model,DD_OrderItemModel *item) {
//                    //                    if([type isEqualToString:@"push_item_list"])
//                    //                    {
//                    ////                        [self.navigationController pushViewController:[[DD_CircleItemListViewController alloc] initWithShareID:model.shareId WithBlock:^(NSString *type) {
//                    ////
//                    ////                        }] animated:YES];
//                    //                    }else if([type isEqualToString:@"push_circle_detail"])
//                    //                    {
//                    //                        [self.navigationController pushViewController:[[DD_CircleDetailViewController alloc] initWithCircleListModel:model WithShareID:model.shareId IsHomePage:NO  WithBlock:^(NSString *type) {
//                    //                            if([type isEqualToString:@"reload"])
//                    //                            {
//                    ////                                [ctn2 reloadData];
//                    //                            }
//                    //                        }] animated:YES];
//                    //                    }else if([type isEqualToString:@"head_click"])
//                    //                    {
//                    //                        if([model.userType integerValue]==2)
//                    //                        {
//                    //                            //                设计师
//                    //                            DD_DesignerHomePageViewController *_DesignerHomePage=[[DD_DesignerHomePageViewController alloc] init];
//                    //                            _DesignerHomePage.designerId=model.userId;
//                    //                            [self.navigationController pushViewController:_DesignerHomePage animated:YES];
//                    //                        }else if([model.userType integerValue]==4)
//                    //                        {
//                    //                            //                达人
//                    //                            [self.navigationController pushViewController:[[DD_TarentoHomePageViewController alloc] initWithUserId:model.userId] animated:YES];
//                    //                        }else
//                    //                        {
//                    //                            [self presentViewController:[regular alertTitle_Simple:NSLocalizedString(@"no_homepage", @"")] animated:YES completion:nil];
//                    //                        }
//                    //                    }else if([type isEqualToString:@"item_click"])
//                    //                    {
//                    //                        DD_ItemsModel *_item=[[DD_ItemsModel alloc] init];
//                    //                        _item.g_id=item.itemId;
//                    //                        _item.colorId=item.colorId;
//                    //                        _item.colorCode=item.colorCode;
//                    //                        DD_GoodsDetailViewController *_GoodsDetail=[[DD_GoodsDetailViewController alloc] initWithModel:_item WithBlock:^(DD_ItemsModel *model, NSString *type) {
//                    //                            //        if(type)
//                    //                        }];
//                    //                        [self.navigationController pushViewController:_GoodsDetail animated:YES];
//                    //                    }
//                    
//                }];
//            }
//            if(currentPage<1)
//            {
//                [_pageVc setViewControllers:@[ctn2] direction:1 animated:YES completion:nil];
//            }
//            //            [UIView beginAnimations:@"anmationName2" context:nil];
//            //            [UIView setAnimationDuration:0.5];
//            //            [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
//            //            [UIView setAnimationDelegate:self];
//            //            dibu.frame=_rect_right;
//            //            [UIView commitAnimations];
//            [self SetBtnStateWithBtnTag:btn.tag];
//        }
//    }
//}

@end
