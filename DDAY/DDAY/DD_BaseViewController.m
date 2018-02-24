//
//  DD_BaseViewController.m
//  DDAY
//
//  Created by yyj on 16/5/20.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_BaseViewController.h"

#import "DD_LoginViewController.h"
#import "DD_ClearingDoneViewController.h"
#import "DD_BenefitListViewController.h"
#import "DD_CustomViewController.h"

@interface DD_BaseViewController ()
//派生到我的代码片
@property (nonatomic, weak) UIImageView *lineView;
@end

@implementation DD_BaseViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=_define_backview_color;

//    self.navigationController.navigationBar.barTintColor = _define_white_color;
//    //   应对导航栏黑线问题（异常）
//    if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
//        NSArray *list=self.navigationController.navigationBar.subviews;
//        for (id obj in list) {
//            if ([obj isKindOfClass:[UIImageView class]]) {
//                UIImageView *imageView=(UIImageView *)obj;
//                NSArray *list2=imageView.subviews;
//                for (id obj2 in list2) {
//                    if ([obj2 isKindOfClass:[UIImageView class]]) {
//                        UIImageView *imageView2=(UIImageView *)obj2;
//                        imageView2.hidden=YES;
//                    }
//                }
//            }
//        }
//    }
    //获取导航栏下面黑线
    _lineView = [self getLineViewInNavigationBar:self.navigationController.navigationBar];
    
    DD_NavBtn *backBtn=[DD_NavBtn getBackBtn];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
}
-(void)hideBackNavBtn
{
    self.navigationItem.leftBarButtonItem=nil;
}
-(BOOL )isVisible
{
    return (self.isViewLoaded && self.view.window);
}
/**
 * 跳转登录界面
 */
-(void)pushLoginView
{
    if(![DD_UserModel isLogin])
    {
        DD_LoginViewController *_login=[[DD_LoginViewController alloc] initWithBlock:^(NSString *type) {
            if([type isEqualToString:@"success"])
            {
                
            }
        }];
        [self.navigationController pushViewController:_login animated:YES];
    }
}
-(void )pushCleaingDoneViewWithResultDic:(NSDictionary *)resultDic WithType:(NSString *)type
{
    [self.navigationController pushViewController:[[DD_ClearingDoneViewController alloc] initWithReturnCode:[resultDic objectForKey:@"resultStatus"] WithTradeOrderCode:[resultDic objectForKey:@"tradeOrderCode"] WithType:type WithBlock:^(NSString *type) {
        
    }] animated:YES];
}
-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[DD_CustomViewController sharedManager] tabbarHide];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    _lineView.hidden = YES;
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
//    _lineView.hidden = NO;
//    self.navigationController.navigationBar.translucent = NO;
//    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
}
//找到导航栏最下面黑线视图
- (UIImageView *)getLineViewInNavigationBar:(UIView *)view
{
    __block UIImageView *getLine=nil;
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    [view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImageView *imageView = [self getLineViewInNavigationBar:obj];
        if (imageView) {
            getLine=imageView;
            *stop=YES;
        }
    }];
    
    return getLine;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
