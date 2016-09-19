//
//  DD_DesignerHomePageViewController.m
//  DDAY
//
//  Created by yyj on 16/5/22.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_DesignerHomePageViewController.h"

#import "DD_TarentoHomePageViewController.h"
#import "DD_CircleDetailViewController.h"
#import "DD_DesignerItemViewController.h"
#import "DD_DesignerCircleViewController.h"
#import "DD_DesignerIntroViewController.h"
#import "DD_GoodsDetailViewController.h"

#import "DD_ShareView.h"

#import "DD_ShareTool.h"
#import "DD_DesignerModel.h"

@interface DD_DesignerHomePageViewController ()

@end

@implementation DD_DesignerHomePageViewController
{
    DD_DesignerModel *_DesignerModel;
    
    
    UIView *_UpView;
    UIView *_MiddleView;
    
    NSMutableArray *btnarr;
    
    NSInteger currentPage;
    
    DD_DesignerItemViewController *ctn1;
    DD_DesignerIntroViewController *ctn2;
    DD_DesignerCircleViewController *ctn3;
    
    UIPageViewController *_pageVc;
    UIButton *followBtn;
    
    DD_ShareView *shareView;
    UIImageView *mengban;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self SomePrepare];
    [self RequestData];
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
    
    DD_NavBtn *backBtn=[DD_NavBtn getNavBtnWithSize:CGSizeMake(11, 19) WithImgeStr:@"System_Back"];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kStatusBarHeight);
        make.width.height.mas_equalTo(44);
        make.left.mas_equalTo(0);
    }];
    
