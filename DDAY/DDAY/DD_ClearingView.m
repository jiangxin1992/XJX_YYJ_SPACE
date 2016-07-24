//
//  DD_ClearingView.m
//  DDAY
//
//  Created by yyj on 16/5/24.
//  Copyright © 2016年 YYJ. All rights reserved.
//
#import "DD_ClearingSeriesModel.h"
#import "DD_ClearingTool.h"
#import "DD_ClearingView.h"

@implementation DD_ClearingView
{
    UIView *totalView;// 总结视图(小计)
    UIView *payView;// 支付方式视图
    UIView *remarksView;// 备注的背景视图
    UIWebView *_webView;// 备注视图 remarksView子视图
}
#pragma mark - 初始化方法
-(instancetype)initWithFrame:(CGRect)frame WithDataArr:(NSArray *)dataArr Withfreight:(NSString *)freight WithCountPrice:(NSString *)subTotal WithBlock:(void (^)(NSString *type,CGFloat height))block
{
    self=[super initWithFrame:frame];
    if(self)
    {
        _subTotal=subTotal;
        _freight=freight;
        _dataArr=dataArr;
        _block=block;
        [self UIConfig];
    }
    return self;
}
#pragma mark - UIConfig
-(void)UIConfig
{
    [self CreateTotalView];
    [self CreatePayView];
    [self CreateRemarksView];
}
/**
 * 创建总结视图(小计)
 */
-(void)CreateTotalView
{
    totalView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 150)];
    totalView.backgroundColor=[UIColor whiteColor];
    [self addSubview:totalView];
    
    CGFloat _Freight=_dataArr.count*[_freight floatValue];
    
    CGFloat _count=[_subTotal floatValue];
    CGFloat _countPrice=_count+_Freight;
    
    NSArray *content=@[
                       @"总结"
                       ,[[NSString alloc] initWithFormat:@"小计(%ld)"
                         ,[self getGoodsCount]]
                       ,[[NSString alloc] initWithFormat:@"￥%.1lf",_count]
                       ,@"运费"
                       ,[[NSString alloc] initWithFormat:@"￥%.0lf",_Freight]
                       ,@"总计"
                       ,[[NSString alloc] initWithFormat:@"￥%.1lf",_countPrice]
                       ];
    CGFloat _y_p=0;
    CGFloat _x_p=20;
    CGFloat _width=(ScreenWidth/2.0f)-40;
    NSInteger _algin=0;
    for (int i=0; i<content.count; i++) {
        if(i==0)
        {
            _y_p=0;
            _x_p=20;
            _algin=0;
        }else
        {
            _y_p=30*((i+1)/2);
            _x_p=20+_width*((i+1)%2);
            if((i+1)%2)
            {
                _algin=2;
            }else
            {
                _algin=0;
            }
            
        }
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(_x_p, _y_p,_width , 30)];
        [totalView addSubview:label];
        label.textColor=[UIColor blackColor];
        label.textAlignment=_algin;
        label.text=content[i];
    }
}
/**
 * 创建支付视图
 */
-(void)CreatePayView
{
    payView=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(totalView.frame)+2, ScreenWidth, 40)];
    payView.backgroundColor=[UIColor whiteColor];
    [self addSubview:payView];
    
    for (int i=0; i<2; i++) {
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(20+200*i, 5, i==0?170:90, 30)];
        [payView addSubview:label];
        label.textAlignment=i==0?0:2;
        label.textColor=i==0?[UIColor blackColor]:[UIColor lightGrayColor];
        label.text=i==0?@"支付方式":@"支付宝";
    }
}
/**
 * 创建备注视图
 */
-(void)CreateRemarksView
{
    remarksView=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(payView.frame)+2, ScreenWidth, 80)];
    remarksView.backgroundColor=[UIColor whiteColor];
    [self addSubview:remarksView];
    remarksView.userInteractionEnabled=YES;
    [remarksView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(remarksAction)]];
    
    _webView=[[UIWebView alloc] initWithFrame:CGRectMake(20, 10, ScreenWidth-40, 10)];
    [remarksView addSubview:_webView];
    _webView.userInteractionEnabled=NO;
    _webView.backgroundColor = [UIColor clearColor];
    _webView.delegate=self;
    _webView.opaque = NO;
    _webView.dataDetectorTypes = UIDataDetectorTypeNone;
    [self setRemarksWithWebView:@"添加订单备注"];
    [remarksView addSubview:_webView];
}

#pragma mark - SomeAction
/**
 * 获取结算页面的订单个数
 */
-(NSInteger )getGoodsCount
{
    NSInteger _num=0;
    for (DD_ClearingSeriesModel *_Series in _dataArr) {
        _num+=_Series.items.count;
    }
    return _num;
}
/**
 * 添加备注
 */
-(void)remarksAction{
    _block(@"remarks",0);
}
/**
 * 备注填写完毕之后，回调更新备注视图的内容
 */
-(void)setRemarksWithWebView:(NSString *)content
{
    NSString *font=@"17px/23px";
    [_webView loadHTMLString:[NSString stringWithFormat:@"<style>body{word-wrap:break-word;margin:0;background-color:transparent;font:%@ Custom-Font-Name;align:justify;color:#9b9b9b}</style><div align='justify'>%@<div>",font,content] baseURL:nil];
    [_webView sizeToFit];
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
    remarksView.frame=CGRectMake(0, CGRectGetMaxY(payView.frame)+2, ScreenWidth, CGRectGetHeight(webView.frame)+20);
    _block(@"height",CGRectGetMaxY(remarksView.frame)+10);
}

@end
