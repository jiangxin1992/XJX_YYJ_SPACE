//
//  DD_BenefitDetailViewController.m
//  YCO SPACE
//
//  Created by yyj on 2016/11/3.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_BenefitDetailViewController.h"

#import "DD_BenefitDetailModel.h"

@interface DD_BenefitDetailViewController ()

@end

@implementation DD_BenefitDetailViewController
{
    DD_BenefitDetailModel *_benefitDetailModel;
    UIScrollView *_scrollView;
    UIView *container;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self SomePrepare];
    [self UIConfig];
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
-(void)PrepareUI{}
#pragma mark - UIConfig
-(void)UIConfig
{
    [self CreateScrollView];
    [self CreateUI];

}
-(void)CreateScrollView
{
    _scrollView=[[UIScrollView alloc] init];
    [self.view addSubview:_scrollView];
    container = [UIView new];
    [_scrollView addSubview:container];
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_scrollView);
        make.width.equalTo(_scrollView);
    }];
    
//    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.right.mas_equalTo(0);
//        make.bottom.mas_equalTo(ktabbarHeight);
//        // 让scrollview的contentSize随着内容的增多而变化
//        make.bottom.mas_equalTo(version_back.mas_bottom).with.offset(40);
//    }];
}
-(void)CreateUI
{
    // 50
    // 30
    UIImageView *_backImg=[UIImageView getCustomImg];
    [container addSubview:_backImg];
    [_backImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).with.offset(14);
        make.centerX.mas_equalTo(self.view);
//        make.ce
    }];
}
#pragma mark - RequestData
-(void)RequestData
{
    [self RequestDetailData];
    [self RequestCloseData];
}
-(void)RequestDetailData
{
    [[JX_AFNetworking alloc] GET:@"user/queryBenefitDetail.do" parameters:@{@"benefitId":_benefitInfoModel.benefitId,@"token":[DD_UserModel getToken]} success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
        if(success)
        {
            _benefitDetailModel=[DD_BenefitDetailModel getBenefitDetailInfoModel:[data objectForKey:@"benefitInfo"]];
            self.navigationItem.titleView=[regular returnNavView:_benefitDetailModel.name withmaxwidth:200];
            
//            UILabel *label=[UILabel getLabelWithAlignment:0 WithTitle:_benefitDetailModel.ruleContent WithFont:15.0f WithTextColor:nil WithSpacing:0];
//            [self.view addSubview:label];
//            label.numberOfLines=0;
//            [label mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.center.mas_equalTo(self.view);
//                make.width.height.mas_equalTo(200);
//            }];
            
        }else
        {
            [self presentViewController:successAlert animated:YES completion:nil];
        }
    } failure:^(NSError *error, UIAlertController *failureAlert) {
        [self presentViewController:failureAlert animated:YES completion:nil];
    }];
}
-(void)RequestCloseData
{
    if([DD_UserModel isLogin])
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
}

#pragma mark - other
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
