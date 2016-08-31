//
//  DD_UserCell.m
//  DDAY
//
//  Created by yyj on 16/5/21.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_UserCell.h"

@implementation DD_UserCell
{
    UILabel *_f_title_label;
    UILabel *_title_label;
    UIImageView *_head_img;
    UIImageView *_not_img;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}
-(id)initWithImageStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        _title_label=[[UILabel alloc] init];
        [self.contentView addSubview:_title_label];
        _title_label.textAlignment=0;
        _title_label.textColor=[UIColor blackColor];
        [_title_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.top.mas_equalTo(0);
            make.width.mas_equalTo(200);
            make.height.mas_equalTo(80);
        }];
        
        _head_img=[[UIImageView alloc] init];
        [self.contentView addSubview:_head_img];
        _head_img.contentMode=0;
        [_head_img mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.and.height.mas_equalTo(60);
            make.top.mas_equalTo(10);
            make.left.mas_equalTo(_title_label.mas_right).with.offset(60);
        }];
    }
    return self;
}
-(id)initWithF_titleStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        _title_label=[[UILabel alloc] init];
        [self.contentView addSubview:_title_label];
        _title_label.textAlignment=0;
        _title_label.textColor=[UIColor blackColor];
        [_title_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.top.mas_equalTo(0);
            make.width.mas_equalTo(200);
            make.height.mas_equalTo(80);
        }];
        
        _f_title_label=[[UILabel alloc] init];
        [self.contentView addSubview:_f_title_label];
        _f_title_label.textAlignment=2;
        _f_title_label.textColor=[UIColor blackColor];
        [_f_title_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_title_label.mas_right).with.offset(20);
            make.top.mas_equalTo(0);
            make.width.mas_equalTo(100);
            make.height.mas_equalTo(_title_label);
        }];
    }
    return self;
}
-(id)initWithNotF_titleStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        _title_label=[[UILabel alloc] init];
        [self.contentView addSubview:_title_label];
        _title_label.textAlignment=0;
        _title_label.textColor=[UIColor blackColor];
        [_title_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.top.mas_equalTo(0);
            make.width.mas_equalTo(200);
            make.height.mas_equalTo(80);
        }];
        
        _not_img=[[UIImageView alloc] init];
        [self.contentView addSubview:_not_img];
        _not_img.backgroundColor=[UIColor redColor];
        _not_img.hidden=YES;
        [_not_img mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_title_label.mas_right);
            make.width.and.height.mas_equalTo(5);
            make.top.mas_equalTo(10);
        }];
        
        _f_title_label=[[UILabel alloc] init];
        [self.contentView addSubview:_f_title_label];
        _f_title_label.textAlignment=2;
        _f_title_label.textColor=[UIColor blackColor];
        [_f_title_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_title_label.mas_right).with.offset(20);
            make.top.mas_equalTo(0);
            make.width.mas_equalTo(100);
            make.height.mas_equalTo(_title_label);
        }];
        
    }
    return self;
}
-(id)initWithTitleStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        _title_label=[[UILabel alloc] init];
        [self.contentView addSubview:_title_label];
        _title_label.textAlignment=0;
        _title_label.textColor=[UIColor blackColor];
        [_title_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.top.mas_equalTo(0);
            make.width.mas_equalTo(200);
            make.height.mas_equalTo(80);
        }];
    }
    return self;
}
-(void)setImage:(NSString *)image
{
    [_head_img JX_ScaleToFill_loadImageUrlStr:image WithSize:200 placeHolderImageName:nil radius:CGRectGetWidth(_head_img.frame)/2.0f] ;
}
-(void)setF_title:(NSString *)f_title
{
    _f_title_label.text=f_title;
}
-(void)setTitle:(NSString *)title
{
    _title_label.text=title;
}
-(void)setHasNewFans:(BOOL)hasNewFans
{
    _not_img.hidden=!hasNewFans;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
