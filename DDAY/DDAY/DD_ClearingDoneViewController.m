//
//  DD_ClearingDoneViewController.m
//  DDAY
//
//  Created by yyj on 16/5/26.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_ClearingDoneViewController.h"

#import "DD_OrderDetailViewController.h"
#import "DD_ClearingViewController.h"

@interface DD_ClearingDoneViewController ()

@end

@implementation DD_ClearingDoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self SomePrepare];
    [self UIConfig];
}
#pragma mark - 初始化
-(instancetype)initWithReturnCode:(NSString *)code WithType:(NSString *)type WithBlock:(void (^)(NSString *type))block
{
    self=[super init];
    if(self)
    {
        _type=type;
        _code=code;
        _block=block;
        [self UIConfig];
    }
    return self;
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
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
}
#pragma mark - UIConfig
/**
 * 根据支付状态设置不同的界面
 */
-(void)UIConfig
{
    NSString *title=nil;
    if([_code integerValue]==9000)
    {
        title=@"支付成功";
    }else
    {
        title=@"支付失败";
    }
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:btn];
    btn.frame=CGRectMake((ScreenWidth-100)/2.0f, (ScreenHeight-50)/2.0f, 100, 50);
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark - SomeAction
/**
 * 返回结算界面之前的那个界面
 * type 类型 clear（结算页面处） order（订单列表处） detail_order（订单详情处）
 * 每个类型的返回页面有所差别 故分开处理
 */
-(void)backAction
{
    if([_type isEqualToString:@"clear"])
    {
        NSArray *controllers=self.navigationController.viewControllers;
        for (int i=0; i<controllers.count; i++) {
            id obj=controllers[i];
            if([obj isKindOfClass:[DD_ClearingViewController class]])
            {
                if(i>0)
                {
                    [self.navigationController popToViewController:controllers[i-1] animated:YES];
                }
            }
        }
    }else if([_type isEqualToString:@"order"])
    {
        [self.navigationController popViewControllerAnimated:YES];
    }else if([_type isEqualToString:@"detail_order"])
    {
        NSArray *controllers=self.navigationController.viewControllers;
        for (int i=0; i<controllers.count; i++) {
            id obj=controllers[i];
            if([obj isKindOfClass:[DD_OrderDetailViewController class]])
            {
                if(i>0)
                {
                    [self.navigationController popToViewController:controllers[i-1] animated:YES];
                }
            }
        }
    }
}
#pragma mark - Other
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"DD_ClearingDoneViewController"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"DD_ClearingDoneViewController"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
