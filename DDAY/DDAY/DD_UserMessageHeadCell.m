//
//  DD_UserMessageHeadCell.m
//  YCO SPACE
//
//  Created by yyj on 16/9/14.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_UserMessageHeadCell.h"

@implementation DD_UserMessageHeadCell
{
    UIImageView *userHead;
    UILabel *titleLabel;
    UILabel *timeLabel;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}
#pragma mark - 初始化
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier WithBlock:(void(^)(NSString *type,DD_UserModel *user))block
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
    userHead=[UIImageView getCornerRadiusImg];
    [self.contentView addSubview:userHead];
    userHead.userInteractionEnabled=YES;
    [userHead addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headClick)]];
    [userHead mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kEdge);
        make.width.height.mas_equalTo(30);
        make.centerY.mas_equalTo(self.contentView);
    }];
    
    titleLabel=[UILabel getLabelWithAlignment:0 WithTitle:@"" WithFont:13.0f WithTextColor:nil WithSpacing:0];
    [self.contentView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(userHead.mas_right).with.offset(15);
        make.centerY.mas_equalTo(self.contentView);
    }];
    
    timeLabel=[UILabel getLabelWithAlignment:2 WithTitle:@"" WithFont:12.0f WithTextColor:_define_light_gray_color1 WithSpacing:0];
    [self.contentView addSubview:timeLabel];
    timeLabel.font=[regular get_en_Font:12.0f];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-kEdge);
        make.centerY.mas_equalTo(self.contentView);
    }];
}
#pragma mark - setter
-(void)headClick
{
    _block(@"headClick",_messageItem.fromUser);
}
-(void)setMessageItem:(DD_UserMessageItemModel *)messageItem
{
    _messageItem=messageItem;
    if(_messageItem.fromUser)
    {
        [userHead JX_ScaleAspectFill_loadImageUrlStr:_messageItem.fromUser.head WithSize:400 placeHolderImageName:nil radius:0];
    }
    titleLabel.text=_messageItem.message;
    timeLabel.text=[regular getTimeStr:_messageItem.createTime WithFormatter:@"YYYY-MM-dd"];
}
#pragma mark - Other
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}
@end