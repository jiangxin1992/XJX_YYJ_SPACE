//
//  DD_OrderDetailHeadView.m
//  YCO SPACE
//
//  Created by yyj on 2016/11/9.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_OrderDetailHeadView.h"

#define PHONEREGULAR @"\\d{3,4}[- ]?\\d{7,8}"//匹配10到12位连续数字，或者带连字符/空格的固话号，空格和连字符可以省略。

@implementation DD_OrderDetailHeadView
{

    UIView *_orderStateView;
    UILabel *_stateLabel;
    UILabel *_restTimeLabel;
    dispatch_source_t _timer;
    
    UIButton *_orderLogisticsBtn;
    UIImageView *_logisticsImgView;
    TTTAttributedLabel *_latestLogisticsInfoLabel;
    UILabel *_latestLogisticsTimeLabel;
    UIView *_logisticsDownLine;
    
    UIView *_addressView;
    UIImageView *_addressImgView;
    UILabel *_addressNameLabel;
    UILabel *_addressPhoneNumLabel;
    UILabel *_addressDetailLabel;
    UIView *_addressDownLine;
}
#pragma mark - 初始化
/**
 * 订单状态view
 * 物流状态view
 * 地址view
 */
-(instancetype)initWithOrderDetailModel:(DD_OrderDetailModel *)orderDetailModel WithOrderModel:(DD_OrderModel *)orderModel WithBlock:(void (^)(NSString *type,CGFloat height,NSString *phonenum))block
{
    self=[super init];
    if(self)
    {
        _orderDetailModel=orderDetailModel;
        _orderModel=orderModel;
        _block=block;
        [self SomePrepare];
        [self UIConfig];
        [self SetState];
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
-(void)PrepareUI{}

#pragma mark - UIConfig

-(void)UIConfig
{
    [self CreateOrderStateView];
    [self CreateOrderLogisticsView];
    [self CteateAddressView];
}
-(void)CteateAddressView
{
    
    if(!_addressView)
    {
        _addressView=[UIView getCustomViewWithColor:nil];
        [self addSubview:_addressView];
        
        _addressImgView=[UIImageView getImgWithImageStr:@"System_address"];
        [_addressView addSubview:_addressImgView];
        
        
        _addressNameLabel=[UILabel getLabelWithAlignment:0 WithTitle:@"" WithFont:13.0f WithTextColor:nil WithSpacing:0];
        [_addressView addSubview:_addressNameLabel];
        
        _addressPhoneNumLabel=[UILabel getLabelWithAlignment:0 WithTitle:@"" WithFont:13.0f WithTextColor:nil WithSpacing:0];
        [_addressView addSubview:_addressPhoneNumLabel];
        _addressPhoneNumLabel.font=[regular get_en_Font:13.0f];
        
        _addressDetailLabel=[UILabel getLabelWithAlignment:0 WithTitle:@"" WithFont:13.0f WithTextColor:nil WithSpacing:0];
        [_addressView addSubview:_addressDetailLabel];
        _addressDetailLabel.numberOfLines=2;
        
        _addressDownLine=[UIView getCustomViewWithColor:_define_black_color];
        [_addressView addSubview:_addressDownLine];
    }
}

-(void)CreateOrderLogisticsView
{
    if(!_orderLogisticsBtn)
    {
        _orderLogisticsBtn=[UIButton getCustomBtn];
        [self addSubview:_orderLogisticsBtn];
        [_orderLogisticsBtn addTarget:self action:@selector(enterLogisticDetailView) forControlEvents:UIControlEventTouchUpInside];
        
        _logisticsImgView=[UIImageView getCustomImg];
        [_orderLogisticsBtn addSubview:_logisticsImgView];
        
        _latestLogisticsInfoLabel=[[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        [_orderLogisticsBtn addSubview:_latestLogisticsInfoLabel];
        _latestLogisticsInfoLabel.textAlignment=0;
        _latestLogisticsInfoLabel.numberOfLines=0;
        _latestLogisticsInfoLabel.delegate=self;
        _latestLogisticsInfoLabel.linkAttributes = @{NSForegroundColorAttributeName:[UIColor blueColor]};
        _latestLogisticsInfoLabel.activeLinkAttributes = @{NSForegroundColorAttributeName:[UIColor blueColor]};
        _latestLogisticsInfoLabel.inactiveLinkAttributes = @{NSForegroundColorAttributeName:[UIColor blueColor]};

        _latestLogisticsTimeLabel=[UILabel getLabelWithAlignment:0 WithTitle:@"" WithFont:12.0f WithTextColor:_define_light_gray_color1 WithSpacing:0];
        [_orderLogisticsBtn addSubview:_latestLogisticsTimeLabel];
        
        _logisticsDownLine=[UIView getCustomViewWithColor:_define_light_gray_color1];
        [_orderLogisticsBtn addSubview:_logisticsDownLine];
    }
}

-(void)CreateOrderStateView
{
    if(!_orderStateView)
    {
        _orderStateView=[UIView getCustomViewWithColor:nil];
        [self addSubview:_orderStateView];
        _orderStateView.layer.masksToBounds=YES;
        _orderStateView.layer.borderWidth=1;
        _orderStateView.layer.borderColor=[_define_black_color CGColor];
        [_orderStateView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(kEdge);
            make.right.mas_equalTo(-kEdge);
            make.top.mas_equalTo(10);
            make.height.mas_equalTo(44);
        }];
        
        _stateLabel=[UILabel getLabelWithAlignment:2 WithTitle:@"" WithFont:15.0f WithTextColor:nil WithSpacing:0];
        [_orderStateView addSubview:_stateLabel];
        
        _restTimeLabel=[UILabel getLabelWithAlignment:0 WithTitle:@"" WithFont:12.0f WithTextColor:_define_light_gray_color1 WithSpacing:0];
        [_orderStateView addSubview:_restTimeLabel];

    }
}
#pragma mark - SetState

/**
 * 设置当前视图状态
 */
-(void)SetState
{
    [self SetOrderStateView];
    [self SetOrderLogisticsView];
    [self SetAddressView];
    
    [self layoutIfNeeded];
    CGFloat _y_p=_addressView.origin.y + _addressView.size.height;
    _block(@"height",_y_p,@"");
}
-(void)SetAddressView
{
    
    [_addressView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_orderLogisticsBtn.mas_bottom).with.offset(0);
        make.left.right.mas_equalTo(0);
    }];
    [_addressNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        if(_orderDetailModel.logisticsModel)
        {
            make.left.mas_equalTo(kEdge+39);
        }else
        {
            make.left.mas_equalTo(kEdge);
        }
        make.top.mas_equalTo(15);
        make.right.mas_equalTo(-kEdge-30);
    }];
    
    
    [_addressPhoneNumLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_addressNameLabel.mas_bottom).with.offset(8);
        make.left.mas_equalTo(_addressNameLabel);
        make.right.mas_equalTo(-kEdge-30);
    }];
    
    [_addressDetailLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_addressPhoneNumLabel.mas_bottom).with.offset(8);
        make.left.mas_equalTo(_addressNameLabel);
        make.right.mas_equalTo(-kEdge);
    }];
    
    [_addressImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(27);
        if(_orderDetailModel.logisticsModel)
        {
            make.centerY.mas_equalTo(_addressPhoneNumLabel);
            make.left.mas_equalTo(kEdge+4);
        }else
        {
            make.top.mas_equalTo(_addressNameLabel);
            make.right.mas_equalTo(-kEdge);
        }
    }];
    
    [_addressDownLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_addressDetailLabel.mas_bottom).with.offset(15);
        make.left.mas_equalTo(kEdge);
        make.right.mas_equalTo(-kEdge);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    
    _addressNameLabel.text=_orderDetailModel.address.deliverName;
    _addressPhoneNumLabel.text=_orderDetailModel.address.deliverPhone;
    _addressDetailLabel.text=[[NSString alloc] initWithFormat:@"%@ %@ %@",_orderDetailModel.address.provinceName,_orderDetailModel.address.cityName,_orderDetailModel.address.detailAddress];
    
}
-(void)SetOrderLogisticsView
{
    
    [_orderLogisticsBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_orderStateView.mas_bottom).mas_equalTo(0);
        make.left.right.mas_equalTo(0);
    }];
    
    [_logisticsImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kEdge);
        if(_orderDetailModel.logisticsModel)
        {
            make.height.width.mas_equalTo(28);
            make.top.mas_equalTo(15);
        }else
        {
            make.height.width.mas_equalTo(0);
            make.top.mas_equalTo(0);
        }
    }];
    
    [_latestLogisticsInfoLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_logisticsImgView);
        make.right.mas_equalTo(-kEdge);
        make.left.mas_equalTo(_logisticsImgView.mas_right).with.offset(10);
        if(_orderDetailModel.logisticsModel)
        {
            make.height.mas_equalTo([regular getHeightWithWidth:ScreenWidth-2*kEdge-28-10 WithContent:_orderDetailModel.logisticsModel.AcceptStation WithFont:[regular getFont:13.0f]]);
        }else
        {
            make.height.mas_equalTo(0);
        }
    }];
    
    [_latestLogisticsTimeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-kEdge);
        make.left.mas_equalTo(_logisticsImgView.mas_right).with.offset(10);
        if(_orderDetailModel.logisticsModel)
        {
            make.top.mas_equalTo(_latestLogisticsInfoLabel.mas_bottom).with.offset(8);
            
        }else
        {
            make.top.mas_equalTo(0);
        }
    }];
    
    [_logisticsDownLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-kEdge);
        make.left.mas_equalTo(_logisticsImgView.mas_right).with.offset(10);
        if(_orderDetailModel.logisticsModel)
        {
            make.top.mas_equalTo(_latestLogisticsTimeLabel.mas_bottom).with.offset(15);
            make.height.mas_equalTo(1);
        }else
        {
            make.top.mas_equalTo(0);
            make.height.mas_equalTo(0);
        }
        make.bottom.mas_equalTo(0);
        
    }];
    
    if(_orderDetailModel.logisticsModel)
    {
        _logisticsImgView.image=[UIImage imageNamed:@"System_Logistics"];
        
        
        //设置段落，文字样式
        NSMutableParagraphStyle *paragraphstyle = [[NSMutableParagraphStyle alloc] init];
        paragraphstyle.lineSpacing = 0;
        NSDictionary *paragraphDic = @{NSFontAttributeName:[regular getFont:13.0f],NSParagraphStyleAttributeName:paragraphstyle};
        NSMutableAttributedString *tempStr = [[NSMutableAttributedString alloc] initWithString:_orderDetailModel.logisticsModel.AcceptStation  attributes:paragraphDic];
        
        [tempStr addAttribute:NSForegroundColorAttributeName value:_define_black_color range:NSMakeRange(0, _orderDetailModel.logisticsModel.AcceptStation.length)];
        
        _latestLogisticsInfoLabel.text = tempStr;
        
        NSRange stringRange = NSMakeRange(0, _orderDetailModel.logisticsModel.AcceptStation.length);
        //正则匹配
        NSError *error;
        NSRegularExpression *regexps = [NSRegularExpression regularExpressionWithPattern:PHONEREGULAR options:0 error:&error];
        if (!error && regexps != nil) {
            [regexps enumerateMatchesInString:_orderDetailModel.logisticsModel.AcceptStation options:0 range:stringRange usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
                
                //添加链接
                NSString *actionString = [NSString stringWithFormat:@"%@",[_orderDetailModel.logisticsModel.AcceptStation substringWithRange:result.range]];
                
                if ([regular isMobilePhoneOrtelePhone:actionString] || [[actionString substringToIndex:3] isEqualToString:@"400"]) {
                    [_latestLogisticsInfoLabel addLinkToPhoneNumber:actionString withRange:result.range];
                }
            }];
        }
        
        
        _latestLogisticsTimeLabel.text=[regular getTimeStr:_orderDetailModel.logisticsModel.AcceptTime WithFormatter:@"YYYY-MM-dd HH:mm"];
    }else
    {
        _logisticsImgView.image=[UIImage imageNamed:@""];
        _latestLogisticsInfoLabel.text=@"";
        _latestLogisticsTimeLabel.text=@"";
    }
}
-(void)SetOrderStateView
{
    long _status=_orderModel.orderStatus;
    _stateLabel.text=_status==0?@"待付款":_status==1?@"待发货":_status==2?@"待收货":_status==3?@"交易成功":_status==4?@"申请退款":_status==5?@"退款处理中":_status==6?@"已退款":@"拒绝退款";
    _stateLabel.textAlignment=_status?1:2;
    [_stateLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        if(_status)
        {
            make.edges.mas_equalTo(_orderStateView);
        }else
        {
            make.left.top.bottom.mas_equalTo(0);
            make.width.mas_equalTo(110);
        }
    }];
    
    
    [_restTimeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        if(_status)
        {
            make.edges.mas_equalTo(_orderStateView);
        }else
        {
            make.left.mas_equalTo(_stateLabel.mas_right).with.offset(12);
            make.top.bottom.right.mas_equalTo(0);
        }
    }];
    
    if(!_status)
    {
        [self orderCountdown];
    }else
    {
        _restTimeLabel.text=@"";
    }
}
#pragma mark  ---------------TTTAttributedLabelDelegate--------------

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithPhoneNumber:(NSString *)phoneNumber {
    //点击手机号
    _block(@"phone_click",0,phoneNumber);
}

