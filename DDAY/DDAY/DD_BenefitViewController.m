//
//  DD_BenefitViewController.m
//  YCO SPACE
//
//  Created by yyj on 2016/10/28.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_BenefitViewController.h"

@interface DD_BenefitViewController ()

@end

@implementation DD_BenefitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self SomePrepare];
    [self RequestData];
}
-(instancetype)initWithBenefitInfoModel:(DD_BenefitInfoModel *)benefitInfoModel WithBlock:(void (^)(NSString *type))block
{
    self=[super init];
    if(self)
    {
        _benefitInfoModel=benefitInfoModel;
        _block=block;
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
-(void)PrepareUI{
    self.navigationItem.titleView=[regular returnNavView:@"首单立减详情页" withmaxwidth:200];
}
#pragma mark - RequestData
-(void)RequestData
{
    //关闭
    [[JX_AFNetworking alloc] GET:@"user/readBenefit.do" parameters:@{@"token":[DD_UserModel getToken]} success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
        if(success)
        {
            _block(@"markread");
        }else
        {
        }
    } failure:^(NSError *error, UIAlertController *failureAlert) {
    }];
}
#pragma mark - other
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
