//
//  DD_ShowRoomSimpleCell.m
//  YCO SPACE
//
//  Created by yyj on 16/9/12.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_ShowRoomSimpleCell.h"

@implementation DD_ShowRoomSimpleCell
{
    UILabel *_storeName;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark - 初始化
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self UIConfig];
    }
    return  self;
}
#pragma mark - UIConfig
-(void)UIConfig
{
    UIImageView *_head=[UIImageView getImgWithImageStr:@"User_ShowRoom"];
    [self.contentView addSubview:_head];
    [_head mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kEdge);
        make.top.mas_equalTo(25);
        make.width.height.mas_equalTo(23);
    }];
    
    _storeName=[UILabel getLabelWithAlignment:0 WithTitle:@"" WithFont:13.0f WithTextColor:nil WithSpacing:0];
    [self.contentView addSubview:_storeName];
    [_storeName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_head.mas_right).with.offset(10);
        make.bottom.mas_equalTo(_head);
    }];
    [_storeName sizeToFit];
    
    _address=[UILabel getLabelWithAlignment:0 WithTitle:@"" WithFont:13.0f WithTextColor:nil WithSpacing:0];
    [self.contentView addSubview:_address];
    _address.numberOfLines=1;
    [_address mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kEdge);
        make.right.mas_equalTo(-kEdge);
        make.top.mas_equalTo(_head.mas_bottom).with.offset(6);
    }];
    [_address sizeToFit];
    
    UIView *downLine=[UIView getCustomViewWithColor:_define_black_color];
    [self.contentView addSubview:downLine];
    [downLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kEdge);
        make.right.mas_equalTo(-kEdge);
        make.height.mas_equalTo(1);
        make.bottom.mas_equalTo(0);
    }];
}
#pragma mark - Setter
-(void)setShowRoomModel:(DD_ShowRoomModel *)showRoomModel
{
    _showRoomModel=showRoomModel;
    _storeName.text=_showRoomModel.storeName;
    _address.text=_showRoomModel.address;
}

+ (CGFloat)heightWithModel:(DD_ShowRoomModel *)model{
    DD_ShowRoomSimpleCell *cell = [[DD_ShowRoomSimpleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
    cell.showRoomModel=model;
    [cell.contentView layoutIfNeeded];
    CGRect frame =  cell.address.frame;
    CGFloat _height=frame.origin.y + frame.size.height+25;
    return _height;
}

@end
