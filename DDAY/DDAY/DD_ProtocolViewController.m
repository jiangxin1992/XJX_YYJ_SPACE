//
//  DD_ProtocolViewController.m
//  YCO SPACE
//
//  Created by yyj on 16/9/26.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_ProtocolViewController.h"

@interface DD_ProtocolViewController ()

@end

@implementation DD_ProtocolViewController
{
    UIWebView *_webview;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self UIConfig];
}
-(void)UIConfig
{
    DD_NavBtn *backBtn=[DD_NavBtn getBackBtn];
    [self.view addSubview:backBtn];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame=CGRectMake(10, kStatusBarHeight, CGRectGetWidth(backBtn.frame), CGRectGetHeight(backBtn.frame));
    [backBtn setEnlargeEdge:20];
    
    UILabel *title=[UILabel getLabelWithAlignment:1 WithTitle:@"服务协议" WithFont:IsPhone6_gt?18.0f:15.0f WithTextColor:nil WithSpacing:0];
    title.font=[regular getSemiboldFont:IsPhone6_gt?18.0f:15.0f];
    [self.view addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(19+kStatusBarHeight);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(19);
        make.centerX.mas_equalTo(self.view);
    }];
    
    _webview=[[UIWebView alloc] init];
    [self.view addSubview:_webview];
    _webview.userInteractionEnabled=YES;
    _webview.backgroundColor =  _define_clear_color;
    _webview.opaque = NO;
    _webview.dataDetectorTypes = UIDataDetectorTypeNone;
    [_webview loadRequest:[[NSURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:[[NSString alloc] initWithFormat:@"%@%@",[regular getDNS],@"user/getProtocolPage.htm"]]]];
    [_webview sizeToFit];
    
    [_webview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kNavHeight);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
}

#pragma mark - SomeAction
/**
 * 返回
 */
-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - Other
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [regular dismissKeyborad];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
