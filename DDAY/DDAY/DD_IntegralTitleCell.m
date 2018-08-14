//
//  DD_IntegralTitleCell.m
//  YCO SPACE
//
//  Created by yyj on 2016/11/4.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_IntegralTitleCell.h"

#import "DD_IntegralModel.h"

@implementation DD_IntegralTitleCell{
    UILabel *_content_label;
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
    _content_label=[UILabel getLabelWithAlignment:1 WithTitle:@"" WithFont:13.0f WithTextColor:_define_light_gray_color1 WithSpacing:0];
    [self.contentView addSubview:_content_label];
    [_content_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).with.offset(-1);
    }];
    
    UIView *line=[UIView getCustomViewWithColor:_define_black_color];
    [self.contentView addSubview:line];
    line.backgroundColor=_define_light_gray_color1;
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kEdge);
        make.right.mas_equalTo(-kEdge);
        make.height.mas_equalTo(1);
        make.bottom.mas_equalTo(self.mas_bottom).with.offset(0);
    }];
}

-(void)setIntegralModel:(DD_IntegralModel *)integralModel
{
    _integralModel=integralModel;
    _content_label.text=_integralModel.tips;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
@end
