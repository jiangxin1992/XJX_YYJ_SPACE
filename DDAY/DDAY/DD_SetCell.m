//
//  DD_SetCell.m
//  YCO SPACE
//
//  Created by yyj on 16/8/5.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_SetCell.h"

@implementation DD_SetCell
{
    UILabel *titlelabel;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        titlelabel=[UILabel getLabelWithAlignment:0 WithTitle:@"" WithFont:15.0f WithTextColor:nil WithSpacing:0];
        [self.contentView addSubview:titlelabel];
        [titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(kEdge);
            make.centerY.mas_equalTo(self.contentView);
        }];
//        [titlelabel sizeToFit];
        
        UIView *line=[UIView getCustomViewWithColor:_define_black_color];
        [self.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(3);
            make.centerY.mas_equalTo(self.contentView);
            make.right.mas_equalTo(-kEdge);
            make.height.mas_equalTo(16);
        }];
        
    }
    return self;
}
-(void)setTitle:(NSString *)title
{
    titlelabel.text=title;
}
@end
