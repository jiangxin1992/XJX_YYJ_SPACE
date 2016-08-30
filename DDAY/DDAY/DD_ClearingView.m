//
//  DD_ClearingView.m
//  DDAY
//
//  Created by yyj on 16/5/24.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_ClearingView.h"

//#import "DD_ClearingTool.h"
//#import "DD_ClearingSeriesModel.h"

@implementation DD_ClearingView
{
//    UIView *totalView;// 总结视图(小计)

    UIView *remarksView;// 备注的背景视图
    UIWebView *_webView;// 备注视图 remarksView子视图
    
    UIView *middleLine;
    UILabel *freightTitleLabel;
    UIView *payView;// 支付方式视图
    
    BOOL _isShow;
    
    
}
#pragma mark - 初始化方法
-(instancetype)initWithDataArr:(NSArray *)dataArr Withfreight:(NSString *)freight WithPayWay:(NSString *)payWay WithBlock:(void (^)(NSString *type,CGFloat height,NSString *payWay))block
{
    self=[super init];
    if(self)
    {
        _freight=freight;
        _payWay=payWay;
        _dataArr=dataArr;
        _block=block;
        _isShow=NO;
        [self UIConfig];
    }
    return self;
}
#pragma mark - UIConfig
-(void)UIConfig
{
    freightTitleLabel=[UILabel getLabelWithAlignment:0 WithTitle:@"邮费：" WithFont:12 WithTextColor:_define_light_gray_color1 WithSpacing:0];
    [self addSubview:freightTitleLabel];
    
    freightTitleLabel.frame=CGRectMake(kEdge, 0, 100, 30);
    
    CGFloat _Freight=_dataArr.count*[_freight floatValue];
    UILabel *freightLabel=[UILabel getLabelWithAlignment:2 WithTitle:[[NSString alloc] initWithFormat:@"￥%.0lf",_Freight] WithFont:12 WithTextColor:nil WithSpacing:0];
    [self addSubview:freightLabel];
    freightLabel.font=[regular getSemiboldFont:12];
    freightLabel.frame=CGRectMake(ScreenWidth-kEdge-100, 0, 100, 30);
    
    remarksView=[[UIView alloc] initWithFrame:CGRectMake(kEdge,CGRectGetMaxY(freightLabel.frame)+5 , ScreenWidth-kEdge*2, 1)];
    [self addSubview:remarksView];
    remarksView.userInteractionEnabled=YES;
    [remarksView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(remarksAction)]];
    
    _webView=[[UIWebView alloc] initWithFrame:CGRectMake(0 ,0 , ScreenWidth-kEdge*2, 1)];
    [remarksView addSubview:_webView];
    _webView.userInteractionEnabled=NO;
    _webView.delegate=self;
    _webView.opaque = NO;
    _webView.dataDetectorTypes = UIDataDetectorTypeNone;
    [self setRemarksWithWebView:@"添加订单备注："];
    
