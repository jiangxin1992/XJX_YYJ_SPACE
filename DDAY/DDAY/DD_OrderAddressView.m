//
//  DD_OrderAddressView.m
//  DDAY
//
//  Created by yyj on 16/6/8.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_OrderAddressView.h"

@implementation DD_OrderAddressView
{
    UILabel *_phone;
    UILabel *_address;
    UILabel *_name;
    UILabel *_title_label;
    UIView *_upView;
    UIView *_downView;
    

}
#pragma mark - 初始化
-(instancetype)initWithFrame:(CGRect)frame WithOrderDetailInfoModel:(DD_OrderDetailModel *)OrderDetailModel WithBlock:(void (^)(NSString *type))block
{
    self=[super initWithFrame:frame];
    if(self)
    {
        _DetailModel=OrderDetailModel;
        _addressBlock=block;
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
    [self CreateUpView];
    [self CreateDownView];
}
-(void)CreateUpView
{
    _upView=[[UIView alloc] initWithFrame:CGRectMake(0, 2, ScreenWidth, 96)];
    [self addSubview:_upView];
    _upView.backgroundColor=[UIColor grayColor];
    
    NSString *status=nil;
    if(_DetailModel.orderInfo.isPay)
    {
        if(_DetailModel.orderInfo.orderList.count)
        {
            
            DD_OrderModel *_OrderModel=[_DetailModel.orderInfo.orderList objectAtIndex:0];
            long _status=_OrderModel.orderStatus;
            status=_status==0?@"待付款":_status==1?@"待发货":_status==2?@"待收货":_status==3?@"交易成功":_status==4?@"申请退款":_status==5?@"退款处理中":_status==6?@"已退款":@"拒绝退款";
        }
    }else
    {
        status=@"待付款";
    }
    NSArray *arr=@[@"订单号",_DetailModel.orderInfo.tradeOrderCode,@"订单状态",status];
    CGFloat _width=0;
    CGFloat _x_p=0;
    for (int i=0; i<arr.count; i++) {
        _width=i%2?(ScreenWidth-100-40):100;
        _x_p=i%2?120:20;
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(_x_p, 8+40*(i/2), _width, 40)];
        [_upView addSubview:label];
        label.textColor=[UIColor whiteColor];
        label.text=arr[i];
        label.textAlignment=0;
    }
}
-(void)CreateDownView
{
    _downView=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_upView.frame)+2, ScreenWidth, 118)];
    [self addSubview:_downView];
    _downView.backgroundColor=[UIColor whiteColor];
    
    _title_label=[[UILabel alloc] initWithFrame:CGRectMake(20,5, 60, 40)];
    [_downView addSubview:_title_label];
    _title_label.textAlignment=0;
    _title_label.textColor=[UIColor blackColor];
    
    _name=[[UILabel alloc] initWithFrame:CGRectMake(90,5, 100, 40)];
    [_downView addSubview:_name];
    _name.textAlignment=0;
    _name.textColor=[UIColor blackColor];
    
    _phone=[[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-160,5, 150, 40)];
    [_downView addSubview:_phone];
    _phone.textAlignment=0;
    _phone.numberOfLines=0;
    _phone.textColor=[UIColor blackColor];
    
    _address=[[UILabel alloc] initWithFrame:CGRectMake(20, 45, ScreenWidth-40, 70)];
    [_downView addSubview:_address];
    _address.textAlignment=0;
    _address.textColor=[UIColor blackColor];
}
#pragma mark - SetState
-(void)SetState
{
    if(_DetailModel.address==nil)
    {
        _title_label.text=@"";
        _address.text=@"";
        _phone.text=@"";
        _name.text=@"";
        
    }else
    {
        _title_label.text=@"收件人";
        _address.text=_DetailModel.address.detailAddress;
        _phone.text=_DetailModel.address.deliverPhone;
        _name.text=_DetailModel.address.deliverName;
    }
}
@end
