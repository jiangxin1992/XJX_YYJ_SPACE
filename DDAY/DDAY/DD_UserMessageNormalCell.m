//
//  DD_UserMessageNormalCell.m
//  YCO SPACE
//
//  Created by yyj on 16/9/14.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_UserMessageNormalCell.h"

#import "DD_UserMessageItemModel.h"

@implementation DD_UserMessageNormalCell
{
    UILabel *_titleLabel;
    UILabel *_timeLabel;
    UIView *_view;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}
#pragma mark - 初始化
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier WithBlock:(void(^)(NSString *type))block
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        _block=block;
        [self UIConfig];
    }
    return  self;
}
#pragma mark - UIConfig
-(void)UIConfig
{
    
    _titleLabel=[UILabel getLabelWithAlignment:0 WithTitle:@"" WithFont:13.0f WithTextColor:nil WithSpacing:0];
    [self.contentView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kEdge);
        make.centerY.mas_equalTo(self.contentView);
        make.right.mas_equalTo(-kEdge);
    }];
    
    _timeLabel=[UILabel getLabelWithAlignment:2 WithTitle:@"" WithFont:12.0f WithTextColor:_define_light_gray_color1 WithSpacing:0];
    [self.contentView addSubview:_timeLabel];
    _timeLabel.font=[regular get_en_Font:12.0f];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-kEdge);
        make.bottom.mas_equalTo(self.contentView);
    }];
    
    _view=[UIView getCustomViewWithColor:_define_light_red_color];
    [self.contentView addSubview:_view];
    _view.layer.masksToBounds=YES;
    _view.layer.cornerRadius=3;
    [_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(5);
        make.width.height.mas_offset(6);
    }];
    _view.hidden=YES;
    
}
#pragma mark - setter
-(void)setMessageItem:(DD_UserMessageItemModel *)messageItem
{
    _messageItem=messageItem;
    _titleLabel.text=_messageItem.message;
    _timeLabel.text=_messageItem.createTimeStr;
}
-(void)setIsNotice:(BOOL)isNotice
{
    _isNotice=isNotice;
    if(_isNotice)
    {
        _view.hidden=_messageItem.readStatus;
    }else
    {
        _view.hidden=YES;
    }
}
#pragma mark - Other
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
