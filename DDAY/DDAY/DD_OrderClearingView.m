//
//  DD_OrderClearingView.m
//  DDAY
//
//  Created by yyj on 16/6/7.
//  Copyright © 2016年 YYJ. All rights reserved.
//
#import "DD_ClearingSeriesModel.h"
#import "DD_ClearingTool.h"
#import "DD_OrderClearingView.h"

@implementation DD_OrderClearingView
{
    UIView *totalView;
    UIView *payView;
    UIView *remarksView;
    UIWebView *_webView;
}
#pragma mark - 初始化方法
-(instancetype)initWithFrame:(CGRect)frame WithOrderDetailInfoModel:(DD_OrderDetailInfoModel *)orderInfo Withfreight:(CGFloat )freight WithCountPrice:(NSString *)subTotal WithBlock:(void (^)(NSString *type,CGFloat height))block
{
    self=[super initWithFrame:frame];
    if(self)
    {
        _subTotal=subTotal;
        _freight=freight;
        _orderInfo=orderInfo;
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
    
    CGFloat _count=[_subTotal floatValue];
    CGFloat _countPrice=_count+_freight;
    
    NSArray *content=@[
                       @"总结"
                       ,[[NSString alloc] initWithFormat:@"小计(%ld)"
                         ,[self getGoodsCount]]
                       ,[[NSString alloc] initWithFormat:@"￥%.1lf",_count]
                       ,@"运费"
                       ,[[NSString alloc] initWithFormat:@"￥%.0lf",_freight]
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
    
    UILabel *titlelabel=[[UILabel alloc] initWithFrame:CGRectMake(20, 5, ScreenWidth-40, 30)];
    [remarksView addSubview:titlelabel];
    titlelabel.textAlignment=0;
    titlelabel.textColor=[UIColor blackColor];
    titlelabel.text=@"订单备注:";
    
    _webView=[[UIWebView alloc] initWithFrame:CGRectMake(20, 40, ScreenWidth-40, 60)];
    [remarksView addSubview:_webView];
    _webView.userInteractionEnabled=NO;
    _webView.backgroundColor = [UIColor clearColor];
    _webView.delegate=self;
    _webView.opaque = NO;
    _webView.dataDetectorTypes = UIDataDetectorTypeNone;
    [self setRemarksWithWebView:@"京华时报6月7日报道 今天上午11点半，第一门语文考试结束。考生陆续自考场内走出，半小时前就有家长等候在外。11点38分左右，关晓彤随着人流出走出来，笑着说，“考得还行，就是作文有些素材没用上。”关晓彤的母亲介绍，她对关晓彤很有信心，“只要发挥好就行。”语文是关晓彤的长项，其余科目成绩也比较均衡。关晓彤的母亲称，昨晚他们就在附近宾馆登记入住。今晨步行至考场，关晓彤选择穿红色短袖“图个开门红”，希望考试成绩能过500分。高考结束，关晓彤将赴横店拍戏“也没什么时间放松”。"];
//    [self setRemarksWithWebView:_orderInfo.memo];
    [remarksView addSubview:_webView];
}
/**
 * 创建联系客服按钮
 */
-(void)CreateContactBtn
{
    //    remarksView
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:btn];
    btn.frame=CGRectMake(10, CGRectGetMaxY(remarksView.frame)+5, ScreenWidth-20, 40);
    btn.backgroundColor=[UIColor whiteColor];
    [btn setTitle:@"联系客服" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(contactAction) forControlEvents:UIControlEventTouchUpInside];
    //    self
}
#pragma mark - SomeAction
/**
 * 获取结算页面的订单个数
 */
-(NSInteger )getGoodsCount
{
    NSInteger _num=0;
    for (DD_OrderModel *_order in _orderInfo.orderList) {
        for (DD_OrderItemModel *_item in _order.itemList) {
            _num+=_item.itemCount;
        }
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

-(void)contactAction
{
    _block(@"contact",0);
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
    remarksView.frame=CGRectMake(0, CGRectGetMaxY(payView.frame)+2, ScreenWidth, CGRectGetHeight(webView.frame)+50);
    _block(@"height",CGRectGetMaxY(remarksView.frame));
    [self CreateContactBtn];
}


@end
