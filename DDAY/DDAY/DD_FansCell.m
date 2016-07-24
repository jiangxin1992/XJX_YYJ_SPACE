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
    UIImageView *isNew;
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
        head=[[UIImageView alloc] init];
        [self.contentView addSubview:head];
        [head mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.top.mas_equalTo(5);
            make.height.and.width.mas_equalTo(50);
        }];
        isNew=[[UIImageView alloc] init];
        [self.contentView addSubview:isNew];
        isNew.backgroundColor=[UIColor redColor];
        [isNew mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.and.width.mas_equalTo(2);
            make.left.mas_equalTo(head.mas_right);
            make.top.mas_equalTo(5);
        }];
        
        username=[[UILabel alloc] init];
        [self.contentView addSubview:username];
        username.textAlignment=0;
        username.font=[regular getFont:13.0f];
        username.textColor=[UIColor blackColor];
        [username mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(head.mas_right).with.offset(10);
            make.top.mas_equalTo(5);
            make.height.mas_equalTo(head);
            make.width.mas_equalTo(100);
        }];
        
    }
    return self;
}
-(void)setFansModel:(DD_FansModel *)fansModel
{
    _fansModel=fansModel;
    username.text=_fansModel.userName;
    [head JX_loadImageUrlStr:_fansModel.userHead WithSize:200 placeHolderImageName:nil radius:25];
    isNew.hidden=!_fansModel.isNew;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
