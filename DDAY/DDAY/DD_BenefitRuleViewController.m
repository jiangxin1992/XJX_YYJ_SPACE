//
//  DD_BenefitRuleViewController.m
//  YCO SPACE
//
//  Created by yyj on 2016/11/4.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_BenefitRuleViewController.h"

@interface DD_BenefitRuleViewController ()

@end

@implementation DD_BenefitRuleViewController
{
    UIScrollView *_scrollView;
    UIView *container;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self SomePrepare];
    [self UIConfig];
    [self RequestData];
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
    self.navigationItem.titleView=[regular returnNavView:NSLocalizedString(@"user_benefit_rule", @"") withmaxwidth:200];
}
#pragma mark -UIConfig
-(void)UIConfig
{
    [self CreateScrollView];
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
}
#pragma mark - RequestData
-(void)RequestData
{
    [[JX_AFNetworking alloc] GET:@"user/getBenefitRule.do" parameters:@{@"token":[DD_UserModel getToken]} success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
        if(success)
        {
            UILabel *rule_content_label=[UILabel getLabelWithAlignment:0 WithTitle:[data objectForKey:@"rule"] WithFont:13.0f WithTextColor:nil WithSpacing:0];
            [container addSubview:rule_content_label];
            rule_content_label.numberOfLines=0;
            [rule_content_label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(kEdge);
                make.right.mas_equalTo(-kEdge);
                make.top.mas_equalTo(18);
            }];
            
            [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.right.mas_equalTo(0);
                make.bottom.mas_equalTo(ktabbarHeight);
                // 让scrollview的contentSize随着内容的增多而变化
                make.bottom.mas_equalTo(rule_content_label.mas_bottom).with.offset(18);
            }];
        }else
        {
            [self presentViewController:successAlert animated:YES completion:nil];
        }
    } failure:^(NSError *error, UIAlertController *failureAlert) {
        [self presentViewController:failureAlert animated:YES completion:nil];
    }];
}

#pragma mark - Other
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