//    40 170
    payView=[UIView getCustomViewWithColor:nil];
    [self addSubview:payView];
    payView.frame=CGRectMake(0, CGRectGetMaxY(_webView.frame), ScreenWidth, _isShow?170:41);
    
    middleLine=[UIView getCustomViewWithColor:_define_black_color];
    [payView addSubview:middleLine];
    [middleLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(kEdge);
        make.right.mas_equalTo(-kEdge);
        make.height.mas_equalTo(1);
    }];
    
    UILabel *payWay=[UILabel getLabelWithAlignment:0 WithTitle:@"支付方式" WithFont:15.0f WithTextColor:nil WithSpacing:0];
    [payView addSubview:payWay];
    [payWay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(middleLine.mas_bottom).with.offset(0);
        make.left.mas_equalTo(kEdge);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(40);
    }];
    
    
    UIButton *pulldowBtn=[UIButton getCustomImgBtnWithImageStr:@"System_Triangle" WithSelectedImageStr:@"System_UpTriangle"];
    [payView addSubview:pulldowBtn];
    [pulldowBtn addTarget:self action:@selector(showPayWayView:) forControlEvents:UIControlEventTouchUpInside];
    [pulldowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-kEdge);
        make.centerY.mas_equalTo(payWay);
        make.height.mas_equalTo(9);
        make.width.mas_equalTo(17);
    }];
    [pulldowBtn setEnlargeEdge:20];
    
    
    UIButton *lastview=nil;
    for (int i=0; i<3; i++) {
        NSString *normalImg=i==0?@"System_alipay_normal":i==1?@"System_wechat_normal":@"System_unionpay_normal";
        UIButton *iconBtn=[UIButton getCustomImgBtnWithImageStr:normalImg WithSelectedImageStr:nil];
        [payView addSubview:iconBtn];
        iconBtn.tag=100+i;
        iconBtn.hidden=YES;
        [iconBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(kEdge);
            make.width.mas_equalTo(kEdge);
            make.height.mas_equalTo(21);
            if(lastview)
            {
                make.top.mas_equalTo(lastview.mas_bottom).with.offset(24);
            }else
            {
                make.top.mas_equalTo(payWay.mas_bottom).with.offset(12);
            }
        }];
        
        NSString *title=i==0?@"支付宝":i==1?@"微信支付":@"银联在线支付";
        UILabel *label=[UILabel getLabelWithAlignment:0 WithTitle:title WithFont:12 WithTextColor:nil WithSpacing:0];
        [payView addSubview:label];
        label.hidden=YES;
        label.tag=200+i;
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(iconBtn.mas_right).with.offset(18);
            make.top.mas_equalTo(iconBtn);
            make.height.mas_equalTo(iconBtn);
            make.width.mas_equalTo(150);
        }];
    
//        System_check
        UIButton *selectBtn=[UIButton getCustomImgBtnWithImageStr:@"System_nocheck" WithSelectedImageStr:@"System_check"];
        [payView addSubview:selectBtn];
        selectBtn.hidden=YES;
        selectBtn.tag=300+i;
        [selectBtn addTarget:self action:@selector(choosePayAction:) forControlEvents:UIControlEventTouchUpInside];
        [selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-kEdge);
            make.centerY.mas_equalTo(iconBtn.mas_centerY);
            make.width.height.mas_equalTo(15);
        }];
        [selectBtn setEnlargeEdge:20];
        lastview=iconBtn;
    }
    [self setPayWayState];
}

#pragma mark - SomeAction
-(void)setPayWayState
{
    NSInteger _selectIndex=[_payWay isEqualToString:@"alipay"]?0:[_payWay isEqualToString:@"wechat"]?1:2;
    for (int i=0; i<3; i++) {
        UIButton *selectbtn=[self viewWithTag:300+i];
        if(_selectIndex==i)
        {
            selectbtn.selected=YES;
        }else
        {
            selectbtn.selected=NO;
        }
    }
}
-(void)choosePayAction:(UIButton *)btn
{
    NSInteger _selectIndex=btn.tag-300;
    NSString *__payway=_selectIndex==0?@"alipay":_selectIndex==1?@"wechat":@"unionpay";
    if(![__payway isEqualToString:_payWay])
    {
        _payWay=__payway;
        [self setPayWayState];
        _block(@"pay_way_change",CGRectGetMaxY(payView.frame)+10,_payWay);
    }
}
-(void)showPayWayView:(UIButton *)btn
{
    if(btn.selected)
    {
        btn.selected=NO;
        _isShow=NO;
    }else
    {
        btn.selected=YES;
        _isShow=YES;
    }
    for (int i=0; i<3; i++) {
        UIButton *iconbtn=[self viewWithTag:100+i];
        UILabel *label=[self viewWithTag:200+i];
        UIButton *selectbtn=[self viewWithTag:300+i];
        iconbtn.hidden=!_isShow;
        label.hidden=!_isShow;
        selectbtn.hidden=!_isShow;
    }
    
    payView.frame=CGRectMake(0, CGRectGetMaxY(remarksView.frame)+10, ScreenWidth, _isShow?170:41);
    _block(@"height",CGRectGetMaxY(payView.frame)+10,_payWay);
}
/**
 * 添加备注
 */
-(void)remarksAction{
    _block(@"remarks",0,_payWay);
}
/**
 * 备注填写完毕之后，回调更新备注视图的内容
 */