//    DD_NavBtn *shareBtn=[DD_NavBtn getNavBtnWithSize:CGSizeMake(25, 25) WithImgeStr:@"System_share"];
//    [shareBtn addTarget:self action:@selector(ShareAction) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:shareBtn];
//    [shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(kStatusBarHeight);
//        make.right.mas_equalTo(0);
//        make.width.height.mas_equalTo(44);
//    }];
    
    DD_UserModel *user=[DD_UserModel getLocalUserInfo];
    if(![_designerId isEqualToString:user.u_id])
    {
        followBtn=[UIButton getCustomTitleBtnWithAlignment:0 WithFont:15.0f WithSpacing:0 WithNormalTitle:@"关注" WithNormalColor:_define_white_color WithSelectedTitle:@"已关注" WithSelectedColor:_define_black_color];
        [self.view addSubview:followBtn];
        [regular setBorder:followBtn];
        [followBtn addTarget:self action:@selector(followAction) forControlEvents:UIControlEventTouchUpInside];
        [followBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.centerY.mas_equalTo(backBtn);
            make.width.mas_equalTo(70);
            make.height.mas_equalTo(25);
        }];
    }else
    {
        UIView *titleView=[regular returnNavView:NSLocalizedString(@"user_home_page", @"") withmaxwidth:140];
        [self.view addSubview:titleView];
        [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(140);
            make.height.mas_equalTo(44);
            make.centerX.mas_equalTo(self.view);
            make.top.mas_equalTo(self.view.mas_top).with.offset(kStatusBarHeight);
        }];
    }
    
}
#pragma mark - RequestData
-(void)RequestData
{
    [[JX_AFNetworking alloc] GET:@"designer/queryDesignerDetail.do" parameters:@{@"token":[DD_UserModel getToken],@"designerId":_designerId} success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
        if(success)
        {
            _DesignerModel=[DD_DesignerModel getDesignerModel:data];
            if(_DesignerModel.guanzhu)
            {
                followBtn.selected=YES;
                followBtn.backgroundColor=_define_white_color;
            }else
            {
                followBtn.selected=NO;
                followBtn.backgroundColor=_define_black_color;
            }
            [self SetUpView];
        }else
        {
            [self presentViewController:successAlert animated:YES completion:nil];
        }
    } failure:^(NSError *error, UIAlertController *failureAlert) {
        [self presentViewController:failureAlert animated:YES completion:nil];
    }];
}
#pragma mark - UIConfig
-(void)UIConfig
{
    [self CreateUpView];
    [self CreateMiddleView];
    [self CreatePageViewCtn];
}
-(void)CreateUpView
{
    _UpView=[UIView getCustomViewWithColor:nil];
    [self.view addSubview:_UpView];
    [_UpView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kNavHeight);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(145);
    }];
}
-(void)CreateMiddleView
{
    _MiddleView=[UIView getCustomViewWithColor:nil];
    [self.view addSubview:_MiddleView];
    _MiddleView.backgroundColor=_define_white_color;
    [_MiddleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_UpView.mas_bottom).with.offset(0);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(28);
    }];
    
    UIView *upline=[UIView getCustomViewWithColor:_define_black_color];
    [_MiddleView addSubview:upline];
    [upline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(2);
    }];

    
    UIButton *lastview=nil;
    for (int i=0; i<3; i++) {
        UIButton *btn=[UIButton getCustomTitleBtnWithAlignment:0 WithFont:15.0f WithSpacing:0 WithNormalTitle:i==0?@"发布品":i==1?@"故事":@"共享" WithNormalColor:_define_black_color WithSelectedTitle:i==0?@"发布品":i==1?@"故事":@"共享" WithSelectedColor:_define_white_color];
        [_MiddleView addSubview:btn];
        [btn addTarget:self action:@selector(qiehuan:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag=100+i;
        btn.titleLabel.font=[regular getFont:15];
        [btn setEnlargeEdgeWithTop:0 right:0 bottom:2 left:0];
        btn.backgroundColor= _define_clear_color;
        if(i==0)
        {
            btn.selected=YES;
            btn.backgroundColor=_define_black_color;
        }
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(_MiddleView.mas_bottom).with.offset(-2);
            if(lastview)
            {
                make.left.mas_equalTo(lastview.mas_right).with.offset(kEdge);
                make.width.mas_equalTo(lastview);
            }else
            {
                make.left.mas_equalTo(kEdge);
            }
            if(i==2)
            {
                make.right.mas_equalTo(-kEdge);
            }
        }];
        [btnarr addObject:btn];
        lastview=btn;
    }
    
}
-(void)CreatePageViewCtn
{
    _pageVc = [[UIPageViewController alloc]initWithTransitionStyle:1 navigationOrientation:0 options:nil];
    _pageVc.view.frame = CGRectMake(0, 171+kNavHeight, 1000, 1000);
    if(ctn1==nil)
    {
        ctn1=[[DD_DesignerItemViewController alloc] initWithDesignerID:_designerId WithBlock:^(NSString *type, DD_ItemsModel *model) {
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
#pragma mark - SomeAction
-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
//蒙板消失
-(void)mengban_dismiss
{
    [UIView animateWithDuration:0.5 animations:^{
        shareView.frame=CGRectMake(0, ScreenHeight, ScreenWidth, CGRectGetHeight(shareView.frame));
    } completion:^(BOOL finished) {
        [mengban removeFromSuperview];
        mengban=nil;
    }];
    
}
//分享
-(void)ShareAction
{
    
    mengban=[UIImageView getMaskImageView];
    [self.view addSubview:mengban];
    [mengban addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mengban_dismiss)]];
    
    shareView=[[DD_ShareView alloc] initWithTitle:@"hi 我是标题君" Content:@"我也不知道分享什么" WithImg:@"System_Fans" WithUrl:@"https://appsto.re/cn/9EOHcb.i" WithBlock:^(NSString *type) {
        if([type isEqualToString:@"cancel"])
        {
            [self mengban_dismiss];
        }
    }];
    [mengban addSubview:shareView];
    
    CGFloat _height=[DD_ShareTool getHeight];
    shareView.frame=CGRectMake(0, ScreenHeight, ScreenWidth, _height);
    [UIView animateWithDuration:0.5 animations:^{
        shareView.frame=CGRectMake(0, ScreenHeight-CGRectGetHeight(shareView.frame), ScreenWidth, CGRectGetHeight(shareView.frame));
    }];
    
}
/**
 * 切换视图
 */
-(void)qiehuan:(UIButton *)btn
{
    
    if(btn.tag-100==0)
    {
        if(currentPage>0)
        {
            if(ctn1==nil)
            {
                ctn1=[[DD_DesignerItemViewController alloc] initWithDesignerID:_designerId WithBlock:^(NSString *type, DD_ItemsModel *model) {
                    if([type isEqualToString:@"detail"])
                    {
                        DD_GoodsDetailViewController *_GoodsDetail=[[DD_GoodsDetailViewController alloc] initWithModel:model WithBlock:^(DD_ItemsModel *model, NSString *type) {
                            //        if(type)
                        }];
                        [self.navigationController pushViewController:_GoodsDetail animated:YES];
                    }
                }];
                
            }
            [_pageVc setViewControllers:@[ctn1] direction:1 animated:YES completion:nil];
            
        }
        
    }else if(btn.tag-100==1)
    {
        
        if(currentPage>1)
        {
            if(ctn2==nil)
            {
                ctn2=[[DD_DesignerIntroViewController alloc] initWithDesignerID:_designerId WithBlock:^(NSString *type) {
                    
                }];
            }
            
            [_pageVc setViewControllers:@[ctn2] direction:1 animated:YES completion:nil];
            
        }else if(currentPage<1)
        {
            if(ctn2==nil)
            {
                ctn2=[[DD_DesignerIntroViewController alloc] initWithDesignerID:_designerId WithBlock:^(NSString *type) {
                    
                }];
                
            }
            [_pageVc setViewControllers:@[ctn2] direction:0 animated:YES completion:nil];
        }
        
        
    }else if(btn.tag-100==2)
    {
        if(ctn3==nil)
        {
            ctn3=[[DD_DesignerCircleViewController alloc] initWithDesignerID:_designerId WithBlock:^(NSString *type, DD_CircleListModel *listModel) {
                if([type isEqualToString:@"head_click"])
                {
                    if([_DesignerModel.userType integerValue]==2)
                    {
                        //                设计师
                        DD_DesignerHomePageViewController *_DesignerHomePage=[[DD_DesignerHomePageViewController alloc] init];
                        _DesignerHomePage.designerId=_DesignerModel.designerId;
                        [self.navigationController pushViewController:_DesignerHomePage animated:YES];
                    }else if([_DesignerModel.userType integerValue]==4)
                    {
                        //                达人
                        [self.navigationController pushViewController:[[DD_TarentoHomePageViewController alloc] initWithUserId:_DesignerModel.designerId] animated:YES];
                    }else
                    {
                        [self presentViewController:[regular alertTitle_Simple:NSLocalizedString(@"no_homepage", @"")] animated:YES completion:nil];
                    }
                }else if([type isEqualToString:@"push_comment"])
                {
                    [self.navigationController pushViewController:[[DD_CircleDetailViewController alloc] initWithCircleListModel:listModel WithShareID:listModel.shareId IsHomePage:YES  WithBlock:^(NSString *type) {
                        if([type isEqualToString:@"reload"])
                        {
                            [ctn3 reloadData];
                        }
                    }] animated:YES];
                }
                
            }];
        }
        if(currentPage<2&&ctn3!=nil)
        {
            [_pageVc setViewControllers:@[ctn3] direction:0 animated:YES completion:nil];
        }
        
    }
    
    for (UIButton *_btn in btnarr) {
        if(_btn.tag==btn.tag)
        {
            _btn.selected=YES;
            _btn.backgroundColor=_define_black_color;
            currentPage=_btn.tag-100;
        }else
        {
            _btn.selected=NO;
            _btn.backgroundColor= _define_clear_color;
        }
    }
    
}
/**
 * 设置upview
 */
-(void)SetUpView
{
    for (int i=0; i<2; i++) {

        UIImageView *imageView=[UIImageView getCornerRadiusImg];
        [_UpView addSubview:imageView];
        imageView.contentMode=i==0?2:1;
        if(i==0)
        {
            [imageView JX_ScaleAspectFill_loadImageUrlStr:i==0?_DesignerModel.head:_DesignerModel.brandIcon WithSize:400 placeHolderImageName:nil radius:30];
        }else
        {
            [imageView JX_ScaleAspectFit_loadImageUrlStr:i==0?_DesignerModel.head:_DesignerModel.brandIcon WithSize:400 placeHolderImageName:nil radius:30];
        }
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            if(i==0)
            {
                make.right.mas_equalTo(_UpView.mas_centerX).with.offset(-39);
            }else
            {
                make.left.mas_equalTo(_UpView.mas_centerX).with.offset(39);
            }
            make.top.mas_equalTo(10);
            make.height.width.mas_equalTo(60);
        }];

        UILabel *label=[UILabel getLabelWithAlignment:1 WithTitle:i==0?_DesignerModel.name:_DesignerModel.brandName WithFont:15.0f WithTextColor:nil WithSpacing:0];
        [_UpView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(imageView.mas_bottom).with.offset(11);
            make.centerX.mas_equalTo(imageView);
        }];
        [label sizeToFit];
    }
}
/**
 * 关注取消关注
 */
