//
//  DD_OrderClearingView.m
//  DDAY
//
//  Created by yyj on 16/6/7.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_OrderClearingView.h"

#import "DD_OrderModel.h"
#import "DD_OrderItemModel.h"

#define _jiange 9

@interface DD_OrderClearingView()<UIWebViewDelegate>

@end

@implementation DD_OrderClearingView
{
    UIView *totalView;
    UIView *payView;
    UIView *remarksView;
}
#pragma mark - 初始化方法
-(instancetype)initWithOrderDetailInfoModel:(DD_OrderDetailInfoModel *)orderInfo Withfreight:(CGFloat )freight WithCountPrice:(NSString *)subTotal WithBlock:(void (^)(NSString *type,CGFloat height))block
{
    self=[super init];
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
    [self CreateRemarksView];
    [self CreatePayView];
    [self CreateTotalView];
}
/**
 * 创建备注视图
 */
-(void)CreateRemarksView
{
    remarksView=[UIView getCustomViewWithColor:nil];
    [self addSubview:remarksView];
    [remarksView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
    }];
    
    UILabel *titlelabel=[UILabel getLabelWithAlignment:0 WithTitle:@"订单备注:" WithFont:13.0f WithTextColor:_define_light_gray_color1 WithSpacing:0];
    [remarksView addSubview:titlelabel];
    [titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(kEdge);
    }];
    [titlelabel sizeToFit];
    
    UILabel *weblabel=[UILabel getLabelWithAlignment:0 WithTitle:_orderInfo.memo WithFont:13.0f WithTextColor:_define_light_gray_color1 WithSpacing:0];
    [remarksView addSubview:weblabel];
    weblabel.numberOfLines=0;
    [weblabel sizeToFit];
    weblabel.lineBreakMode=NSLineBreakByCharWrapping;
    [weblabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titlelabel.mas_bottom).with.offset(_jiange);
        make.width.mas_equalTo(ScreenWidth-2*kEdge);
        make.centerX.mas_equalTo(self);
        make.bottom.mas_equalTo(remarksView.mas_bottom).with.offset(-_jiange);
    }];
}
/**
 * 创建支付视图
 */
-(void)CreatePayView
{
    payView=[UIView getCustomViewWithColor:nil];
    [self addSubview:payView];
    [payView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(remarksView.mas_bottom).with.offset(0);
        make.left.right.mas_equalTo(0);
    }];
    
    UIView *upline=[UIView getCustomViewWithColor:_define_black_color];
    [payView addSubview:upline];
    [upline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(kEdge);
        make.right.mas_equalTo(-kEdge);
        make.height.mas_equalTo(1);
    }];
    UIView *lastView=nil;
    for (int i=0; i<2; i++) {
        UILabel *label=[UILabel getLabelWithAlignment:i==0?0:2 WithTitle:i==0?@"支付方式":@"支付宝" WithFont:13.0f WithTextColor:i==0?_define_black_color:_define_light_gray_color1 WithSpacing:0];
        [payView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            if(i==0)
            {
                make.left.mas_equalTo(kEdge);
            }else
            {
                make.right.mas_equalTo(-kEdge);
            }
            make.top.mas_equalTo(payView.mas_top).with.offset(_jiange);
        }];
        [label sizeToFit];
        lastView=label;
    }
    [lastView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(payView.mas_bottom).with.offset(-_jiange);
    }];
}
/**
 * 创建总结视图(小计)
 */
-(void)CreateTotalView
{
    totalView=[UIView getCustomViewWithColor:nil];
    [self addSubview:totalView];
    [totalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(payView.mas_bottom).with.offset(0);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.mas_bottom).with.offset(0);
    }];
    
    UIView *upline=[UIView getCustomViewWithColor:_define_black_color];
    [totalView addSubview:upline];
    [upline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(kEdge);
        make.right.mas_equalTo(-kEdge);
        make.height.mas_equalTo(1);
    }];
    
    CGFloat _count=[_subTotal floatValue];
    CGFloat _countPrice=_count+_freight;
    
    UIView *lastView=nil;
    for (int i=0; i<2; i++) {
        UILabel *label=[UILabel getLabelWithAlignment:2 WithTitle:i==0?[[NSString alloc] initWithFormat:@"总计￥%.1lf",_countPrice]:[[NSString alloc] initWithFormat:@"共%ld件商品（含邮费￥%.0lf）",[self getGoodsCount],_freight] WithFont:15.0f WithTextColor:nil WithSpacing:0];
        [totalView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            if(lastView)
            {
                make.right.mas_equalTo(lastView.mas_left).with.offset(-20);
            }else
            {
                make.right.mas_equalTo(-kEdge);
            }
            make.top.mas_equalTo(_jiange);
        }];
        [label sizeToFit];
        
        lastView=label;
    }
    [lastView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(totalView.mas_bottom).with.offset(-_jiange);
    }];
    
    //    NSArray *content=@[
    //                       @"总结"
    //                       ,[[NSString alloc] initWithFormat:@"小计(%ld)"
    //                         ,[self getGoodsCount]]
    //                       ,[[NSString alloc] initWithFormat:@"￥%.1lf",_count]
    //                       ,@"运费"
    //                       ,[[NSString alloc] initWithFormat:@"￥%.0lf",_freight]
    //                       ,@"总计"
    //                       ,[[NSString alloc] initWithFormat:@"￥%.1lf",_countPrice]
    //                       ];   
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


#pragma mark - 弃用代码
/**
 * 备注填写完毕之后，回调更新备注视图的内容
 */
//-(void)setRemarksWithWebView:(NSString *)content
//{
//    NSString *font=@"17px/23px";
//    [_webView loadHTMLString:[NSString stringWithFormat:@"<style>body{word-wrap:break-word;margin:0;background-color:transparent;font:%@ Custom-Font-Name;align:justify;color:#9b9b9b}</style><div align='justify'>%@<div>",font,content] baseURL:nil];
//    [_webView sizeToFit];
//
//}

//#pragma mark - UIWebViewDelegate
/**
 * 适应
 */
//- (void)webViewDidFinishLoad:(UIWebView *)webView { //webview 自适应高度
//    CGRect frame = webView.frame;
//    CGSize fittingSize = [webView sizeThatFits:CGSizeZero];
//    frame.size = fittingSize;
//    [webView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(titlelabel.mas_bottom).with.offset(_jiange);
//        make.left.mas_equalTo(kEdge);
//        make.right.mas_equalTo(-kEdge);
//        make.bottom.mas_equalTo(remarksView.mas_bottom).with.offset(-_jiange);
//        make.height.mas_equalTo(frame.size.height);
//    }];
////    _block(@"height",CGRectGetMaxY(remarksView.frame));
////    [self CreateContactBtn];
//}
/**
 * 创建联系客服按钮
 */
//-(void)CreateContactBtn
//{
//    //    remarksView
//    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
//    [self addSubview:btn];
//    btn.frame=CGRectMake(10, CGRectGetMaxY(remarksView.frame)+5, ScreenWidth-20, 40);
//    btn.backgroundColor=_define_white_color;
//    [btn setTitle:@"联系客服" forState:UIControlStateNormal];
//    [btn setTitleColor:_define_black_color forState:UIControlStateNormal];
//    [btn addTarget:self action:@selector(contactAction) forControlEvents:UIControlEventTouchUpInside];
//    //    self
//}
//
//-(void)contactAction
//{
//    _block(@"contact",0);
//}
///**
// * 添加备注
// */
//-(void)remarksAction{
//    _block(@"remarks",0);
//}


@end
