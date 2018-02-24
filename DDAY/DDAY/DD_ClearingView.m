//
//  DD_ClearingView.m
//  DDAY
//
//  Created by yyj on 16/5/24.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_ClearingView.h"

#import <WebKit/WebKit.h>

//#import "DD_ClearingTool.h"
#import "DD_ClearingSeriesModel.h"
#import "DD_ClearingOrderModel.h"
#import "DD_BenefitInfoModel.h"
#import "DD_ClearingModel.h"

@interface DD_ClearingView()<WKNavigationDelegate>

@end

@implementation DD_ClearingView
{
    UIButton *_chooseCouponBtn;
    UILabel *_couponLabel;
//    UIView *totalView;// 总结视图(小计)

    UIView *remarksView;// 备注的背景视图
    WKWebView *_webView;// 备注视图 remarksView子视图
    UIView *line1;
    
//    UIView *middleLine;
    UILabel *freightTitleLabel;
    UILabel *_integralLabel;
    
    UIView *payView;// 支付方式视图
    UILabel *payWayLabel;
    
    UILabel *_couponDesLabel;
    
    UISwitch *_switch;
    
    BOOL _isShow;
    
    UIImageView *_chooseImg;
    
    
}
#pragma mark - 初始化方法
-(instancetype)initWithDataArr:(NSArray *)dataArr WithClearingModel:(DD_ClearingModel *)clearingModel WithPayWay:(NSString *)payWay WithBlock:(void (^)(NSString *type,CGFloat height,NSString *payWay))block
{
    self=[super init];
    if(self)
    {
        _clearingModel=clearingModel;
        _payWay=payWay;
        _dataArr=dataArr;
        _block=block;
        _isShow=NO;
        [self UIConfig];
        [self SetPayWayState];
        [self SetState];
    }
    return self;
}
#pragma mark - UIConfig
-(void)UIConfig
{
    freightTitleLabel=[UILabel getLabelWithAlignment:0 WithTitle:@"邮费：" WithFont:12 WithTextColor:_define_light_gray_color1 WithSpacing:0];
    [self addSubview:freightTitleLabel];
    
    freightTitleLabel.frame=CGRectMake(kEdge, 0, 100, 30);
    
    CGFloat _Freight=_dataArr.count*[_clearingModel.freight floatValue];
    
    UILabel *freightLabel=[UILabel getLabelWithAlignment:2 WithTitle:[[NSString alloc] initWithFormat:@"￥%@",[regular getRoundNum:_Freight]] WithFont:12 WithTextColor:nil WithSpacing:0];
    [self addSubview:freightLabel];
    freightLabel.font=[regular getSemiboldFont:12];
    freightLabel.frame=CGRectMake(ScreenWidth-kEdge-100, 0, 100, 30);
    
    remarksView=[[UIView alloc] initWithFrame:CGRectMake(kEdge,CGRectGetMaxY(freightLabel.frame)+5 , ScreenWidth-kEdge*2, 1)];
    [self addSubview:remarksView];
    remarksView.userInteractionEnabled=YES;
//    [remarksView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(remarksAction)]];
    [remarksView bk_whenTapped:^{
//        填写备注
        _block(@"remarks",0,_payWay);
    }];
    
    _webView=[[WKWebView alloc] initWithFrame:CGRectMake(0 ,0 , ScreenWidth-kEdge*2, 1)];
    [remarksView addSubview:_webView];
    _webView.userInteractionEnabled=NO;
    _webView.navigationDelegate = self;
    [self setRemarksWithWebView:@"添加订单备注："];
    
    line1=[UIView getCustomViewWithColor:_define_light_gray_color1];
    [self addSubview:line1];
    line1.frame=CGRectMake(kEdge, CGRectGetMaxY(remarksView.frame), ScreenWidth-2*kEdge, 1);
    
    UIView *_subtotalView=[UIView getCustomViewWithColor:nil];
    [self addSubview:_subtotalView];
    [_subtotalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(line1.mas_bottom).with.offset(0);
        make.height.mas_equalTo(50);
    }];
    UILabel *_subtotalLabel=[UILabel getLabelWithAlignment:2 WithTitle:@"" WithFont:13 WithTextColor:nil WithSpacing:0];
    [_subtotalView addSubview:_subtotalLabel];
    [_subtotalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-kEdge);
        make.top.mas_equalTo(line1.mas_bottom).with.offset(0);
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(kEdge);
    }];
    
    _subtotalLabel.text=[[NSString alloc] initWithFormat:@"共 %ld 件商品 小计 ￥%@",[self getGoodsCount],[regular getRoundNum:[self getAllCountPriceWithArr:_dataArr]+_Freight]];
    
    UIView *line2=[UIView getCustomViewWithColor:_define_black_color];
    [self addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_subtotalView.mas_bottom).with.offset(0);
        make.left.mas_equalTo(kEdge);
        make.right.mas_equalTo(-kEdge);
        make.height.mas_equalTo(1);
    }];
    
    _chooseCouponBtn=[UIButton getCustomBtn];
    [self addSubview:_chooseCouponBtn];
    [_chooseCouponBtn addTarget:self action:@selector(chooseCouponAction) forControlEvents:UIControlEventTouchUpInside];
    [_chooseCouponBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(line2.mas_bottom).with.offset(0);
        make.height.mas_equalTo(50);
    }];
    _chooseImg=[UIImageView getImgWithImageStr:@"System_Arrow"];
    [_chooseCouponBtn addSubview:_chooseImg];
    [_chooseImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_chooseCouponBtn);
        make.right.mas_equalTo(-kEdge);
        make.width.mas_equalTo(10);
        make.height.mas_equalTo(18);
    }];
    
