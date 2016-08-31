//
//  DD_CircleCommentCell.m
//  DDAY
//
//  Created by yyj on 16/6/22.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_CircleCommentCell.h"

@implementation DD_CircleCommentCell
{
    UIImageView *icon;
    UILabel *userName;
    UILabel *createTime;
    UILabel *comment;
    
    UIButton *praiseBtn;//点赞按钮
    UILabel *praiseLabel;//点赞数量
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
}
#pragma mark - 初始化
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self SomePrepare];
        [self UIConfig];
    }
    return self;
}
#pragma mark - SomePrepare
-(void)SomePrepare
{
    [self PrepareData];
    [self PrepareUI];
}
-(void)PrepareData{}
-(void)PrepareUI
{
    self.contentView.backgroundColor=[UIColor whiteColor];
}
#pragma mark - UIConfig
-(void)UIConfig
{
    icon=[UIImageView getCustomImg];
    [self.contentView addSubview:icon];
    icon.contentMode=0;
    icon.userInteractionEnabled=YES;
    [icon addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headAction)]];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(19);
        make.width.and.height.mas_equalTo(44);
    }];
    
    userName=[UILabel getLabelWithAlignment:0 WithTitle:@"" WithFont:12.0f WithTextColor:_define_light_gray_color1 WithSpacing:0];
    [self.contentView addSubview:userName];
    [userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(icon.mas_right).with.offset(14);
        make.top.mas_equalTo(10);
        make.width.mas_equalTo(80);
    }];
    [userName sizeToFit];
    
    createTime=[UILabel getLabelWithAlignment:0 WithTitle:@"" WithFont:12.0f WithTextColor:_define_light_gray_color1 WithSpacing:0];
    [self.contentView addSubview:createTime];
    createTime.textAlignment=0;
    createTime.textColor=[UIColor grayColor];
    createTime.font=[regular getFont:13.0f];
    [createTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(userName.mas_bottom).with.offset(6);
        make.width.mas_equalTo(120);
        make.left.mas_equalTo(icon.mas_right).with.offset(14);
    }];
    [createTime sizeToFit];
    
    praiseLabel=[UILabel getLabelWithAlignment:2 WithTitle:@"" WithFont:12.0f WithTextColor:_define_light_gray_color1 WithSpacing:0];
    [self addSubview:praiseLabel];
    [praiseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-22);
        make.top.mas_equalTo(10);
        make.centerY.mas_equalTo(userName);
        make.width.mas_equalTo(20);
    }];
    [praiseLabel sizeToFit];
    
    praiseBtn=[UIButton getCustomImgBtnWithImageStr:@"System_NoGood" WithSelectedImageStr:@"System_Good"];
    [self addSubview:praiseBtn];
    [praiseBtn addTarget:self action:@selector(praiseAction:) forControlEvents:UIControlEventTouchUpInside];
    [praiseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(22);
        make.right.mas_equalTo(praiseLabel.mas_left).with.offset(-5);
        make.centerY.mas_equalTo(praiseLabel);
        make.height.mas_equalTo(39);
    }];
    
    
    comment=[UILabel getLabelWithAlignment:0 WithTitle:@"" WithFont:12.0f WithTextColor:_define_black_color WithSpacing:0];
    [self.contentView addSubview:comment];
    comment.numberOfLines=0;
    [comment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(icon.mas_right).with.offset(19);
        make.top.mas_equalTo(createTime.mas_bottom).with.offset(6);
        make.right.mas_equalTo(-22);
        make.height.mas_equalTo(0);
    }];
    [comment sizeToFit];
    
    _downLine=[UIView getCustomViewWithColor:_define_black_color];
    [self.contentView addSubview:_downLine];
    [_downLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(userName);
        make.top.mas_equalTo(comment.mas_bottom).with.offset(6);
        make.height.mas_equalTo(1);
        make.right.mas_equalTo(-22);
    }];
}
-(void)setCommentModel:(DD_CircleCommentModel *)CommentModel
{
    _CommentModel=CommentModel;
    [self setAction];
}
+ (CGFloat)heightWithModel:(DD_CircleCommentModel *)model{
    DD_CircleCommentCell *cell = [[DD_CircleCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
    [cell setCommentModel:model];
    [cell.contentView layoutIfNeeded];
    CGRect frame =  cell.downLine.frame;
    return frame.origin.y + frame.size.height;
}
#pragma mark - SomeAction
/**
 * 点赞或取消点赞
 */
-(void)praiseAction:(UIButton *)btn
{
    if(btn.selected)
    {
        _cellBlock(@"praise_cancel",_index);
    }else
    {
        _cellBlock(@"praise",_index);
    }
}
/**
 * 头像点击
 */
-(void)headAction
{
}
/**
 * 更新
 */
-(void)setAction
{
    
    [comment mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(_CommentModel.commHeight);
    }];
    comment.text=_CommentModel.comment;
    userName.text=_CommentModel.userName;
    [icon JX_ScaleToFill_loadImageUrlStr:_CommentModel.userHead WithSize:400 placeHolderImageName:nil radius:30];
    createTime.text=[regular getTimeStr:_CommentModel.createTime WithFormatter:@"YYYY-MM-dd HH:mm"];
//    praiseLabel.text=[[NSString alloc] initWithFormat:@"%ld",_CommentModel.likeTimes];
    praiseBtn.selected=_CommentModel.isLike;

}
#pragma mark - Other
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