-(void)followAction
{
    if(![DD_UserModel isLogin])
    {
        [self presentViewController:[regular alertTitleCancel_Simple:NSLocalizedString(@"login_first", @"") WithBlock:^{
            [self pushLoginView];
        }] animated:YES completion:nil];
    }else
    {
        NSString *url=nil;
        if(_DesignerModel.guanzhu)
        {
            //            取消关注
            url=@"designer/unCareDesigner.do";
        }else
        {
            //            关注
            url=@"designer/careDesigner.do";
        }
        [[JX_AFNetworking alloc] GET:url parameters:@{@"token":[DD_UserModel getToken],@"designerId":_DesignerModel.designerId} success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
            if(success)
            {
                _DesignerModel.guanzhu=[[data objectForKey:@"guanzhu"] boolValue];
                if(_DesignerModel.guanzhu)
                {
                    followBtn.selected=YES;
                    followBtn.backgroundColor=_define_white_color;
                }else
                {
                    followBtn.selected=NO;
                    followBtn.backgroundColor=_define_black_color;
                }
                
            }else
            {
                [self presentViewController:successAlert animated:YES completion:nil];
            }
        } failure:^(NSError *error, UIAlertController *failureAlert) {
            [self presentViewController:failureAlert animated:YES completion:nil];
        }];
    }
}
#pragma mark - Other
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
