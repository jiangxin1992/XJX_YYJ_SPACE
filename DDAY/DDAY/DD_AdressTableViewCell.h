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

@property (nonatomic,strong) DD_AddressModel *AddressModel;
__string(defaultID);
__block_type(alertblock, type);
@end
