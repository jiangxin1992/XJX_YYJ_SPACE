//
//  DD_CircleSearchCell.m
//  YCO SPACE
//
//  Created by yyj on 16/9/4.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_CircleSearchCell.h"

@implementation DD_CircleSearchCell
{
    UILabel *content_label;
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
        content_label=[UILabel getLabelWithAlignment:0 WithTitle:@"" WithFont:13.0f WithTextColor:nil WithSpacing:0];
        [self.contentView addSubview:content_label];
        [content_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.top.mas_equalTo(0);
            make.right.mas_equalTo(-20);
            make.bottom.mas_equalTo(-1);
        }];
        
        UIView *downLine=[UIView getCustomViewWithColor:_define_light_gray_color1];
        [self.contentView addSubview:downLine];
        [downLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.height.mas_equalTo(1);
            make.right.mas_equalTo(-20);
            make.bottom.mas_equalTo(0);
        }];
    }
    return self;
}
-(void)setContent:(NSString *)content
{
    _content=content;
    content_label.text=_content;
}


#pragma mark - others
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
