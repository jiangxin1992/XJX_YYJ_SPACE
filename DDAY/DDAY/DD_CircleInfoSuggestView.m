//
//  DD_CircleInfoSuggestView.m
//  DDAY
//
//  Created by yyj on 16/6/15.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_CircleInfoSuggestView.h"

@implementation DD_CircleInfoSuggestView
{
    UIWebView *_webView;//搭配建议内容
    UILabel *_numlabel;//字数
}

#pragma mark - 初始化
/**
 * 初始化
 */
-(instancetype)initWithPlaceHoldStr:(NSString *)holdStr WithBlockType:(NSString *)blockType WithLimitNum:(long)limitNum Block:(void (^)(NSString *type,NSInteger num))block
{
    self=[super init];
    if(self)
    {
        _block=block;
        _holdStr=holdStr;
        _limitNum=limitNum;
        _blockType=blockType;
        [self SomePrepare];
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
    self.backgroundColor=[UIColor whiteColor];
    self.userInteractionEnabled=YES;
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(remarksAction)]];
}
#pragma mark - UIConfig
-(void)UIConfig
{
    _webView=[[UIWebView alloc] initWithFrame:CGRectMake(20, 10, ScreenWidth-40, 10)];
    [self addSubview:_webView];
    _webView.backgroundColor=[UIColor clearColor];
    _webView.userInteractionEnabled=NO;
    _webView.delegate=self;
    _webView.opaque = NO;
    _webView.dataDetectorTypes = UIDataDetectorTypeNone;
    [self addSubview:_webView];
    [self setRemarksWithWebView:_holdStr];
    
    _numlabel=[[UILabel alloc] init];
    [self addSubview:_numlabel];
    _numlabel.textAlignment=2;
    _numlabel.textColor=[UIColor lightGrayColor];
    _numlabel.font=[regular getFont:13.0f];
    _numlabel.text=[[NSString alloc] initWithFormat:@"0/%ld",_limitNum];
    [_numlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(@20);
    }];
}
#pragma mark - SomeAction
/**
 * 跳转填写备注界面
 */
-(void)remarksAction
{
    _block(_blockType,_limitNum);
}
/**
 * 备注填写完毕之后，回调更新备注视图的内容
 */
-(void)setRemarksWithWebView:(NSString *)content
{
    NSString *font=@"17px/23px";
    [_webView loadHTMLString:[NSString stringWithFormat:@"<style>body{word-wrap:break-word;margin:0;background-color:transparent;font:%@ Custom-Font-Name;align:justify;color:#9b9b9b}</style><div align='justify'>%@<div>",font,content] baseURL:nil];
    [_webView sizeToFit];//自适应
    _numlabel.text=[[NSString alloc] initWithFormat:@"%ld/%ld",content.length,_limitNum];//更新字数
}
#pragma mark - UIWebViewDelegate
/**
 * 适应
 */
- (void)webViewDidFinishLoad:(UIWebView *)webView { //webview 自适应高度
    CGRect frame = webView.frame;
    CGSize fittingSize = [webView sizeThatFits:CGSizeZero];
    frame.size = fittingSize;
    webView.frame = frame;
    
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(webView.mas_bottom).with.offset(20);
    }];
}
@end






