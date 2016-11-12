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
    UIWebView *_webView;
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
    [self CreateWebView];
}
-(void)CreateWebView
{
    _webView=[[UIWebView alloc] init];
    [self.view addSubview:_webView];
    _webView.userInteractionEnabled=YES;
    _webView.backgroundColor =  _define_clear_color;
    _webView.opaque = NO;
    _webView.dataDetectorTypes = UIDataDetectorTypeNone;
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.bottom.mas_equalTo(ktabbarHeight);
    }];
}
#pragma mark - RequestData
-(void)RequestData
{
    [[JX_AFNetworking alloc] GET:@"user/getBenefitRule.do" parameters:@{@"token":[DD_UserModel getToken]} success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
        if(success)
        {
            if([data objectForKey:@"ruleLink"])
            {
                [_webView loadRequest:[[NSURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:[data objectForKey:@"ruleLink"]]]];
                [_webView sizeToFit];
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
