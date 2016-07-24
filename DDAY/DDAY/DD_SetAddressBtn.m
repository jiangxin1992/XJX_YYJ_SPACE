//
//  DD_SetAddressBtn.m
//  DDAY
//
//  Created by yyj on 16/5/24.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_SetAddressBtn.h"

@implementation DD_SetAddressBtn{
    UILabel *_phone;
    UILabel *_address;
    UILabel *_name;
    UILabel *_title_label;
}
/**
 * 初始化方法
 */
+(instancetype)buttonWithType:(UIButtonType)buttonType WithFrame:(CGRect )frame WithAddressModel:(DD_AddressModel *)AddressModel WithBlock:(void(^)(NSString *type))block
{
    DD_SetAddressBtn *btn=[DD_SetAddressBtn buttonWithType:UIButtonTypeCustom];
    if(btn)
    {
        btn.touchBlock=block;
        btn.AddressModel=AddressModel;
        btn.frame=frame;
        [btn SomePrepare];
        [btn UIConfig];
        [btn SetState];
    }
    return btn;
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
    [self addTarget:self action:@selector(touchAction) forControlEvents:UIControlEventTouchUpInside];
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}
#pragma mark - SomeActions
-(void)touchAction
{
    _touchBlock(@"address");
}
#pragma mark - UIConfig
-(void)UIConfig
{
    _title_label=[[UILabel alloc] initWithFrame:CGRectMake(20,5, 60, 40)];
    [self addSubview:_title_label];
    _title_label.textAlignment=0;
    _title_label.textColor=[UIColor blackColor];
    
    _name=[[UILabel alloc] initWithFrame:CGRectMake(90,5, 100, 40)];
    [self addSubview:_name];
    _name.textAlignment=0;
    _name.textColor=[UIColor blackColor];
    
    _phone=[[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-160,5, 150, 40)];
    [self addSubview:_phone];
    _phone.textAlignment=0;
    _phone.numberOfLines=0;
    _phone.textColor=[UIColor blackColor];
    
    _address=[[UILabel alloc] initWithFrame:CGRectMake(20, 45, ScreenWidth-40, 70)];
    [self addSubview:_address];
    _address.textAlignment=0;
    _address.textColor=[UIColor blackColor];
    
}

#pragma mark - SetState
-(void)SetState
{
    if(_AddressModel==nil)
    {
        [self setTitle:@" + 添加收货地址" forState:UIControlStateNormal];
        _title_label.text=@"";
        _address.text=@"";
        _phone.text=@"";
        _name.text=@"";
        
    }else
    {
        [self setTitle:@"" forState:UIControlStateNormal];
        _title_label.text=@"收件人";
        _address.text=_AddressModel.detailAddress;
        _phone.text=_AddressModel.deliverPhone;
        _name.text=_AddressModel.deliverName;
    }
    
}
@end