//    有XX个红包可用
    _couponLabel=[UILabel getLabelWithAlignment:0 WithTitle:@"优惠" WithFont:13.0f WithTextColor:nil WithSpacing:0];
    [_chooseCouponBtn addSubview:_couponLabel];
    [_couponLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kEdge);
        make.centerY.mas_equalTo(_chooseCouponBtn);
    }];
    _couponDesLabel=[UILabel getLabelWithAlignment:2 WithTitle:@"" WithFont:13.0f WithTextColor:_define_light_gray_color1 WithSpacing:0];
    [_chooseCouponBtn addSubview:_couponDesLabel];
    [_couponDesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_chooseImg.mas_left).with.offset(-15);
        make.centerY.mas_equalTo(_chooseCouponBtn);
        make.left.mas_equalTo(_couponLabel.mas_right).with.offset(10);
    }];
    
    UIView *line3=[UIView getCustomViewWithColor:_define_light_gray_color1];
    [self addSubview:line3];
    [line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_chooseCouponBtn.mas_bottom).with.offset(0);
        make.left.mas_equalTo(kEdge);
        make.right.mas_equalTo(-kEdge);
        make.height.mas_equalTo(1);
    }];
    
    UIView *_integralView=[UIView getCustomViewWithColor:nil];
    [self addSubview:_integralView];
    [_integralView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(line3.mas_bottom).with.offset(0);
        make.height.mas_equalTo(50);
    }];
    _switch=[[UISwitch alloc] init];
    [_integralView addSubview:_switch];
    [_switch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-kEdge);
        make.centerY.mas_equalTo(_integralView);
        make.width.mas_equalTo(35);
        make.height.mas_equalTo(20);
    }];
    
    [_switch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    // 显示的颜色
    _switch.onTintColor = [UIColor blackColor];
    // 控件大小，不能设置frame，只能用缩放比例
    _switch.transform = CGAffineTransformMakeScale(0.75, 0.75);
    // 控件开关
    _switch.on = YES;
    _integralLabel=[UILabel getLabelWithAlignment:0 WithTitle:@"" WithFont:13.0f WithTextColor:nil WithSpacing:0];
    [_integralView addSubview:_integralLabel];
    [_integralLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kEdge);
        make.centerY.mas_equalTo(_integralView);
        make.right.mas_equalTo(_switch.mas_left).with.offset(-10);
    }];
    
    
    UIView *line4=[UIView getCustomViewWithColor:_define_light_gray_color1];
    [self addSubview:line4];
    [line4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_integralView.mas_bottom).with.offset(0);
        make.left.mas_equalTo(kEdge);
        make.right.mas_equalTo(-kEdge);
        make.height.mas_equalTo(1);
    }];
    
