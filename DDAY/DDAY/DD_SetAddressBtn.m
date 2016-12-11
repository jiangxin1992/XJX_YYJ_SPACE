//
//  DD_SetAddressBtn.m
//  DDAY
//
//  Created by yyj on 16/5/24.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_SetAddressBtn.h"

#import "DD_AddressModel.h"

@implementation DD_SetAddressBtn{
    UILabel *_nameLabel;
    UILabel *_phoneLabel;
    UILabel *_addressLabel;
    UIImageView *addressImg;
}
/**
 * 初始化方法
 */
+(instancetype)buttonWithType:(UIButtonType)buttonType WithAddressModel:(DD_AddressModel *)AddressModel WithBlock:(void(^)(NSString *type))block ;
{
    DD_SetAddressBtn *btn=[DD_SetAddressBtn buttonWithType:UIButtonTypeCustom];
    if(btn)
    {
        
        btn.touchBlock=block;
        btn.AddressModel=AddressModel;
        [btn SomePrepare];
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
    self.backgroundColor=_define_white_color;
    [self addTarget:self action:@selector(touchAction) forControlEvents:UIControlEventTouchUpInside];
    [self setTitleColor:_define_black_color forState:UIControlStateNormal];
}
#pragma mark - SomeActions
-(void)touchAction
{
    _touchBlock(@"address");
}
#pragma mark - UIConfig
-(void)haveAdressView
{
    CGFloat _jianju=9.0f;
    
    _nameLabel=[UILabel getLabelWithAlignment:0 WithTitle:_AddressModel.deliverName WithFont:13.0f WithTextColor:nil WithSpacing:0];
    [self addSubview:_nameLabel];
    [_nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_jianju);
        make.left.mas_equalTo(kEdge);
    }];
//    [_nameLabel sizeToFit];
    
    addressImg=[UIImageView getImgWithImageStr:@"System_Address"];
    [self addSubview:addressImg];
    addressImg.userInteractionEnabled=NO;
    [addressImg mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_nameLabel.mas_right).with.offset(20);
        make.right.mas_equalTo(-kEdge);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(27);
        make.centerY.mas_equalTo(_nameLabel);
    }];
    
    _phoneLabel=[UILabel getLabelWithAlignment:0 WithTitle:_AddressModel.deliverPhone WithFont:13.0f WithTextColor:nil WithSpacing:0];
    [self addSubview:_phoneLabel];
    [_phoneLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_nameLabel);
        make.top.mas_equalTo(_nameLabel.mas_bottom).with.offset(_jianju);
        make.width.mas_equalTo(200);
    }];
//    [_phoneLabel sizeToFit];
    
    NSString *addressContent=[[NSString alloc] initWithFormat:@"%@ %@ %@",_AddressModel.provinceName,_AddressModel.cityName,_AddressModel.detailAddress];
    _addressLabel=[UILabel getLabelWithAlignment:0 WithTitle:addressContent WithFont:13.0f WithTextColor:nil WithSpacing:0];
    [self addSubview:_addressLabel];
    _addressLabel.numberOfLines=2;
    _addressLabel.preferredMaxLayoutWidth = ScreenWidth-kEdge*2;
    [_addressLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_nameLabel);
        make.top.mas_equalTo(_phoneLabel.mas_bottom).with.offset(_jianju);
        make.right.mas_equalTo(-kEdge);
        make.bottom.mas_equalTo(self.mas_bottom).with.offset(-_jianju-10);
    }];
//    [_addressLabel sizeToFit];
    
    
    UIView *dibu=[UIView getCustomViewWithColor:_define_black_color];
    [self addSubview:dibu];
    [dibu mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kEdge);
        make.right.mas_equalTo(-kEdge);
        make.height.mas_equalTo(1);
        make.bottom.mas_equalTo(-10);
    }];
}
-(void)noAdressView
{
    [self setTitle:@"添加收货地址" forState:UIControlStateNormal];
    self.titleLabel.font=[regular getFont:15.0f];
    [self setTitleColor:_define_black_color forState:UIControlStateNormal];
    self.contentHorizontalAlignment=1;
    [self setImage:[UIImage imageNamed:@"System_Add"] forState:UIControlStateNormal];
    UIView *con=[UIView getCustomViewWithColor:nil];
    [self addSubview:con];
    con.userInteractionEnabled=NO;
    [con mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
        make.height.mas_equalTo(39).priorityLow();
    }];
}
#pragma mark - SetState
-(void)SetState
{
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
//    for (UIView *view in self.subviews) {
//        [view removeFromSuperview];
//    }
    
    if(_AddressModel)
    {
        [self setTitle:@"" forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [self haveAdressView];        
    }else
    {
        [self noAdressView];
    }
}
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(kEdge+22+15, 0, 100, 39);
}
-(CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(kEdge, (39-22)/2.0f, 22, 22);
}
@end
