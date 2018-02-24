//
//  DD_ClearingDoneViewController.m
//  DDAY
//
//  Created by yyj on 16/5/26.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_ClearingDoneViewController.h"

#import "DD_GoodsViewController.h"
#import "DD_OrderDetailViewController.h"
#import "DD_ClearingOrderViewController.h"

#import "DD_OrderModel.h"

@interface DD_ClearingDoneViewController ()

@end

@implementation DD_ClearingDoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
#pragma mark - 初始化
-(instancetype)initWithReturnCode:(NSString *)code WithTradeOrderCode:(NSString *)tradeOrderCode WithType:(NSString *)type WithBlock:(void (^)(NSString *type))block
{
    self=[super init];
    if(self)
    {
        _tradeOrderCode=tradeOrderCode;
        _type=type;
        _code=code;
        _block=block;
        [self SomePrepare];
        [self UIConfig];
    }
    return self;
}
#pragma mark - SomePrepare
-(void)SomePrepare
{
    [self hideBackNavBtn];
    [self PrepareData];
    [self PrepareUI];
}

-(void)PrepareData{}
-(void)PrepareUI
{
    DD_NavBtn *backBtn=[DD_NavBtn getBackBtn];
//    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:backBtn];
    [backBtn bk_addEventHandler:^(id sender) {
        /**
         * 返回结算界面之前的那个界面
         * type 类型 clear（结算页面处） order（订单列表处） detail_order（订单详情处）
         * 每个类型的返回页面有所差别 故分开处理
         */
        if([_type isEqualToString:@"clear"])
        {
            [self.navigationController popViewControllerAnimated:YES];
        }else if([_type isEqualToString:@"order"])
        {
            [self.navigationController popViewControllerAnimated:YES];
        }else if([_type isEqualToString:@"detail_order_have_clearing_done"])
        {
            [self.navigationController popViewControllerAnimated:YES];
        }else if([_type isEqualToString:@"detail_order_havenot_clearing_done"])
        {
            NSArray *controllers=self.navigationController.viewControllers;
            [controllers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if([obj isKindOfClass:[DD_OrderDetailViewController class]])
                {
                    if(idx>0)
                    {
                        [self.navigationController popToViewController:controllers[idx] animated:YES];
                    }
                }
            }];

        }
    } forControlEvents:UIControlEventTouchUpInside];
    
    NSString *title=nil;
    if([_code integerValue]==9000)
    {
        title=@"支付成功";
    }else
    {
        title=@"支付失败";
    }
    self.navigationItem.titleView=[regular returnNavView:title withmaxwidth:150];
    
}
#pragma mark - UIConfig
/**
 * 根据支付状态设置不同的界面
 */
-(void)UIConfig
{
    NSString *title=nil;
    NSString *imgStr=nil;
    if([_code integerValue]==9000)
    {
        title=@"支付成功";
        imgStr=@"Order_Paid";
    }else
    {
        title=@"支付失败";
        imgStr=@"Order_Fail_Pay";
    }
    UIButton *btn=[UIButton getCustomBackImgBtnWithImageStr:imgStr WithSelectedImageStr:nil];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(((ScreenHeight/2.0f)-kStatusBarAndNavigationBarHeight-kTabbarHeight));
        make.height.width.mas_equalTo(72);
    }];
    
    UILabel *titleLabel=[UILabel getLabelWithAlignment:1 WithTitle:title WithFont:18.0f WithTextColor:nil WithSpacing:0];
    [self.view addSubview:titleLabel];
    titleLabel.font=[regular getSemiboldFont:17.0f];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(btn.mas_bottom).with.offset(10);
    }];
