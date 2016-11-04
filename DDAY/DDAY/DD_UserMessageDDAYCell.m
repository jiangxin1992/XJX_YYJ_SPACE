//
//  DD_UserMessageDDAYCell.m
//  YCO SPACE
//
//  Created by yyj on 2016/11/4.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_UserMessageDDAYCell.h"

@implementation DD_UserMessageDDAYCell
{
    UIImageView *_userHead;
    UILabel *_titleLabel;
    UILabel *_f_titleLabel;
    UILabel *_timeLabel;
    UIView *_view;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
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
    _userHead=[UIImageView getCustomImg];
    [self.contentView addSubview:_userHead];
    [regular setZeroBorder:_userHead];
    [_userHead mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kEdge);
        make.centerY.mas_equalTo(self.contentView);
        make.width.height.mas_equalTo(100);
    }];
    
    _titleLabel=[UILabel getLabelWithAlignment:0 WithTitle:@"" WithFont:13.0f WithTextColor:nil WithSpacing:0];
    [self.contentView addSubview:_titleLabel];
    _titleLabel.numberOfLines=2;
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_userHead.mas_right).with.offset(27);
        make.top.mas_equalTo(_userHead);
        make.right.mas_equalTo(-kEdge);
    }];
    
    _f_titleLabel=[UILabel getLabelWithAlignment:0 WithTitle:@"" WithFont:13.0f WithTextColor:nil WithSpacing:0];
    [self.contentView addSubview:_f_titleLabel];
    [_f_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.left.mas_equalTo(_userHead.mas_right).with.offset(27);
        make.right.mas_equalTo(-kEdge);
    }];
    
    _timeLabel=[UILabel getLabelWithAlignment:0 WithTitle:@"" WithFont:12.0f WithTextColor:_define_light_gray_color1 WithSpacing:0];
    [self.contentView addSubview:_timeLabel];
    _timeLabel.font=[regular get_en_Font:12.0f];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_userHead);
        make.left.mas_equalTo(_userHead.mas_right).with.offset(27);
        make.right.mas_equalTo(-kEdge);
    }];
    
    _view=[UIView getCustomViewWithColor:_define_light_red_color];
    [self.contentView addSubview:_view];
    _view.layer.masksToBounds=YES;
    _view.layer.cornerRadius=3;
    [_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(_userHead);
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
    
    if([_messageItem.params objectForKey:@"title"])
    {
        _f_titleLabel.text=[_messageItem.params objectForKey:@"title"];
    }
    NSString *pic=[[_messageItem.params objectForKey:@"picInfo"] objectForKey:@"pic"];
    if(pic)
    {
        [_userHead JX_ScaleAspectFill_loadImageUrlStr:pic WithSize:800 placeHolderImageName:nil radius:0];
    }
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

    // Configure the view for the selected state
}

@end