//    40 170
    payView=[UIView getCustomViewWithColor:nil];
    [self addSubview:payView];
    [payView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line4.mas_bottom).with.offset(0);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(_isShow?170:41);
    }];
    UILabel *payWay=[UILabel getLabelWithAlignment:0 WithTitle:@"支付方式" WithFont:15.0f WithTextColor:nil WithSpacing:0];
    [payView addSubview:payWay];
    [payWay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line4.mas_bottom).with.offset(0);
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
        make.height.mas_equalTo(14);
        make.width.mas_equalTo(15);
    }];
    [pulldowBtn setEnlargeEdge:20];
    
    payWayLabel = [UILabel getLabelWithAlignment:2 WithTitle:@"" WithFont:12 WithTextColor:_define_light_gray_color1 WithSpacing:0];
    [payView addSubview:payWayLabel];
    [payWayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(pulldowBtn.mas_left).with.offset(-15);
        make.centerY.mas_equalTo(pulldowBtn);
    }];
    
    UIButton *lastview=nil;
    for (int i=0; i<1; i++) {
        NSString *normalImg=i==0?@"Order_Alipay_Normal":i==1?@"Order_wechat_normal":@"Order_unionpay_normal";
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
    
//        System_Check
        UIButton *selectBtn=[UIButton getCustomImgBtnWithImageStr:@"System_nocheck" WithSelectedImageStr:@"System_Check"];
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
    
}
#pragma mark - SetState
-(void)SetState
{
    NSInteger _count=[_clearingModel.benefitInfo count];
    if(_count)
    {
        _chooseImg.hidden=NO;
        [_couponDesLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_chooseImg.mas_left).with.offset(-15);
            make.centerY.mas_equalTo(_chooseCouponBtn);
            make.left.mas_equalTo(_couponLabel.mas_right).with.offset(10);
        }];
    }else
    {
        _chooseImg.hidden=YES;
        [_couponDesLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-kEdge);
            make.centerY.mas_equalTo(_chooseCouponBtn);
            make.left.mas_equalTo(_couponLabel.mas_right).with.offset(10);
        }];
    }
    
    if(!_clearingModel.rewardPoints)
    {
        _switch.on=NO;
        _switch.userInteractionEnabled=NO;
        _integralLabel.text=@"无积分";
    }else{
        if(_clearingModel.employ_rewardPoints)
        {
            _switch.on=_clearingModel.use_rewardPoints;
            _switch.userInteractionEnabled=YES;
        }else
        {
            _switch.on=NO;
            _switch.userInteractionEnabled=NO;
        }
        _integralLabel.text=[[NSString alloc] initWithFormat:@"可用%ld积分抵扣%ld元",_clearingModel.employ_rewardPoints,_clearingModel.employ_rewardPoints];
    }
    
    DD_BenefitInfoModel *_benefitModel=[_clearingModel getChoosedBenefitInfo];
    if(_benefitModel)
    {
        _couponDesLabel.text=_benefitModel.name;
    }else
    {
        if(_count)
        {
            _couponDesLabel.text=[[NSString alloc] initWithFormat:@"有%lu个优惠券可用",(unsigned long)[_clearingModel.benefitInfo count]];
        }else
        {
            _couponDesLabel.text=@"暂无可用优惠券";
        }
    }
}
#pragma mark - SomeAction

