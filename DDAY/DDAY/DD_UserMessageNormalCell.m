//
//  DD_UserMessageNormalCell.m
//  YCO SPACE
//
//  Created by yyj on 16/9/14.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_UserMessageNormalCell.h"

@implementation DD_UserMessageNormalCell
{
    UILabel *titleLabel;
    UILabel *timeLabel;
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
    timeLabel=[UILabel getLabelWithAlignment:2 WithTitle:@"" WithFont:12.0f WithTextColor:_define_light_gray_color1 WithSpacing:0];
    [self.contentView addSubview:timeLabel];
    timeLabel.font=[regular get_en_Font:12.0f];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-kEdge);
        make.centerY.mas_equalTo(self.contentView);
    }];
    
    titleLabel=[UILabel getLabelWithAlignment:0 WithTitle:@"" WithFont:13.0f WithTextColor:nil WithSpacing:0];
    [self.contentView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kEdge);
        make.centerY.mas_equalTo(self.contentView);
        make.right.mas_equalTo(timeLabel.mas_left).with.offset(-10);
    }];
    
    
}
#pragma mark - setter
-(void)setMessageItem:(DD_UserMessageItemModel *)messageItem
{
    _messageItem=messageItem;
    titleLabel.text=_messageItem.message;
    timeLabel.text=[regular getTimeStr:_messageItem.createTime WithFormatter:@"YYYY-MM-dd"];
}
#pragma mark - Other
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