//    [titleLabel sizeToFit];
    
    CGFloat _jiange=(ScreenWidth-121*2)/3.0f;
    NSArray *titleArr=@[@"查看订单",@"其他发布品"];
    
    [titleArr enumerateObjectsUsingBlock:^(NSString *title, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *actionbtn=[UIButton getCustomTitleBtnWithAlignment:0 WithFont:18.0f WithSpacing:0 WithNormalTitle:title WithNormalColor:_define_white_color WithSelectedTitle:nil WithSelectedColor:nil];
        [self.view addSubview:actionbtn];
        actionbtn.backgroundColor=_define_black_color;
        [actionbtn mas_makeConstraints:^(MASConstraintMaker *make) {
            if(idx==0)
            {
                [actionbtn addTarget:self action:@selector(checkOrderAction) forControlEvents:UIControlEventTouchUpInside];
                make.left.mas_equalTo(_jiange);
            }else
            {
                [actionbtn addTarget:self action:@selector(otherItemAction) forControlEvents:UIControlEventTouchUpInside];
                make.right.mas_equalTo(-_jiange);
            }
            make.width.mas_equalTo(121);
            make.height.mas_equalTo(40);
            make.top.mas_equalTo(titleLabel.mas_bottom).with.offset(IsPhone6_gt?94:47);
        }];
    }];

}
#pragma mark - SomeAction
/**
 * 查看订单
 */
-(void)checkOrderAction
{
    NSDictionary *_parameters = @{@"tradeOrderCode":_tradeOrderCode,@"token":[DD_UserModel getToken]};
    [[JX_AFNetworking alloc] GET:@"order/queryTradeOrderInfo.do" parameters:_parameters success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
        if(success)
        {
            NSArray *getArr=[DD_OrderModel getOrderModelArr:[data objectForKey:@"orders"]];
            if(getArr.count)
            {
                if(getArr.count>1)
                {
                    [self.navigationController pushViewController:[[DD_ClearingOrderViewController alloc] initWithDataArr:[[NSMutableArray alloc] initWithArray:getArr] WithTradeOrderCode:_tradeOrderCode] animated:YES];
                }else
                {
                    DD_OrderModel *order=getArr[0];
                    [self.navigationController pushViewController:[[DD_OrderDetailViewController alloc] initWithModel:order WithBlock:^(NSString *type, NSDictionary *resultDic) {
                        
                    }] animated:YES];
                }
            }
        }else
        {
            [self presentViewController:successAlert animated:YES completion:nil];
        }
    } failure:^(NSError *error, UIAlertController *failureAlert) {
        [self presentViewController:failureAlert animated:YES completion:nil];
    }];
}
/**
 * 其他发布品
 */
-(void)otherItemAction
{
    DD_GoodsViewController *goodView=[[DD_GoodsViewController alloc] init];
    goodView.noTabbar=YES;
    [self.navigationController pushViewController:goodView animated:YES];
}
///**
// * 返回结算界面之前的那个界面
// * type 类型 clear（结算页面处） order（订单列表处） detail_order（订单详情处）
// * 每个类型的返回页面有所差别 故分开处理
// */
//-(void)backAction
//{
//    JXLOG(@"type=%@",_type);
//    if([_type isEqualToString:@"clear"])
//    {
//        [self.navigationController popViewControllerAnimated:YES];
//    }else if([_type isEqualToString:@"order"])
//    {
//        [self.navigationController popViewControllerAnimated:YES];
//    }else if([_type isEqualToString:@"detail_order_have_clearing_done"])
//    {
//        [self.navigationController popViewControllerAnimated:YES];
//    }else if([_type isEqualToString:@"detail_order_havenot_clearing_done"])
//    {
//        NSArray *controllers=self.navigationController.viewControllers;
//        for (int i=0; i<controllers.count; i++) {
//            id obj=controllers[i];
//            if([obj isKindOfClass:[DD_OrderDetailViewController class]])
//            {
//                if(i>0)
//                {
//                    [self.navigationController popToViewController:controllers[i] animated:YES];
//                }
//            }
//        }
//    }
//}
#pragma mark - Other
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [DD_UserModel removeTradeOrderCode];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
