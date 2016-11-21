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
    _scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-kNavHeight-145-28)];
    [self.view addSubview:_scrollView];
}
-(void)CreateWebView
{
    _webView=[[UIWebView alloc] initWithFrame:CGRectMake( 0, 0, ScreenWidth, ScreenHeight-kNavHeight-145-28)];
    [_scrollView addSubview:_webView];
    _webView.userInteractionEnabled=YES;
    _webView.backgroundColor =  _define_clear_color;
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
    
    //JXLOG(@"%@",webView.mj_JSONString);
    NSString *jsString = [[NSString alloc] initWithFormat:@"document.getElementsByTagName('body')[0].style.fontFamily= '%@'",
                          @"Helvetica"];
    [webView stringByEvaluatingJavaScriptFromString:jsString];
//    NSString *jsString = [[NSString alloc] initWithFormat:@"document.body.style.fontSize=%f;document.body.style.color=%@",1.0f,@"#FFFF00"];
//    [webView stringByEvaluatingJavaScriptFromString:jsString];
}


#pragma mark - Other
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
