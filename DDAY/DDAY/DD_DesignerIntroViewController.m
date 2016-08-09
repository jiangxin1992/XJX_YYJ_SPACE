//
//  DD_DesignerIntroViewController.m
//  DDAY
//
//  Created by yyj on 16/6/12.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_DesignerIntroViewController.h"

@interface DD_DesignerIntroViewController ()<UIWebViewDelegate>

@end

@implementation DD_DesignerIntroViewController
{
    UIWebView *_webView;
    UIScrollView *_scrollView;
}
#pragma mark - 初始化
-(instancetype)initWithDesignerID:(NSString *)DesignerID WithBlock:(void(^)(NSString *type))block
{
    self=[super init];
    if(self)
    {
        _DesignerID=DesignerID;
        _block=block;
    }
    return self;
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
-(void)PrepareData{}
-(void)PrepareUI{}
#pragma mark - UIConfig
-(void)UIConfig
{
    [self CreateScrollView];
    [self CreateWebView];
}

-(void)CreateScrollView
{
    _scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-kNavHeight-169)];
    [self.view addSubview:_scrollView];
}
-(void)CreateWebView
{
    _webView=[[UIWebView alloc] initWithFrame:CGRectMake( 0, 0, ScreenWidth, ScreenHeight-kNavHeight-169+ktabbarHeight)];
    [_scrollView addSubview:_webView];
    _webView.userInteractionEnabled=YES;
    _webView.backgroundColor = [UIColor clearColor];
    _webView.delegate=self;
    _webView.opaque = NO;
    _webView.dataDetectorTypes = UIDataDetectorTypeNone;
    
}
#pragma mark - RequestData
-(void)RequestData
{
    NSDictionary *_parameters=@{@"token":[DD_UserModel getToken],@"designerId":_DesignerID};
    [[JX_AFNetworking alloc] GET:@"designer/queryDesignerStoryPage.do" parameters:_parameters success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
        if(success)
        {
//            @"http://10.200.6.36:8080/dday-web/service/designer/queryDesignerStoryContent.do?designerId=397"
            NSString *_url=[data objectForKey:@"url"];
            [_webView loadRequest:[[NSURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:_url]]];
            [_webView sizeToFit];
        }else
        {
            [self presentViewController:successAlert animated:YES completion:nil];
        }
    } failure:^(NSError *error, UIAlertController *failureAlert) {
        [self presentViewController:failureAlert animated:YES completion:nil];
    }];
}
#pragma mark - UIWebViewDelegate
/**
 * 适应
 */
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    //webview 自适应高度
    CGRect frame = webView.frame;
    CGSize fittingSize = [webView sizeThatFits:CGSizeZero];
    frame.size = fittingSize;
    webView.frame = frame;
    _scrollView.contentSize=CGSizeMake(ScreenWidth, CGRectGetHeight(webView.frame));
}
#pragma mark - Other
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"DD_DesignerIntroViewController"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"DD_DesignerIntroViewController"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
