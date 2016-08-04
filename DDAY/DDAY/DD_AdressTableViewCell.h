//
//  DD_AdressTableViewCell.h
//  DDAY
//
//  Created by yyj on 16/5/17.
//  Copyright © 2016年 mike_xie. All rights reserved.
//
#import "DD_AddressModel.h"
#import <UIKit/UIKit.h>

@interface DD_AdressTableViewCell : UITableViewCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier WithBlock:(void(^)(NSString *type))block;
-(void)setAddressModel:(DD_AddressModel *)AddressModel WithDefaultID:(NSString *)defaultID;
+ (CGFloat)heightWithModel:(DD_AddressModel *)model WithDefaultID:(NSString *)defaultID;
@property (nonatomic,strong) DD_AddressModel *AddressModel;

__block_type(alertblock, type);
__string(defaultID);
__bool(is_last);

__label(addressName);
__label(detailAddress);
__label(phoneNum);
__btn(alertBtn);
__view(downline);
@end
