//
//  DD_AdressTableViewCell.m
//  DDAY
//
//  Created by yyj on 16/5/17.
//  Copyright © 2016年 mike_xie. All rights reserved.
//

#import "DD_AdressTableViewCell.h"

@implementation DD_AdressTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier WithBlock:(void(^)(NSString *type))block
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.alertblock=block;
        [self UIConfig];
    }
    return  self;
}
#pragma mark - UIConfig
-(void)UIConfig
{
    CGFloat _jiange=9;
    _addressName=[UILabel getLabelWithAlignment:0 WithTitle:@"" WithFont:15.0f WithTextColor:nil WithSpacing:0];
    [self.contentView addSubview:_addressName];
    [_addressName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_jiange);
        make.left.mas_equalTo(26);
        make.width.lessThanOrEqualTo(@200);
    }];
    [_addressName sizeToFit];
    
    _alertBtn=[UIButton getCustomImgBtnWithImageStr:@"System_edit" WithSelectedImageStr:@"System_edit"];
    [self.contentView addSubview:_alertBtn];
    [_alertBtn addTarget:self action:@selector(alertAction) forControlEvents:UIControlEventTouchUpInside];
    [_alertBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-26);
        make.centerY.mas_equalTo(_addressName);
        make.width.height.mas_equalTo(24);
    }];
    [_alertBtn setEnlargeEdge:10];
    
    _phoneNum=[UILabel getLabelWithAlignment:0 WithTitle:@"" WithFont:14.0f WithTextColor:nil WithSpacing:0];
    [self.contentView addSubview:_phoneNum];
    [_phoneNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_addressName);
        make.top.mas_equalTo(_addressName.mas_bottom).with.offset(_jiange);
        make.width.lessThanOrEqualTo(@200);
    }];
    [_phoneNum sizeToFit];
    
    _detailAddress=[UILabel getLabelWithAlignment:0 WithTitle:@"" WithFont:12.0f WithTextColor:nil WithSpacing:0];
    [self.contentView addSubview:_detailAddress];
    _detailAddress.numberOfLines=2;
    [_detailAddress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_addressName);
        make.top.mas_equalTo(_phoneNum.mas_bottom).with.offset(_jiange);
        make.width.lessThanOrEqualTo(@(ScreenWidth-26*2));
    }];
    [_detailAddress sizeToFit];
    
    _downline=[UIView getCustomViewWithColor:_define_black_color];
    [self.contentView addSubview:_downline];
    [_downline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(26);
        make.right.mas_equalTo(-26);
        make.height.mas_equalTo(1);
        make.top.mas_equalTo(_detailAddress.mas_bottom).with.offset(_jiange);
    }];
}
#pragma mark - Setter
-(void)setIs_last:(BOOL)is_last
{
    _is_last=is_last;
    _downline.hidden=_is_last;
}
-(void)setAddressModel:(DD_AddressModel *)AddressModel WithDefaultID:(NSString *)defaultID
{
    _AddressModel=AddressModel;
    _defaultID=defaultID;
    _addressName.text=_AddressModel.deliverName;
    
    if([_AddressModel.udaId isEqualToString:_defaultID])
    {
        _detailAddress.text=[[NSString alloc] initWithFormat:@"[默认地址]%@",_AddressModel.detailAddress];
    }else
    {
        _detailAddress.text=_AddressModel.detailAddress;
    }
    _phoneNum.text=_AddressModel.deliverPhone;
    
}
#pragma mark - SomeAction
-(void)alertAction
{
    self.alertblock(@"alert");
}

+ (CGFloat)heightWithModel:(DD_AddressModel *)model WithDefaultID:(NSString *)defaultID{
    DD_AdressTableViewCell *cell = [[DD_AdressTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"" WithBlock:nil];
    [cell setAddressModel:model WithDefaultID:defaultID];
    [cell.contentView layoutIfNeeded];
    CGRect frame =  cell.downline.frame;
    return frame.origin.y + frame.size.height;
}
#pragma mark - Other
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