-(void)setRemarksWithWebView:(NSString *)content
{
    NSString *font=@"12px/15px";
    [_webView loadHTMLString:[NSString stringWithFormat:@"<style>body{word-wrap:break-word;margin:0;background-color:#ffffff;font:%@ Custom-Font-Name;align:justify;color:#a8a7a7}</style><div align='justify'>%@<div>",font,content] baseURL:nil];
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
    remarksView.frame=CGRectMake(CGRectGetMinX(remarksView.frame), CGRectGetMinY(remarksView.frame), CGRectGetWidth(remarksView.frame), frame.size.height);
    payView.frame=CGRectMake(0, CGRectGetMaxY(remarksView.frame)+10, ScreenWidth, _isShow?170:41);
    _block(@"height",CGRectGetMaxY(payView.frame)+10,_payWay);
}

#pragma mark - 弃用代码
//-(instancetype)initWithDataArr:(NSArray *)dataArr Withfreight:(NSString *)freight WithPayWay:(NSString *)payWay WithCountPrice:(NSString *)subTotal WithBlock:(void (^)(NSString *type,CGFloat height,NSString *payWay))block
//{
//    self=[super init];
//    if(self)
//    {
//        _payWay=payWay;
//        _subTotal=subTotal;
//        _freight=freight;
//        _dataArr=dataArr;
//        _block=block;
//        _isShow=NO;
//        [self UIConfig];
//    }
//    return self;
//}
///**
// * 创建总结视图(小计)
// */
//-(void)CreateTotalView
//{
//    totalView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 150)];
//    totalView.backgroundColor=[UIColor whiteColor];
//    [self addSubview:totalView];
//    
//    CGFloat _Freight=_dataArr.count*[_freight floatValue];
//    
//    CGFloat _count=[_subTotal floatValue];
//    CGFloat _countPrice=_count+_Freight;
//    
//    NSArray *content=@[
//                       @"总结"
//                       ,[[NSString alloc] initWithFormat:@"小计(%ld)"
//                         ,[self getGoodsCount]]
//                       ,[[NSString alloc] initWithFormat:@"￥%.1lf",_count]
//                       ,@"运费"
//                       ,[[NSString alloc] initWithFormat:@"￥%.0lf",_Freight]
//                       ,@"总计"
//                       ,[[NSString alloc] initWithFormat:@"￥%.1lf",_countPrice]
//                       ];
//    CGFloat _y_p=0;
//    CGFloat _x_p=20;
//    CGFloat _width=(ScreenWidth/2.0f)-40;
//    NSInteger _algin=0;
//    for (int i=0; i<content.count; i++) {
//        if(i==0)
//        {
//            _y_p=0;
//            _x_p=20;
//            _algin=0;
//        }else
//        {
//            _y_p=30*((i+1)/2);
//            _x_p=20+_width*((i+1)%2);
//            if((i+1)%2)
//            {
//                _algin=2;
//            }else
//            {
//                _algin=0;
//            }
//            
//        }
//        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(_x_p, _y_p,_width , 30)];
//        [totalView addSubview:label];
//        label.textColor=[UIColor blackColor];
//        label.textAlignment=_algin;
//        label.text=content[i];
//    }
//}
///**
// * 创建支付视图
// */
//-(void)CreatePayView
//{
//    payView=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(totalView.frame)+2, ScreenWidth, 40)];
//    payView.backgroundColor=[UIColor whiteColor];
//    [self addSubview:payView];
//    
//    for (int i=0; i<2; i++) {
//        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(20+200*i, 5, i==0?170:90, 30)];
//        [payView addSubview:label];
//        label.textAlignment=i==0?0:2;
//        label.textColor=i==0?[UIColor blackColor]:[UIColor lightGrayColor];
//        label.text=i==0?@"支付方式":@"支付宝";
//    }
//}
///**
// * 获取结算页面的订单个数
// */
//-(NSInteger )getGoodsCount
//{
//    NSInteger _num=0;
//    for (DD_ClearingSeriesModel *_Series in _dataArr) {
//        _num+=_Series.items.count;
//    }
//    return _num;
//}
@end