-(void)switchAction:(id)sender
{
    UISwitch *_mySwitch = (UISwitch *)sender;
    if(_mySwitch == _switch){
        BOOL switchStatus = _mySwitch.on;
        _clearingModel.use_rewardPoints=switchStatus;
        _block(@"switch",0,_payWay);
    }
}

-(void)chooseCouponAction
{
    NSInteger _count=[_clearingModel.benefitInfo count];
    if(_count)
    {
        _block(@"choose_coupon",0,_payWay);
    }
    
}
/**
 * 获取结算页面的订单个数
 */
-(NSInteger )getGoodsCount
{
    __block NSInteger _num=0;
    [_dataArr enumerateObjectsUsingBlock:^(DD_ClearingSeriesModel *_Series, NSUInteger idx, BOOL * _Nonnull stop) {
        _num+=_Series.items.count;
    }];

    return _num;
}
-(CGFloat )getAllCountPriceWithArr:(NSArray *)dataArr
{
    __block CGFloat _price=0;
    [dataArr enumerateObjectsUsingBlock:^(DD_ClearingSeriesModel *Series, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [Series.items enumerateObjectsUsingBlock:^(DD_ClearingOrderModel *order, NSUInteger idx2, BOOL * _Nonnull stop2) {
            _price+=[order.price floatValue]*[order.numbers integerValue];
        }];
    }];

    return _price;
}

-(void)SetPayWayState
{
    
    NSInteger _selectIndex=[_payWay isEqualToString:@"alipay"]?0:[_payWay isEqualToString:@"wechat"]?1:2;
    payWayLabel.text=_selectIndex==0?@"支付宝":_selectIndex==1?@"微信支付":@"银联在线支付";
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
        [self SetPayWayState];
        _block(@"pay_way_change",CGRectGetMaxY(payView.frame),_payWay);
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
    
    [payView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(_isShow?170:41);
    }];
    [self layoutIfNeeded];
    _block(@"height",payView.origin.y + payView.size.height,_payWay);
}
///**
// * 添加备注
// */
//-(void)remarksAction{
//    _block(@"remarks",0,_payWay);
//}
/**
 * 备注填写完毕之后，回调更新备注视图的内容
 */
-(void)setRemarksWithWebView:(NSString *)content
{
    [_webView loadHTMLString:[regular getHTMLStringWithContent:content WithFont:@"12px/15px" WithColorCode:@"#A8A7A7"] baseURL:nil];
    
    [_webView sizeToFit];
}

#pragma mark - WKNavigationDelegate

//加载完成时调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [webView evaluateJavaScript:@"document.body.offsetHeight" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        CGRect frame =webView.frame;
        frame.size.height =[result doubleValue];
        webView.frame = frame;
        remarksView.frame=CGRectMake(CGRectGetMinX(remarksView.frame), CGRectGetMinY(remarksView.frame), CGRectGetWidth(remarksView.frame), frame.size.height);
        line1.frame=CGRectMake(kEdge, CGRectGetMaxY(remarksView.frame)+10, ScreenWidth-2*kEdge, 1);
        [self layoutIfNeeded];
        CGFloat _y_p=payView.origin.y + payView.size.height;
        _block(@"height",_y_p,_payWay);
    }];
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
//    totalView.backgroundColor=_define_white_color;
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
//                       ,[regular getRoundNum:_count]
//                       ,@"运费"
//                       ,[[NSString alloc] initWithFormat:@"￥%@",[regular getRoundNum:_Freight]]
//                       ,@"总计"
//                       ,[regular getRoundNum:_countPrice]
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
//        label.textColor=_define_black_color;
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
//    payView.backgroundColor=_define_white_color;
//    [self addSubview:payView];
//    
//    for (int i=0; i<2; i++) {
//        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(20+200*i, 5, i==0?170:90, 30)];
//        [payView addSubview:label];
//        label.textAlignment=i==0?0:2;
//        label.textColor=i==0?_define_black_color:_define_light_gray_color1;
//        label.text=i==0?@"支付方式":@"支付宝";
//    }
//}

@end
