//
//  DD_AdressTableViewCell.m
//  DDAY
//
//  Created by yyj on 16/5/17.
//  Copyright © 2016年 mike_xie. All rights reserved.
//

#import "DD_AdressTableViewCell.h"

@implementation DD_AdressTableViewCell
{
    UILabel *addressName;
    UILabel *detailAddress;
    UILabel *phoneNum;
    UIButton *alertBtn;
}

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
    addressName=[[UILabel alloc] initWithFrame:CGRectMake(20, 5, 150, 20)];
    [self.contentView addSubview:addressName];
    addressName.textAlignment=0;
    addressName.textColor=[UIColor blackColor];
    
    phoneNum=[[UILabel alloc] initWithFrame:CGRectMake(200, 5, 150, 20)];
    [self.contentView addSubview:phoneNum];
    phoneNum.textAlignment=0;
    phoneNum.textColor=[UIColor blackColor];
    
    detailAddress=[[UILabel alloc] initWithFrame:CGRectMake(20, 25, 300, 30)];
    [self.contentView addSubview:detailAddress];
    detailAddress.textAlignment=0;
    detailAddress.numberOfLines=0;
    detailAddress.textColor=[UIColor blackColor];
    
    alertBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:alertBtn];
    alertBtn.frame=CGRectMake(305, 15, 50, 50);
    [alertBtn setTitle:@"修改" forState:UIControlStateNormal];
    [alertBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [alertBtn addTarget:self action:@selector(alertAction) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark - Setter
-(void)setAddressModel:(DD_AddressModel *)AddressModel WithDefaultID:(NSString *)defaultID
{
    _AddressModel=AddressModel;
    _defaultID=defaultID;
    addressName.text=_AddressModel.deliverName;
    
    if([_AddressModel.udaId isEqualToString:_defaultID])
    {
        detailAddress.text=[[NSString alloc] initWithFormat:@"[默认地址]%@",_AddressModel.detailAddress];
    }else
    {
        detailAddress.text=_AddressModel.detailAddress;
    }
    phoneNum.text=_AddressModel.deliverPhone;
    
}
#pragma mark - SomeAction
-(void)alertAction
{
    self.alertblock(@"alert");
}
#pragma mark - Other
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
