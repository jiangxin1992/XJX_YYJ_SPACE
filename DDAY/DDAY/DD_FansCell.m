//
//  DD_FansCell.m
//  DDAY
//
//  Created by yyj on 16/6/28.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_FansCell.h"

@implementation DD_FansCell
{
    UIImageView *head;
    UILabel *username;
//    UIImageView *isNew;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self UIConfig];
    }
    return self;
}
-(void)UIConfig
{
    //        isNew=[[UIImageView alloc] init];
    //        [self.contentView addSubview:isNew];
    //        [isNew mas_makeConstraints:^(MASConstraintMaker *make) {
    //            make.height.and.width.mas_equalTo(2);
    //            make.left.mas_equalTo(head.mas_right);
    //            make.top.mas_equalTo(5);
    //        }];
    
    head=[UIImageView getCornerRadiusImg];
    [self.contentView addSubview:head];
    head.contentMode=2;
    [regular setZeroBorder:head];
    [head mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.left.mas_equalTo(kEdge);
        make.height.width.mas_equalTo(50);
    }];
    
    username=[UILabel getLabelWithAlignment:0 WithTitle:@"" WithFont:13.0f WithTextColor:nil WithSpacing:0];
    [self.contentView addSubview:username];
    [username mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.left.mas_equalTo(head.mas_right).with.offset(12);
    }];
    [username sizeToFit];
    
    UIView *line=[UIView getCustomViewWithColor:_define_black_color];
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(3);
        make.centerY.mas_equalTo(self.contentView);
        make.right.mas_equalTo(-kEdge);
        make.height.mas_equalTo(16);
    }];
}
-(void)setFansModel:(DD_FansModel *)fansModel
{
    _fansModel=fansModel;
    username.text=_fansModel.userName;
    [head JX_ScaleAspectFill_loadImageUrlStr:_fansModel.userHead WithSize:400 placeHolderImageName:nil radius:20];
//    isNew.hidden=!_fansModel.isNew;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