#pragma mark - SomeAction
/**
 * 跳转物流详情页
 */
-(void)enterLogisticDetailView
{
    _block(@"enter_logistics",0,@"");
}
/**
 * 订单关闭倒计时
 */
-(void)orderCountdown
{
    [regular dispatch_cancel:_timer];
    _timer=nil;
    
    if(_orderDetailModel.orderInfo.orderCancelTime>_orderDetailModel.orderInfo.createTime)
    {
        __block NSInteger timeout=_orderDetailModel.orderInfo.orderCancelTime-_orderDetailModel.orderInfo.createTime;
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    
        dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
        dispatch_source_set_event_handler(_timer, ^{
            if(timeout==0){ //倒计时结束，关闭
                dispatch_source_cancel(_timer);
                dispatch_async(dispatch_get_main_queue(), ^{
                    //时间已到 自动取消订单
                    [self dispatch_cancel];
                    _block(@"close",0,@"");
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
    
                    NSCalendar *cal = [NSCalendar currentCalendar];//定义一个NSCalendar对象
                    //用来得到具体的时差
                    unsigned int unitFlags = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
                    NSDateComponents *d = [cal components:unitFlags fromDate:[NSDate nowDate] toDate:[NSDate dateWithTimeIntervalSince1970:[NSDate nowTime]+timeout] options:0];
                    
                    _restTimeLabel.text=[[NSString alloc] initWithFormat:@"%ld分%ld秒后自动取消订单",[d minute],[d second]];
                    timeout--;
                });
            }
        });
        dispatch_resume(_timer);
    }
}

/**
 * 关闭线程
 * 置空
 */
-(void)dispatch_cancel
{
    [regular dispatch_cancel:_timer];
    _timer=nil;
}

@end