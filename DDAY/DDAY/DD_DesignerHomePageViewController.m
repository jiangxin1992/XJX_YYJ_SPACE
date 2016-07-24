//
//  DD_DesignerHomePageViewController.m
//  DDAY
//
//  Created by yyj on 16/5/22.
//  Copyright © 2016年 YYJ. All rights reserved.
//
#import "DD_CircleDetailViewController.h"
#import "DD_DesignerItemViewController.h"
#import "DD_DesignerCircleViewController.h"
#import "DD_DesignerIntroViewController.h"
#import "DD_DesignerModel.h"
#import "DD_DesignerHomePageViewController.h"
#import "DD_GoodsDetailViewController.h"
@interface DD_DesignerHomePageViewController ()

@end

@implementation DD_DesignerHomePageViewController
{
    DD_DesignerModel *_DesignerModel;
    
    UIButton *right_btn;
    
    UIView *_UpView;
    UIView *_MiddleView;
    UIView *dibu;
    NSMutableArray *btnarr;
    
    NSInteger currentPage;
    
    CGRect _rect_left;
    CGRect _rect_middle;
    CGRect _rect_right;
    
    DD_DesignerItemViewController *ctn1;
    DD_DesignerCircleViewController *ctn2;
    DD_DesignerIntroViewController *ctn3;
    
    UIPageViewController *_pageVc;
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
    DD_UserModel *user=[DD_UserModel getLocalUserInfo];
    if(![_designerId isEqualToString:user.u_id])
    {
        right_btn=[UIButton buttonWithType:UIButtonTypeCustom];
        right_btn.frame=CGRectMake(0, 0, 40, 30);
        right_btn.titleLabel.font=[regular getFont:13.0f];
        [right_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [right_btn addTarget:self action:@selector(followAction) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:right_btn];
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
                [right_btn setTitle:@"已关注" forState:UIControlStateNormal];
            }else
            {
                [right_btn setTitle:@"关注" forState:UIControlStateNormal];
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
    _UpView=[[UIView alloc] initWithFrame:CGRectMake(0, kNavHeight, ScreenWidth, 170)];
    [self.view addSubview:_UpView];
    _UpView.backgroundColor=[UIColor whiteColor];
}
-(void)CreateMiddleView
{
    _MiddleView=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_UpView.frame)+2, ScreenWidth, 50)];
    [self.view addSubview:_MiddleView];
    _MiddleView.backgroundColor=[UIColor whiteColor];
    
    CGFloat _width=(ScreenWidth-50*2-30*2)/3.0f;
    for (int i=0; i<3; i++) {
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake(50+(_width+30)*i, 0, _width, CGRectGetHeight(_MiddleView.frame));
        CGRect _rect=CGRectMake(50+(_width+30)*i, CGRectGetHeight(_MiddleView.frame)-3, _width, 3);
        if(i==0){
            _rect_left=_rect;
        }else if(i==1){
            _rect_middle=_rect;
        }else if(i==2){
            _rect_right=_rect;
        }
        [_MiddleView addSubview:btn];
        [btn addTarget:self action:@selector(qiehuan:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag=100+i;
        btn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
        NSString *str=i==0?@"发布品":i==1?@"共享":@"故事";
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
    [_MiddleView addSubview:dibu];
    
}
-(void)CreatePageViewCtn
{
    _pageVc = [[UIPageViewController alloc]initWithTransitionStyle:1 navigationOrientation:0 options:nil];
    _pageVc.view.frame = CGRectMake(0, CGRectGetMaxY(_MiddleView.frame)+2, 1000, 1000);
    _pageVc.view.backgroundColor = [UIColor yellowColor];
    if(ctn1==nil)
    {
        ctn1=[[DD_DesignerItemViewController alloc] initWithDesignerID:_designerId WithBlock:^(NSString *type, DD_ItemsModel *model) {
            if([type isEqualToString:@"detail"])
            {
                DD_GoodsDetailViewController *_GoodsDetail=[[DD_GoodsDetailViewController alloc] initWithModel:model WithBlock:^(DD_ItemsModel *model, NSString *type) {
                    //        if(type)
                }];
                _GoodsDetail.title=model.name;
                [self.navigationController pushViewController:_GoodsDetail animated:YES];
            }
        }];
    }
    [_pageVc setViewControllers:@[ctn1] direction:0 animated:YES completion:nil];
    currentPage=0;
    [self.view addSubview:_pageVc.view];
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
            if(ctn1==nil)
            {
                ctn1=[[DD_DesignerItemViewController alloc] initWithDesignerID:_designerId WithBlock:^(NSString *type, DD_ItemsModel *model) {
                    if([type isEqualToString:@"detail"])
                    {
                        DD_GoodsDetailViewController *_GoodsDetail=[[DD_GoodsDetailViewController alloc] initWithModel:model WithBlock:^(DD_ItemsModel *model, NSString *type) {
                            //        if(type)
                        }];
                        _GoodsDetail.title=model.name;
                        [self.navigationController pushViewController:_GoodsDetail animated:YES];
                    }
                }];
                
            }
            [_pageVc setViewControllers:@[ctn1] direction:1 animated:YES completion:nil];
            [UIView beginAnimations:@"anmationName1" context:nil];
            [UIView setAnimationDuration:0.5];
            [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
            [UIView setAnimationDelegate:self];
            dibu.frame=_rect_left;
            [UIView commitAnimations];
            
        }
        
    }else if(btn.tag-100==1)
    {
        
        if(currentPage>1)
        {
            if(ctn2==nil)
            {
                ctn2=[[DD_DesignerCircleViewController alloc] initWithDesignerID:_designerId WithBlock:^(NSString *type, DD_CircleListModel *listModel) {
                        [self.navigationController pushViewController:[[DD_CircleDetailViewController alloc] initWithCircleListModel:listModel WithShareID:listModel.shareId WithBlock:^(NSString *type) {
                            if([type isEqualToString:@"reload"])
                            {
                                [ctn2 reloadData];
                            }
                        }] animated:YES];
                }];
            }
            
            [_pageVc setViewControllers:@[ctn2] direction:1 animated:YES completion:nil];
            [UIView beginAnimations:@"anmationName1" context:nil];
            [UIView setAnimationDuration:0.5];
            [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
            [UIView setAnimationDelegate:self];
            dibu.frame=_rect_middle;
            [UIView commitAnimations];
            
        }else if(currentPage<1)
        {
            if(ctn2==nil)
            {
                ctn2=[[DD_DesignerCircleViewController alloc] initWithDesignerID:_designerId WithBlock:^(NSString *type, DD_CircleListModel *listModel) {
                    
                    [self.navigationController pushViewController:[[DD_CircleDetailViewController alloc] initWithCircleListModel:listModel WithShareID:listModel.shareId WithBlock:^(NSString *type) {
                        if([type isEqualToString:@"reload"])
                        {
                            [ctn2 reloadData];
                        }
                    }] animated:YES];
                }];
            }
            [_pageVc setViewControllers:@[ctn2] direction:0 animated:YES completion:nil];
            [UIView beginAnimations:@"anmationName1" context:nil];
            [UIView setAnimationDuration:0.5];
            [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
            [UIView setAnimationDelegate:self];
            dibu.frame=_rect_middle;
            [UIView commitAnimations];
        }
        
        
    }else if(btn.tag-100==2)
    {
        if(ctn3==nil)
        {
            ctn3=[[DD_DesignerIntroViewController alloc] initWithDesignerID:_designerId WithBlock:^(NSString *type) {
                
            }];
        }
        if(currentPage<2&&ctn3!=nil)
        {
            [_pageVc setViewControllers:@[ctn3] direction:0 animated:YES completion:nil];
            [UIView beginAnimations:@"anmationName1" context:nil];
            [UIView setAnimationDuration:0.5];
            [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
            [UIView setAnimationDelegate:self];
            dibu.frame=_rect_right;
            [UIView commitAnimations];
        }
        
    }
    for (UIButton *_btn in btnarr) {
        _btn.selected=NO;
//        _btn.backgroundColor=[UIColor colorWithRed:251.0f/255.0f green:251.0f/255.0f blue:251.0f/255.0f alpha:1];
        if(_btn.tag==btn.tag)
        {
            _btn.selected=YES;
//            _btn.backgroundColor=[UIColor whiteColor];
            currentPage=_btn.tag-100;
        }
    }
}
/**
 * 设置upview
 */
-(void)SetUpView
{
    for (int i=0; i<2; i++) {
        UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth-240)/2.0f+160*i, 30, 80, 80)];
        [_UpView addSubview:imageView];
        
        [imageView JX_loadImageUrlStr:i==0?_DesignerModel.head:_DesignerModel.brandIcon WithSize:200 placeHolderImageName:nil radius:CGRectGetWidth(imageView.frame)/2.0f];
        
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(imageView.frame)-40, CGRectGetMaxY(imageView.frame), CGRectGetWidth(imageView.frame)+80, 50)];
        [_UpView addSubview:label];
        label.textAlignment=1;
        label.textColor=[UIColor blackColor];
        label.text=i==0?_DesignerModel.name:_DesignerModel.brandName;
    }
}
/**
 * 关注取消关注
 */
-(void)followAction
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
                [right_btn setTitle:@"已关注" forState:UIControlStateNormal];
            }else
            {
                [right_btn setTitle:@"关注" forState:UIControlStateNormal];
            }
            
        }else
        {
            [self presentViewController:successAlert animated:YES completion:nil];
        }
    } failure:^(NSError *error, UIAlertController *failureAlert) {
        [self presentViewController:failureAlert animated:YES completion:nil];
    }];
}
#pragma mark - Other
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
